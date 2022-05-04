1. Создание сети в облаке:
```commandline
yc vpc network create --name net --labels my-label=netology --description "my first network via yc"
```

2. Создание подсети в облаке:
```commandline
yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "my first subnet via yc"
```

3. Вывод параметров:
```commandline
yc config list
```

4. df
```commandline
yc compute image list
```

5. Удаление подсети и сети:
```commandline
yc vpc subnet delete --name my-subnet-a
yc vpc network delete --name net
```