CLUSTER_NAME=std-cluster-1
PROJECT=$(gcloud config get project)
REGION=asia-east1
MACHINE_TYPE=e2-standard-4
# VERSION="--cluster-version 1.30.3-gke.1969001"
    
gcloud beta container --project "$PROJECT" clusters create "$CLUSTER_NAME" \
    --no-enable-basic-auth --release-channel "regular" \
    --machine-type "$MACHINE_TYPE" --image-type "COS_CONTAINERD" \
    --disk-type "pd-balanced" --disk-size "60" \
    --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM \
    --enable-ip-alias --network "projects/$PROJECT/global/networks/default" \
    --no-enable-intra-node-visibility --default-max-pods-per-node "110" \
    --security-posture=standard --workload-vulnerability-scanning=disabled \
    --no-enable-master-authorized-networks \
    --spot \
    --enable-network-policy \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver,GcpFilestoreCsiDriver,GcsFuseCsiDriver \
    --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 \
    --binauthz-evaluation-mode=DISABLED --enable-managed-prometheus \
    --workload-pool "$PROJECT.svc.id.goog" --enable-shielded-nodes \
    --enable-l4-ilb-subsetting --enable-image-streaming \
    --node-locations "$REGION-c" --zone=$REGION-c $VERSION

# kubectl이 설치되어 있지 않은 경우
KUBECTL=`which kubectl`
if [ -z $KUBECTL ]; then
    sudo apt update
    sudo apt install -y kubectl
    sudo apt install -y google-cloud-cli-gke-gcloud-auth-plugin
    sudo apt -y install kubectx
fi

gcloud container clusters get-credentials $CLUSTER_NAME --zone $REGION-c --project $PROJECT

ALIAS=`alias | grep kubectl | xargs`
if [ -z "$ALIAS" ]; then
cat << EOF >> ~/.bashrc
alias k='kubectl '
alias kget='kubectl get '
EOF
fi

echo kubectx 명령으로 Kubernetes 클러스터를 확인하거나 변경할 수 있습니다.
