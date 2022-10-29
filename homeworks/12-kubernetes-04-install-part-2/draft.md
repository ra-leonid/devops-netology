
### IaC
```commandline
terraform init
terraform init -upgrade
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve

# Debug Ansible
ansible-lint site.yml
ansible-playbook -i inventory.yml local_config.yml
ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../kubespray/inventory/mycluster/hosts.yaml --become --become-user=root --extra-vars "{ 'supplementary_addresses_in_ssl_keys':'[\"62.84.112.31\"]' }" ../kubespray/cluster.yml
```

ssh ubuntu@178.154.200.148

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

scp ubuntu@178.154.200.148:~/.kube/config ~/.kube/config
vi ~/.kube/config

kubectl get pods -A
kubectl get nodes -A