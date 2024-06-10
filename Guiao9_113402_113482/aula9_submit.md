# BD: Guião 9


## ​9.1
 
### *a)*

```
CREATE PROCEDURE removeEmployee(@employeeSSN VARCHAR(9))
AS
BEGIN
    -- Delete employee from DEP_EMPLOYEE
    DELETE FROM DEP_EMPLOYEE
    WHERE Ssn = @employeeSSN;

    -- Delete employee's entries from DEP_WORKS_ON
    DELETE FROM DEP_WORKS_ON
    WHERE Essn = @employeeSSN;

    -- Delete employee's dependents from DEP_DEPENDENT
    DELETE FROM DEP_DEPENDENT
    WHERE Essn = @employeeSSN;
END;


Caso removamos um manager é preciso remover este manager dos employees que tinham esta pessoa como manager, alterar para null.
```

### *b)* 

```
CREATE PROC Managers @OldMgrSsn INT OUTPUT, @OldMgrYear INT OUTPUT
AS
BEGIN
    SELECT E.Fname, E.Minit, E.Lname, E.Ssn, E.Bdate, E.Address, E.Sex, E.Salary, E.Dno, D.Mgr_start_date
    FROM DEP_EMPLOYEE AS E
        JOIN DEP_DEPARTMENT AS D ON E.ssn=D.Mgr_ssn

    SELECT TOP(1) @OldMgrSsn = Ssn, @OldMgrYear = DATEDIFF(YEAR, Mgr_start_date, GETDATE())
    FROM DEP_EMPLOYEE AS E
        JOIN DEP_DEPARTMENT AS D ON E.ssn=D.Mgr_ssn
    ORDER BY Mgr_start_date
END
```

### *c)* 

```
CREATE TRIGGER manager_trigger ON DEP_DEPARTMENT
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @manager_ssn INT;
    SELECT @manager_ssn=Mgr_ssn FROM inserted;

    IF @manager_ssn IN (SELECT Mgr_ssn FROM DEP_DEPARTMENT)
    BEGIN
        RAISERROR('Employee cannot manage more than one department',16,1)
    END
    ELSE
    BEGIN
        INSERT INTO DEP_DEPARTMENT SELECT * FROM inserted
        PRINT 'Inserted successfully'
    END
END
```

### *d)* 

```
CREATE TRIGGER LowerSalaryThanMgr ON DEP_EMPLOYEE
    AFTER INSERT, UPDATE
    AS
    DECLARE @EmpSSN     INT
    DECLARE @EmpSalary  INT
    DECLARE @MgrSalary  INT
    SELECT @EmpSSN = I.Ssn, @EmpSalary = I.Salary, @MgrSalary = S.Salary
	FROM inserted AS I JOIN DEP_EMPLOYEE AS S ON I.Super_ssn = S.Ssn

    IF (@EmpSalary > @MgrSalary)
        BEGIN
            UPDATE DEP_EMPLOYEE SET Salary = @MgrSalary - 1 WHERE Ssn = @EmpSSN
        END
```

### *e)* 

```
CREATE FUNCTION exercise_e (@emp_ssn INT) RETURNS @table_info TABLE
    (Pname     VARCHAR(15)     NOT NULL    UNIQUE ,
     Plocation VARCHAR(15))
AS
BEGIN
    INSERT @table_info
        SELECT Pname, Plocation
        FROM DEP_WORKS_ON
        JOIN DEP_PROJECT ON DEP_WORKS_ON.Pno= DEP_PROJECT.Pnumber
        WHERE DEP_WORKS_ON.Essn =@emp_ssn;
    RETURN;
END
```

### *f)* 

```
CREATE FUNCTION exercise_f (@dno INT) RETURNS @table_info TABLE
    (Ssn             INT             NOT NULL   UNIQUE,
     Fname          VARCHAR(15)     NOT NULL,
     Minit          CHAR,
     Lname          VARCHAR(15)     NOT NULL,
     Bdate      DATE,
     Address         VARCHAR(50),
     Sex             CHAR,
     Salary          DECIMAL(10,2))
AS
BEGIN
    DECLARE @salaryAvg DECIMAL(10,2)

    SELECT @salaryAvg = AVG(salary)
    FROM DEP_EMPLOYEE
    WHERE Dno=@dno

    INSERT @table_info
    SELECT Ssn, Fname, Minit, Lname, Bdate, Address, Sex, Salary
    FROM DEP_EMPLOYEE AS E
    WHERE E.Salary > @salaryAvg AND Dno=@dno;
    RETURN;
END
```

### *g)* 

