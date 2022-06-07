## Задание 1
Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите бэкап БД и восстановитесь из него.

Перейдите в управляющую консоль mysql внутри контейнера.

Используя команду \h получите список управляющих команд.

Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

Приведите в ответе количество записей с price > 300.

### Ответ:
```commandline
\s
...
Server version:		8.0.29 MySQL Community Server - GPL
...
```

```mysql
mysql> \u test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)

mysql> select count(*) from orders o where o.price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

```
## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

### Ответ:
```commandline
mysql> CREATE USER 'test'@'localhost' 
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_QUERIES_PER_HOUR 100 
    -> PASSWORD EXPIRE INTERVAL 180 DAY 
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"fname": "Pretty", "lname": "James"}';
Query OK, 0 rows affected (0.02 sec)

mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "Pretty", "lname": "James"} |
+------+-----------+---------------------------------------+
1 row in set (0.01 sec)


```
## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

### Ответ:
Команда ```SET profiling = 1;``` включает профилирование запросов.
Первое выполнение ```SHOW PROFILES;``` после включения профилирования, вернуло пустой результат. Последующие запуски выводят время выполнения каждого запроса.
```commandline
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show profiles;
Empty set, 1 warning (0.00 sec)

mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show profiles;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00031150 | SET profiling = 1 |
+----------+------------+-------------------+

```


```commandline
ALTER TABLE orders ENGINE = MyISAM;
ALTER TABLE orders ENGINE = InnoDB;
mysql> show profiles;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.00031150 | SET profiling = 1                  |
|        2 | 0.10689800 | ALTER TABLE orders ENGINE = MyISAM |
|        3 | 0.12543800 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+

```
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

### Ответ:
Исходный файл:
```commandline
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

```

Размер ОЗУ:
```commandline
leonid@leonid-P85-D3:~ $ free
              всего        занято        свободно      общая  буф./врем.   доступно
Память:    16334280     6023516     4275724      261816     6035040     9720420
Подкачка:    15625212           0    15625212
leonid@leonid-P85-D3:~ $ 
```

30% ОЗУ ~ 536870912 Байт.

Измененный файл:
```commandline
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = ON
innodb_log_buffer_size = 1048576
innodb_buffer_pool_size = 536870912
innodb_log_file_size = 104857600

# Custom config should go here
!includedir /etc/mysql/conf.d/
```