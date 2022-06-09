## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

### Ответ
```commandline
\l[+]   [PATTERN]      list databases
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
\d[S+]                 list tables, views, and sequences
\dt[S+] [PATTERN]      list tables
\q                     quit psql
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

### Ответ
```dbn-sql
SELECT t1.attname, t1.avg_width 
FROM pg_stats t1
JOIN (
    SELECT max(avg_width) max_avg 
    FROM pg_stats 
    WHERE tablename='orders') t2
ON t1.avg_width = t2.max_avg 
WHERE t1.tablename='orders';
```
```commandline
 attname | avg_width 
---------+-----------
 title   |        16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

### Ответ

```dbn-psql
CREATE TABLE orders_1 (CHECK (price>499)) INHERITS (orders);
CREATE TABLE orders_2 (CHECK (price<=499)) INHERITS (orders);
CREATE RULE orders_1_rule AS ON INSERT TO orders WHERE (price>499) DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);
CREATE RULE orders_2_rule AS ON INSERT TO orders WHERE (price<=499) DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);
```
Если бы мы изначально знали диапазон разброса цен, их распределение по диапазонам, то наверно можно было бы исключить и сразу в архитектуре заложить шардирование, но это маловероятно.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

### Ответ

В конец команды создания таблицы добавить строку ограничения.

Было:
```dbn-psql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);

```

Стало:

```dbn-psql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0,
    CONSTRAINT unique_title UNIQUE(title)
);
```

Либо отдельной командой:
```dbn-psql
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT unique_title UNIQUE (title);
```


