create: create_net create_vm

create_net:
	yc vpc network create --name net --labels my-label=netology --description "my first network via yc"
	yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "my first subnet via yc"

create_k8s:
	yc managed-kubernetes cluster create \
      --name test-k8s \
      --network-name net \
      --zone ru-central1-a \
      --subnet-name my-subnet-a \
      --public-ip \
      --release-channel regular \
      --version 1.21 \
      --service-account-name editor \
      --node-service-account-name gitlab-container
    yc managed-kubernetes node-group create \
      --cluster-name test-k8s \
      --cores 2 \
      --disk-size 96 \
      --disk-type network-hdd \
      --fixed-size 1 \
      --memory 4 \
      --name gitlab-runner \
      --ssh-key ~/.ssh/id_rsa.pub \
      --version 1.21
    yc managed-kubernetes cluster \
      get-credentials test-k8s \
      --external
    kubectl apply -f gitlab-admin-service-account.yaml
    yc container registry create --name gitlab-reg
    helm repo add gitlab https://charts.gitlab.io

create_vm:
	yc compute instance create \
      --name jenkins \
      --zone ru-central1-a \
      --network-interface subnet-name=my-subnet-a,nat-ip-version=ipv4 \
      --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts \
      --ssh-key ~/.ssh/id_rsa.pub \
      --memory 4 \
      --cores 2 
	yc compute instance create \
      --name agent-01 \
      --zone ru-central1-a \
      --network-interface subnet-name=my-subnet-a,nat-ip-version=ipv4 \
      --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts \
      --ssh-key ~/.ssh/id_rsa.pub \
      --memory 4 \
      --cores 2

destroy: destroy_vm destroy_net

destroy_vm:
	yc compute instance delete jenkins
	yc compute instance delete agent-01

destroy_net:
	yc vpc subnet delete --name my-subnet-a
	yc vpc network delete --name net
