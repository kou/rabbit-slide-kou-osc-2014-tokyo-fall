DROP DATABASE IF EXISTS full_text_search;
CREATE DATABASE full_text_search;
USE full_text_search;

CREATE TABLE ratings (
  comment TEXT
) DEFAULT CHARSET=utf8mb4;
