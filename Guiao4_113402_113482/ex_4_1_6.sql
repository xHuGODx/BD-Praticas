IF OBJECT_ID('escola_PessoaAutorizadaTransportaAluno', 'U') IS NOT NULL
  DROP TABLE escola_PessoaAutorizadaTransportaAluno;

IF OBJECT_ID('escola_TurmaTemAtividade', 'U') IS NOT NULL
  DROP TABLE escola_TurmaTemAtividade;

IF OBJECT_ID('escola_ClassesTurma', 'U') IS NOT NULL
  DROP TABLE escola_ClassesTurma;

IF OBJECT_ID('escola_Turma', 'U') IS NOT NULL
  DROP TABLE escola_Turma;

IF OBJECT_ID('escola_Professor', 'U') IS NOT NULL
  DROP TABLE escola_Professor;

IF OBJECT_ID('escola_AlunoTemAtividade', 'U') IS NOT NULL
  DROP TABLE escola_AlunoTemAtividade;

IF OBJECT_ID('escola_Aluno', 'U') IS NOT NULL
  DROP TABLE escola_Aluno;

IF OBJECT_ID('escola_EncarregadoDeEducacao', 'U') IS NOT NULL
  DROP TABLE escola_EncarregadoDeEducacao;

IF OBJECT_ID('escola_PessoaAutorizada', 'U') IS NOT NULL
  DROP TABLE escola_PessoaAutorizada;

IF OBJECT_ID('escola_atividade', 'U') IS NOT NULL
  DROP TABLE escola_atividade;

IF OBJECT_ID('escola_Adulto', 'U') IS NOT NULL
  DROP TABLE escola_Adulto;

IF OBJECT_ID('escola_Pessoa', 'U') IS NOT NULL
  DROP TABLE escola_Pessoa;

CREATE TABLE escola_Pessoa (
  numero_cc int NOT NULL,
  nome varchar(50) NOT NULL,
  morada varchar(50) NOT NULL,
  data_nascimento date NOT NULL,

  PRIMARY KEY (numero_cc),
)


CREATE TABLE escola_Adulto(
  numero_cc int NOT NULL,
  numero_telemovel int NOT NULL,
  email varchar(50) NOT NULL,

  PRIMARY KEY (numero_cc),
  FOREIGN KEY (numero_cc) REFERENCES escola_Pessoa(numero_cc),
)

CREATE TABLE escola_atividade(
  id int NOT NULL,
  custo int NOT NULL,
  designacao varchar(50) NOT NULL,

  PRIMARY KEY (id),
)

CREATE TABLE escola_PessoaAutorizada(
  numero_cc int NOT NULL,
  relacao_com_aluno varchar(50) NOT NULL,

  PRIMARY KEY (numero_cc),
  FOREIGN KEY (numero_cc) REFERENCES escola_Adulto(numero_cc),
)

CREATE TABLE escola_EncarregadoDeEducacao(
  numero_cc int NOT NULL,
  
  PRIMARY KEY (numero_cc),
  FOREIGN KEY (numero_cc) REFERENCES escola_PessoaAutorizada(numero_cc),
)

CREATE TABLE escola_Aluno(
  numero_cc int NOT NULL,
  numero_cc_encarregado int NOT NULL,

  PRIMARY KEY (numero_cc),
  FOREIGN KEY (numero_cc) REFERENCES escola_Pessoa(numero_cc),
  FOREIGN KEY (numero_cc_encarregado) REFERENCES escola_EncarregadoDeEducacao(numero_cc),
)

CREATE TABLE escola_AlunoTemAtividade(
  numero_cc_aluno int NOT NULL,
  id_atividade int NOT NULL,

  PRIMARY KEY (numero_cc_aluno, id_atividade),
  FOREIGN KEY (numero_cc_aluno) REFERENCES escola_Aluno(numero_cc),
  FOREIGN KEY (id_atividade) REFERENCES escola_atividade(id),
)

CREATE TABLE escola_Professor(
  numero_cc int NOT NULL,
  numero_funcionario int NOT NULL,  

  PRIMARY KEY (numero_cc),
  FOREIGN KEY (numero_cc) REFERENCES escola_Adulto(numero_cc),
)

CREATE TABLE escola_Turma(
  id_turma int NOT NULL,
  num_funcionarios int NOT NULL,
  designacao varchar(50) NOT NULL,
  num_max_alunos int NOT NULL,
  id_professor int NOT NULL,

  PRIMARY KEY (id_turma),
  FOREIGN KEY (id_professor) REFERENCES escola_Professor(numero_cc),
)

CREATE TABLE escola_ClassesTurma(
  id_turma int NOT NULL,
  Classe_da_turma varchar(50) NOT NULL,

  PRIMARY KEY (id_turma, Classe_da_turma),
  FOREIGN KEY (id_turma) REFERENCES escola_Turma(id_turma),
)

CREATE TABLE escola_TurmaTemAtividade(
  id_atividade int NOT NULL,
  id_turma int NOT NULL,

  PRIMARY KEY (id_atividade, id_turma),
  FOREIGN KEY (id_atividade) REFERENCES escola_atividade(id),
  FOREIGN KEY (id_turma) REFERENCES escola_Turma(id_turma),
)

CREATE TABLE escola_PessoaAutorizadaTransportaAluno(
  numero_cc_autorizado int NOT NULL,
  numero_cc_aluno int NOT NULL,

  PRIMARY KEY (numero_cc_autorizado, numero_cc_aluno),
  FOREIGN KEY (numero_cc_autorizado) REFERENCES escola_PessoaAutorizada(numero_cc),
  FOREIGN KEY (numero_cc_aluno) REFERENCES escola_Aluno(numero_cc),
)

ALTER TABLE escola_Professor
ADD id_turma int;

ALTER TABLE escola_Professor 
ADD CONSTRAINT fk_professor_turma
FOREIGN KEY (id_turma) REFERENCES escola_Turma(id_turma);

