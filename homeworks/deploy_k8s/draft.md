
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

### Развертывание тестового приложения
1. Используйте команду kubectl create для создание деплоймента для управления подом. POD запускает контейнер на основе предоставленного Docker образа.
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
2. Посмотреть информацию о Deployment
kubectl get deployments
3. Посмотреть информацию о поде:
kubectl get pods
4. Посмотреть события кластера:
kubectl get events
5. Посмотреть kubectl конфигурацию:
kubectl config view

### Создание сервиса
По-умолчанию под доступен только при обращении по его внутреннему IP адресу внутри кластера Kubernetes. 
Чтобы сделать контейнер hello-node доступным вне виртульной сети Kubernetes, необходимо представить под как сервис Kubernetes.

1. Сделать под доступным для публичной сети Интернет можно с помощью команды kubectl expose:

kubectl expose deployment hello-node --type=LoadBalancer --port=8080

Флаг --type=LoadBalancer показывает, что сервис должен быть виден вне кластера.

2. Посмотреть только что созданный сервис:

kubectl get services

Для облачных провайдеров, поддерживающих балансировщики нагрузки, для доступа к сервису будет предоставлен внешний IP адрес. 
В Minikube тип LoadBalancer делает сервис доступным при обращении с помощью команды minikube service.

3. Выполните следующую команду:

minikube service hello-node



ssh ubuntu@178.154.200.148

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

scp ubuntu@178.154.200.148:~/.kube/config ~/.kube/config
vi ~/.kube/config

kubectl get pods -A
kubectl get nodes -A