```
CREATE FUNCTION DEP_employeeDeptHighAverage (@dept_num INT) RETURNS @table_info TABLE (
    Pnumber        INT,
    Pname          VARCHAR(15),
    Plocation      VARCHAR(15),
    Dnum           INT             NOT NULL,
    budget          DECIMAL(10,2),
    totalBudget     DECIMAL(10,2)
)
AS
BEGIN
    DECLARE @p_number INT, @p_name VARCHAR(15), @p_location VARCHAR(15), @d_num INT;
    DECLARE @essn INT, @pno INT, @hours DECIMAL(3,1), @hourly_rate DECIMAL(10,2);
    DECLARE @budget DECIMAL(10,2), @totalBudget DECIMAL(10,2);
    SET @totalBudget = 0;

    DECLARE project_cursor CURSOR FOR
        SELECT Pnumber, Pname, Plocation, Dnum
        FROM DEP_PROJECT
        WHERE Dnum = @dept_num;

    OPEN project_cursor;

    FETCH NEXT FROM project_cursor INTO @p_number, @p_name, @p_location, @d_num;

    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @budget = 0;

            DECLARE works_on_cursor CURSOR FOR
                SELECT Essn, Pno, hours
                FROM DEP_WORKS_ON
                WHERE Pno = @p_number;

            OPEN works_on_cursor;

            FETCH NEXT FROM works_on_cursor INTO @essn, @pno, @hours;

            WHILE @@FETCH_STATUS = 0
                BEGIN
                    SELECT @hourly_rate = salary / 40 FROM DEP_EMPLOYEE WHERE Ssn = @essn;
                    SET @budget += @hours * @hourly_rate;
                    FETCH NEXT FROM works_on_cursor INTO @essn, @pno, @hours;
                END

            CLOSE works_on_cursor;
            DEALLOCATE works_on_cursor;

            SET @totalBudget += @budget;

            INSERT INTO @table_info VALUES (@p_number, @p_name, @p_location, @d_num, @budget, @totalBudget);

            FETCH NEXT FROM project_cursor INTO @p_number, @p_name, @p_location, @d_num;
        END

    CLOSE project_cursor;
    DEALLOCATE project_cursor;

    RETURN;
END
```

### *h)* 

```
CREATE TRIGGER After_Delete_Department 
ON DEP_DEPARTMENT
AFTER DELETE
AS
BEGIN
    IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DELETED_DEPARTMENTS'))
    BEGIN
        CREATE TABLE DELETED_DEPARTMENTS (
            Dnumber            int        NOT NULL,
            Dname            varchar(20)    NOT NULL,
            Mgr_ssn            varchar(9)    ,
            Mgr_start_date    date

            PRIMARY KEY (Dnumber)
        );
    END

    INSERT INTO DELETED_DEPARTMENTS (Dnumber, Dname, Mgr_ssn, Mgr_start_date)
    SELECT Dnumber, Dname, Mgr_ssn, Mgr_start_date
    FROM deleted;
END

CREATE TRIGGER InsteadOf_Delete_Department 
ON DEP_DEPARTMENT
INSTEAD OF DELETE
AS
BEGIN
    IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DELETED_DEPARTMENTS'))
    BEGIN
        CREATE TABLE DELETED_DEPARTMENTS (
            Dnumber            int        NOT NULL,
            Dname            varchar(20)    NOT NULL,
            Mgr_ssn            varchar(9)    ,
            Mgr_start_date    date

            PRIMARY KEY (Dnumber)
        );
    END

    INSERT INTO DELETED_DEPARTMENTS (Dnumber, Dname, Mgr_ssn, Mgr_start_date)
    SELECT Dnumber, Dname, Mgr_ssn, Mgr_start_date
    FROM deleted;

    DELETE FROM DEP_DEPARTMENT
    WHERE Dnumber IN (SELECT Dnumber FROM DELETED);
END
```

### *i)* 

```
Os stored procedures são blocos de código que podem ser executados várias vezes com diferentes parâmetros de entrada, ou seja são basicamente funcões ás quais ja esamos habituados nas linguagens de programação do nosso dia-a-dia (python, c, java).
Para além disso, permitem retornar mais do que um valor, lidar com exceções e receber argumentos de saída.

Estes são mais indicados para uma quantidade avultada de dados, já que o plano de execução fica armazenado em cache, sendo reutilizado para chamadas subsequentes.
Exemplo: Decrementar o saldo de uma conta quando ela efetua uma transferencia.



As UDFs são também como funções, e permitem **retornar uma tabela** criada ou um valor único.
Estas são mais indicadas para o cálculo de valores, formatação de strings ou tranformações de dados.
Face aos stored procedures, permitem utilizar "WHERE" ou "HAVING".
Exemplo: Devolver o custo de um emprestimo tendo em conta o ID da conta que efetou o emprestimo e a taxa de juros.
```
