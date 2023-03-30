all: init plan apply pause deploy

init:
	cd ./src/terraform/app && terraform init

plan:
	cd ./src/terraform/app && terraform plan

apply:
	cd ./src/terraform/app &&  terraform apply -auto-approve

destroy:
	cd ./src/terraform/app &&  terraform destroy -auto-approve

pause:
	echo "Wait for 120 seconds stupid Yandex Cloud creating a VM's..."
	sleep 120
	echo "May be created? Ok, run an ansible playbook..."

deploy_k8s:
    cd ./src/kubespray && \
    ANSIBLE_FORCE_COLOR=1 ansible-playbook \
        -i ./inventory/mycluster/hosts.yaml \
        -b --become-user=root \
        --extra-vars "{ \\"supplementary_addresses_in_ssl_keys\\":${jsonencode(module.all_nodes["control_plane"].internal_ip_address_instance)}}" \
        cluster.yml

configuring_access_to_k8s:
	cd ./src/playbook && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory.yml configuring_access_to_k8s.yml

deploy_monitoring:
    cd ./src/manifests/kube-prometheus && \
    kubectl apply --server-side -f setup && \
    kubectl wait \
        --for condition=Established \
        --all CustomResourceDefinition \
        --namespace=monitoring && \
    kubectl apply -f

reconfig:
	cd ./ansible && source .env.news-app && ansible-playbook -i inventory/demo site.yml -t config