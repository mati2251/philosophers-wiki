CREATE SEQUENCE era_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Era
(
    ID       NUMBER DEFAULT era_seq.nextval NOT NULL PRIMARY KEY,
    NAME     VARCHAR2(50)                   NOT NULL,
    AGE_FROM NUMBER                         NOT NULL,
    AGE_TO   NUMBER                         NOT NULL
);


INSERT INTO Era (NAME, AGE_FROM, AGE_TO)
VALUES ('Ancient Philosophy', -700, 500);

INSERT INTO Era (NAME, AGE_FROM, AGE_TO)
VALUES ('Medieval Philosophy', 500, 1500);

INSERT INTO Era (NAME, AGE_FROM, AGE_TO)
VALUES ('Renaissance Philosophy', 1400, 1600);

INSERT INTO Era (NAME, AGE_FROM, AGE_TO)
VALUES ('Enlightenment Philosophy', 1600, 1800);

INSERT INTO Era (NAME, AGE_FROM, AGE_TO)
VALUES ('Modern Philosophy', 1600, 1900);

INSERT INTO Era (NAME, AGE_FROM, AGE_TO)
VALUES ('Contemporary Philosophy', 1900, 2021);

CREATE SEQUENCE countries_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Countries
(
    ID   NUMBER DEFAULT countries_seq.nextval NOT NULL PRIMARY KEY,
    NAME VARCHAR2(50)                         NOT NULL
);

INSERT INTO Countries (NAME)
VALUES ('Greece');
INSERT INTO Countries (NAME)
VALUES ('France');
INSERT INTO Countries (NAME)
VALUES ('German');
INSERT INTO Countries (NAME)
VALUES ('China');
INSERT INTO Countries (NAME)
VALUES ('Scotland');
INSERT INTO Countries (NAME)
VALUES ('Austrian');
INSERT INTO Countries (NAME)
VALUES ('USA');

CREATE SEQUENCE universities_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Universities
(
    ID         NUMBER DEFAULT universities_increment.nextval NOT NULL PRIMARY KEY,
    NAME       VARCHAR2(50)                                  NOT NULL,
    COUNTRY_ID NUMBER                                        NOT NULL,
    FOREIGN KEY (COUNTRY_ID) REFERENCES Countries (ID)
);

INSERT INTO Universities (NAME, COUNTRY_ID)
Values ('Harvard University', 7);

CREATE SEQUENCE philosophers_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Philosophers
(
    ID             NUMBER DEFAULT philosophers_increment.nextval NOT NULL PRIMARY KEY,
    SURNAME        VARCHAR2(50)                          NOT NULL,
    NAME           VARCHAR2(100)                         NOT NULL,
    DESCRIPTION    VARCHAR2(1000)                        NOT NULL,
    ERA_ID         NUMBER,
    COUNTRY_ID     NUMBER,
    ALMA_MUTTER_ID NUMBER,
    YEAR_OF_BIRTH  NUMBER,
    YEAR_OF_DEATH  NUMBER,
    FOREIGN KEY (ALMA_MUTTER_ID) REFERENCES Universities (ID),
    FOREIGN KEY (COUNTRY_ID) REFERENCES Countries (ID),
    FOREIGN KEY (ERA_ID) REFERENCES Era (ID)
);

INSERT INTO Philosophers (SURNAME, NAME, DESCRIPTION, ERA_ID, ALMA_MUTTER_ID, COUNTRY_ID, YEAR_OF_BIRTH, YEAR_OF_DEATH)
VALUES ('Aristotle', 'Aristoteles', 'Philosopher and scientist', 1, NULL, 1, -384, -322);

INSERT INTO Philosophers (SURNAME, NAME, DESCRIPTION, ERA_ID, ALMA_MUTTER_ID, COUNTRY_ID, YEAR_OF_BIRTH, YEAR_OF_DEATH)
Values('Thoureau', 'Henry David', 'American philosopher, essayist, poet, and naturalist', 5, 1, 7, 1817, 1862);

CREATE SEQUENCE ideas_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Ideas
(
    ID          NUMBER DEFAULT ideas_increment.nextval NOT NULL PRIMARY KEY,
    NAME        VARCHAR2(50)                          NOT NULL,
    DESCRIPTION VARCHAR2(1000)                        NOT NULL,
    ERA_ID      NUMBER,
    FOREIGN KEY (ERA_ID) REFERENCES Era (ID)
);

INSERT INTO Ideas (NAME, DESCRIPTION, ERA_ID)
VALUES('Naturalism', 'Naturalism is a literary movement that emphasizes observation and the scientific method in the fictional portrayal of reality.', 1);

INSERT INTO Ideas (NAME, DESCRIPTION, ERA_ID)
VALUES('Transcendentalism', 'Transcendentalism is a philosophical movement that developed in the late 1820s and 1830s in the eastern United States.', 5);

