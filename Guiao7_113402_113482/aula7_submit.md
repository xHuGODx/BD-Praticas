# BD: Guião 7


## ​7.2 
 
### *a)*

```
Está na 1FN, pois os atributos aparentam ser atómicos e não suporta nested relations (relações dentro de relações), mas não está na 2FN, pois existem dependências parciais, existem atributos não pertecentes a qualquer chave candidata que dependem só de parte da chave. (Nome_Autor -> Afiliacao_Autor)
```

### *b)* 

```
Passar para 2FN, as dependências parciais vão dar resultado a novas relações

R1={A,B,D,E,F,G,H,I}
R2={B,C}

Passar para 3FN, as dependÊncias transitivas relativamente a Tipo_Livro (D) com Nopaginas (F), e Editor(G) deu origem a duas novas relações em que D e F são chaves primárias, e G a chave primária da outra relação

R1={A,B,D,F,G,I}
R2={B,C}
R3={D,F,E}
R4={G,H}
```

## ​7.3
 
### *a)*

```
{A,B}
```

### *b)* 

```
R1={A,B,C}
R2={A,D,E,I,J} 
R3={B,F,G,H}
```


### *c)* 

```
R1={A,B,C} 
R2={A,D,E} 
R3={D,I,J} 
R4={B,F} 
R5={F,G,H}
```


## ​7.4
 
### *a)*

```
{A,B}
```


### *b)* 

```
R1 = {A,B,C,D}
R2 = {D,E}
```


### *c)* 

```
R1 = {A,B,C,D}
R2 = {D,E}
R3 = {A,C}
```



## ​7.5
 
### *a)*

```
{A,B}
```

### *b)* 

```
R1 = {A,B,C,D,E}
R2 = {A,C,D}
```


### *c)* 

```
R1 = {A,B,D,E}
R2 = {A,C}
R3 = {C,D}
```

### *d)* 

```

Na BCNF, cada atributo de uma relação depende apenas da chave da relação, ou seja, da chave inteira e nada mais. Fica igual a alinea c.

R1 = {A,B,D,E}
R2 = {A,C}
R3 = {C,D}
```
