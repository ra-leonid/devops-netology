Подготовка control-node к использованию kubectl:
```commandline
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

```


```commandline
# Получить список подов в текущем namespace:
kubectl get pods

# Получить список всех подов включая служебные в текущем namespace:
kubectl get pods -A

kubectl get po,pv,pvc,sts,storageclass,svc -o wide

# Получить список подов в namespace kube-system:
kubectl get pods --namespace=kube-system
kubectl get pods -n=kube-system

# Получить список подов с отбором по label:
kubectl get pods --selector app=main
kubectl get pods -l app=main
kubectl -n prod get po -l 'app in (backend, frontend)'
kubectl get pods -l app.kubernetes.io/name=grafana

# Получить список подов с выводом подробной информации:
kubectl get pods -o wide

# Получить список подов с выводом информации о labels:
kubectl get pods --show-labels
kubectl get svc --show-labels

# Получить подробную информацию о поде:
kubectl describe pod nginx

# Получить список configmap
kubectl -n default get cm

# Выполнить команду в контейнере пода:
kubectl exec hello-node-697897c86-fvngg curl http://127.0.0.1
kubectl -n default exec hello-node-697897c86-fvngg curl -s nginx-7664fdf455-wx5dp
kubectl -n default exec nginx-7664fdf455-wx5dp -- curl -s -m hello-node:8080

# Выполнить команду bash в контейнере пода (зайти в контейнер):
kubectl exec hello-node-697897c86-fvngg -ti bash

# Удалить под:
kubectl delete pod hello-node-697897c86-fvngg

# Получить список нод
kubectl get nodes

# Получить список деплойментов:
kubectl get deployments

# Развернуть деплоймент из манифеста
kubectl apply -f ../manifests/nginx.yml

# Удалить все ресурсы созданные манифестом
kubectl delete -f ../manifests/nginx.yml

# Изменить манифест деплоймента:
kubectl edit deployment hello-node
kubectl edit svc grafana-web
kubectl delete deployment,pvc,pv,storageclass --all
kubectl delete pvc --all
kubectl delete svc grafana-web
kubectl --namespace monitoring delete "$(kubectl api-resources --namespaced=true --verbs=delete -o name | tr "\n" "," | sed -e 's/,$//')" --all

# Изменить манифест деплоймента командой (здесь мы изменяем количество реплик на 5):
kubectl scale deploy hello-node -n default --replicas=5

# Display information about your ReplicaSet objects:
kubectl get replicasets
kubectl describe replicasets

# Получить список namespaces:
kubectl get namespace
kubectl get ns

# Изменить namespace
kubectl config set-context --current --namespace=monitoring
kubectl config set-context --current --namespace=default

# Просмотр логов:
kubectl logs hello-node-697897c86-fvngg
kubectl logs hello-node-697897c86-fvngg --all-containers

# Проброс порта пода до локальной ВМ
kubectl port-forward hello-node-697897c86-fvngg 8080:8080
kubectl port-forward service/grafana 3000:3000
# Проверка
curl http://127.0.0.1:8080

# проброс порта созданием сервиса NodePort
kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment web --type=NodePort --port=8080
minikube service web --url


```
# HELM
# Создание чарта first в папке charts
```commandline
helm create first
```

# Сборка ресурсов из шаблона 
```commandline
helm template first
```

# Linter
```commandline
helm lint first
```

Посмотреть список подключенных репозиториев:
```commandline
 helm repo list
```

Обновить репозитории:
```commandline
helm repo update
```

Найти в репозиториях чарты приложения
```commandline
helm search repo alertmanager
helm search repo jenkins
```
Установить
```commandline
helm install --create-namespace -n app1 demo-release 13-kubernetes-config
```
Что было установлено в k8s с помощью helm:
```commandline
helm list
helm list -n app1
```

Удалить приложение:
```commandline
helm uninstall -n app1 demo-release
```

# Qbec & Jsonnet
## Установка qbec
1. Качаем последнюю версию с [github](https://github.com/splunk/qbec/releases)
2. Распаковываем:
```commandline
cd ~/Загрузки/
tar -xf qbec-linux-amd64.tar.gz -C qbec
```
3. Перемещаем к бинарям:
```commandline
sudo cp ./qbec/jsonnet-qbec /usr/bin
sudo cp ./qbec/qbec /usr/bin
```
4. Удаляем:
```commandline
rm -rf qbec*
```

## Установка jsonnet
1. Качаем последнюю версию с [github](https://github.com/google/jsonnet/releases)
2. Распаковываем:
```commandline
cd ~/Загрузки/
tar -xf jsonnet-0.19.1.tar.gz
```
3. Собираем:
```commandline
cd jsonnet-0.19.1/
make
```
4. Перемещаем к бинарям:
```commandline
sudo cp jsonnet /usr/bin
sudo cp jsonnetfmt /usr/bin
```

```commandline
# старт minikube
minikube start --vm-driver=virtualbox --kubernetes-version=v1.26.1

# Старт minikube для запуска пакета kube-prometheus
minikube delete && minikube start --vm-driver=virtualbox --kubernetes-version=v1.23.0 --memory=6g --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0

# Стек kube-prometheus включает API-сервер метрик ресурсов, 
# поэтому аддон metrics-server не нужен. 
# Убедитесь, что надстройка metrics-server отключена на minikube:
minikube addons disable metrics-server

```



### Рабочие заметки: </br>
Хороша статья про политики: https://habr.com/ru/company/flant/blog/443190/ </br>
Понятно по k8s: http://linuxsql.ru/content/kubernetes-glazami-novichka </br>
Самая адекватная статья: https://mcs.mail.ru/help/ru_RU/k8s-net/k8s-ingress </br>
Calico статья: https://www.kryukov.biz/kubernetes/set-kubernetes-teoriya/calico/ </br>
Расшарить hello-world: https://kubernetes.io/docs/tutorials/stateless-application/expose-external-ip-address/ </br>
Микросервисное приложение в k8s + настройка ingress: https://serveradmin.ru/nastroyka-kubernetes/#_Ingress </br>
Статья по calico: https://habr.com/ru/company/flant/blog/485716/ </br>
Статья по хранилищам данных: https://serveradmin.ru/hranilishha-dannyh-persistent-volumes-v-kubernetes/ </br>
Работа с HELM: https://serveradmin.ru/rabota-s-helm-3-v-kubernetes/ </br>
Развёртывание MYSQL в k8s: https://itisgood.ru/2020/12/09/kak-razvernut-mysql-na-kubernetes/ </br>
Открытие доступа к приложению в k8s: https://kubernetes.io/ru/docs/tutorials/kubernetes-basics/expose/expose-intro/ </br>
Управление трафиком в Kubernetes-кластере с Calico: https://habr.com/ru/company/nixys/blog/494194/ </br>
Введение в kubectl(толковое объяснение от mail.ru): https://mcs.mail.ru/blog/kak-effektivnee-ispolzovat-kubectl-podrobnoe-rukovodstvo </br>
Demo-policy: https://docs.projectcalico.org/security/tutorials/kubernetes-policy-basic </br>
Подробная и понятная серия статей по k8s: https://russianblogs.com/article/3334128666/ </br>
Ingress IBM: https://www.ibm.com/docs/ru/control-desk/7.6.1.x?topic=kubernetes-installing-nginx-ingress-controller-in-cluster </br>
Ingress от mail.ru: https://mcs.mail.ru/help/ru_RU/k8s-net/k8s-ingress </br>
Объяснение работы Ingress: https://habr.com/ru/company/ruvds/blog/442646/ </br>
Объяснение yaml для k8s: https://russianblogs.com/article/49161592346/ </br>