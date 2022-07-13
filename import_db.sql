
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Question_likes;
DROP TABLE IF EXISTS Replies;
DROP TABLE IF EXISTS question_follows; 
DROP TABLE IF EXISTS Questions ;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL

);


CREATE TABLE Questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT,
    User_id INTEGER NOT NULL,

    FOREIGN KEY (User_id) REFERENCES Users(id)
);

-- USERS THAT ARE FOLLOWING QUESTIONS , NOT THAT THEY HAVE MADE IT

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

FOREIGN KEY (user_id) REFERENCES Users(id),
FOREIGN KEY(question_id) REFERENCES Questions(id)
);

CREATE TABLE Replies (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,

    FOREIGN KEY (user_id) REFERENCES Users(id)
    FOREIGN KEY (parent_id) REFERENCES Replies(id)

);

CREATE TABLE Question_likes(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL, 

   FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY(question_id) REFERENCES Questions(id)
);

INSERT INTO
Users (fname,lname)
VALUES
('Anna','Fisher'),
('Vince', 'Shuali'),
('Jay','Reddy'),
('Karen','Siu');

INSERT INTO 
Questions (title,body,user_id)
VALUES
('Schedule','When will the schedule be published?',(SELECT id FROM Users WHERE fname = 'Anna')),
('Games','Will we be having game night on Friday?',(SELECT id FROM Users WHERE fname = 'Vince')),
('Lunch','Can I organize a lunch outing to Chinatown?',(SELECT id FROM Users WHERE fname = 'Karen')),
('Discord','Who wants to be the Discord moderator?',(SELECT id FROM Users WHERE fname = 'Jay'));

INSERT INTO
question_follows (user_id,question_id)
VALUES
    ((SELECT id FROM Users WHERE fname = 'Anna'), (SELECT id FROM Questions WHERE title = 'Games')),
    ((SELECT id From USERS where fname = 'Vince'), (SELECT id FROM Questions WHERE title = 'Lunch')),
     ((SELECT id FROM Users WHERE fname = 'Karen'),(SELECT id FROM Questions WHERE title = 'Discord')),
    ((SELECT id FROM Users WHERE fname = 'Karen'),(SELECT id FROM Questions WHERE title = 'Games'));

INSERT INTO
Replies (body, user_id, question_id, parent_id)

VALUES
    ('Next week', (SELECT id FROM Users WHERE fname = 'Vince'), (SELECT id FROM Questions WHERE title = 'Schedule'), NULL),
    ('They said Monday', (SELECT id FROM Users WHERE fname = 'Jay'), (SELECT id FROM Questions WHERE title = 'Schedule'), (SELECT id FROM Replies WHERE body = 'Next week')),
    ('Hell yeah', (SELECT id FROM Users WHERE fname = 'Anna'), (SELECT id FROM Questions WHERE title = 'Games'), NULL);

INSERT INTO
Question_likes (question_id, user_id)
VALUES
    ((SELECT id FROM Questions WHERE title = 'Games'), (SELECT id FROM Users WHERE fname = 'Anna')),
    ((SELECT id FROM Questions WHERE title = 'Games'), (SELECT id FROM Users WHERE fname = 'Vince')),
    ((SELECT id FROM Questions WHERE title = 'Discord'), (SELECT id FROM Users WHERE fname = 'Karen'));
