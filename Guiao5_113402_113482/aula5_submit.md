# BD: Guião 5


## ​Problema 5.1
 
### *a)*

```
π project.Pname, employee.Fname,employee.Lname, employee.Ssn
(
project
⨝ project.Pnumber=works_on.Pno
works_on
⨝ works_on.Essn=employee.Ssn
employee
)
```


### *b)* 

```
π employee.Fname,employee.Lname
(
employee
⨝ employee.Super_ssn=Chefe.Ssn
ρ Chefe
π employee.Ssn
σ Fname='Carlos' ∧ Minit='D' ∧ Lname='Gomes'
employee
)
```


### *c)* 

```
γ Pname; sum(Hours)->TotalHours
    (
    ρ AllProjects
        (
        works_on
        ⨝ works_on.Pno=project.Pnumber
        project
        )
    )
```


### *d)* 

```
π employee.Fname, employee.Minit, employee.Lname
σ department.Dnumber=3 ∧ works_on.Hours>20 ∧ project.Pname='Aveiro Digital'
(
department
⨝ department.Dnumber = employee.Dno
employee
⨝ employee.Ssn = works_on.Essn
works_on
⨝ works_on.Pno = project.Pnumber project
)
```


### *e)* 

```
π Fname,Minit,Lname
(σ Essn = null
(employee ⟕ Ssn=Essn works_on))
```


### *f)* 

```
π department.Dname, avgSalary

(
department
⟕ department.Dnumber = ALGO.Dno
ρ ALGO
σ Sex='F'
γ Dno, Sex; avg(Salary)->avgSalary
employee
)
```


### *g)* 

```
π employee.Fname, employee.Minit, employee.Lname
(
employee
⨝ employee.Ssn=dependent.Essn
σ number_Dependents > 2
γ Essn; count(Dependent_name)->number_Dependents
dependent
)
```


### *h)* 

```
π employee.Fname,employee.Minit,employee.Lname
σ Dependent_name = null
(
employee
⨝ employee.Ssn=department.Mgr_ssn
department
⟕ employee.Ssn=dependent.Essn
dependent
)
```


### *i)* 

```
π employee.Ssn, employee.Fname, employee.Minit, employee.Lname, employee.Address, project.Plocation, dept_location.Dlocation

    σ dept_location.Dlocation!='Aveiro' ∧ project.Plocation='Aveiro'
    (
        employee
        ⨝ employee.Ssn=works_on.Essn
        works_on
        ⨝ works_on.Pno=project.Pnumber
        project
        ⨝ employee.Dno=department.Dnumber
        department
        ⨝ department.Dnumber=dept_location.Dnumber
        dept_location
    )
```


## ​Problema 5.2

### *a)*

```
π nif, nome, fax, endereco, condpag, tipo
σ numero = null
(
	encomenda
	⟖ encomenda.fornecedor = fornecedor.nif
	fornecedor
)
```

### *b)* 

```
γ produto.nome,codProd; avg(item.unidades) -> Media
(
	item
	⨝ item.codProd = produto.codigo
	produto
)
```


### *c)* 

```
γ avg(nProd) -> z
γ numEnc; count(codProd)->nProd
(
    item
)
```


### *d)* 

```
τ nome
(
	γ fornecedor.nif, fornecedor.nome, codProd; sum(unidades)->quantidade
	(
		encomenda
		⨝ encomenda.fornecedor = fornecedor.nif
		fornecedor
		⨝ encomenda.numero = item.numEnc
		item
	)
)
```


## ​Problema 5.3

### *a)*

```
π paciente.numUtente, nome, dataNasc ( σ prescricao.numPresc = null (paciente ⟕ paciente.numUtente = prescricao.numUtente prescricao))
```

### *b)* 

```
γ especialidade; COUNT(numPresc)→pres_especialidade (medico ⨝ numSNS = numMedico prescricao)
```


### *c)* 

```
γ farmacia; COUNT(numPresc)→num_pres (farmacia ⨝ nome = farmacia prescricao)
```


### *d)* 

```
( π farmaco.nome ( σ numRegFarm = 906 (farmaco))) - ( π presc_farmaco.nomeFarmaco ( σ numRegFarm = 906 (presc_farmaco)))
```

### *e)* 

```
γ farmacia.nome, farmaceutica.nome; COUNT(farmaceutica.nome)→vendas (farmaceutica ⨝ numReg = numRegFarm ( π presc_farmaco.numPresc, numRegFarm, nomeFarmaco, nome (presc_farmaco ⨝ presc_farmaco.numPresc = prescricao.numPresc (farmacia ⨝ nome = farmacia prescricao))))
```

### *f)* 

```
σ medicos > 1 ( γ paciente.nome, paciente.numUtente; COUNT(medico.nome)→medicos (medico ⨝ numSNS = numMedico (paciente ⨝ paciente.numUtente = prescricao.numUtente prescricao)))
```