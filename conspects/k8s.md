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

# Получить список подов в namespace kube-system:
kubectl get pods --namespace=kube-system
kubectl get pods -n=kube-system

# Получить список подов с отбором по label:
kubectl get pods --selector app=main
kubectl get pods -l app=main

# Получить список подов с выводом подробной информации:
kubectl get pods -o wide

# Получить список подов с выводом информации о labels:
kubectl get pods --show-labels

# Получить подробную информацию о поде:
kubectl describe pod nginx

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

# Изменить манифест деплоймента:
kubectl edit deployment hello-node

# Изменить манифест деплоймента командой (здесь мы изменяем количество реплик на 5):
kubectl scale deploy hello-node -n default --replicas=5

# Display information about your ReplicaSet objects:
kubectl get replicasets
kubectl describe replicasets

# Получить список namespaces:
kubectl get namespace
kubectl get ns

# Просмотр логов:
kubectl logs hello-node-697897c86-fvngg
kubectl logs hello-node-697897c86-fvngg --all-containers

# Проброс порта пода до локальной ВМ
kubectl port-forward hello-node-697897c86-fvngg 8080:8080
# Проверка
curl http://127.0.0.1:8080

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