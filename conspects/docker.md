docker-compose -f docker-compose.yaml up
docker exec -it 2_db_1 bash
docker exec -it 2_adminer_1 bash
docker exec -it 3_db_1 bash
docker ps
docker-compose pull
docker-compose up -d
docker-compose stop
docker-compose down
docker-compose down --rmi all

docker-compose ps --a
docker-compose restart


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

sudo rm -Rf data
mkdir data

SET old_passwords=0;

CREATE USER 'test'@'localhost' 
IDENTIFIED WITH mysql_native_password BY 'test-pass'
WITH MAX_QUERIES_PER_HOUR 100 
PASSWORD EXPIRE INTERVAL 180 DAY 
FAILED_LOGIN_ATTEMPTS 3
ATTRIBUTE '{"fname": "Pretty", "lname": "James"}';