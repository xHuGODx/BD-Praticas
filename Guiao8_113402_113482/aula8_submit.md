# BD: Guião 8


## ​8.1. Complete a seguinte tabela.
Complete the following table.

| #    | Query                                                                                                      | Rows  | Cost  | Pag. Reads | Time (ms) | Index used                     | Index Op.            | Discussion |
| :--- | :--------------------------------------------------------------------------------------------------------- | :---- | :---- | :--------- | :-------- | :------------------------------| :------------------- | :--------- |
| 1    | SELECT * from Production.WorkOrder                                                                         | 72591 | 0.473 | 552        | 950       | WorkOrderID                    | Clustered Index Scan |            |
| 2    | SELECT * from Production.WorkOrder where WorkOrderID=1234                                                  |   1   |0.003  | 26         | 114       |WorkOrderID                     |Clustered Index Seek  |            |
| 3.1  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010                               |  11   | 0.003 |   26       | 133       |WorkOrderID                     |Clustered Index Seek  |            |
| 3.2  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591                                   |72591  |  0.473|     556    | 878       |WorkOrderID                     |Clustered Index Seek  |            |
| 4    | SELECT * FROM Production.WorkOrder WHERE StartDate = '2007-06-25'                                          |55     |  0.473|    556     |  278      |WorkOrderID                     |Clustered Index Scan  |            |
| 5    | SELECT * FROM Production.WorkOrder WHERE ProductID = 757                                                   |  9    |0.033  |    46      |   144     |  Product ID                    |Index Seek/Key lookup |            |
| 6.1  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757                              |   9   | 0.037 |     46     |    124    |ProductID Covered (StartDate)   |Index Seek/Key lookup |            |
| 6.2  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945                              | 1105  |  0.473|     556    |    81     |ProductID Covered (StartDate)   |Clustered Index Scan  |            |
| 6.3  | SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04'            |   1   |  0.473|     814    |   103     |ProductID Covered (StartDate)   |Clustered Index Scan  |            |
| 7    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' |   1   | 0.473 |      558   |   94      |ProductID and StartDate         |Clustered Index Scan  |            |
| 8    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' |    1  | 0.473 |      558   |    90     |Composite (ProductID, StartDate)|Clustered Index Scan  |            |

## ​8.2.

### a)

```
PRIMARY KEY (rid)
```

### b)

```
74312 ms
99.02% de fragmentacao
69.93% average page space used
```

### c)

```

CREATE CLUSTERED INDEX ridPK ON mytemp(rid) WITH (FILLFACTOR = X);

fillfactor / tempo insercao
65 / 66201
80 / 68128
90 / 59361
```

### d)

```
... Write here your answer ...
```

### e)

```
... Write here your answer ...
```

## ​8.3.

```
As respostas que tiverem "or" devem se ao facto de eu não saber qual a sintax mais correta mas são equivalente de qualquer modo.

i. The employee with certain number ssn;
    Index: Ssn (UNIQUE) on the EMPLOYEE table.
    or
    Index: Ssn (PK)
   
ii. The employee(s) with a certain first and last name;
    Index: (Lname, Fname) on the EMPLOYEE table.
    or
    Index: Composite (Fname, Lname)

iii. Employees working for a particular department;
    Index: Dno on the EMPLOYEE table.
    or
    Index: Dno
iv. Employees who work for certain project;
    Index: (Essn, Pno) on the WORKS_ON table.
    or
    Index: Composite (Essn, Pno)
v. Dependents of a particular employee;
    Index: Essn on the DEPENDENT table.
    or
    Index: Essn (PK)
vi. The projects associated with a given department;
    Index: Dnum on the PROJECT table.
    or
    Index: Dnum
```
