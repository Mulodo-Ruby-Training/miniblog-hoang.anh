-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS mini_blog
CHARACTER SET utf8
COLLATE utf8_general_ci;

-- USE DATABASE CREATED
USE mini_blog;

-- SET ENCODING
SET NAMES utf8;

--
-- Table `user`
--

-- CREATE TABLE

CREATE TABLE IF NOT EXISTS user(
	id int(11) NOT NULL AUTO_INCREMENT,
	username VARCHAR(64) NOT NULL,
	password VARCHAR(64) NOT NULL,
	firstname VARCHAR(30) NOT NULL,
	lastname VARCHAR(30) NOT NULL,
	avatar VARCHAR(100),
	gender TINYINT NOT NULL DEFAULT 1,
	birthday DATE,
	address VARCHAR(200),
	city VARCHAR(30),
	email VARCHAR(50) NOT NULL,
	mobile VARCHAR(20),	
	created_dt DATETIME NOT NULL,
	updated_dt DATETIME NOT NULL,

	FULLTEXT INDEX(username, firstname,lastname),
	PRIMARY KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table `post`
--

-- CREATE TABLE

CREATE TABLE IF NOT EXISTS post(
	id int(11) NOT NULL AUTO_INCREMENT,
	title VARCHAR(100) NOT NULL,
	description TINYTEXT NOT NULL,
	content LONGTEXT NOT NULL,
	image VARCHAR(100),
	user_id int(11) NOT NULL,
	status TINYINT NOT NULL,
	created_dt DATETIME NOT NULL,
	updated_dt DATETIME NOT NULL,

	FULLTEXT INDEX(title, description,content),
	PRIMARY KEY(id),
	FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table `comment`
--

-- CREATE TABLE

CREATE TABLE IF NOT EXISTS comment(
	id int(11) NOT NULL AUTO_INCREMENT,
	content VARCHAR(250) NOT NULL,
	user_id int(11) NOT NULL,
	post_id int(11) NOT NULL,
	created_dt DATETIME NOT NULL,
	updated_dt DATETIME NOT NULL,
	
	PRIMARY KEY(id),
	FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE,
	FOREIGN KEY(post_id) REFERENCES post(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;