/* PROYECTO: ALKE WALLET - BASE DE DATOS RELACIONAL
   AUTORA: Paula Ossandón Erazo
   GitHub: Cyanide6666
   DESCRIPCIÓN: Implementación de una billetera digital con soporte 
                multimoneda e integridad referencial.
*/

-- =============================================
-- 1. CREACIÓN DE LA ESTRUCTURA (DDL)
-- =============================================

-- Tabla de Monedas: Utilizamos CLP y USD
CREATE TABLE public.moneda (
    currency_id SERIAL PRIMARY KEY,
    currency_name VARCHAR(50) NOT NULL,
    currency_symbol VARCHAR(10) NOT NULL
);

-- Tabla de Usuarios: Almacena perfiles y saldos.
CREATE TABLE public.usuario (
    user_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    saldo DECIMAL(15,2) DEFAULT 0.00
);

-- Tabla de Transacciones: Registro histórico con llave foránea a Usuario y Moneda.
CREATE TABLE public.transaccion (
    transaction_id SERIAL PRIMARY KEY,
    sender_user_id INT REFERENCES public.usuario(user_id),
    receiver_user_id INT REFERENCES public.usuario(user_id),
    importe DECIMAL(15,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    currency_id INT REFERENCES public.moneda(currency_id)
);

-- =============================================
-- 2. CARGA DE DATOS INICIALES (DML)
-- =============================================

-- Insertar monedas base
INSERT INTO public.moneda (currency_name, currency_symbol) 
VALUES ('Peso Chileno', '$'), ('Dólar', 'USD');


-- Insertar usuarios de prueba
INSERT INTO public.usuario (nombre, correo_electronico, contrasena, saldo) 
VALUES 
('Paula', 'progamer67@mail.com', 'pass123', 100000.00),
('Bruno', 'tilin@mail.com', 'ney10', 50000.00);

--Insertar transacción
INSERT INTO Transacción (sender_user_id, receiver_user_id, importe)
VALUES (1, 2, 15000.00);

--Insertar a más usuarios a la base de datos!!
INSERT INTO public.usuario (nombre, correo_electronico, contrasena, saldo)
VALUES
('Messi', 'leo@messi.com', 'bokitashunior', 9999),
('Cristiano Ronaldo', 'cr7@siuu.com', 'siuuu666', 888888),
('Neymar Jr', 'garoto_guapo@cs.com', 'macacovoce', 750000);

--===============================================
-- 3. LÓGICA DE NEGOCIO Y CONSULTAS (DQL)
--===============================================

-- Realizar transacción de un usuario con ID existente a otro usuario
INSERT INTO public.transaccion (sender_user_id, receiver_user_id, importe)
VALUES (1, 8 100.00);


-- Registrar transacciones en distintas divisas
INSERT INTO public.transaccion (sender_user_id, receiver_user_id, importe, currency_id) 
VALUES 
(1, 8, 15000.00, 1), -- Paula a Neymar en CLP
(8, 1, 500.00, 2);   -- Neymar a Paula en USD

-- Consulta para historial detallado con símbolos de moneda
SELECT 
    t.transaction_id AS "ID",
    u_send.nombre AS "Emisor",
    u_rec.nombre AS "Receptor",
    t.importe AS "Monto",
    m.currency_symbol AS "Divisa",
    t.transaction_date AS "Fecha"
FROM public.transaccion t
JOIN public.usuario u_send ON t.sender_user_id = u_send.user_id
JOIN public.usuario u_rec ON t.receiver_user_id = u_rec.user_id
JOIN public.moneda m ON t.currency_id = m.currency_id
ORDER BY t.transaction_date DESC;

-- Borramos todo el desorden porque tenía la cagaita con la moneda
TRUNCATE TABLE public.moneda RESTART IDENTITY CASCADE;

-- Insertamos solo una vez el Peso y el Dólar
INSERT INTO public.moneda (currency_name, currency_symbol) 
VALUES ('Peso Chileno', '$'), ('Dólar', 'USD');

--Consultamos
SELECT * FROM public.moneda;


-- Agregamos la columna de moneda a las transacciones
ALTER TABLE public.transaccion 
ADD COLUMN currency_id INT REFERENCES public.moneda(currency_id);

-- Actualizamos las transacciones viejas para que sean en Pesos (ID 1)
UPDATE public.transaccion SET currency_id = 1;


-- Actualizamos las transacciones viejas para que sean en Pesos (ID 1)
UPDATE public.transaccion SET currency_id = 1;

SELECT 
    t.transaction_id, 
    u.nombre AS emisor, 
    t.importe, 
    m.currency_symbol AS moneda
FROM public.transaccion t
JOIN public.usuario u ON t.sender_user_id = u.user_id
JOIN public.moneda m ON t.currency_id = m.currency_id;

select * from usuario 

-- Enviando 500.00 USD de neymar (ID 8) a paula (ID 1)
INSERT INTO public.transaccion (sender_user_id, receiver_user_id, importe, currency_id) 
VALUES (8, 1, 500.00, 1);
-- Reporte de saldos totales por usuario
SELECT nombre, saldo FROM public.usuario;

-- Cambiamos las transacciones de Neymar Jr a Dólares (ID 2)
UPDATE public.transaccion 
SET currency_id = 2 
WHERE transaction_id IN (7, 8);

--Consulta de historial de todas las transacciones realizadas por todos los usuarios
SELECT 
    u.nombre,
    COUNT(t.transaction_id) AS total_envios,
    SUM(t.importe) AS dinero_total_enviado
FROM public.usuario u
LEFT JOIN public.transaccion t ON u.user_id = t.sender_user_id
GROUP BY u.nombre;


-- Eliminar usuario de base de datos
-- Borramos a Messi wuajaja
DELETE FROM public.usuario
WHERE user_id = 6

-- Para borrar tablas que ya existen para empezar de cero: 
-- DROP TABLE IF EXISTS public.transaccion;
-- DROP TABLE IF EXISTS public.usuario;
-- DROP TABLE IF EXISTS public.moneda;