CREATE SEQUENCE groups_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Groups
(
    ID           NUMBER DEFAULT groups_increment.nextval NOT NULL PRIMARY KEY,
    NAME         VARCHAR2(50)                          NOT NULL,
    DESCRIPTION  VARCHAR2(1000)                        NOT NULL,
    ERA_ID       NUMBER,
    COUNTRY_ID   NUMBER,
    MAIN_IDEA_ID NUMBER,
    FOREIGN KEY (ERA_ID) REFERENCES Era (ID),
    FOREIGN KEY (COUNTRY_ID) REFERENCES Countries (ID),
    FOREIGN KEY (MAIN_IDEA_ID) REFERENCES Ideas (ID)
);

INSERT INTO Groups (NAME, DESCRIPTION, ERA_ID, COUNTRY_ID, MAIN_IDEA_ID)
VALUES ('The Dial redaction', 'The Dial was an American magazine published intermittently from 1840 to 1929.', 5, 7, 2);


CREATE TABLE Philosophers_Ideas
(
    PHILOSOPHER_ID NUMBER NOT NULL,
    IDEA_ID        NUMBER NOT NULL,
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID),
    FOREIGN KEY (IDEA_ID) REFERENCES Ideas (ID)
);

INSERT INTO Philosophers_Ideas (PHILOSOPHER_ID, IDEA_ID)
VALUES (2, 1);
INSERT INTO Philosophers_Ideas (PHILOSOPHER_ID, IDEA_ID)
VALUES (2, 2);

CREATE TABLE Philosophers_Groups
(
    PHILOSOPHER_ID NUMBER NOT NULL,
    GROUP_ID       NUMBER NOT NULL,
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID),
    FOREIGN KEY (GROUP_ID) REFERENCES Groups (ID)
);

INSERT INTO Philosophers_Groups (PHILOSOPHER_ID, GROUP_ID)
VALUES (2, 1);

CREATE SEQUENCE books_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Books
(
    ID              NUMBER DEFAULT books_increment.nextval NOT NULL PRIMARY KEY,
    TITLE           VARCHAR2(50)                          NOT NULL,
    DESCRIPTION     VARCHAR2(1000),
    PUBLISHING_YEAR NUMBER,
    PHILOSOPHER_ID  NUMBER,
    MAIN_IDEA_ID    NUMBER,
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID)
);

INSERT INTO Books (TITLE, DESCRIPTION, PUBLISHING_YEAR, PHILOSOPHER_ID)
VALUES ('Walden', 'Walden is a book by transcendentalist Henry David Thoreau.', 1854, 2);

INSERT INTO Books (TITLE, DESCRIPTION, PUBLISHING_YEAR, PHILOSOPHER_ID)
VALUES ('Civil Disobedience', 'Civil Disobedience is an essay by American transcendentalist Henry David Thoreau that was first published in 1849.', 1849, 2);

CREATE SEQUENCE quotations_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Quotations
(
    ID        NUMBER DEFAULT quotations_increment.nextval NOT NULL PRIMARY KEY,
    CONTENT   VARCHAR2(1000)                        NOT NULL,
    BOOK_ID   NUMBER,
    AUTHOR_ID NUMBER,
    FOREIGN KEY (AUTHOR_ID) REFERENCES Philosophers (ID)
);

INSERT INTO Quotations (CONTENT, BOOK_ID, AUTHOR_ID)
VALUES ("I went to the woods because I wished to live deliberately, to front only the essential facts of life, and see if I could not learn what it had to teach, and not, when I came to die, discover that I had not lived.", 1, 2);

CREATE SEQUENCE sources_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Sources
(
    ID     NUMBER DEFAULT sources_increment.nextval NOT NULL PRIMARY KEY,
    SOURCE VARCHAR2(200)                         NOT NULL,
    LINK   VARCHAR2(200)
);

INSERT INTO Sources (SOURCE, LINK)
VALUES ('Wikipedia', 'https://en.wikipedia.org/wiki/Henry_David_Thoreau');

CREATE TABLE Sources_Groups
(
    ID        NUMBER NOT NULL,
    SOURCE_ID NUMBER NOT NULL,
    FOREIGN KEY (SOURCE_ID) REFERENCES Sources (ID)
);

INSERT INTO Sources_Groups (ID, SOURCE_ID)
VALUES (1, 1);

CREATE SEQUENCE paragraph_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Paragraph
(
    ID      NUMBER DEFAULT paragraph_increment.nextval NOT NULL PRIMARY KEY,
    "ORDER" NUMBER,
    TITLE   VARCHAR2(100)                         NOT NULL,
    CONTENT VARCHAR2(1000)                        NOT NULL
);

