DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;
PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT,
  lname TEXT
  -- is_instructor BOOLEAN
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT,
  body TEXT,
  user_id INTEGER,

  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  reply_id INTEGER,
  user_id INTEGER,
  body TEXT,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(reply_id) REFERENCES replies(id)
);

CREATE TABLE questions_likes (
  id INTEGER,
  likes BOOLEAN,
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Vulma', 'Jones'),
  ('David', 'Oliver');


INSERT INTO
  questions (title, body, user_id)
VALUES
  ('psql no working', 'my psql is stuck in the ceiling fan nooo', (SELECT id FROM users WHERE fname = 'Vulma')),
  ('ruby', 'I miss ruby', (SELECT id FROM users WHERE fname = 'David'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES 
  ((SELECT id FROM users WHERE fname = 'Vulma'), (SELECT id FROM questions WHERE title = 'psql no working')),
  ((SELECT id FROM users WHERE fname = 'David'), (SELECT id FROM questions WHERE title = 'ruby'));

INSERT INTO
  replies (question_id, reply_id, user_id, body)
VALUES 
  ((SELECT id FROM questions WHERE title = 'psql no working'), NULL, (SELECT id FROM users WHERE fname = 'Vulma'), 'replys1'),
  ((SELECT id FROM questions WHERE title = 'ruby'), 1, (SELECT id FROM users WHERE fname = 'David'), 'reply2'),
  ((SELECT id FROM questions WHERE title = 'psql no working'), 1, (SELECT id FROM users WHERE fname = 'Vulma'), 'reply to reply2');

INSERT INTO 
  questions_likes (likes, user_id, question_id)
VALUES 
  (1, (SELECT id FROM users WHERE fname = 'Vulma'), (SELECT id FROM questions WHERE title = 'psql no working')),
  (0, (SELECT id FROM users WHERE fname = 'David'), (SELECT id FROM questions WHERE title = 'ruby'));
