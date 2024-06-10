# BD: Guião 6

## Problema 6.1

### *a)* Todos os tuplos da tabela autores (authors);

```
SELECT *
    FROM authors
```

### *b)* O primeiro nome, o último nome e o telefone dos autores;

```
SELECT authors.au_fname, authors.au_lname, authors.phone
    FROM authors
```

### *c)* Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 

```
SELECT authors.au_fname, authors.au_lname, authors.phone
    FROM authors
    ORDER BY authors.au_fname , authors.au_lname
```

### *d)* Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 

```
SELECT authors.au_fname AS first_name, authors.au_lane AS last_name, authors.phone AS telephone
   FROM authors
   ORDER BY authors.au_fname, authors.au_lname
```

### *e)* Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 

```
SELECT authors.au_fname AS first_name, authors.au_lname AS last_name, authors.phone AS telephone, authors.state AS city
   FROM authors
   WHERE authors.state = 'CA' AND authors.au_lname != 'Ringer'
   ORDER BY authors.au_fname, authors.au_lname
```

### *f)* Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 

```
SELECT publishers.pub_name
   FROM publishers
   WHERE publishers.pub_name LIKE '%Bo%';
```

### *g)* Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’; 

```
SELECT publishers.pub_name
FROM publishers
INNER JOIN titles ON publishers.pub_id = titles.pub_id
WHERE titles.type = 'business'
GROUP BY publishers.pub_name
HAVING COUNT(titles.pub_id) >= 1;
```

### *h)* Número total de vendas de cada editora; 

```
SELECT publishers.pub_name,
       SUM(sales.qty) AS total_quantity_sold
FROM publishers
INNER JOIN titles ON publishers.pub_id = titles.pub_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY publishers.pub_name;
```

### *i)* Número total de vendas de cada editora agrupado por título; 

```
SELECT publishers.pub_name, titles.title, SUM(sales.qty) AS total_sales
FROM publishers
INNER JOIN titles ON publishers.pub_id = titles.pub_id
INNER JOIN sales ON titles.title_id = sales.title_id
GROUP BY publishers.pub_name, titles.title;
```

### *j)* Nome dos títulos vendidos pela loja ‘Bookbeat’; 

```
SELECT title
    FROM sales, titles, stores
    WHERE sales.title_id = titles.title_id and sales.stor_id = stores.stor_id and stor_name like 'Bookbeat'
    GROUP BY title
```

### *k)* Nome de autores que tenham publicações de tipos diferentes; 

```
SELECT authors.au_fname, authors.au_lname
    FROM authors, titles, titleauthor
    WHERE titleauthor.title_id=titles.title_id AND titleauthor.au_id=authors.au_id
    GROUP BY au_fname, au_lname
    HAVING count(DISTINCT [type]) > 1
```

### *l)* Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```
SELECT "type", pub_id, AVG(price) as Average, SUM(qty) as quantity
	FROM sales, titles
	WHERE sales.title_id = titles.title_id
	GROUP BY "type", pub_id
```

### *m)* Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```
Select titles.type, MAX(advance) as max_advance, AVG(advance) as avg_advance
    FROM titles
    GROUP BY [type]
    Having MAX(advance) > 1.5 * AVG(advance)
```

### *n)* Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```
SELECT title, au_fname, au_lname, SUM(royaltyper * royalty * price / 10000) as income
	FROM authors, titleauthor, titles, sales
	WHERE authors.au_id = titleauthor.au_id and titleauthor.title_id = titles.title_id and titles.title_id = sales.title_id
	GROUP BY title, au_fname, au_lname, royaltyper, price

```

### *o)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```
Select title, ytd_sales, ytd_sales*price as faturacao, 
    royalty*ytd_sales*price/100 as auths_revenue ,
    (100-royalty)*ytd_sales*price/100 as publisher_revenue 
    FROM titles
    WHERE ytd_sales IS NOT NULL;
```

### *p)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

```
SELECT title, au_fname, au_lname ytd_sales, SUM(royalty * royaltyper * price * ytd_sales / 10000) as auth_income, SUM((100-royalty) * price * ytd_sales / 100) as store_income
	FROM authors, titleauthor, titles, sales
	WHERE authors.au_id = titleauthor.au_id and titleauthor.title_id = titles.title_id and titles.title_id = sales.title_id
```

### *q)* Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
Select stores.stor_name
    FROM stores, sales, titles
    Where stores.stor_id=sales.stor_id AND sales.title_id=titles.title_id
    Group by stor_name
    Having COUNT(Distinct sales.title_id)=(select count(title_id) from titles);
```

### *r)* Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
SELECT *
FROM (
	SELECT sales.stor_id, SUM(qty) as sales
	FROM sales, stores
	WHERE sales.stor_id = stores.stor_id
	GROUP BY sales.stor_id
	) as sumSales
