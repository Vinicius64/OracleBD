ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER vinicius IDENTIFIED BY vinicius;

GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE TO vinicius;

GRANT CREATE MATERIALIZED VIEW TO vinicius;

ALTER USER vinicius QUOTA UNLIMITED ON USERS;

CREATE USER usuario IDENTIFIED BY usuario;

GRANT CREATE SESSION TO usuario;

ALTER USER usuario QUOTA UNLIMITED ON USERS;

GRANT CONNECT TO usuario;


GRANT SELECT ON vinicius.Autores TO usuario;
GRANT SELECT ON vinicius.Categorias TO usuario;
GRANT SELECT ON vinicius.Editoras TO usuario;
GRANT SELECT ON vinicius.Livros TO usuario;
GRANT SELECT ON vinicius.Usuarios TO usuario;
GRANT SELECT ON vinicius.Compras TO usuario;
GRANT SELECT ON vinicius.Avaliacoes TO usuario;
GRANT SELECT ON vinicius.Favoritos TO usuario;
GRANT SELECT ON vinicius.Tags TO usuario;
GRANT SELECT ON vinicius.LivrosTags TO usuario;
GRANT SELECT ON vinicius.BibliotecaUsuarios TO usuario;
GRANT SELECT ON vinicius.LivroAutor TO usuario;
GRANT SELECT ON vinicius.LivroCompras TO usuario;

GRANT INSERT, UPDATE, DELETE ON vinicius.Autores TO usuario;

GRANT INSERT, UPDATE, DELETE ON vinicius.Editoras TO usuario;

GRANT SELECT ON vinicius.v_AvaliacoesLivros TO usuario;

GRANT SELECT ON vinicius.v_ComprasUsuarios TO usuario;

GRANT SELECT ON vinicius.v_LivrosCategoriasTags TO usuario;

GRANT SELECT ON vinicius.MV_NumLivrosPorAutor TO usuario;


GRANT SELECT ON vinicius.seq_autor TO usuario;

GRANT SELECT ON vinicius.seq_editora TO usuario;

REVOKE DELETE ON vinicius.Autores FROM usuario;
REVOKE DELETE ON vinicius.Editoras FROM usuario;





