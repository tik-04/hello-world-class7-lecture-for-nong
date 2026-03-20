DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS course;
DROP TYPE IF EXISTS course_type;

CREATE TYPE course_type AS ENUM ('CS', 'DSI', 'IT');

CREATE TABLE course (
    course_code VARCHAR(10),
    title VARCHAR(100) NOT NULL,
    credits INT DEFAULT 3,
    
    CONSTRAINT pk_course PRIMARY KEY (course_code),
    CONSTRAINT chk_credits CHECK (credits > 0 AND credits <= 4)
);

CREATE TABLE student (
    id SERIAL,
    name VARCHAR(50) NOT NULL,
    age INT,
    major course_type,
    
    CONSTRAINT pk_student PRIMARY KEY (id),
    CONSTRAINT chk_age CHECK (age >= 15 AND age <= 100)
);


CREATE TABLE enrollment (
    enroll_id SERIAL,
    student_id INT,
    course_code VARCHAR(10),
    grade CHAR(1),
    
    CONSTRAINT pk_enrollment PRIMARY KEY (enroll_id),
    

    CONSTRAINT fk_student 
        FOREIGN KEY (student_id) 
        REFERENCES student(id) 
        ON DELETE CASCADE,
    
    CONSTRAINT fk_course 
        FOREIGN KEY (course_code) 
        REFERENCES course(course_code) 
        ON DELETE CASCADE,
        

    CONSTRAINT chk_grade CHECK (grade IN ('A', 'B', 'C', 'D', 'F', 'W'))
);


INSERT INTO course (course_code, title, credits) VALUES
('CS101', 'Introduction to Programming', 3),
('DSI201', 'Data Analytics Foundation', 4),
('IT301', 'Cloud Computing', 3);

INSERT INTO student (name, age, major) VALUES
('vavy', 20, 'CS'),
('mokun', 22, 'DSI'),
('sunny', 23, 'IT'),
('Alice', 19, 'DSI');

-- ลงทะเบียนเรียน
INSERT INTO enrollment (student_id, course_code, grade) VALUES
(1, 'CS101', 'A'),
(1, 'IT301', 'B'),
(2, 'DSI201', 'C'),
(3, 'IT301', 'A'),
(4, 'DSI201', 'B');