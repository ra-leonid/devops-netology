
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
# Не работает
kubectl port-forward --address 0.0.0.0 -n=kubernetes-dashboard "kubernetes-dashboard-57bbdc5f89-zgxdg" 8001:8001
# Работает
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

