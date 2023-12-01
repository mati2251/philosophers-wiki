CREATE SEQUENCE era_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Era
(
    ID       NUMBER DEFAULT era_seq.nextval NOT NULL PRIMARY KEY,
    NAME     VARCHAR2(50)                   NOT NULL UNIQUE CHECK (NAME <> ''),
    AGE_FROM NUMBER                         NOT NULL CHECK ( AGE_FROM < AGE_TO ),
    AGE_TO   NUMBER                         NOT NULL CHECK ( AGE_TO > AGE_FROM )
);

CREATE INDEX name_idx ON Era (NAME);

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
    NAME VARCHAR2(50)                         NOT NULL UNIQUE CHECK (NAME <> '')
);

CREATE INDEX name_idx ON Countries (NAME);

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
    NAME       VARCHAR2(50)                                  NOT NULL UNIQUE CHECK (NAME <> ''),
    COUNTRY_ID NUMBER                                        NOT NULL,
    FOREIGN KEY (COUNTRY_ID) REFERENCES Countries (ID)
);

CREATE INDEX name_idx ON Universities (NAME);
CREATE INDEX country_id_idx ON Universities (COUNTRY_ID);

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
    SURNAME        VARCHAR2(50)                                  NOT NULL,
    NAME           VARCHAR2(100)                                 NOT NULL,
    DESCRIPTION    VARCHAR2(1000)                                NOT NULL,
    ERA_ID         NUMBER,
    COUNTRY_ID     NUMBER,
    ALMA_MUTTER_ID NUMBER,
    YEAR_OF_BIRTH  NUMBER,
    YEAR_OF_DEATH  NUMBER,
    FOREIGN KEY (ALMA_MUTTER_ID) REFERENCES Universities (ID),
    FOREIGN KEY (COUNTRY_ID) REFERENCES Countries (ID),
    FOREIGN KEY (ERA_ID) REFERENCES Era (ID)
);

CREATE VIEW PhilosophersView AS
SELECT PHILOSOPHERS.ID,
       PHILOSOPHERS.SURNAME,
       PHILOSOPHERS.NAME,
       PHILOSOPHERS.DESCRIPTION,
       PHILOSOPHERS.YEAR_OF_BIRTH,
       PHILOSOPHERS.YEAR_OF_DEATH,
       ERA.NAME          AS ERA_NAME,
       COUNTRIES.NAME    AS COUNTRY_NAME,
       UNIVERSITIES.NAME AS ALMA_MUTTER_NAME
FROM PHILOSOPHERS
         LEFT JOIN ERA ON PHILOSOPHERS.ERA_ID = ERA.ID
         LEFT JOIN COUNTRIES ON PHILOSOPHERS.COUNTRY_ID = COUNTRIES.ID
         LEFT JOIN UNIVERSITIES ON PHILOSOPHERS.ALMA_MUTTER_ID = UNIVERSITIES.ID;

CREATE PROCEDURE add_philosopher(
    surname IN VARCHAR2,
    name IN VARCHAR2,
    description IN VARCHAR2,
    era IN VARCHAR2,
    alma_mutter IN VARCHAR2,
    country IN VARCHAR2,
    year_of_birth IN NUMBER,
    year_of_death IN NUMBER
)
AS
    era_id         NUMBER;
    alma_mutter_id NUMBER;
    country_id     NUMBER;
BEGIN
    if (year_of_birth > year_of_death) then
        raise_application_error(-20001, 'Year of birth must be less than year of death');
    end if;
    if not era is null then
        SELECT ID INTO era_id FROM Era e WHERE e.NAME = era;
    end if;
    if era_id is null then
        raise_application_error(-20002, 'Era not found');
    end if;
    if not alma_mutter is null then
        SELECT ID INTO alma_mutter_id FROM Universities WHERE Universities.NAME = alma_mutter;
    end if;
    if alma_mutter_id is null then
        raise_application_error(-20004, 'Alma mutter not found');
    end if;
    if not country is null then
        SELECT ID INTO country_id FROM Countries WHERE Countries.NAME = country;
    end if;
    if country_id is null then
        raise_application_error(-20003, 'Country not found');
    end if;
    INSERT INTO Philosophers (SURNAME, NAME, DESCRIPTION, ERA_ID, ALMA_MUTTER_ID, COUNTRY_ID, YEAR_OF_BIRTH,
                              YEAR_OF_DEATH)
    VALUES (surname, name, description, era_id, alma_mutter_id, country_id, year_of_birth, year_of_death);
