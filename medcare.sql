CREATE TABLE pacientes ( 
    id SERIAL PRIMARY KEY, 
    nome VARCHAR(200) NOT NULL, 
    email VARCHAR(200) UNIQUE NOT NULL, 
    cpf VARCHAR(11) UNIQUE NOT NULL, 
    data_nascimento DATE NOT NULL, 
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE especialidades ( 
    id SERIAL PRIMARY KEY, 
    nome VARCHAR(200) NOT NULL
);

CREATE TABLE medicos ( 
    id SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    especialidade_id INT NOT NULL,
	crm TEXT UNIQUE NOT NULL,
	valor_consulta NUMERIC NOT NULL CHECK (valor_consulta > 0),

	CONSTRAINT id_especialidades
    FOREIGN KEY (id)
    REFERENCES especialidades (id)
);

CREATE TABLE consultas ( 
    id SERIAL PRIMARY KEY, 
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    status TEXT NOT NULL DEFAULT 'Agendada' CHECK (status IN ('Agendada', 'Realizada', 'Cancelada')),
    medico_id INT REFERENCES medicos (id), 
    paciente_id INT REFERENCES pacientes (id)
);

CREATE TABLE exames_consulta (
    id SERIAL PRIMARY KEY,
    consulta_id INT NOT NULL,
    nome_exame VARCHAR(100) NOT NULL,
    valor_exame NUMERIC(10, 2) NOT NULL CHECK (valor_exame >= 0),
    
    CONSTRAINT fk_exame_consulta 
    FOREIGN KEY (consulta_id) 
    REFERENCES consultas(id) 
);

INSERT INTO medicos (especialidade_id, nome, crm, valor_consulta) VALUES 
(1, 'Dr. Tintako Nakamara', 'CRM/SP 234543', 241.00),
(2, 'Dr. Lucas Alves', 'CRM/SP 098765', 2783.00),
(3, 'Dr. Gustavo Lima', 'CRM/SP 453547', 321.01),
(4, 'Dra. Ana Júlia', 'CRM/SP 523533', 3289.99),
(5, 'Dra. Fabiana Melzi', 'CRM/SP 132398', 2167.67);

INSERT INTO consultas (medico_id, paciente_id, data_hora, status) VALUES 
(1, 1, '2026-03-10 09:00:00', 'Realizada'),
(1, 3, '2026-03-10 10:30:00', 'Realizada'),
(3, 1, '2026-03-12 11:00:00', 'Agendada');
(3, 1, '2026-03-02 11:23:31', 'Agendada');
(3, 1, '2026-03-12 13:23:43', 'Agendada');

INSERT INTO exames_consulta (consulta_id, nome_exame, valor_exame) VALUES 
(7, 'Eletrocardiograma', 120.00),
(8, 'Ecocardiograma', 250.00),
(9, 'Hemograma Completo', 45.00),
(10, 'Exame de Urina', 30.00);

INSERT INTO especialidades (nome) VALUES 
('Cardiologia'),
('Neurologia'),
('Psiquiatria'),
('Dermatologia'),
('Ginecologia ');


INSERT INTO pacientes (nome, email, cpf, data_nascimento) VALUES 
('Arthur Melzi', 'arthurmds123@gmail.com', '12345678910', '2009-12-31')

INSERT INTO pacientes (nome, email, cpf, data_nascimento) VALUES 
('Junior Lima', 'sla@gmail.com', '11111111111', '2007-01-29'),
('Carlos Silva', 'carlos.silva@email.com', '11122233344', '1985-05-12'),
('Mariana Costa', 'mariana.costa@email.com', '55566677788', '2010-08-25'),
('Lucas Pereira', 'lucas.pereira@email.com', '99900011122', '1998-11-03');

-- Q1
SELECT nome, crm, especialidade_id, valor_consulta
FROM medicos
ORDER BY valor_consulta DESC;


-- Q2
SELECT c.id, c.data_hora, m.nome, e.nome, c.status
FROM consultas c
JOIN pacientes p ON c.paciente_id = p.id
JOIN medicos m ON c.medico_id = m.id
JOIN especialidades e ON m.especialidade_id = e.id
WHERE p.nome = 'Carlos Silva';


-- Q3
SELECT c.id, p.nome, m.nome,
       m.valor_consulta + COALESCE(SUM(ec.valor_exame), 0) AS valor_total
FROM consultas c
JOIN pacientes p ON c.paciente_id = p.id
JOIN medicos m ON c.medico_id = m.id
LEFT JOIN exames_consulta ec ON c.id = ec.consulta_id
GROUP BY c.id, p.nome, m.nome, m.valor_consulta;


-- Q4
SELECT nome, crm, especialidade_id, valor_consulta
FROM medicos
WHERE valor_consulta > 300;


-- Q5
SELECT e.nome, SUM(m.valor_consulta) AS total_faturado
FROM consultas c
JOIN medicos m ON c.medico_id = m.id
JOIN especialidades e ON m.especialidade_id = e.id
WHERE c.status = 'Realizada'
GROUP BY e.nome;
