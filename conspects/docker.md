# Установка Docker

```commandline
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
# Убедитесь, что установка будет выполняться из репозитория Docker, а не из репозитория Ubuntu по умолчанию:
apt-cache policy docker-ce
sudo apt install docker-ce
# Docker должен быть установлен, демон-процесс запущен, а для процесса активирован запуск при загрузке. Проверьте, что он запущен:
sudo systemctl status docker
# Проверка версии docker
docker version
```

# Удаление docker

```commandline
# определяем какие пакеты нужно удалить
dpkg -l | grep -i docker

sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli docker-compose-plugin
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce docker-compose-plugin

sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
```

# Установка последней версии docker-compose
```commandline
VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
DESTINATION=/usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION
echo $VERSION

```
Для остановки всех запущенных контейнеров используйте такую команду: 
docker container stop $(docker container ls -q)

Удалить остановленный контейнер можно так: 
docker rm [CONTAINER ID]

Удалить все остановленные контейнеры можно командой: 
docker container prune

docker run --name app -d -p 8080:80 raleonid/app-meow:0.0.1


docker-compose -f docker-compose.yaml up
docker exec -it 2_db_1 bash
docker exec -it 2_adminer_1 bash
docker exec -it 3_db_1 bash
docker ps
docker-compose pull
docker-compose up -d - запуск контейнеров в фоновом режиме
docker-compose stop
docker-compose down
docker-compose down --rmi all

docker-compose ps --a
docker-compose restart

### Вы можете проверить работающий контейнер, чтобы получить эту информацию:
sudo docker container inspect container_name_or_ID


psql -U postgres


SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges WHERE table_name in ('clients','orders');

\l
\d
\c test_db
UPDATE clients SET order_id = 3 WHERE id = 1;
UPDATE clients SET order_id = 4 WHERE id = 2;
UPDATE clients SET order_id = 5 WHERE id = 3;

SELECT c.id, c.family, o.name, o.price FROM clients c
JOIN orders o
ON c.order_id = o.id;

EXPLAIN SELECT c.id, c.family, o.name, o.price FROM clients c
JOIN orders o
ON c.order_id = o.id;

docker exec -it 3_db_1 bash -c "pg_dump -U postgres test_db > /media/postgresql/backup/test_db_$(date '+%Y-%m-%d-%H-%M-%S').sql"

docker run --rm -d -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=admin -v ~/PycharmProjects/devops-netology/homeworks/06-db-02-sql/src/3/pgdata1:/var/lib/postgresql/data -v ~/PycharmProjects/devops-netology/homeworks/06-db-02-sql/src/3/backup:/media/postgresql/backup --name psql postgres:12

docker exec -it psql bash -c "psql -U postgres test_db < /media/postgresql/backup/test_db_2022-05-25-21-42-12.sql"

docker exec -it 3_db_1 bash -c "pg_dumpall -U postgres > /media/postgresql/backup/test_db_$(date '+%Y-%m-%d-%H-%M-%S').sql"

docker exec -it psql bash -c "psql -U postgres -f /media/postgresql/backup/test_db_2022-05-25-22-15-58.sql postgres"

docker exec -it src_db_1 bash

sudo rm -Rf data && mkdir data

SET old_passwords=0;

CREATE USER 'test'@'localhost' 
IDENTIFIED WITH mysql_native_password BY 'test-pass'
WITH MAX_QUERIES_PER_HOUR 100 
PASSWORD EXPIRE INTERVAL 180 DAY 
FAILED_LOGIN_ATTEMPTS 3
ATTRIBUTE '{"fname": "Pretty", "lname": "James"}';

select attname, avg_width from pg_stats where tablename='orders';

SELECT t1.attname, t1.avg_width 
FROM pg_stats t1
JOIN (
    SELECT max(avg_width) max_avg 
    FROM pg_stats 
    WHERE tablename='orders') t2
ON t1.avg_width = t2.max_avg 
WHERE t1.tablename='orders';

CREATE TABLE orders_1 (CHECK (price>499)) INHERITS (orders);
CREATE TABLE orders_2 (CHECK (price<=499)) INHERITS (orders);
CREATE RULE orders_1_rule AS ON INSERT TO orders WHERE (price>499) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
CREATE RULE orders_2_rule AS ON INSERT TO orders WHERE (price<=499) DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);

docker exec -it src_db_1 bash -c "pg_dump -U postgres test_database > /media/postgresql/backup/test_db_$(date '+%Y-%m-%d-%H-%M-%S').sql"

pg_restore -U postgres /media/postgresql/backup/test_db_2022-06-09-21-30-29.sql -d test_database
psql -U postgres -d test_database -f /media/postgresql/backup/test_db_2022-06-09-21-30-29.sql

psql -U postgres test_database < /media/postgresql/backup/test_db_2022-06-09-21-30-29.sql
psql -U postgres test_database < /docker-entrypoint-initdb.d/test_db_2022-06-09-21-30-29.sql


docker image build -t raleonid/elasticsearch:7 .

sudo docker pull elasticsearch:7.17.4

docker network create somenetwork

sudo docker run -d --name elasticsearch1 --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.17.4

sudo docker exec -it elasticsearch bash

ll -la /etc/elasticsearch

sudo docker image build -t raleonid/elasticsearch:7.17.4 .

sudo docker stop elasticsearch1
sudo docker rm elasticsearch
sudo docker run -d --name elasticsearch --net somenetwork -v ./data:/var/lib -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" raleonid/elasticsearch:7.17.4

sudo docker logs elasticsearch

sudo docker run --rm -d --name elasticsearch --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -v /media/andr/90391f22-676d-469f-8cb3-7ac8a1760393/git/devops-netology/homeworks/06-db-05-elasticsearch/src/data:/var/lib/data raleonid/elasticsearch:7.17.4

sudo docker system prune -a
sudo docker images -a
sudo docker rmi Image raleonid/elasticsearch:7.17.4

sudo docker image push raleonid/elasticsearch:7.17.4

curl -X GET "localhost:9200/_cat/nodes?v&pretty"

Создание индексов:
curl -X PUT "localhost:9200/my-index-000001?pretty"

curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}
'

Состояние индексов:
curl -X GET "localhost:9200/_cat/indices"

sudo docker run --rm -d --name elasticsearch --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -v /media/andr/90391f22-676d-469f-8cb3-7ac8a1760393/git/devops-netology/homeworks/06-db-05-elasticsearch/src/data:/var/lib/data -v /media/andr/90391f22-676d-469f-8cb3-7ac8a1760393/git/devops-netology/homeworks/06-db-05-elasticsearch/src/snapshots:/usr/share/elasticsearch/snapshots raleonid/elasticsearch:7.17.4

# PUT _snapshot/my_repository/<my_snapshot_{now/d}>
curl -X PUT "localhost:9200/_snapshot/my_repository/%3Cmy_snapshot_%7Bnow%2Fd%7D%3E?pretty"

"reason" : "cannot restore index because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name"


cannot restore index because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name

torsocks wget -qO - https://api.ipify.org; echo
wget -qO - https://api.ipify.org; echo

sudo service privoxy restart
sudo service tor restart
sudo service privoxy start && sudo service tor start

sudo service tor stop
sudo service privoxy stop
sudo systemctl stop tinyproxy.service

