DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE austral;

CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60) NULL,
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL
);

CREATE TABLE colecciones (
    id_coleccion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL
);

CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    id_coleccion INT NULL,
    titulo VARCHAR(120) NOT NULL,
    paginas INT NOT NULL,
    ejemplares_vendidos INT NOT NULL,
    anio INT NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion)
);

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

-- CARGA OFICIAL
INSERT INTO autores (nombre, pais, genero) VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');

INSERT INTO libros
(id_autor, titulo, paginas, ejemplares_vendidos, anio) VALUES
(1, 'Cielo de Enero', 210, 1500, 2024),
(1, 'Marea Baja', 185, 800, 2023),
(1, 'El Norte', 200, 2200, 2024),
(2, 'Estrellas que Caen', 240, 3000, 2022),
(2, 'Máquinas', 215, 450, 2024),
(3, 'Luz Artificial', 300, 1200, 2024),
(3, 'Ruido Blanco', 280, 600, 2023),
(4, 'El Barrio de Lila', 190, 5000, 2024),
(4, 'Antes del Amanecer', 205, 2700, 2024),
(4, 'La Calle 8', 175, 900, 2023),
(5, 'Flor de Hierro', 195, 4100, 2024),
(5, 'Hora Dorada', 220, 1800, 2022);

-- CONSULTA 1
SELECT nombre, genero
FROM autores
WHERE pais <> 'Chile' OR pais IS NULL
ORDER BY nombre;

-- CONSULTA 2
SELECT titulo, paginas
FROM libros
WHERE paginas BETWEEN 190 AND 220
ORDER BY paginas;

-- CONSULTA 3
SELECT COUNT(*) AS cantidad_libros,
       SUM(ejemplares_vendidos) AS total_vendidos,
       AVG(paginas) AS promedio_paginas,
       MIN(anio) AS anio_mas_antiguo,
       MAX(ejemplares_vendidos) AS mayor_venta
FROM libros;

-- CONSULTA 4
SELECT DISTINCT genero
FROM autores
ORDER BY CAST(genero AS CHAR);

-- CONSULTA 5
SELECT a.nombre, COUNT(*) AS libros_2024
FROM autores AS a
JOIN libros AS l ON l.id_autor = a.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre;

-- CONSULTA 6
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE anio = 2024 AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;

-- CONSULTA 7
-- Permite los filtros por titulo exigidos en 7 y 8 en Workbench.
SET @modo_seguro_anterior = @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;

INSERT INTO libros
(id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES (3, 'Papel Mojado', 260, 50, 2024);

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

DELETE FROM libros WHERE titulo = 'Papel Mojado';

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

-- CONSULTA 8
SELECT titulo, ejemplares_vendidos
FROM libros WHERE titulo = 'Cielo de Enero';

UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE titulo = 'Cielo de Enero';

SELECT titulo, ejemplares_vendidos
FROM libros WHERE titulo = 'Cielo de Enero';

SET SQL_SAFE_UPDATES = @modo_seguro_anterior;

-- CONSULTA 9
INSERT INTO colecciones (titulo, fecha_publicacion) VALUES
('Voces y horizontes', '2024-03-15'),
('Historias para imaginar', '2024-08-01');

UPDATE libros SET id_coleccion = 1
WHERE id_libro IN (1, 2, 3, 4, 5, 6, 7);
UPDATE libros SET id_coleccion = 2
WHERE id_libro IN (8, 9, 10, 11, 12);

SELECT l.titulo AS libro, c.titulo AS coleccion,
       c.fecha_publicacion
FROM libros AS l
JOIN colecciones AS c ON c.id_coleccion = l.id_coleccion
ORDER BY l.titulo;

-- CONSULTA 10
INSERT INTO pagos (id_autor, fecha_pago, monto) VALUES
(1, '2024-09-01', 150000.00),
(1, '2024-10-01', 75000.50),
(2, '2024-10-05', 120000.00),
(3, '2024-10-10', 90000.00),
(4, '2024-10-15', 200000.00),
(5, '2024-10-20', 180000.00),
(6, '2024-10-25', 25000.00);

SELECT a.nombre, p.fecha_pago, p.monto
FROM pagos AS p
JOIN autores AS a ON a.id_autor = p.id_autor
ORDER BY a.nombre, p.fecha_pago, p.id_pago;

SELECT a.nombre, SUM(p.monto) AS total_pagado
FROM autores AS a
JOIN pagos AS p ON p.id_autor = a.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY a.nombre;
