CREATE DATABASE alemanac;

\c alemanac;

CREATE TABLE users (id SERIAL PRIMARY KEY, first_name varchar(25), last_name varchar(25), username varchar(25), email varchar(50), password_salt varchar(255), password_hash varchar (255));

CREATE TABLE entries (id SERIAL PRIMARY KEY, user_id INT references users(id), beer_id INT, notes text, vote INT, consume_location varchar(100), consume_date date, entry_date timestamp, is_custom boolean, beer_name varchar(30), brewery varchar(50), brew_location varchar(50), abv real);

INSERT INTO users (first_name, last_name, username, email, password_salt, password_hash) VALUES ('Joe','Wilson','joewilson','joe@gmail.com','1324','14223');

INSERT INTO users (first_name, last_name, username, email, password_salt, password_hash) VALUES ('Mary','Contrary','thatgirl','mary@yahoo.com','9324','22223');

INSERT INTO entries (user_id, beer_id, notes, vote, consume_location, consume_date, entry_date, is_custom, beer_name, brewery, brew_location, abv)
   VALUES (1, 2, 'I like this beer', 5, 'Chicago',2015-6-30,2015-7-31,TRUE,'Bud Light Lime','Budweiser','St. Louis',5);

INSERT INTO entries (user_id, beer_id, notes, vote, consume_location, consume_date, entry_date, is_custom, beer_name, brewery, brew_location, abv)
  VALUES (2, 5, 'It da bomb!', 2, 'Boston',2013-2-20,2014-2-1,TRUE,'Sam Adams Lager','Sam Adams','Boston',4.5);
