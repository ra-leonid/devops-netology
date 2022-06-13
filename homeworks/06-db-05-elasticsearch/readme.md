## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib` 
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения
- обратите внимание на настройки безопасности такие как `xpack.security.enabled` 
- если докер образ не запускается и падает с ошибкой 137 в этом случае может помочь настройка `-e ES_HEAP_SIZE`
- при настройке `path` возможно потребуется настройка прав доступа на директорию

Далее мы будем работать с данным экземпляром elasticsearch.

### Ответ:
[Dockerfile](./src/Dockerfile)

[image](https://hub.docker.com/repository/docker/raleonid/elasticsearch)

http://localhost:9200/

Команда запуска:
```commandline
sudo docker run --rm -d --name elasticsearch --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -v /home/andr/git/devops-netology/homeworks/06-db-05-elasticsearch/src/data:/var/lib/data raleonid/elasticsearch:7.17.4
```

```json
{
  "name" : "netology_test",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "17BWuLuXTP-Fp3SU8Fq4Yw",
  "version" : {
    "number" : "7.17.4",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "79878662c54c886ae89206c685d9f1051a9d6411",
    "build_date" : "2022-05-18T18:04:20.964345128Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

### Ответ:

Создание индекса ind-1:

```commandline
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
```
Ответ elastic:

```commandline
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
```

Создание индекса ind-2:

```commandline
curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 2,  
      "number_of_replicas": 1 
    }
  }
}
'
```

Ответ elastic:

```commandline
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
```

Создание индекса ind-3:

```commandline
curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 3,  
      "number_of_replicas": 2 
    }
  }
}
'
```
Ответ elastic:

```commandline
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```

Список индексов и их состояний:

```commandline
curl -X GET "localhost:9200/_cat/indices"
green  open .geoip_databases RECBoJxGQPeXDs8N4lc60Q 1 0 41 0 38.8mb 38.8mb
green  open ind-1            4mjeslDDRYCtoIqzw4NjDw 1 0  0 0   226b   226b
yellow open ind-3            slN9yOU_QlOJXTSaTkV3Dg 3 2  0 0   678b   678b
yellow open ind-2            aPVmFGMEQcW-E_pVl6m8AA 2 1  0 0   452b   452b
```
Green только индексы, у которого нет реплик. У остальных yellow, т.к. мы не поднимали реплики, а для них они нужны.

Удаляем индексы:
```commandline
curl -X DELETE "localhost:9200/ind-1?pretty"
curl -X DELETE "localhost:9200/ind-2?pretty"
curl -X DELETE "localhost:9200/ind-3?pretty"
```

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

### Ответ:

Каталог для репозиториев создаем при создании docker образа в [Dockerfile](./src/Dockerfile)
Регистрация репозитория для снапшотов:

```commandline
curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/usr/share/elasticsearch/snapshots"
  }
}
'
```

Получаем ответ с ошибкой:

```commandline
{
  "error" : {
    "root_cause" : [
      {
        "type" : "repository_exception",
        "reason" : "[netology_backup] location [/usr/share/elasticsearch/snapshots] doesn't match any of the locations specified by path.repo because this setting is empty"
      }
    ],
    "type" : "repository_exception",
    "reason" : "[netology_backup] failed to create repository",
    "caused_by" : {
      "type" : "repository_exception",
      "reason" : "[netology_backup] location [/usr/share/elasticsearch/snapshots] doesn't match any of the locations specified by path.repo because this setting is empty"
    }
  },
  "status" : 500
}
```

Добавляем переменную в [Dockerfile](./src/Dockerfile) path.repo=/usr/share/elasticsearch/snapshots, пересоздаем образ, перезапускаем контейнер, даём полные права на хостовой машине на каталог snapshots:

```commandline
docker stop elasticsearch
docker image build -t raleonid/elasticsearch:7.17.4 .
docker run --rm -d --name elasticsearch --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -v /home/leonid/PycharmProjects/devops-netology/homeworks/06-db-05-elasticsearch/src/data:/var/lib/data -v /home/leonid/PycharmProjects/devops-netology/homeworks/06-db-05-elasticsearch/src/snapshots:/usr/share/elasticsearch/snapshots raleonid/elasticsearch:7.17.4