END;

CREATE INDEX surname_idx ON Philosophers (SURNAME);
CREATE INDEX era_id_idx ON Philosophers (ERA_ID);
CREATE INDEX country_phi_id_idx ON Philosophers (COUNTRY_ID);
CREATE INDEX alma_mutter_id_idx ON Philosophers (ALMA_MUTTER_ID);
CREATE INDEX year_of_birth_idx ON Philosophers (YEAR_OF_BIRTH ASC);

INSERT INTO Philosophers (SURNAME, NAME, DESCRIPTION, ERA_ID, ALMA_MUTTER_ID, COUNTRY_ID, YEAR_OF_BIRTH, YEAR_OF_DEATH)
VALUES ('Aristotle', 'Aristoteles', 'Philosopher and scientist', 1, NULL, 1, -384, -322);

INSERT INTO Philosophers (SURNAME, NAME, DESCRIPTION, ERA_ID, ALMA_MUTTER_ID, COUNTRY_ID, YEAR_OF_BIRTH, YEAR_OF_DEATH)
Values ('Thoureau', 'Henry David', 'American philosopher, essayist, poet, and naturalist', 5, 1, 7, 1817, 1862);

CREATE SEQUENCE ideas_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Ideas
(
    ID          NUMBER DEFAULT ideas_increment.nextval NOT NULL PRIMARY KEY,
    NAME        VARCHAR2(50)                           NOT NULL,
    DESCRIPTION VARCHAR2(1000)                         NOT NULL,
    ERA_ID      NUMBER,
    FOREIGN KEY (ERA_ID) REFERENCES Era (ID)
);

CREATE INDEX name_ide_idx ON Ideas (NAME);
CREATE INDEX era_id_ide_idx ON Ideas (ERA_ID);

INSERT INTO Ideas (NAME, DESCRIPTION, ERA_ID)
VALUES ('Naturalism',
        'Naturalism is a literary movement that emphasizes observation and the scientific method in the fictional portrayal of reality.',
        1);

INSERT INTO Ideas (NAME, DESCRIPTION, ERA_ID)
VALUES ('Transcendentalism',
        'Transcendentalism is a philosophical movement that developed in the late 1820s and 1830s in the eastern United States.',
        5);

CREATE SEQUENCE groups_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Groups
(
    ID           NUMBER DEFAULT groups_increment.nextval NOT NULL PRIMARY KEY,
    NAME         VARCHAR2(50)                            NOT NULL,
    DESCRIPTION  VARCHAR2(1000)                          NOT NULL,
    ERA_ID       NUMBER,
    COUNTRY_ID   NUMBER,
    MAIN_IDEA_ID NUMBER,
    FOREIGN KEY (ERA_ID) REFERENCES Era (ID),
    FOREIGN KEY (COUNTRY_ID) REFERENCES Countries (ID),
    FOREIGN KEY (MAIN_IDEA_ID) REFERENCES Ideas (ID)
);

CREATE VIEW GroupsView AS
SELECT GROUPS.ID,
       GROUPS.NAME,
       GROUPS.DESCRIPTION,
       ERA.NAME                      AS ERA_NAME,
       COUNTRIES.NAME                AS COUNTRY_NAME,
       IDEAS.NAME                    AS MAIN_IDEA_NAME,
       LISTAGG(Philosophers.SURNAME) AS PHILOSOPHERS