WHERE sales > (
	SELECT AVG(allSales.sumSales)
	FROM (
	SELECT SUM(qty) as sumSales
	FROM sales, stores 
	WHERE sales.stor_id = stores.stor_id
	GROUP BY sales.stor_id
	) as allSales
    )
```

### *s)* Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
Select titles.title
    FROM (sales join stores on stores.stor_id = sales.stor_id 
    AND stores.stor_name='Bookbeat')
    right outer join titles on titles.title_id=sales.title_id
    WHERE sales.stor_id IS NULL
```

### *t)* Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora; 

```
SELECT stores.stor_id, publishers.pub_id
FROM stores
CROSS JOIN publishers
LEFT JOIN (
    SELECT sales.stor_id, titles.pub_id
    FROM sales, titles
    WHERE sales.title_id = titles.title_id
) AS existing_publishers 
ON stores.stor_id = existing_publishers.stor_id AND publishers.pub_id = existing_publishers.pub_id
WHERE existing_publishers.stor_id IS NULL;
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT DEP_PROJECT.Pname, DEP_EMPLOYEE.Fname, DEP_EMPLOYEE.Lname, DEP_EMPLOYEE.Ssn
FROM DEP_PROJECT
JOIN DEP_WORKS_ON ON DEP_PROJECT.Pnumber = DEP_WORKS_ON.Pno
JOIN DEP_EMPLOYEE ON DEP_WORKS_ON.Essn = DEP_EMPLOYEE.Ssn;
```

##### *b)* 

```
SELECT DEP_EMPLOYEE.Fname, DEP_EMPLOYEE.Lname
FROM DEP_EMPLOYEE
JOIN (
    SELECT DEP_EMPLOYEE.Ssn AS Super_ssn
    FROM DEP_EMPLOYEE
    WHERE Fname='Carlos' AND Minit='D' AND Lname='Gomes'
) AS Chefe ON DEP_EMPLOYEE.Super_ssn = Chefe.Super_ssn;
```

##### *c)* 

```
SELECT DEP_PROJECT.Pname, SUM(DEP_WORKS_ON.Hours) AS TotalHours
FROM DEP_WORKS_ON
JOIN DEP_PROJECT ON DEP_WORKS_ON.Pno = DEP_PROJECT.Pnumber
GROUP BY DEP_PROJECT.Pname;
```

##### *d)* 

```
SELECT DEP_EMPLOYEE.Fname, DEP_EMPLOYEE.Minit, DEP_EMPLOYEE.Lname
FROM DEP_DEPARTMENT
JOIN DEP_EMPLOYEE ON DEP_DEPARTMENT.Dnumber = DEP_EMPLOYEE.Dno
JOIN DEP_WORKS_ON ON DEP_EMPLOYEE.Ssn = DEP_WORKS_ON.Essn
JOIN DEP_PROJECT ON DEP_WORKS_ON.Pno = DEP_PROJECT.Pnumber
WHERE DEP_DEPARTMENT.Dnumber = 3 AND DEP_WORKS_ON.Hours > 20 AND DEP_PROJECT.Pname = 'Aveiro Digital';
```

##### *e)* 

```
SELECT DEP_EMPLOYEE.Fname, DEP_EMPLOYEE.Minit, DEP_EMPLOYEE.Lname
FROM DEP_EMPLOYEE
LEFT JOIN DEP_WORKS_ON ON DEP_EMPLOYEE.Ssn = DEP_WORKS_ON.Essn
WHERE DEP_WORKS_ON.Essn IS NULL;
```

##### *f)* 

```
SELECT DEP_DEPARTMENT.Dname, AVG(DEP_EMPLOYEE.Salary) AS avgSalary
FROM DEP_DEPARTMENT
LEFT JOIN DEP_EMPLOYEE ON DEP_DEPARTMENT.Dnumber = DEP_EMPLOYEE.Dno
WHERE DEP_EMPLOYEE.Sex = 'F'
GROUP BY DEP_DEPARTMENT.Dname, DEP_EMPLOYEE.Sex;
```

##### *g)* 

```
SELECT DEP_EMPLOYEE.Fname, DEP_EMPLOYEE.Minit, DEP_EMPLOYEE.Lname
FROM DEP_EMPLOYEE
JOIN (
    SELECT Essn, COUNT(Dependent_name) AS number_Dependents
    FROM DEP_DEPENDENT
    GROUP BY Essn
    HAVING COUNT(Dependent_name) > 2
) AS dependent_count ON DEP_EMPLOYEE.Ssn = dependent_count.Essn;
```

##### *h)* 

```
SELECT DEP_EMPLOYEE.Fname, DEP_EMPLOYEE.Minit, DEP_EMPLOYEE.Lname
FROM DEP_EMPLOYEE
JOIN DEP_DEPARTMENT ON DEP_EMPLOYEE.Ssn = DEP_DEPARTMENT.Mgr_ssn
LEFT JOIN DEP_DEPENDENT ON DEP_EMPLOYEE.Ssn = DEP_DEPENDENT.Essn
WHERE DEP_DEPENDENT.Dependent_name IS NULL;
```

