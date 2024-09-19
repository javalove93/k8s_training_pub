# SSH Key 추가 방법
VM_NAME=k8s-bastion
ZONE=$(gcloud compute instances list --filter="name=$VM_NAME" --format="value(ZONE)")
USER=$(whoami)
USER2=$(echo $USER | sed -e "s/_/-/g")

# .ssh/id_rsa가 없으면 생성
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi

gcloud compute instances add-metadata $VM_NAME \
  --project $(gcloud config get project) \
  --zone $(gcloud compute instances list --filter="name=$VM_NAME" --format="value(ZONE)") \
  --metadata="ssh-keys=$USER:$(cat ~/.ssh/id_rsa.pub)"

export ID_RSA=`cat ~/.ssh/id_rsa.pub`
gcloud compute ssh k8s-bastion --zone `gcloud compute instances list --filter "name=k8s-bastion" --format "value(ZONE)"` -- << EOF
mkdir -p .ssh
chmod 700 .ssh
echo $ID_RSA >> .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
sudo apt -y install git
EOF

echo cat ~/.ssh/id_rsa
echo ""

echo Qwiklabs
echo ssh -i ks_bastion $USER2@$(gcloud compute instances list --filter="name=$VM_NAME" --format="value(EXTERNAL_IP)")

echo ""

echo Argolis
export SSH_USER=`gcloud auth list | grep ACCOUNT | awk '{print $2}' | sed -e "s/@/_/g" | sed -e "s/\./_/g"`
echo ssh -i ks_bastion $SSH_USER@`gcloud compute instances list --filter "name=k8s-bastion" --format "value(EXTERNAL_IP)"`

echo ""

echo 일반 Gmail

echo ssh -i ks_bastion $USER@`gcloud compute instances list --filter "name=k8s-bastion" --format "value(EXTERNAL_IP)"`


