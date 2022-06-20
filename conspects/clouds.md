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
5. В настройках файла packer заполняем значение token folder_id subnet_id zone

6. Создаем образ с помощью packer:
```commandline
cd ~/PycharmProjects/devops-netology/05-virt-04-docker-compose/src/packer/
packer build centos-7-base.json
```
7. Вывод параметров образа
```commandline
yc compute image list
```
8. Удаление подсети и сети:
```commandline
yc vpc subnet delete --name my-subnet-a && yc vpc network delete --name net
```
9. Чтобы не испытывать проблем с ограничениями Hashicorp, переопределяем обращения terraform к репо yc
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
10. Создаем сервисный аккаунт в облаке:
```commandline
yc iam service-account create --name robot --description "this is my favorite service account"

# либо
yc iam service-account create --name robot --folder-name default --description "service account"
yc iam service-account create --name robot --folder-id b1gradps4tqg50qntprp --description "service account"
```
11. Назначаем ему роли
```commandline
# узнаем id
yc iam service-account list

# назначаем роль editor
yc resource-manager folder add-access-binding b1gradps4tqg50qntprp --role editor --subject serviceAccount:ajero42nm28dhqlvvorn
```
12. Переходим в каталог terraform и создаем файл авторизации:
```commandline
cd ~/PycharmProjects/devops-netology/05-virt-04-docker-compose/src/terraform/

yc iam key create --service-account-name robot --output .key.json
yc iam key create --folder-id b1gradps4tqg50qntprp --service-account-name robot --output .key.json
```

12.1. Создаем статические ключи доступа
```commandline
yc iam access-key create --folder-id b1gradps4tqg50qntprp --service-account-name robot
```

13. Заполняем параметры в файле variables.tf

14. Запускаем создание ВМ с помощью terraform
```commandline
terraform init
terraform validate
terraform plan
terraform123 apply -auto-approve
```
15. Переходим в каталог ansible
```commandline
cd ../ansible
```
16. В файле inventory заполняем внешний ip созданной ВМ.
17. Выполняем установку ПО в созданной ВМ
```commandline
cd ../ansible
ansible-playbook provision.yml
```
18. Удаляем всё что создали:
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