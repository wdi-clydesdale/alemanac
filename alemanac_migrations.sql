CREATE DATABASE alemanac;

\c alemanac;

CREATE TABLE users (id SERIAL PRIMARY KEY, first_name varchar(25), last_name varchar(25), username varchar(25), email varchar(50), password_salt varchar(255), password_hash varchar (255));

CREATE TABLE entries (id SERIAL PRIMARY KEY, user_id INT references users(id), beer_id INT, notes text, vote INT, consume_location varchar(100), consume_date date, entry_date timestamp, is_custom boolean, beer_name varchar(30), brewery varchar(50), brew_location varchar(50), abv real);
