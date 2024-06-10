IF OBJECT_ID ('DEP_DEPENDENT','U') IS NOT NULL
    DROP TABLE dbo.DEP_DEPENDENT;
IF OBJECT_ID ('DEP_WORKS_ON','U') IS NOT NULL
    DROP TABLE dbo.DEP_WORKS_ON;
IF OBJECT_ID ('DEP_PROJECT','U') IS NOT NULL
    DROP TABLE dbo.DEP_PROJECT;
IF OBJECT_ID ('DEP_DEPT_LOCATIONS','U') IS NOT NULL
    DROP TABLE dbo.DEP_DEPT_LOCATIONS;
IF OBJECT_ID ('DEP_EMPLOYEE','U') IS NOT NULL
    DROP TABLE dbo.DEP_EMPLOYEE;
IF OBJECT_ID ('DEP_DEPARTMENT','U') IS NOT NULL
    DROP TABLE dbo.DEP_DEPARTMENT;

CREATE TABLE DEP_DEPARTMENT(
    Dname               VARCHAR(20) NOT NULL,
    Dnumber             INT NOT NULL,
    Mgr_ssn             CHAR(9),
    Mgr_start_date      DATE,

    PRIMARY KEY (Dnumber)
);

CREATE TABLE DEP_EMPLOYEE(
    Ssn             CHAR(9) NOT NULL,
    Fname           VARCHAR(15) NOT NULL,
    Minit           VARCHAR(1),
    Lname           VARCHAR(15) NOT NULL,
    Bdate           DATE,
    [Address]       VARCHAR(30),
    Sex             VARCHAR(1), 
    Salary          DECIMAL(6,2),
    Super_ssn       CHAR(9),
    Dno             INT NOT NULL,

    PRIMARY KEY (Ssn),
    FOREIGN KEY (Super_ssn) REFERENCES DEP_EMPLOYEE(Ssn),
    FOREIGN KEY (Dno) REFERENCES DEP_DEPARTMENT(Dnumber)
);

CREATE TABLE DEP_DEPT_LOCATIONS(
    Dnumber             INT NOT NULL,
    Dlocation           VARCHAR(20) NOT NULL,

    PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES DEP_DEPARTMENT(Dnumber)
);

CREATE TABLE DEP_PROJECT(
    Pname           VARCHAR(30) NOT NULL,
    Pnumber         INT NOT NULL,
    Plocation       VARCHAR(20),
    Dnum            INT NOT NULL,

    PRIMARY KEY (Pnumber),
    FOREIGN KEY (Dnum) REFERENCES DEP_DEPARTMENT(Dnumber)
);

CREATE TABLE DEP_WORKS_ON(
    Essn        CHAR(9) NOT NULL,
    Pno         INT NOT NULL,
    [Hours]     DECIMAL(3,1) NOT NULL,

    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES DEP_EMPLOYEE(Ssn),
    FOREIGN KEY (Pno) REFERENCES DEP_PROJECT(Pnumber)
);

CREATE TABLE DEP_DEPENDENT(
    Essn                CHAR(9) NOT NULL,
    Dependent_name      VARCHAR(30) NOT NULL,
    Sex                 CHAR(1),
    Bdate               DATE,
    Relationship        VARCHAR(15),

    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES DEP_EMPLOYEE(Ssn)
);