FROM GROUPS
         LEFT JOIN ERA ON GROUPS.ERA_ID = ERA.ID
         LEFT JOIN COUNTRIES ON GROUPS.COUNTRY_ID = COUNTRIES.ID
         LEFT JOIN IDEAS ON GROUPS.MAIN_IDEA_ID = IDEAS.ID
         LEFT JOIN PHILOSOPHERS_GROUPS ON GROUPS.ID = PHILOSOPHERS_GROUPS.GROUP_ID
         LEFT JOIN PHILOSOPHERS ON PHILOSOPHERS_GROUPS.PHILOSOPHER_ID = PHILOSOPHERS.ID
group by IDEAS.NAME, COUNTRIES.NAME, ERA.NAME, GROUPS.DESCRIPTION, GROUPS.NAME, GROUPS.ID;

CREATE INDEX name_gro_idx ON Groups (NAME);
CREATE INDEX era_gro_id_idx ON Groups (ERA_ID);
CREATE INDEX country_gro_id_idx ON Groups (COUNTRY_ID);
CREATE INDEX main_idea_gro_id_idx ON Groups (MAIN_IDEA_ID);

INSERT INTO Groups (NAME, DESCRIPTION, ERA_ID, COUNTRY_ID, MAIN_IDEA_ID)
VALUES ('The Dial redaction', 'The Dial was an American magazine published intermittently from 1840 to 1929.', 5, 7, 2);


CREATE TABLE Philosophers_Ideas
(
    PHILOSOPHER_ID NUMBER NOT NULL,
    IDEA_ID        NUMBER NOT NULL,
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID),
    FOREIGN KEY (IDEA_ID) REFERENCES Ideas (ID)
);

CREATE INDEX philosopher_ideas_idx ON Philosophers_Ideas (PHILOSOPHER_ID, IDEA_ID);

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

CREATE INDEX philosopher_groups_idx ON Philosophers_Groups (PHILOSOPHER_ID, GROUP_ID);

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
    TITLE           VARCHAR2(50)                           NOT NULL,
    DESCRIPTION     VARCHAR2(1000),
    PUBLISHING_YEAR NUMBER,
    PHILOSOPHER_ID  NUMBER,
    MAIN_IDEA_ID    NUMBER,
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID)
);

CREATE INDEX title_idx ON Books (TITLE);
CREATE INDEX philosopher_id_idx ON Books (PHILOSOPHER_ID);
CREATE INDEX main_idea_id_idx ON Books (MAIN_IDEA_ID);

INSERT INTO Books (TITLE, DESCRIPTION, PUBLISHING_YEAR, PHILOSOPHER_ID)
VALUES ('Walden', 'Walden is a book by transcendentalist Henry David Thoreau.', 1854, 2);

INSERT INTO Books (TITLE, DESCRIPTION, PUBLISHING_YEAR, PHILOSOPHER_ID)
VALUES ('Civil Disobedience',
        'Civil Disobedience is an essay by American transcendentalist Henry David Thoreau that was first published in 1849.',
        1849, 2);

CREATE SEQUENCE quotations_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Quotations
(
    ID        NUMBER DEFAULT quotations_increment.nextval NOT NULL PRIMARY KEY,
    CONTENT   VARCHAR2(1000)                              NOT NULL,
    BOOK_ID   NUMBER,
    AUTHOR_ID NUMBER,
    FOREIGN KEY (AUTHOR_ID) REFERENCES Philosophers (ID)
);

CREATE INDEX content_idx ON Quotations (CONTENT);
CREATE INDEX book_id_idx ON Quotations (BOOK_ID);
CREATE INDEX author_id_idx ON Quotations (AUTHOR_ID);

INSERT INTO Quotations (CONTENT, BOOK_ID, AUTHOR_ID)
VALUES ("I went to the woods because I wished to live deliberately, to front only the essential facts of life, and see if I could not learn what it had to teach, and not, when I came to die, discover that I had not lived.",
        1, 2);

