CREATE TABLE Autores (
    AutorID NUMBER(5) PRIMARY KEY,
    Nome VARCHAR2(60),
    Biografia VARCHAR2(300)
);

CREATE TABLE Categorias (
    CategoriaID NUMBER(5) PRIMARY KEY,
    Nome VARCHAR2(60)
);

CREATE TABLE Editoras (
    EditoraID NUMBER(5) PRIMARY KEY,
    Nome VARCHAR2(60),
    Endereco VARCHAR2(120)
);

CREATE TABLE Livros (
    LivroID NUMBER(5) PRIMARY KEY,
    Titulo VARCHAR2(60),
    CategoriaID NUMBER(5),
    EditoraID NUMBER(5),
    AnoPublicacao NUMBER(4),
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID),
    FOREIGN KEY (EditoraID) REFERENCES Editoras(EditoraID)
);

CREATE TABLE Usuarios (
    UsuarioID NUMBER(5) PRIMARY KEY,
    Nome VARCHAR2(60),
    Email VARCHAR2(120),
    Senha VARCHAR2(20)
);

CREATE TABLE Compras (
    CompraID NUMBER(5) PRIMARY KEY,
    UsuarioID NUMBER(5),
    DataCompra DATE,
    Preco NUMBER(5, 2),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE Avaliacoes (
    UsuarioID NUMBER(5),
    LivroID NUMBER(5),
    Avaliacao NUMBER(2, 1),
    Comentario VARCHAR2(300),
    DataAvaliacao DATE,
    PRIMARY KEY (UsuarioID, LivroID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (LivroID) REFERENCES Livros(LivroID)
);

CREATE TABLE Favoritos (
    UsuarioID NUMBER(5),
    LivroID NUMBER(5),
    DataFavorito DATE,
    PRIMARY KEY (UsuarioID, LivroID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (LivroID) REFERENCES Livros(LivroID)
);

CREATE TABLE Tags (
    TagID NUMBER(5) PRIMARY KEY,
    Nome VARCHAR2(60)
);

CREATE TABLE LivrosTags (
    LivroID NUMBER(5),
    TagID NUMBER(5),
    PRIMARY KEY (LivroID, TagID),
    FOREIGN KEY (LivroID) REFERENCES Livros(LivroID),
    FOREIGN KEY (TagID) REFERENCES Tags(TagID)
);

CREATE TABLE BibliotecaUsuarios (
    UsuarioID NUMBER(5),
    LivroID NUMBER(5),
    DataAdicionado DATE,
    CodPDF VARCHAR2(14),
    PRIMARY KEY (UsuarioID, LivroID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (LivroID) REFERENCES Livros(LivroID)
);

CREATE TABLE LivroAutor (
    LivroID NUMBER(5),
    AutorID NUMBER(5),
    PRIMARY KEY (AutorID, LivroID),
    FOREIGN KEY (AutorID) REFERENCES Autores(AutorID),
    FOREIGN KEY (LivroID) REFERENCES Livros(LivroID)
);

CREATE TABLE LivroCompras (
    CompraID NUMBER(5),
    LivroID NUMBER(5),
    PRIMARY KEY (CompraID, LivroID),
    FOREIGN KEY (CompraID) REFERENCES Compras(CompraID),
    FOREIGN KEY (LivroID) REFERENCES Livros(LivroID)
);

CREATE SEQUENCE seq_autor start with 1 increment by 1 nocycle;

CREATE SEQUENCE seq_categoria start with 1 increment by 1 nocycle;

CREATE SEQUENCE seq_usuario start with 1 increment by 1 nocycle;

CREATE SEQUENCE seq_editora start with 1 increment by 1 nocycle;

CREATE SEQUENCE seq_livro start with 1 increment by 1 nocycle;

CREATE SEQUENCE seq_compra start with 1 increment by 1 nocycle;

CREATE SEQUENCE seq_tag start with 1 increment by 1 nocycle;

CREATE VIEW v_AvaliacoesLivros AS
SELECT l.Titulo, a.Nome AS Autor, av.Avaliacao, av.Comentario
FROM Livros l
INNER JOIN LivroAutor la ON l.LivroID = la.LivroID
INNER JOIN Autores a ON la.AutorID = a.AutorID
LEFT JOIN Avaliacoes av ON l.LivroID = av.LivroID;

CREATE VIEW v_ComprasUsuarios AS
SELECT u.Nome AS Usuario, l.Titulo, c.DataCompra, c.Preco
FROM Compras c
INNER JOIN Usuarios u ON c.UsuarioID = u.UsuarioID
INNER JOIN LivroCompras lc ON c.CompraID = lc.CompraID
INNER JOIN Livros l ON lc.LivroID = l.LivroID;

CREATE VIEW v_LivrosCategoriasTags AS
SELECT l.Titulo, c.Nome AS Categoria, t.Nome AS Tag
FROM Livros l
LEFT JOIN Categorias c ON l.CategoriaID = c.CategoriaID
LEFT JOIN LivrosTags lt ON l.LivroID = lt.LivroID
LEFT JOIN Tags t ON lt.TagID = t.TagID;

CREATE MATERIALIZED VIEW MV_NumLivrosPorAutor
REFRESH ON DEMAND
AS
SELECT a.AutorID, a.Nome AS NomeAutor,COUNT(l.LivroID) AS NumLivros
FROM Autores a
LEFT JOIN LivroAutor la ON a.AutorID = la.AutorID
LEFT JOIN Livros l ON la.LivroID = l.LivroID
GROUP BY a.AutorID, a.Nome;



INSERT INTO Autores (AutorID, Nome, Biografia) VALUES (seq_autor.nextval, 'Alice Green', 'Autora de romances de fantasia.');
INSERT INTO Autores (AutorID, Nome, Biografia) VALUES (seq_autor.nextval, 'Benjamin Clark', 'Especialista em ficção científica.');
INSERT INTO Autores (AutorID, Nome, Biografia) VALUES (seq_autor.nextval, 'Carolina Silva', 'Escritora de mistérios intrigantes.');
INSERT INTO Autores (AutorID, Nome, Biografia) VALUES (seq_autor.nextval, 'Daniel Santos', 'Autor de thrillers psicológicos.');
INSERT INTO Autores (AutorID, Nome, Biografia) VALUES (seq_autor.nextval, 'Eva White', 'Conhecida por seus romances históricos.');
INSERT INTO Autores (AutorID, Nome, Biografia) VALUES (seq_autor.nextval, 'Fernando Costa', 'Escritor de literatura clássica.');



INSERT INTO Categorias (CategoriaID, Nome) VALUES (seq_categoria.nextval, 'Fantasia');
INSERT INTO Categorias (CategoriaID, Nome) VALUES (seq_categoria.nextval, 'Ficção Científica');
INSERT INTO Categorias (CategoriaID, Nome) VALUES (seq_categoria.nextval, 'Mistério');
INSERT INTO Categorias (CategoriaID, Nome) VALUES (seq_categoria.nextval, 'Thriller');
INSERT INTO Categorias (CategoriaID, Nome) VALUES (seq_categoria.nextval, 'Romance');
INSERT INTO Categorias (CategoriaID, Nome) VALUES (seq_categoria.nextval, 'Clássico');



INSERT INTO Editoras (EditoraID, Nome, Endereco) VALUES (seq_editora.nextval, 'Editora Nova', 'Rua da Amizade, 123');
INSERT INTO Editoras (EditoraID, Nome, Endereco) VALUES (seq_editora.nextval, 'Editora Criativa', 'Avenida da Liberdade, 456');
INSERT INTO Editoras (EditoraID, Nome, Endereco) VALUES (seq_editora.nextval, 'Editora Imaginação', 'Praça das Flores, 789');
INSERT INTO Editoras (EditoraID, Nome, Endereco) VALUES (seq_editora.nextval, 'Editora Páginas', 'Alameda dos Sonhos, 1011');
INSERT INTO Editoras (EditoraID, Nome, Endereco) VALUES (seq_editora.nextval, 'Editora Universal', 'Travessa da Esperança, 1213');
INSERT INTO Editoras (EditoraID, Nome, Endereco) VALUES (seq_editora.nextval, 'Editora Expressão', 'Rua do Sol, 1415');


INSERT INTO Livros (LivroID, Titulo, CategoriaID, EditoraID, AnoPublicacao) VALUES (seq_livro.nextval, 'Aventuras de Alphar', 1, 1, 2005);
INSERT INTO Livros (LivroID, Titulo, CategoriaID, EditoraID, AnoPublicacao) VALUES (seq_livro.nextval, 'O Espaço Inexplorado', 2, 2, 2010);
INSERT INTO Livros (LivroID, Titulo, CategoriaID, EditoraID, AnoPublicacao) VALUES (seq_livro.nextval, 'O Mistério do Lago', 3, 3, 2015);
INSERT INTO Livros (LivroID, Titulo, CategoriaID, EditoraID, AnoPublicacao) VALUES (seq_livro.nextval, 'No Escuro da Noite', 4, 4, 2020);
INSERT INTO Livros (LivroID, Titulo, CategoriaID, EditoraID, AnoPublicacao) VALUES (seq_livro.nextval, 'Uma História de Amor', 5, 5, 2012);
INSERT INTO Livros (LivroID, Titulo, CategoriaID, EditoraID, AnoPublicacao) VALUES (seq_livro.nextval, 'Orgulho e Preconceito', 6, 6, 1813);


INSERT INTO Usuarios (UsuarioID, Nome, Email, Senha) VALUES (seq_usuario.nextval, 'Ana Oliveira', 'ana.oliveira@email.com', 'senha123@');
INSERT INTO Usuarios (UsuarioID, Nome, Email, Senha) VALUES (seq_usuario.nextval, 'Bruno Santos', 'bruno.santos@email.com', 'senha456@');
INSERT INTO Usuarios (UsuarioID, Nome, Email, Senha) VALUES (seq_usuario.nextval, 'Clara Lima', 'clara.lima@email.com', 'senha789@');
INSERT INTO Usuarios (UsuarioID, Nome, Email, Senha) VALUES (seq_usuario.nextval, 'Diego Pereira', 'diego.pereira@email.com', 'senha101@');
INSERT INTO Usuarios (UsuarioID, Nome, Email, Senha) VALUES (seq_usuario.nextval, 'Erika Silva', 'erika.silva@email.com', 'senha112@');
INSERT INTO Usuarios (UsuarioID, Nome, Email, Senha) VALUES (seq_usuario.nextval, 'Fernando Almeida', 'fernando.almeida@email.com', 'senha456@');


INSERT INTO Compras (CompraID, UsuarioID, DataCompra, Preco) VALUES (seq_compra.nextval, 1, TO_DATE('2024-04-04', 'YYYY-MM-DD'), 25.99);
INSERT INTO Compras (CompraID, UsuarioID, DataCompra, Preco) VALUES (seq_compra.nextval, 2, TO_DATE('2024-04-03', 'YYYY-MM-DD'), 15.50);
INSERT INTO Compras (CompraID, UsuarioID, DataCompra, Preco) VALUES (seq_compra.nextval, 3, TO_DATE('2024-04-02', 'YYYY-MM-DD'), 30.00);
INSERT INTO Compras (CompraID, UsuarioID, DataCompra, Preco) VALUES (seq_compra.nextval, 4, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 20.75);
INSERT INTO Compras (CompraID, UsuarioID, DataCompra, Preco) VALUES (seq_compra.nextval, 5, TO_DATE('2024-03-31', 'YYYY-MM-DD'), 12.99);
INSERT INTO Compras (CompraID, UsuarioID, DataCompra, Preco) VALUES (seq_compra.nextval, 6, TO_DATE('2024-03-30', 'YYYY-MM-DD'), 18.50);


INSERT INTO Avaliacoes (UsuarioID, LivroID, Avaliacao, Comentario, DataAvaliacao) VALUES (1, 1, 4.5, 'Ótimo livro, recomendo!', TO_DATE('2024-04-01', 'YYYY-MM-DD'));
INSERT INTO Avaliacoes (UsuarioID, LivroID, Avaliacao, Comentario, DataAvaliacao) VALUES (2, 2, 5.0, 'Um clássico que todos deveriam ler.', TO_DATE('2024-04-02', 'YYYY-MM-DD'));
INSERT INTO Avaliacoes (UsuarioID, LivroID, Avaliacao, Comentario, DataAvaliacao) VALUES (3, 3, 4.0, 'Surpreendente final!', TO_DATE('2024-04-03', 'YYYY-MM-DD'));
INSERT INTO Avaliacoes (UsuarioID, LivroID, Avaliacao, Comentario, DataAvaliacao) VALUES (4, 4, 4.0, 'Arrepiante!', TO_DATE('2024-04-04', 'YYYY-MM-DD'));
INSERT INTO Avaliacoes (UsuarioID, LivroID, Avaliacao, Comentario, DataAvaliacao) VALUES (5, 5, 5.0, 'Adoro os personagens!', TO_DATE('2024-04-05', 'YYYY-MM-DD'));
INSERT INTO Avaliacoes (UsuarioID, LivroID, Avaliacao, Comentario, DataAvaliacao) VALUES (6, 6, 4.0, 'Clássico da literatura!', TO_DATE('2024-04-06', 'YYYY-MM-DD'));


INSERT INTO Favoritos (UsuarioID, LivroID, DataFavorito) VALUES (1, 1, TO_DATE('2024-04-04', 'YYYY-MM-DD'));
INSERT INTO Favoritos (UsuarioID, LivroID, DataFavorito) VALUES (2, 2, TO_DATE('2024-04-03', 'YYYY-MM-DD'));
INSERT INTO Favoritos (UsuarioID, LivroID, DataFavorito) VALUES (3, 3, TO_DATE('2024-04-02', 'YYYY-MM-DD'));
INSERT INTO Favoritos (UsuarioID, LivroID, DataFavorito) VALUES (4, 4, TO_DATE('2024-04-01', 'YYYY-MM-DD'));
INSERT INTO Favoritos (UsuarioID, LivroID, DataFavorito) VALUES (5, 5, TO_DATE('2024-03-31', 'YYYY-MM-DD'));
INSERT INTO Favoritos (UsuarioID, LivroID, DataFavorito) VALUES (6, 6, TO_DATE('2024-03-30', 'YYYY-MM-DD'));


INSERT INTO Tags (TagID, Nome) VALUES (seq_tag.nextval, 'Magia');
INSERT INTO Tags (TagID, Nome) VALUES (seq_tag.nextval, 'Viagem Espacial');
INSERT INTO Tags (TagID, Nome) VALUES (seq_tag.nextval, 'Investigação');
INSERT INTO Tags (TagID, Nome) VALUES (seq_tag.nextval, 'Suspense');
INSERT INTO Tags (TagID, Nome) VALUES (seq_tag.nextval, 'Amor');
INSERT INTO Tags (TagID, Nome) VALUES (seq_tag.nextval, 'Literatura Inglesa');


INSERT INTO LivrosTags (LivroID, TagID) VALUES (1, 1);
INSERT INTO LivrosTags (LivroID, TagID) VALUES (2, 2);
INSERT INTO LivrosTags (LivroID, TagID) VALUES (3, 3);
INSERT INTO LivrosTags (LivroID, TagID) VALUES (4, 4);
INSERT INTO LivrosTags (LivroID, TagID) VALUES (5, 5);
INSERT INTO LivrosTags (LivroID, TagID) VALUES (6, 6);


INSERT INTO BibliotecaUsuarios (UsuarioID, LivroID, DataAdicionado,CodPDF) VALUES (1, 1, TO_DATE('2024-04-04', 'YYYY-MM-DD'),'COD0014462');
INSERT INTO BibliotecaUsuarios (UsuarioID, LivroID, DataAdicionado,CodPDF) VALUES (2, 2, TO_DATE('2024-04-03', 'YYYY-MM-DD'),'COD0011963');
INSERT INTO BibliotecaUsuarios (UsuarioID, LivroID, DataAdicionado,CodPDF) VALUES (3, 3, TO_DATE('2024-04-02', 'YYYY-MM-DD'),'COD0019764');
INSERT INTO BibliotecaUsuarios (UsuarioID, LivroID, DataAdicionado,CodPDF) VALUES (4, 4, TO_DATE('2024-04-01', 'YYYY-MM-DD'),'COD0019365');
INSERT INTO BibliotecaUsuarios (UsuarioID, LivroID, DataAdicionado,CodPDF) VALUES (5, 5, TO_DATE('2024-03-31', 'YYYY-MM-DD'),'COD0021466');
INSERT INTO BibliotecaUsuarios (UsuarioID, LivroID, DataAdicionado,CodPDF) VALUES (6, 6, TO_DATE('2024-03-30', 'YYYY-MM-DD'),'COD0017267');


INSERT INTO LivroAutor (LivroID, AutorID) VALUES (1, 1);
INSERT INTO LivroAutor (LivroID, AutorID) VALUES (2, 2);
INSERT INTO LivroAutor (LivroID, AutorID) VALUES (3, 3);
INSERT INTO LivroAutor (LivroID, AutorID) VALUES (4, 4);
INSERT INTO LivroAutor (LivroID, AutorID) VALUES (5, 5);
INSERT INTO LivroAutor (LivroID, AutorID) VALUES (6, 6);


INSERT INTO LivroCompras (CompraID, LivroID) VALUES (1, 1);
INSERT INTO LivroCompras (CompraID, LivroID) VALUES (2, 2);
INSERT INTO LivroCompras (CompraID, LivroID) VALUES (3, 3);
INSERT INTO LivroCompras (CompraID, LivroID) VALUES (4, 4);
INSERT INTO LivroCompras (CompraID, LivroID) VALUES (5, 5);
INSERT INTO LivroCompras (CompraID, LivroID) VALUES (6, 6);

SELECT l.Titulo, a.Nome AS Autor
FROM Livros l
INNER JOIN LivroAutor la ON l.LivroID = la.LivroID
JOIN Autores a ON la.AutorID = a.AutorID;

SELECT e.Nome, COUNT(l.LivroID) AS TotalLivros
FROM Editoras e
LEFT JOIN Livros l ON e.EditoraID = l.EditoraID
GROUP BY e.Nome;

SELECT l.Titulo, AVG(a.Avaliacao) AS Media  FROM Avaliacoes a
INNER JOIN Livros l ON l.livroID = a.LivroID
GROUP BY l.Titulo;

SELECT u.Nome, c.DataCompra
FROM Usuarios u
JOIN Compras c ON u.UsuarioID = c.UsuarioID
WHERE c.dataCompra > TO_DATE('2024-04-01', 'YYYY-MM-DD');

SELECT AutorID, CONCAT(SUBSTR(Nome, 1, 1), '.') || SUBSTR(Nome, INSTR(Nome, ' ') + 1) AS Nome_Formatado
FROM Autores;

SELECT LivroID, Titulo
FROM Livros
WHERE LivroID IN (
    SELECT LivroID FROM Avaliacoes WHERE Avaliacao > 4
);

SELECT u.Nome AS Nome_Usuario, l.Titulo, ct.Nome AS Nome_Categoria, e.Nome AS Nome_Editora
FROM Usuarios u
INNER JOIN Compras c ON u.UsuarioID = c.UsuarioID
INNER JOIN LivroCompras lc ON c.CompraID = lc.CompraID
INNER JOIN Livros l ON lc.LivroID = l.LivroID
INNER JOIN Categorias ct ON l.CategoriaID = ct.CategoriaID
INNER JOIN Editoras e ON l.EditoraID = e.EditoraID;

SELECT Titulo FROM Livros
WHERE LivroID IN (
    SELECT LivroID FROM LivrosTags 
    WHERE TagID = (
        SELECT TagID
        FROM Tags
        WHERE Nome = 'Viagem Espacial'
    )
);

EXECUTE dbms_mview.refresh('MV_NumLivrosPorAutor');
commit;




