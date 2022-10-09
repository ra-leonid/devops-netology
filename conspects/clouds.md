1. Инициализация аккаунта yc
```commandline
yc init
```
2. Создание сети в облаке:
```commandline
yc vpc network create --name net --labels my-label=netology --description "my first network via yc"
```
3. Создание подсети в облаке:
```commandline
yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "my first subnet via yc"
```
4. Вывод основных параметров:
```commandline
yc config list
```
5. Чтобы получить список доступных образов, выполните следующую команду:
```commandline
yc compute image list --folder-id standard-images
```
6. Создание ВМ с командной строки:
```commandline
yc compute instance create \
  --name centos7 \
  --zone ru-central1-a \
  --network-interface subnet-name=my-subnet-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=centos-7 \
  --ssh-key ~/.ssh/id_rsa.pub
```

```commandline
yc compute instance create \
  --name ubuntu \
  --zone ru-central1-a \
  --network-interface subnet-name=my-subnet-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts \
  --ssh-key ~/.ssh/id_rsa.pub
```
6. Получить список ВМ:
```commandline
yc compute instance list
```
7. Информация о ВМ:
```commandline
yc compute instance get centos7
```
8. Подключиться 
```commandline
ssh -i ~/.ssh/id_rsa yc-user@51.250.91.115
ssh yc-user@51.250.8.89
```
8. Удалить ВМ
```commandline
yc compute instance delete centos7 && yc compute instance delete ubuntu
```
9. В настройках файла packer заполняем значение token folder_id subnet_id zone
10. Создаем образ с помощью packer:
```commandline
cd ~/PycharmProjects/devops-netology/05-virt-04-docker-compose/src/packer/
packer build centos-7-base.json
```
9. Вывод параметров образа
```commandline
yc compute image list
```
10. Удаление подсети и сети:
```commandline
yc vpc subnet delete --name my-subnet-a && yc vpc network delete --name net
```
11. Чтобы не испытывать проблем с ограничениями Hashicorp, переопределяем обращения terraform к репо yc
```commandline
# создаем файл ~/.terraformrc
nano ~/.terraformrc

# Добавьте в него следующий блок:
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
12. Создаем сервисный аккаунт в облаке:
```commandline
yc iam service-account create --name robot --description "this is my favorite service account"

# либо
yc iam service-account create --name robot --folder-name default --description "service account"
yc iam service-account create --name robot --folder-id b1gradps4tqg50qntprp --description "service account"
```
13. Назначаем ему роли
```commandline
# узнаем id
yc iam service-account list

# назначаем роль editor
yc resource-manager folder add-access-binding b1gradps4tqg50qntprp --role editor --subject serviceAccount:ajero42nm28dhqlvvorn
```
14. Переходим в каталог terraform и создаем файл авторизации:
```commandline
cd ~/PycharmProjects/devops-netology/05-virt-04-docker-compose/src/terraform/

yc iam key create --service-account-name robot --output .key.json
yc iam key create --folder-id b1gradps4tqg50qntprp --service-account-name robot --output .key.json
```

15. Создаем статические ключи доступа
```commandline
yc iam access-key create --folder-id b1gradps4tqg50qntprp --service-account-name robot
```

16. Заполняем параметры в файле variables.tf

17. Запускаем создание ВМ с помощью terraform
```commandline
terraform init
terraform validate
terraform plan
terraform123 apply -auto-approve
```
18. Переходим в каталог ansible
```commandline
cd ../ansible
```
19. В файле inventory заполняем внешний ip созданной ВМ.
20. Выполняем установку ПО в созданной ВМ
```commandline
cd ../ansible
ansible-playbook provision.yml
```
21. Удаляем всё что создали:
```commandline
terraform destroy -auto-approve
yc compute image delete --name centos-7-base
```

Получить список образов Яндекс:
```commandline
yc compute image list --folder-id standard-images
```

Для автоматического подхватывания токена, и ID сети, и чтобы не хранить их в коде, их можно передать через локальные переменные.
Получить эти значения, можно выполнив команду:

```commandline
yc config list
```

Результат подставляем в переменные:
```commandline
export TF_VAR_yc_token=
export TF_VAR_yc_cloud_id=
```

Terraform читает переменные, и все, которые начинаются с `TF_VAR_` переносит к себе, отбрасывая этот префикс.

Подключение к ВМ:
```commandline
ssh 51.250.78.141 -l centos
```