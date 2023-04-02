
ns ?= stage

ifeq ($(ns),debug)
	TARGET_ALL := apply pause debug_setting deploy
	TARGET_DESTROY := delete destroy_debug
	SLEEP_COUNT := 3
	ns := debug
	url := meow-app.local
else
	TARGET_ALL := init plan apply pause deploy
	TARGET_DESTROY := destroy_cloud
	SLEEP_COUNT := 120
	url := meow-app.duckdns.org
endif

all: $(TARGET_ALL)

destroy: $(TARGET_DESTROY)

init:
	cd ./src/terraform/app && terraform init -reconfigure -backend-config=./.secrets/backend.conf
	cd ./src/terraform/app && terraform init
	cd ./src/terraform/app && terraform workspace new $ns

plan:
	cd ./src/terraform/app && terraform plan

apply:
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
	cd ./src/terraform/app &&  terraform apply -auto-approve
endif

pause:
	echo "Wait for $(SLEEP_COUNT) seconds stupid k8s creating..."
	sleep $(SLEEP_COUNT)
	echo "May be created? Ok, run an deploy..."

debug_setting:
	sed -ie "/debug/,+2d;/  environments:/ a\    debug:\n      defaultNamespace: debug\n      server: https://$(shell minikube ip):8443" src/deploy/app/qbec.yaml
	sudo sed -ie "/\tgrafana.$(url)/d; 1 i$(shell minikube ip)\tgrafana.$(url)" /etc/hosts
	sudo sed -ie "/\tatlantis.$(url)/d; 1 i$(shell minikube ip)\tatlantis.$(url)" /etc/hosts
	sudo sed -ie "/\tjenkins.$(url)/d; 1 i$(shell minikube ip)\tjenkins.$(url)" /etc/hosts
	sudo sed -ie "/\t$(url)/d; 1 i$(shell minikube ip)\t$(url)" /etc/hosts

deploy: deploy_monitoring deploy_app deploy_atlantis deploy_jenkins

deploy_app:
	cd ./src/deploy/app && qbec apply $(ns) --vm:ext-str url=$(url) --strict-vars --yes

deploy_monitoring:
	helm upgrade --install monitoring prometheus-community/kube-prometheus-stack --create-namespace -n $(ns) -f src/deploy/kube-prometheus/values.yaml --set grafana.ingress.hosts[0]=grafana.$(url)

deploy_atlantis:
	helm upgrade --install atlantis runatlantis/atlantis --create-namespace -n $(ns) -f src/deploy/atlantis/values.yaml --set ingress.hosts[0].host=atlantis.$(url)

deploy_jenkins:
	helm upgrade --install jenkins jenkins/jenkins --create-namespace -n $(ns) -f src/deploy/jenkins/values.yaml --set controller.ingress.hostName=jenkins.$(url)

destroy_cloud:
	cd ./src/terraform/app &&  terraform destroy -auto-approve

delete:
	helm uninstall monitoring -n $(ns)
	helm uninstall atlantis -n $(ns)
	helm uninstall jenkins -n $(ns)
	cd ./src/deploy/app && qbec delete $(ns) --yes

destroy_debug:
	minikube delete
