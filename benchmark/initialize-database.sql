DROP DATABASE IF EXISTS full_text_search;
CREATE DATABASE full_text_search;
USE full_text_search;

CREATE TABLE ratings_1000 (
  comment TEXT
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE ratings_5000 (
  comment TEXT
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE ratings_10000 (
  comment TEXT
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE ratings_100000 (
  comment TEXT
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE ratings_all (
  comment TEXT
) DEFAULT CHARSET=utf8mb4;
