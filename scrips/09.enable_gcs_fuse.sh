# https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/cloud-storage-fuse-csi-driver?hl=ko#create-persistentvolume

BUCKET=$(gcloud config get project)-bucket

CLUSTER_NAME=std-cluster-1
LOCATION=$(gcloud container clusters list --filter="name=$CLUSTER_NAME" --format="value(LOCATION)")

gcloud container clusters update $CLUSTER_NAME \
    --update-addons GcsFuseCsiDriver=ENABLED \
    --location=$LOCATION

KSA_NAME=gcs-sa
PROJECT=$(gcloud config get project)
PROJECT_NUMBER=$(gcloud projects list --filter="name=$PROJECT" --format="value(PROJECT_NUMBER)")
ROLE_NAME=roles/storage.objectViewer		# 읽기 전용일 경우
ROLE_NAME=roles/storage.objectUser

kubectl create serviceaccount $KSA_NAME

gcloud storage buckets add-iam-policy-binding gs://$BUCKET \
    --member "principal://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$PROJECT.svc.id.goog/subject/ns/default/sa/$KSA_NAME" \
    --role "$ROLE_NAME"
