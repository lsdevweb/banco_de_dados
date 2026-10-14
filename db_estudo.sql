-- ==========================================
-- CRIAÇÃO DO BANCO DE DADOS
-- ==========================================
CREATE DATABASE FidelizaDrogaLu;
USE FidelizaDrogaLu;
-- ==========================================
-- TABELA CLIENTE
-- ==========================================
CREATE TABLE Cliente (
    cod_cliente INT AUTO_INCREMENT,
    nome_cliente VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    telefone VARCHAR(15),
    endereco VARCHAR(150),
    cep CHAR(8),
    CONSTRAINT pk_cliente
        PRIMARY KEY (cod_cliente),
    CONSTRAINT uq_cliente_cpf
        UNIQUE (cpf)
);
-- ==========================================
-- TABELA CATEGORIA
-- ==========================================
CREATE TABLE Categoria (
    cod_categoria INT AUTO_INCREMENT,
    nome_categoria VARCHAR(50) NOT NULL,
    CONSTRAINT pk_categoria
        PRIMARY KEY (cod_categoria)
);
-- ==========================================
-- TABELA PRODUTO
-- ==========================================
CREATE TABLE Produto (
    cod_produto INT AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    preco_produto DECIMAL(10,2) NOT NULL,
    estoque INT DEFAULT 0,
    cod_categoria INT NOT NULL,
    CONSTRAINT pk_produto
        PRIMARY KEY (cod_produto),
    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (cod_categoria)
        REFERENCES Categoria(cod_categoria)
);
-- ==========================================
-- TABELA VENDEDOR
-- ==========================================
CREATE TABLE Vendedor (
    cod_vendedor INT AUTO_INCREMENT,
    nome_vendedor VARCHAR(100) NOT NULL,
    email_vendedor VARCHAR(100),
    CONSTRAINT pk_vendedor
        PRIMARY KEY (cod_vendedor),
    CONSTRAINT uq_vendedor_email
        UNIQUE (email_vendedor)
);
-- ==========================================
-- TABELA PEDIDO
-- ==========================================
CREATE TABLE Pedido (
    cod_pedido INT AUTO_INCREMENT,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    cod_cliente INT NOT NULL,
    cod_vendedor INT NOT NULL,
    CONSTRAINT pk_pedido
        PRIMARY KEY (cod_pedido),
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (cod_cliente)
        REFERENCES Cliente(cod_cliente),
    CONSTRAINT fk_pedido_vendedor
        FOREIGN KEY (cod_vendedor)
        REFERENCES Vendedor(cod_vendedor)
);
-- ==========================================
-- TABELA ITEM_PEDIDO
-- ==========================================
CREATE TABLE Item_Pedido (
    cod_item_pedido INT AUTO_INCREMENT,
    cod_pedido INT NOT NULL,
    cod_produto INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_item_pedido
        PRIMARY KEY (cod_item_pedido),
    CONSTRAINT fk_itempedido_pedido
        FOREIGN KEY (cod_pedido)
        REFERENCES Pedido(cod_pedido),
    CONSTRAINT fk_itempedido_produto
        FOREIGN KEY (cod_produto)
        REFERENCES Produto(cod_produto),
    CONSTRAINT chk_quantidade
        CHECK (quantidade > 0)
);
SHOW DATABASES;SHOW TABLES;
USE FidelizaDrogaLu;
-- 1-Create (Inserção de Dados - INSERT)
INSERT INTO Cliente (nome_cliente, cpf, telefone, endereco, cep) VALUES
('Maria Oliveira', '12345678901', '31988887777', 'Rua das Flores, 120', '30100000'),
('João Souza', '98765432100', '31977776666', 'Av. Central, 450', '30200000');
-- Inserir Categorias
INSERT INTO Categoria (nome_categoria) VALUES
('Medicamentos'),
('Higiene Pessoal'),
('Cosméticos');
-- Inserir Vendedores
INSERT INTO Vendedor (nome_vendedor, email_vendedor) VALUES
('Carlos Vendas', 'carlos@drogalu.com'),
('Ana Balcão', 'ana@drogalu.com');
-- Inserir Produtos (usando o cod_categoria recém-criado)
INSERT INTO Produto (nome_produto, preco_produto, estoque, cod_categoria) VALUES
('Dipirona 500mg', 5.50, 100, 1),
('Shampoo Anticaspa 200ml', 22.90, 45, 2),
('Protetor Solar FPS 50', 59.90, 30, 3);
-- Inserir um Pedido
INSERT INTO Pedido (data_pedido, valor_total, cod_cliente, cod_vendedor) VALUES
('2026-10-14', 28.40, 1, 1);
-- Inserir Itens no Pedido (1 pedido com 1 Shampoo e 1 Dipirona)
INSERT INTO Item_Pedido (cod_pedido, cod_produto, quantidade, valor_unitario) VALUES
(1, 1, 1, 5.50),  -- 1 Dipirona
(1, 2, 1, 22.90); -- 1 Shampoo

-- 2. Read (Consultas de Dados - SELECT)
-- a) Consulta Simples: Listar todos os clientes
SELECT * FROM Cliente;
-- b) Consulta com Filtro (WHERE): Produtos com estoque menor que 50
SELECT nome_produto, estoque, preco_produto 
FROM Produto 
WHERE estoque < 50;
-- c) Consulta com JOIN: Ver pedidos detalhados com nome do cliente e do vendedor
SELECT 
    p.cod_pedido,
    p.data_pedido,
    c.nome_cliente,
    v.nome_vendedor,
    p.valor_total
FROM Pedido p
INNER JOIN Cliente c ON p.cod_cliente = c.cod_cliente
INNER JOIN Vendedor v ON p.cod_vendedor = v.cod_vendedor;
-- d) Consulta Completa com JOINs: Detalhes dos itens de um pedido específico
SELECT 
    p.cod_pedido,
    pr.nome_produto,
    ip.quantidade,
    ip.valor_unitario,
    (ip.quantidade * ip.valor_unitario) AS subtotal
FROM Item_Pedido ip
INNER JOIN Pedido p ON ip.cod_pedido = p.cod_pedido
INNER JOIN Produto pr ON ip.cod_produto = pr.cod_produto
WHERE p.cod_pedido = 1;

-- 3. Update (Atualização de Dados - UPDATE)
-- a) Atualizar telefone e endereço de um cliente específico
UPDATE Cliente
SET telefone = '31999998888', endereco = 'Rua das Flores, 125 - Apto 201'
WHERE cod_cliente = 1;
-- b) Atualizar o preço e repor o estoque de um produto
UPDATE Produto
SET preco_produto = 6.00, estoque = estoque + 50
WHERE cod_produto = 1;
-- c) Atualizar o e-mail de um vendedor
UPDATE Vendedor
SET email_vendedor = 'carlos.silva@drogalu.com'
WHERE cod_vendedor = 1;

-- 4. Delete (Remoção de Dados - DELETE)
-- a) Deletar um item de pedido específico
DELETE FROM Item_Pedido
WHERE cod_item_pedido = 1;
-- b) Deletar um produto que não tenha vínculos em nenhum pedido
DELETE FROM Produto
WHERE cod_produto = 3;
-- c) Deletar uma categoria sem produtos associados
DELETE FROM Categoria
WHERE cod_categoria = 3;

USE FidelizaDrogaLu;
-- 1. Listar todas as tabelas criadas no banco
SHOW TABLES;
-- 2. Ver a estrutura/colunas de uma tabela específica (exemplo: Cliente)
DESCRIBE Cliente;
DESCRIBE Produto;
DESCRIBE Pedido;
