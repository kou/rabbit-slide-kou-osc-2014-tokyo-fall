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

CREATE TABLE ratings_all_index (
  comment TEXT,
  FULLTEXT INDEX (comment)
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE ratings_all_index_id (
  id INT PRIMARY KEY AUTO_INCREMENT,
  comment TEXT,
  FULLTEXT INDEX (comment)
) DEFAULT CHARSET=utf8mb4;