INSERT INTO Paragraph ("ORDER", TITLE, CONTENT)
VALUES (1, 'Introduction', 'Henry David Thoreau was an American philosopher, essayist, poet, and naturalist.');

INSERT INTO Paragraph ("ORDER", TITLE, CONTENT)
VALUES (2, 'Biography', 'Thoreau was born on July 12, 1817, in Concord, Massachusetts.');

INSERT INTO Paragraph ("ORDER", TITLE, CONTENT)
VALUES (1, 'Introduction', 'Walden book ...');

INSERT INTO Paragraph ("ORDER", TITLE, CONTENT)
VALUES (1, 'Introduction', 'Idea ...');

INSERT INTO Paragraph ("ORDER", TITLE, CONTENT)
VALUES (1, 'Introduction', 'The dial ...');

CREATE TABLE Paragraphs_Philosopher
(
    PARAGRAPH_ID   NUMBER NOT NULL,
    PHILOSOPHER_ID NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID)
);

INSERT INTO Paragraphs_Philosopher (PARAGRAPH_ID, PHILOSOPHER_ID)
VALUES (1, 2);
INSERT INTO Paragraphs_Philosopher (PARAGRAPH_ID, PHILOSOPHER_ID)
VALUES (2, 2);

CREATE TABLE Paragraphs_Group
(
    PARAGRAPH_ID NUMBER NOT NULL,
    GROUP_ID     NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (GROUP_ID) REFERENCES Groups (ID)
);

INSERT INTO Paragraphs_Group (PARAGRAPH_ID, GROUP_ID)
VALUES (5, 1);


CREATE TABLE Paragraphs_Idea
(
    PARAGRAPH_ID NUMBER NOT NULL,
    IDEA_ID      NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (IDEA_ID) REFERENCES Ideas (ID)
);

INSERT INTO Paragraphs_Idea (PARAGRAPH_ID, IDEA_ID)
VALUES (4, 2);

CREATE TABLE Paragraphs_Book
(
    PARAGRAPH_ID NUMBER NOT NULL,
    BOOK_ID      NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books (ID)
);

INSERT INTO Paragraphs_Book (PARAGRAPH_ID, BOOK_ID)
VALUES (3, 1);

CREATE TABLE Sources_Paragraph
(
    PARAGRAPH_ID NUMBER NOT NULL,
    SOURCE_ID    NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (SOURCE_ID) REFERENCES Sources (ID)
);

INSERT INTO Sources_Paragraph (PARAGRAPH_ID, SOURCE_ID)
VALUES (1, 1);

INSERT INTO Sources_Paragraph (PARAGRAPH_ID, SOURCE_ID)
VALUES (2, 1);

INSERT INTO Sources_Paragraph (PARAGRAPH_ID, SOURCE_ID)
VALUES (3, 1);

CREATE TABLE Sources_Book
(
    BOOK_ID   NUMBER NOT NULL,
    SOURCE_ID NUMBER NOT NULL,
    FOREIGN KEY (BOOK_ID) REFERENCES Books (ID),
    FOREIGN KEY (SOURCE_ID) REFERENCES Sources (ID)
);

INSERT INTO Sources_Book (BOOK_ID, SOURCE_ID)
VALUES (1, 1);

CREATE TABLE Sources_Philosopher
(
    PHILOSOPHER_ID NUMBER NOT NULL,
    SOURCE_ID      NUMBER NOT NULL,
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID),
    FOREIGN KEY (SOURCE_ID) REFERENCES Sources (ID)
);

INSERT INTO Sources_Philosopher (PHILOSOPHER_ID, SOURCE_ID)
VALUES (2, 1);

CREATE TABLE Sources_Group
(
    GROUP_ID  NUMBER NOT NULL,
    SOURCE_ID NUMBER NOT NULL,
    FOREIGN KEY (GROUP_ID) REFERENCES Groups (ID),
    FOREIGN KEY (SOURCE_ID) REFERENCES Sources (ID)
);

INSERT INTO Sources_Group (GROUP_ID, SOURCE_ID)
VALUES (1, 1);

CREATE SEQUENCE photos_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Photos
(
    ID    NUMBER DEFAULT photos_increment.nextval NOT NULL PRIMARY KEY,
    PHOTO BLOB                                  NOT NULL
);

CREATE TABLE Philosophers_Photos
(
    PHILOSOPHER_ID NUMBER NOT NULL,
    PHOTO_ID       NUMBER NOT NULL,
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID),
    FOREIGN KEY (PHOTO_ID) REFERENCES Photos (ID)
);

CREATE TABLE Paragraphs_Photo
(
    PARAGRAPH_ID NUMBER NOT NULL,
    PHOTO_ID     NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (PHOTO_ID) REFERENCES Photos (ID)
);