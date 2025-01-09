create database if not exists agenda default character set utf8 collate utf8_general_ci;
use agenda;
create table if not exists Person (id int unsigned not null AUTO_INCREMENT, name VARCHAR(100) NOT NULL, PRIMARY KEY (id) );