CREATE SEQUENCE sources_increment
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE TABLE Sources
(
    ID     NUMBER DEFAULT sources_increment.nextval NOT NULL PRIMARY KEY,
    SOURCE VARCHAR2(200)                            NOT NULL,
    LINK   VARCHAR2(200)
);

CREATE INDEX sources_idx ON Sources (SOURCE, LINK);

INSERT INTO Sources (SOURCE, LINK)
VALUES ('Wikipedia', 'https://en.wikipedia.org/wiki/Henry_David_Thoreau');

CREATE TABLE Sources_Groups
(
    ID        NUMBER NOT NULL,
    SOURCE_ID NUMBER NOT NULL,
    FOREIGN KEY (SOURCE_ID) REFERENCES Sources (ID)
);

CREATE INDEX sources_groups_idx ON Sources_Groups (ID, SOURCE_ID);

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
    "ORDER" NUMBER CHECK ( "ORDER" > 0 ),
    TITLE   VARCHAR2(100)                              NOT NULL,
    CONTENT VARCHAR2(1000)                             NOT NULL
);

CREATE INDEX paragraph_idx ON Paragraph ("ORDER" ASC, TITLE, CONTENT);

CREATE INDEX paragraph_idx ON Paragraph ("ORDER" ASC, TITLE, CONTENT);

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

CREATE OR REPLACE TRIGGER check_order_valid_par_phi
    AFTER INSERT OR UPDATE
    ON Paragraphs_Philosopher
    FOR EACH ROW
DECLARE
    cur NUMBER := 0;
    max_order NUMBER;
    CURSOR
        max_order_cur IS
        SELECT "ORDER"
        FROM Paragraph
        WHERE PARAGRAPH_ID IN
              (SELECT PARAGRAPH_ID FROM Paragraphs_Philosopher WHERE PHILOSOPHER_ID = :NEW.PHILOSOPHER_ID) ORDER BY "ORDER" DESC;
BEGIN
    OPEN max_order_cur;
    LOOP
        FETCH max_order_cur INTO cur;
        IF max_order + 1 = cur THEN
            max_order := cur;
        ELSE
            RAISE_APPLICATION_ERROR(-20004, 'Paragraphs order is not valid');
        END IF;
    END LOOP;
END;

CREATE INDEX paragraphs_philosopher_idx ON Paragraphs_Philosopher (PARAGRAPH_ID, PHILOSOPHER_ID);

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

CREATE INDEX paragraphs_group_idx ON Paragraphs_Group (PARAGRAPH_ID, GROUP_ID);

INSERT INTO Paragraphs_Group (PARAGRAPH_ID, GROUP_ID)
VALUES (5, 1);


CREATE TABLE Paragraphs_Idea
(
    PARAGRAPH_ID NUMBER NOT NULL,
    IDEA_ID      NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (IDEA_ID) REFERENCES Ideas (ID)
);

CREATE OR REPLACE TRIGGER check_order_valid_par_ide
    AFTER INSERT OR UPDATE
    ON Paragraphs_Idea
    FOR EACH ROW
DECLARE
    cur NUMBER := 0;
    max_order NUMBER;
    CURSOR
        max_order_cur IS
        SELECT "ORDER"
        FROM Paragraph
        WHERE PARAGRAPH_ID IN
              (SELECT PARAGRAPH_ID FROM Paragraphs_Idea WHERE IDEA_ID = :NEW.IDEA_ID) ORDER BY "ORDER" DESC;
BEGIN
    OPEN max_order_cur;
    LOOP
        FETCH max_order_cur INTO cur;
        IF max_order + 1 = cur THEN
            max_order := cur;
        ELSE
            RAISE_APPLICATION_ERROR(-20004, 'Paragraphs order is not valid');
        END IF;
    END LOOP;
END;

CREATE INDEX paragraphs_idea_idx ON Paragraphs_Idea (PARAGRAPH_ID, IDEA_ID);

INSERT INTO Paragraphs_Idea (PARAGRAPH_ID, IDEA_ID)
VALUES (4, 2);