sudo chmod -R 777 ./snapshots/
```
                   
Теперь регистрация репозитория снапшотов проходит корректно:

```commandline
curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/usr/share/elasticsearch/snapshots"
  }
}
'
{
  "acknowledged" : true
}
```

Создаём индекс:

```commandline
curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}
'

{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
```

Список индексов:

```commandline
curl -X GET "localhost:9200/_cat/indices"
green open .geoip_databases BwhH5vQDR_OSQlrd2A8vPA 1 0 41 0 38.9mb 38.9mb
green open test             aqpxf6JXQ4Kx0otrE-ReBA 1 0  0 0   226b   226b
```

Создаём снапшот:

```commandline
curl -X PUT "localhost:9200/_snapshot/netology_backup/%3Cmy_snapshot_%7Bnow%2Fd%7D%3E?pretty"
{
  "accepted" : true
}
```

Список файлов:

```commandline
итого 56
drwxrwxrwx 3 root   root    4096 июн 15 00:34 ./
drwxrwxr-x 4 leonid leonid  4096 июн 15 00:29 ../
-rw-rw-r-- 1 leonid root    1434 июн 15 00:34 index-0
-rw-rw-r-- 1 leonid root       8 июн 15 00:34 index.latest
drwxrwxr-x 6 leonid root    4096 июн 15 00:34 indices/
-rw-rw-r-- 1 leonid root   29270 июн 15 00:34 meta-KB8UOGBaSoeSj3YvBjDa1A.dat
-rw-rw-r-- 1 leonid root     721 июн 15 00:34 snap-KB8UOGBaSoeSj3YvBjDa1A.dat
```

Удаляем индекс `test` и создаём индекс `test-2`:

```commandline
curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}

curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
```

Список индексов:

```commandline
curl -X GET "localhost:9200/_cat/indices"
green open .geoip_databases BwhH5vQDR_OSQlrd2A8vPA 1 0 41 0 38.9mb 38.9mb
green open test-2           VUz8kYcqTiyFRuDQdIWEgg 1 0  0 0   226b   226b
```

Получаем список репозиториев и снапшотов:

```commandline
curl -X GET "localhost:9200/_snapshot?pretty"
{
  "netology_backup" : {
    "type" : "fs",
    "uuid" : "ov7ZmPfuRqiVnc6pbp74hA",
    "settings" : {
      "location" : "/usr/share/elasticsearch/snapshots"
    }
  }
}

curl -X GET "localhost:9200/_snapshot/netology_backup/*?verbose=false&pretty"
{
  "snapshots" : [
    {
      "snapshot" : "my_snapshot_2022.06.14",
      "uuid" : "KB8UOGBaSoeSj3YvBjDa1A",
      "repository" : "netology_backup",
      "indices" : [
        ".ds-.logs-deprecation.elasticsearch-default-2022.06.14-000001",
        ".ds-ilm-history-5-2022.06.14-000001",
        ".geoip_databases",
        "test"
      ],
      "data_streams" : [ ],
      "state" : "SUCCESS"
    }
  ],
  "total" : 1,
  "remaining" : 0
}
```

Восстанавливаем индекс test из snapshot, созданного ранее:

```commandline
curl -X POST "localhost:9200/_snapshot/netology_backup/my_snapshot_2022.06.14/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "test"
}
'
{
  "accepted" : true
}
```

Список индексов:

```commandline
curl -X GET "localhost:9200/_cat/indices"
green open .geoip_databases BwhH5vQDR_OSQlrd2A8vPA 1 0 41 0 38.9mb 38.9mb
green open test-2           VUz8kYcqTiyFRuDQdIWEgg 1 0  0 0   226b   226b
green open test             r3DjeGxgQnSWVgKwkWy_Ig 1 0  0 0   226b   226b
```