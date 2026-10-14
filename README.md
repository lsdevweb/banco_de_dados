# 💊 FidelizaDrogaLu — Sistema de Gestão e Fidelização Farmacêutica

O **FidelizaDrogaLu** é um banco de dados relacional projetado para gerenciar as operações de vendas, estoque, cadastro de clientes, vendedores e itens de pedidos para uma rede farmacêutica. O modelo garante integridade referencial, consistência em transações financeiras e rastreabilidade total dos pedidos.

---

## 📌 Sumário
- [Arquitetura e Modelo Relacional]
- [Estrutura do Banco de Dados]
- [Regras de Negócio e Restrições]
- [Como Executar o Projeto]
- [Exemplos de Operações (CRUD)]

---

## 📐 Arquitetura e Modelo Relacional

O modelo relacional foi construído na **3ª Forma Normal (3FN)** para evitar redundância de dados e garantir alta performance em consultas analíticas e operacionais.
[Categoria] 1 --- N [Produto] 1 --- N [Item_Pedido] N --- 1 [Pedido]
|
[Cliente] 1 -------+
|
[Vendedor] 1 -------+


---

## 🗄️ Estrutura do Banco de Dados

O banco de dados é composto por 6 tabelas principais:

| Tabela | Descrição | Chave Primária (PK) | Chaves Estrangeiras (FK) |
|---|---|---|---|
| **`Cliente`** | Armazena os dados cadastrais dos clientes. | `cod_cliente` | — |
| **`Categoria`** | Agrupa os produtos por setor (ex: Medicamentos, Cosméticos). | `cod_categoria` | — |
| **`Produto`** | Registra itens comercializados, preços e estoque atual. | `cod_produto` | `cod_categoria` |
| **`Vendedor`** | Registra os funcionários responsáveis pelas vendas. | `cod_vendedor` | — |
| **`Pedido`** | Cabeçalho das vendas com data, cliente, vendedor e valor total. | `cod_pedido` | `cod_cliente`, `cod_vendedor` |
| **`Item_Pedido`** | Detalhamento dos produtos e quantidades de cada pedido. | `cod_item_pedido` | `cod_pedido`, `cod_produto` |

---

## ⚙️ Regras de Negócio e Restrições

- **Unicidade de Documento:** Cada cliente possui um CPF único (`uq_cliente_cpf`).
- **Validação de Estoque/Venda:** A quantidade de itens em um pedido deve ser obrigatoriamente maior que zero (`chk_quantidade`).
- **Integridade Referencial:** Não é possível excluir categorias, clientes ou produtos que possuem pedidos ou vínculos ativos.
- **Valores Padronizados:** Preços e totais utilizam o tipo `DECIMAL(10,2)` para evitar erros de arredondamento financeiro.

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
* **MySQL Server** (v8.0 ou superior) ou **MariaDB**
* **MySQL Workbench** ou **phpMyAdmin**

### Passo a Passo

1. **Clonar o Repositório:**
   ```bash
   *git clone 
**Importar o Script SQL:
Abra o seu cliente MySQL (Workbench, DBeaver ou terminal) e execute o script DDL de criação do banco:

**SQL
SOURCE schema.sql;
(Ou copie o conteúdo do script SQL e cole diretamente na aba de query).

Verificar as Tabelas:

SQL
USE FidelizaDrogaLu;
SHOW TABLES;
📝 Exemplos de Operações (CRUD)
SQL
INSERT INTO Cliente (nome_cliente, cpf, telefone, endereco, cep) 
VALUES ('Maria Oliveira', '12345678901', '31988887777', 'Rua das Flores, 120', '30100000');

INSERT INTO Categoria (nome_categoria) VALUES ('Medicamentos');

INSERT INTO Produto (nome_produto, preco_produto, estoque, cod_categoria) 
VALUES ('Dipirona 500mg', 5.50, 100, 1);
SQL
SELECT 
    p.cod_pedido AS 'Nº Pedido',
    p.data_pedido AS 'Data',
    c.nome_cliente AS 'Cliente',
    v.nome_vendedor AS 'Vendedor',
    p.valor_total AS 'Total (R$)'
FROM Pedido p
INNER JOIN Cliente c ON p.cod_cliente = c.cod_cliente
INNER JOIN Vendedor v ON p.cod_vendedor = v.cod_vendedor;
SQL
UPDATE Produto 
SET estoque = estoque + 50 
WHERE cod_produto = 1;
SQL
DELETE FROM Item_Pedido 
WHERE cod_item_pedido = 1;

✒️ Licença e Autor
Desenvolvido como parte do projeto de modelagem e estruturação de banco de dados para a LS Soluções WEB.