CREATE TABLE Paragraphs_Book
(
    PARAGRAPH_ID NUMBER NOT NULL,
    BOOK_ID      NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books (ID)
);


CREATE INDEX paragraphs_book_idx ON Paragraphs_Book (PARAGRAPH_ID, BOOK_ID);

CREATE OR REPLACE TRIGGER check_order_valid_par_book
    AFTER INSERT OR UPDATE
    ON Paragraphs_Book
    FOR EACH ROW
DECLARE
    cur NUMBER := 0;
    max_order NUMBER;
    CURSOR
        max_order_cur IS
        SELECT "ORDER"
        FROM Paragraph
        WHERE PARAGRAPH_ID IN
              (SELECT PARAGRAPH_ID FROM Paragraphs_Book WHERE BOOK_ID = :NEW.BOOK_ID) ORDER BY "ORDER" DESC;
BEGIN
    OPEN max_order_cur;
    LOOP
        FETCH max_order_cur INTO cur;
        IF max_order + 1 = cur THEN
            max_order := cur;
        ELSE
            RAISE_APPLICATION_ERROR(-20004, 'Paragraphs order is not valid');
        END IF;
    END LOOP;
END;

INSERT INTO Paragraphs_Book (PARAGRAPH_ID, BOOK_ID)
VALUES (3, 1);

CREATE TABLE Sources_Paragraph
(
    PARAGRAPH_ID NUMBER NOT NULL,
    SOURCE_ID    NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (SOURCE_ID) REFERENCES Sources (ID)
);

CREATE INDEX sources_paragraph_idx ON Sources_Paragraph (PARAGRAPH_ID, SOURCE_ID);

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

CREATE INDEX sources_book_idx ON Sources_Book (BOOK_ID, SOURCE_ID);

INSERT INTO Sources_Book (BOOK_ID, SOURCE_ID)
VALUES (1, 1);

CREATE TABLE Sources_Philosopher
(
    PHILOSOPHER_ID NUMBER NOT NULL,
    SOURCE_ID      NUMBER NOT NULL,
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID),
    FOREIGN KEY (SOURCE_ID) REFERENCES Sources (ID)
);

CREATE INDEX sources_philosopher_idx ON Sources_Philosopher (PHILOSOPHER_ID, SOURCE_ID);

INSERT INTO Sources_Philosopher (PHILOSOPHER_ID, SOURCE_ID)
VALUES (2, 1);

CREATE TABLE Sources_Group
(
    GROUP_ID  NUMBER NOT NULL,
    SOURCE_ID NUMBER NOT NULL,
    FOREIGN KEY (GROUP_ID) REFERENCES Groups (ID),
    FOREIGN KEY (SOURCE_ID) REFERENCES Sources (ID)
);

CREATE INDEX sources_group_idx ON Sources_Group (GROUP_ID, SOURCE_ID);

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
    PHOTO BLOB                                    NOT NULL
);

CREATE TABLE Philosophers_Photos
(
    PHILOSOPHER_ID NUMBER NOT NULL,
    PHOTO_ID       NUMBER NOT NULL,
    FOREIGN KEY (PHILOSOPHER_ID) REFERENCES Philosophers (ID),
    FOREIGN KEY (PHOTO_ID) REFERENCES Photos (ID)
);

CREATE INDEX philosophers_photo_idx ON Philosophers_Photos (PHILOSOPHER_ID, PHOTO_ID);

CREATE TABLE Paragraphs_Photo
(
    PARAGRAPH_ID NUMBER NOT NULL,
    PHOTO_ID     NUMBER NOT NULL,
    FOREIGN KEY (PARAGRAPH_ID) REFERENCES Paragraph (ID),
    FOREIGN KEY (PHOTO_ID) REFERENCES Photos (ID)
);

CREATE INDEX paragraphs_photo_idx ON Paragraphs_Photo (PARAGRAPH_ID, PHOTO_ID);

