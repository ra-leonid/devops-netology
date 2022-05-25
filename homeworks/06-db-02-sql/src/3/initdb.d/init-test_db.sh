#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE USER "test-admin-user";
	CREATE USER "test-simple-user";
	CREATE DATABASE test_db;

	GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user";

  \connect "test_db";

	CREATE TABLE orders (id SERIAL PRIMARY KEY, name VARCHAR(20), price INT);
	CREATE TABLE clients (id SERIAL PRIMARY KEY, family VARCHAR(100), country VARCHAR(50), order_id INT REFERENCES orders (id));
	CREATE INDEX clients_country_index ON clients (country);

	GRANT ALL PRIVILEGES ON TABLE orders, clients TO "test-admin-user";
	GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE orders, clients TO "test-simple-user";

  -- ВСТАВКА ПЕРВОНАЧАЛЬНЫХ ДАННЫХ

  -- ТАБЛИЦА "orders"
  INSERT INTO orders (name, price) VALUES ('Шоколад', 10);
  INSERT INTO orders (name, price) VALUES ('Принтер', 3000);
  INSERT INTO orders (name, price) VALUES ('Книга', 500);
  INSERT INTO orders (name, price) VALUES ('Монитор', 7000);
  INSERT INTO orders (name, price) VALUES ('Гитара', 4000);

  -- ТАБЛИЦА "clients"
  INSERT INTO clients (family, country) VALUES ('Иванов Иван Иванович', 'USA');
  INSERT INTO clients (family, country) VALUES ('Петров Петр Петрович', 'Canada');
  INSERT INTO clients (family, country) VALUES ('Иоганн Себастьян Бах', 'Japan');
  INSERT INTO clients (family, country) VALUES ('Ронни Джеймс Дио', 'Russia');
  INSERT INTO clients (family, country) VALUES ('Ritchie Blackmore', 'Russia');

EOSQL