
ns ?= stage

ifeq ($(ns),debug)
	TARGET_ALL := deploy_k8s pause local_setting deploy
	TARGET_DESTROY := delete destroy_debug
	SLEEP_COUNT := 3
else
	TARGET_ALL := init plan apply pause deploy_k8s pause configuring_access_to_k8s tunnel local_setting deploy_app
	TARGET_DESTROY := destroy_cloud
	SLEEP_COUNT := 120
endif

all: $(TARGET_ALL)

destroy: $(TARGET_DESTROY)

init:
	cd ./src/terraform && terraform init -reconfigure -backend-config=./.secrets/backend.conf
	# cd ./src/terraform && terraform init
	# cd ./src/terraform && terraform workspace new $(ns)

plan:
	cd ./src/terraform && terraform plan

apply:
	cd ./src/terraform && terraform workspace select $(ns)
	cd ./src/terraform && terraform apply -auto-approve

deploy_k8s:
ifeq ($(ns),debug)
	minikube delete
	minikube start \
		--vm-driver=virtualbox \
		--kubernetes-version=v1.23.0 \
		--memory=6g --bootstrapper=kubeadm \
		--extra-config=kubelet.authentication-token-webhook=true \
		--extra-config=kubelet.authorization-mode=Webhook \
		--extra-config=scheduler.bind-address=0.0.0.0 \
		--extra-config=controller-manager.bind-address=0.0.0.0
	minikube addons disable metrics-server
	minikube addons enable ingress
else
	cd ./src/vendor/kubespray && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ./inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
endif

pause:
	echo "Wait for $(SLEEP_COUNT) seconds stupid k8s creating..."
	sleep $(SLEEP_COUNT)
	echo "May be created? Ok, run an deploy..."

tunnel:
	cd ./src/playbook && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory.yml ssh_tunnel.yml

local_setting:
ifeq ($(ns),debug)
	sed -e 's/$${namespace}/$(ns)/; s/$${url}/$(TF_VAR_url)/' src/terraform/app/templates/group_vars_localhost.tpl > src/playbook/group_vars/all/localhost/vars.yml
	@sed -e 's/$${ip_control_plane}/$(shell minikube ip)/; s/$${ansible_user}/$(USER)/' src/terraform/app/templates/inventory.tpl > src/playbook/inventory.yml
endif
	cd ./src/playbook && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory.yml configuration_qbec.yml
	#cd ./src/playbook && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory.yml -K configuration_hosts.yml

deploy: deploy_monitoring deploy_app deploy_atlantis deploy_jenkins

deploy_app:
	cd ./src/deploy/app && qbec apply $(ns) --vm:ext-str url=$$TF_VAR_url --strict-vars --yes

deploy_monitoring:
	helm upgrade --install monitoring prometheus-community/kube-prometheus-stack --create-namespace -n $(ns) -f src/deploy/kube-prometheus/values.yaml

deploy_atlantis:
	helm upgrade --install atlantis runatlantis/atlantis --create-namespace -n $(ns) -f src/deploy/atlantis/values.yaml --set ingress.hosts[0].host=atlantis.$$TF_VAR_url

deploy_jenkins:
	kubectl apply -n $(ns) -f src/deploy/jenkins/jenkins-sa.yaml
	helm upgrade --install jenkins jenkins/jenkins --create-namespace -n $(ns) -f src/deploy/jenkins/values.yaml --set controller.ingress.hostName=jenkins.$$TF_VAR_url

destroy_cloud:
	cd ./src/terraform &&  terraform destroy -auto-approve

delete:
	helm uninstall monitoring -n $(ns)
	helm uninstall atlantis -n $(ns)
	helm uninstall jenkins -n $(ns)
	cd ./src/deploy/app && qbec delete $(ns) --yes

destroy_debug:
	minikube delete

configuring_access_to_k8s:
	cd ./src/playbook && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory.yml configuring_access_to_k8s.yml
