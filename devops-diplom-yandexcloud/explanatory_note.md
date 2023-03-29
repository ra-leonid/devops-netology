# Создание облачной инфраструктуры
Используемые версии:
terraform v1.4.2
terraform yandex provider v0.88.0
kubespray v2.21.0

## Обновляем terraform до последней версии

<details>
    <summary>Перед началом обновления terraform поднимаем free vpn.</summary>
    <p>

1. Устанавливаем OpenVpn:
```commandline
sudo apt-get install openvpn
```
2. Создаём каталог и переходим в него:
```commandline
mkdir ~/vpnbook
```
3. С [сайта](https://www.vpnbook.com/) качаем один из файлов настройки vpn в созданный каталог:

![](./img/vpnbook.png)
4. Настройка:
```commandline
cd ~/vpnbook

# Распаковать файлы настроек OpenVPN 
jar xvf vpnbook-openvpn-pl226.zip
rm vpnbook-openvpn-pl226.zip

# Создать файл с данными авторизации (их берём с сайта vpnbook см. скрин)
cat > auth.txt <<EOF
vpnbook
dd4e58m
EOF

# Заменить строку «auth-user-pass» на «auth-user-pass auth.txt»
sed -i 's/auth-user-pass/auth-user-pass auth.txt/' vpnbook-pl226-udp53.ovpn
```
5. Поднимаем VPN:
```commandline
sudo openvpn --config ~/vpnbook/vpnbook-pl226-udp53.ovpn
```
    </p>
</details>

Обновление terraform выполнялось по инструкции с [сайта](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)

```commandline
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```
### Результат:
![](img/update-terraform.png)

## Предварительная подготовка к установке и запуску Kubernetes кластера.
1. создаём каталог с авторизационными данными (добавлен в .gitignore):
```commandline
mkdir ./.secrets

```
2. Создаём сервисный аккаунт:
```commandline
# Узнать список каталогов
yc resource-manager folder list

# Создать сервисный аккаунт для выбранного каталога
yc iam service-account create --name sa-terraform --folder-name new --description "this is a service account for working with terraform"

# Назначить роль editor
yc resource-manager folder add-access-binding new --role editor --subject serviceAccount:aje32701sqo6nkcbvdsp

# Создать файл авторизации
yc iam key create --folder-name new --service-account-name sa-terraform --output .key.json
```
2. Создаём статический ключ доступа:
```commandline
yc iam access-key create --folder-name new --service-account-name sa-terraform
```
3. Сохраняем данные статического ключа для дальнейшего использования при доступе к s3 bucket:
```commandline
cat > ./.secrets/backend.conf <<EOF
access_key="xxx"
secret_key="xxx"
EOF
terraform init -reconfigure -backend-config=./.secrets/backend.conf
```

<details>
    <summary>Другие варианты использования статического ключа</summary>
    <p>

1. В credetials AWS:
```commandline
mkdir ~/.aws
cat > ~/.aws/auth.txt <<EOF
[default]
aws_access_key_id="xxx"
aws_secret_access_key="xxx"
EOF
```
2. В секции backend файла backend.tf (плохой вариант):
```terraform
terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "tfstate-diplom-devops"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    access_key = "xxx"
    secret_key = "xxx"
  }
}
```
2. В переменных среды:
```commandline
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"
```
3. Передавать в параметрах выполнения команд terraform:
```commandline
terraform init -reconfigure \
    -backend-config="access_key=xxx" \
    -backend-config="secret_key=xxx"
```
    </p>
</details>

4. Создаём S3 бакет:
```commandline
yc storage bucket create --name tfstate-diplom-devops
```

## Настройка workspace
1. Создаём рабочие пространства:
```commandline
terraform workspace new stage
terraform workspace new prod
```
2. Список пространств:
```commandline
terraform workspace list
```
3. Выбираем нужное пространство:
```commandline
terraform workspace select stage
```
4. Тестируем
```commandline
terraform apply -auto-approve
terraform destroy -auto-approve
```

# Создание Kubernetes кластера.
Кластер разворачиваем с помощью Kuberspray. 
* Для `stage` окружения поднимаем: 1 control-plane и 1 node;
* Для `prod` окружения поднимаем: 3 control-plane и 3 node, в разных зонах доступности;

Доступ к k8s-инстансам будет только через nat-instance, все ВМ кластера без публичных ip.

Конфигурация Kuberspray и запуск выполняются автоматически посредством terraform, сразу после поднятия инфраструктуры.
* Настройка хостов в ресурсе `kuberspray_inventory` файла [inventory.tf](src/terraform/k8s/inventory.tf);
* Старт установки реализован в файле [kubespray.tf](src/terraform/k8s/kubespray.tf);

Реализуем "проброс" подключения к ВМ приватной сети через nat-instance:
1. В [host.tpl](src/terraform/k8s/templates/hosts.tpl) добавляем секцию "bastion".
2. В [site.yml](src/ansible/site.yml) реализуем проброс "~/.kube/config", заполнение "server" и "proxy-url", ssh-туннель.

### Результат:
![](img/create-k8s-cluster.png)

---
```commandline
# Первая инициализация:
terraform init -reconfigure -backend-config=./.secrets/backend.conf
terraform workspace select stage
terraform init
terraform validate
terraform plan

terraform apply -auto-approve
terraform destroy -auto-approve

ssh -D 1337 -f -C -q -N ubuntu@84.201.128.134 -p 22322
```

# Создание тестового приложения
* Создаем образ командой ```docker image build -t raleonid/app-meow:0.0.1 .```
* Запускаем контейнер командой ```docker run -d -p 8080:80 raleonid/app-meow:0.0.1```
* Проверяем
* Отправляем образ в удаленный репозиторий 

```commandline
# Авторизуемся
docker login
# Отправляем в докер-репозиторий
docker image push raleonid/app-meow:0.0.1
```
### Результат:
[Контейнер](https://hub.docker.com/repository/docker/raleonid/app-meow)

[Репозиторий тестового приложения](https://github.com/ra-leonid/app-meow)

## Подготовка cистемы мониторинга и деплой приложения
