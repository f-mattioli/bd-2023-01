--
-- Exemplo: criação do banco
--
CREATE DATABASE fornecedores;

CREATE TABLE fornecedores (
    fornecedor_id SERIAL,
    nome VARCHAR (20),
    status INTEGER,
    cidade VARCHAR (20),
    PRIMARY KEY (fornecedor_id)
);

CREATE TABLE pecas (
    peca_id SERIAL,
    nome VARCHAR (20),
    cor VARCHAR (20),
    peso FLOAT,
    cidade VARCHAR (20),
    PRIMARY KEY (peca_id)
);

CREATE TABLE fornecedores_pecas (
    fornecedor_id INTEGER,
    peca_id INTEGER,
    quantidade INTEGER,
    PRIMARY KEY (fornecedor_id, peca_id),
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedores (fornecedor_id),
    FOREIGN KEY (peca_id) REFERENCES pecas (peca_id)
);


--
-- Preenchimento das tabelas
--
INSERT INTO fornecedores (nome, status, cidade)
VALUES
('Smith', 20, 'Londres'),
('Jones', 10, 'Paris'),
('Blake', 30, 'Paris'),
('Clark', 20, 'Londres'),
('Adams', 30, 'Atenas');

INSERT INTO pecas (nome, cor, peso, cidade)
VALUES
('Porca', 'Vermelho', 12.0, 'Londres'),
('Pino', 'Verde', 17.0, 'Paris'),
('Parafuso', 'Azul', 17.0, 'Oslo'),
('Parafuso', 'Vermelho', 14.0, 'Londres'),
('Came', 'Azul', 12.0, 'Paris'),
('Tubo', 'Vermelho', 19.0, 'Londres');

INSERT INTO fornecedores_pecas (fornecedor_id, peca_id, quantidade)
VALUES
(1, 1, 300),
(1, 2, 200),
(1, 3, 400),
(1, 4, 200),
(1, 5, 100),
(1, 6, 100),
(2, 1, 300),
(2, 2, 400),
(3, 2, 200),
(4, 2, 200),
(4, 4, 300),
(4, 5, 400);


--
-- Operadores
--

-- Restrição
SELECT 
    * 
FROM 
    pecas 
WHERE 
    peso > 15;

-- Projeção
SELECT 
    peca_id, 
    nome, 
    peso 
FROM 
    pecas 
WHERE 
    peso > 15;

-- Junção
SELECT
    p.peca_id,
    p.nome,
    p.peso,
    f.fornecedor_id,
    f.nome,
    fp.quantidade
FROM
    pecas p
    JOIN fornecedores_pecas fp ON p.peca_id = fp.peca_id
    JOIN fornecedores f ON f.fornecedor_id = fp.fornecedor_id
WHERE
    p.peso > 15
    AND fp.quantidade > 300;

--
-- Exemplo agregação
--
SELECT 
    f.fornecedor_id, 
    f.nome, 
    SUM(fp.quantidade)
FROM
    fornecedores_pecas fp
    JOIN fornecedores f ON fp.fornecedor_id = f.fornecedor_id
GROUP BY 
    f.fornecedor_id, f.nome 
ORDER BY SUM(fp.quantidade) DESC;

--
-- Exemplo: inserção
--
INSERT INTO pecas (nome, cor, peso, cidade)
VALUES
('Prego', 'Verde', '10', 'Barcelona');

--
-- Exemplo: atualização
--
UPDATE pecas
SET cidade = 'Lisboa'
WHERE nome = 'Prego';

--
-- Exemplo: remoção
--
DELETE FROM pecas
WHERE nome = 'Prego';

--
-- Exemplo: information schema
--
SELECT 
    c.constraint_name AS "CONSTRAINT", 
    k.table_name AS "TABLE", 
    k.column_name AS "COLUMN",
    c.table_name AS "REF TABLE", 
    c.column_name AS "REF COLUMN" 
FROM 
    information_schema.constraint_column_usage c 
    JOIN information_schema.key_column_usage k 
        ON c.constraint_name = k.constraint_name 
WHERE 
    c.table_schema = 'public'
    AND c.constraint_name LIKE '%fkey';