##### *i)* 

```
SELECT DEP_EMPLOYEE.Ssn, DEP_EMPLOYEE.Fname, DEP_EMPLOYEE.Minit, DEP_EMPLOYEE.Lname, DEP_EMPLOYEE.Address, DEP_PROJECT.Plocation, DEP_DEPT_LOCATIONS.Dlocation
FROM DEP_EMPLOYEE
JOIN DEP_WORKS_ON ON DEP_EMPLOYEE.Ssn = DEP_WORKS_ON.Essn
JOIN DEP_PROJECT ON DEP_WORKS_ON.Pno = DEP_PROJECT.Pnumber
JOIN DEP_DEPARTMENT ON DEP_EMPLOYEE.Dno = DEP_DEPARTMENT.Dnumber
JOIN DEP_DEPT_LOCATIONS ON DEP_DEPARTMENT.Dnumber = DEP_DEPT_LOCATIONS.Dnumber
WHERE DEP_DEPT_LOCATIONS.Dlocation != 'Aveiro' AND DEP_PROJECT.Plocation = 'Aveiro'
GROUP BY DEP_EMPLOYEE.Ssn, DEP_EMPLOYEE.Fname, DEP_EMPLOYEE.Minit, DEP_EMPLOYEE.Lname, DEP_EMPLOYEE.Address, DEP_PROJECT.Plocation, DEP_DEPT_LOCATIONS.Dlocation;
```

### 5.2

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT Nif, Nome, Fax, Endereco, CondPag, Tipo
FROM GestStocksFORNECEDOR LEFT OUTER JOIN GestStocksENCOMENDA ON GestStocksFORNECEDOR.NIF=GestStocksENCOMENDA.Fornecedor
WHERE Numero IS NULL
```

##### *b)* 

```
SELECT codProd AS Encomenda, AVG(Unidades) AS AverageUnidades
FROM GestStocksITEM
GROUP BY codProd
```


##### *c)* 

```
SELECT numEnc AS Encomenda, AVG(Unidades) AS AverageUnidades
FROM GestStocksITEM
GROUP BY numEnc
```


##### *d)* 

```
SELECT GestStocksFORNECEDOR.Nome, GestStocksPRODUTO.Nome, SUM(GestStocksITEM.Unidades) AS Unidades
FROM GestStocksPRODUTO JOIN (GestStocksITEM JOIN (GestStocksFornecedor JOIN GestStocksEncomenda ON 
NIF = Fornecedor) ON numEnc=Numero) ON Codigo=codProd
GROUP BY GestStocksFORNECEDOR.Nome, GestStocksPRODUTO.Nome
```

### 5.3

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT Prescricao_paciente.numUtente, Prescricao_paciente.nome, Prescricao_paciente.dataNasc
FROM Prescricao_paciente
LEFT JOIN Prescricao_prescricao ON Prescricao_paciente.numUtente = Prescricao_prescricao.numUtente
WHERE Prescricao_prescricao.numPresc IS NULL
```

##### *b)* 

```
SELECT m.especialidade, COUNT(p.numPresc) AS pres_especialidade
FROM Prescricao_medico AS m
JOIN Prescricao_prescricao AS p ON m.numSNS = p.numMedico
GROUP BY m.especialidade;
```


##### *c)* 

```
SELECT f.nome AS farmacia, COUNT(p.numPresc) AS num_pres
FROM Prescricao_farmacia AS f
JOIN Prescricao_prescricao AS p ON f.nome = p.farmacia
GROUP BY f.nome;
```


##### *d)* 

```
SELECT f.nome
FROM Prescricao_farmaco AS f
WHERE f.numRegFarm = 906
EXCEPT
SELECT pf.nomeFarmaco
FROM Prescricao_presc_farmaco AS pf
WHERE pf.numRegFarm = 906;
```

##### *e)* 

```
SELECT f.nome AS farmacia_nome, fc.nome AS farmaceutica_nome, COUNT(fc.nome) AS vendas
FROM Prescricao_farmaceutica AS fc
JOIN Prescricao_farmaco AS fa ON fc.numReg = fa.numRegFarm
JOIN Prescricao_presc_farmaco AS pf ON fa.numRegFarm = pf.numRegFarm
JOIN Prescricao_prescricao AS p ON pf.numPresc = p.numPresc
JOIN Prescricao_farmacia AS f ON p.farmacia = f.nome
GROUP BY f.nome, fc.nome;
```

##### *f)* 

```
SELECT p.nome AS paciente_nome, p.numUtente, COUNT(DISTINCT m.nome) AS medicos
FROM Prescricao_medico AS m
JOIN Prescricao_prescricao AS pr ON m.numSNS = pr.numMedico
JOIN Prescricao_paciente AS p ON pr.numUtente = p.numUtente
GROUP BY p.nome, p.numUtente
HAVING COUNT(DISTINCT m.nome) > 1;
```
