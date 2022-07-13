
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows; 
DROP TABLE IF EXISTS questions ;
DROP TABLE IF EXISTS users;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL

);


CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- USERS THAT ARE FOLLOWING QUESTIONS , NOT THAT THEY HAVE MADE IT

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id)

);

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL, 

   FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
users (fname,lname)
VALUES
('Anna','Fisher'),
('Vince', 'Shuali'),
('Jay','Reddy'),
('Karen','Siu');

INSERT INTO 
questions (title,body,user_id)
VALUES
('Schedule','When will the schedule be published?',(SELECT id FROM users WHERE fname = 'Anna')),
('Games','Will we be having game night on Friday?',(SELECT id FROM users WHERE fname = 'Vince')),
('Lunch','Can I organize a lunch outing to Chinatown?',(SELECT id FROM users WHERE fname = 'Karen')),
('Discord','Who wants to be the Discord moderator?',(SELECT id FROM users WHERE fname = 'Jay'));

INSERT INTO
question_follows (user_id,question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Anna'), (SELECT id FROM questions WHERE title = 'Games')),
    ((SELECT id From users where fname = 'Vince'), (SELECT id FROM questions WHERE title = 'Lunch')),
     ((SELECT id FROM users WHERE fname = 'Karen'),(SELECT id FROM questions WHERE title = 'Discord')),
    ((SELECT id FROM users WHERE fname = 'Karen'),(SELECT id FROM questions WHERE title = 'Games'));

INSERT INTO
replies (body, user_id, question_id, parent_id)

VALUES
    ('Next week', (SELECT id FROM users WHERE fname = 'Vince'), (SELECT id FROM questions WHERE title = 'Schedule'), NULL),
    ('Hell yeah', (SELECT id FROM users WHERE fname = 'Anna'), (SELECT id FROM questions WHERE title = 'Games'), NULL);

INSERT INTO
question_likes (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Games'), (SELECT id FROM users WHERE fname = 'Anna')),
    ((SELECT id FROM questions WHERE title = 'Games'), (SELECT id FROM users WHERE fname = 'Vince')),
    ((SELECT id FROM questions WHERE title = 'Discord'), (SELECT id FROM users WHERE fname = 'Karen'));

INSERT INTO replies (body, user_id, question_id, parent_id)
VALUES
    ('They said Monday', (SELECT id FROM users WHERE fname = 'Jay'), (SELECT id FROM questions WHERE title = 'Schedule'), (SELECT id FROM replies WHERE body = 'Next week'));
