-- noinspection SqlNoDataSourceInspectionForFile

CREATE DATABASE company_blog;

\c company_blog;

CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    profile_image VARCHAR(64) NOT NULL DEFAULT 'default_profile.png',
    email VARCHAR(64) UNIQUE NOT NULL,
    username VARCHAR(64) UNIQUE NOT NULL,
    password_hash VARCHAR(128),
    CONSTRAINT email_unique UNIQUE(email),
    CONSTRAINT username_unique UNIQUE(username)
);
CREATE INDEX users_email_idx ON users(email);
CREATE INDEX users_username_idx ON users(username);

CREATE TABLE blog_posts(
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    date TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'UTC'),
    title VARCHAR(140) NOT NULL,
    text TEXT NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES users(id)
                       ON DELETE CASCADE -- Delete reference posts when user deleted
);
CREATE INDEX blog_posts_user_id_idx ON blog_posts(user_id);