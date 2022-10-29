
### IaC
```commandline
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve

# Debug Ansible
ansible-lint site.yml
ansible-playbook -i inventory.yml site.yml

ssh ubuntu@178.154.223.60
```
### Start Minikube
####  На control-node

1. Предварительная настройка:

```commandline
sudo sysctl fs.protected_regular=0

sudo modprobe br_netfilter 
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-arptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf
```

2. Стартуем minikube:

```commandline
minikube start --vm-driver=docker --apiserver-ips=178.154.223.60
# ключ --apiserver-ips указывает для какого IP авторизовать сертификаты на подключение
```
3. Проверяем что всё запустилось:
```commandline
ubuntu@minikube1:~$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```
4. Пробрасываем порт API-сервера наружу:

```commandline
kubectl port-forward --address 0.0.0.0 -n=kube-system "kube-apiserver-minikube" 8443:8443
```

#### На локальном ПК:
1. Создаем каталоги для настроек подключения к кластеру:

```commandline
mkdir ~/.kube
mkdir ~/.minikube
```
 
2. Копируем настройки: 

```commandline
scp ubuntu@178.154.223.60:~/.kube/config ~/.kube/config
```

3. Копируем сертификаты: 

```commandline
scp ubuntu@178.154.223.60:~/.minikube/ca.crt ~/.minikube/ca.crt
scp ubuntu@178.154.223.60:~/.minikube/profiles/minikube/client.crt ~/.minikube/client.crt
scp ubuntu@178.154.223.60:~/.minikube/profiles/minikube/client.key ~/.minikube/client.key
```
4. В файле `~/.kube/config` указываем новый путь к сертификатам, меняем внутренний IP на внешний 
5. Проверяем подключение:
```commandline
kubectl get pods --namespace=kube-system
```

### Развертывание тестового приложения
1. Используйте команду kubectl create для создание деплоймента для управления подом. POD запускает контейнер на основе предоставленного Docker образа.
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --namespace=app-namespace
kubectl edit deployment hello-node-697897c86-fj5xc --namespace=app-namespace
kubectl get deployments
2. Посмотреть информацию о Deployment
kubectl get deployments
3. Посмотреть информацию о поде:
kubectl get pods
kubectl get pods -o wide # Подробно
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

#### Запуск dashboard
```commandline
minikube addons enable ingress
minikube addons enable dashboard
minikube dashboard
# или 
minikube dashboard --url
```

*Пробрасываем порт дашборда наружу*
```commandline
kubectl proxy --address 0.0.0.0 --accept-hosts 178.154.223.60
```

В url дашборда меняем IP на внешний и порт на 8001

Пример:
```commandline
http://178.154.223.60:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=default
```

#### Удалить Minikube:
```commandline
minikube stop
minikube delete
rm -rf  ~/.minikube ~/.kube
```

minikube status
kubectl get pods -A
kubectl get pods --namespace=kube-system

kubectl get nodes

kubectl get deployments

# Масштабирование. Увеличение числа реплик до 2
kubectl scale deploy hello-node -n default --replicas=4

kubectl delete deployment hello-node

kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2

minikube start --vm-driver=docker --apiserver-ips=51.250.78.69 --bootstrapper=kubeadm

sudo useradd jony
deluser jony --remove-all-files

mkdir cert && cd cert
openssl genrsa -out user1.key 2048
openssl req -new -key user1.key -out user1.csr -subj "/CN=user1/O=group1"
ls ~/.minikube/ # проверьте наличие файлов ca.crt и ca.key в этом месте.
openssl x509 -req -in user1.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out user1.crt -days 500
kubectl config set-credentials user1 --client-certificate=user1.crt --client-key=user1.key
kubectl config set-context user1-context --cluster=minikube --user=user1

kubectl config use-context user1-context
kubectl config current-context

kubectl config view

kubectl config use-context minikube
kubectl apply -f role.yaml
kubectl apply -f role-binding.yaml

kubectl get roles
kubectl get rolebindings

kubeadm alpha kubeconfig user

kubectl delete -f role.yaml
kubectl delete -f role-binding.yaml
kubectl delete role pod-reader -n default
kubectl delete rolebinding read-pods

kubectl get clusterroles
kubectl get clusterrolebindings
find your role name and then delete
kubectl delete clusterrolebinding name
kubectl delete clusterrole name

minikube start \
    --vm-driver=docker \
    --apiserver-ips=51.250.82.164 \
    --network-plugin=cni \
    --enable-default-cni \
    --container-runtime=containerd \
    --bootstrapper=kubeadm

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | (grep bootstrap-token-v2zfi7 || echo "$_") | awk '{print $1}') | grep token: | awk '{print $2}'

kubectl -n kubernetes-dashboard create token admin-user

ssh ubuntu@51.250.92.115

kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]

kubectl config use-context java-dev-context
kubectl config current-context # check the current context
user1-context


kubectl -n kubernetes-dashboard create token ivanov_ii

kubectl get rolebinding rbac-java-dev-app-namespace-log -o yaml

kubectl get rolebinding --all-namespaces -o yaml
