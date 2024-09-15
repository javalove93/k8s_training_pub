PROJECT_ID=$(gcloud config get-value project)
REGION=asia-northeast3
ZONE=$(gcloud compute zones list --format="value(name)" | grep $REGION | shuf -n 1)
MACHINE_TYPE=e2-medium
VM_NAME=k8s-bastion
IMAGE=projects/debian-cloud/global/images/debian-12-bookworm-v20240910
# IMAGE=$(gcloud compute images list --filter="family:debian" --sort-by="creationTimestamp desc" | grep -v arm64 | grep debian-12 | awk '{print $1}')
DISK_SIZE=30

gcloud services --project $PROJECT_ID enable compute.googleapis.com container.googleapis.com

gcloud compute instances create $VM_NAME     --project=$PROJECT_ID     --zone=$ZONE     \
  --machine-type=$MACHINE_TYPE     --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default     \
  --maintenance-policy=MIGRATE     --provisioning-model=STANDARD     \
  --scopes=https://www.googleapis.com/auth/cloud-platform     --tags=http-server,https-server     \
  --create-disk=auto-delete=yes,boot=yes,device-name=$VM_NAME,image=$IMAGE,mode=rw,size=$DISK_SIZE,type=projects/$PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced     \
  --no-shielded-secure-boot     --shielded-vtpm     --shielded-integrity-monitoring     \
  --labels=goog-ec-src=vm_add-gcloud     --reservation-affinity=any
