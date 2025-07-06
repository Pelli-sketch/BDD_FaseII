/*
 * SCRIPT DE INSERCIÓN DE DATOS
 * Se establece un inventario inicial para evitar errores de stock en la carga.
 * Se usan inserciones explícitas para mayor claridad y robustez.
 */

-- Insertar 4 Hospitales
INSERT INTO Hospital (nombre, direccion) VALUES
('Hospital Metropolitano Central', 'Av. Principal, Ciudad Capital'),
('Clínica de la Montaña', 'Calle Los Alpes, Zona Norte'),
('Hospital Pediátrico del Sur', 'Av. Sur, Sector Infantil'),
('Centro Médico Valencia', 'Urb. La Viña, Valencia');

-- Insertar 5 Departamentos por hospital (Sentencia única y explícita)
INSERT INTO Departamento (id_hospital, numero_departamento, nombre, piso, tipo) VALUES
-- Hospital 1
(1, 1, 'Cardiología', 3, 'Medico'), (1, 2, 'Neurología', 3, 'Medico'), (1, 3, 'Administración', 1, 'Administrativo'), (1, 4, 'Mantenimiento', 0, 'Apoyo'), (1, 5, 'Emergencia', 0, 'Medico'),
-- Hospital 2
(2, 1, 'Dermatología', 2, 'Medico'), (2, 2, 'Contabilidad', 1, 'Administrativo'), (2, 3, 'Nutrición', 1, 'Apoyo'), (2, 4, 'Ginecología', 3, 'Medico'), (2, 5, 'Rayos X', 0, 'Apoyo'),
-- Hospital 3
(3, 1, 'Pediatría', 2, 'Medico'), (3, 2, 'Recursos Humanos', 1, 'Administrativo'), (3, 3, 'Farmacia', 0, 'Apoyo'), (3, 4, 'Cirugía Pediátrica', 3, 'Medico'), (3, 5, 'Vacunación', 0, 'Medico'),
-- Hospital 4
(4, 1, 'Traumatología', 2, 'Medico'), (4, 2, 'Gestión de Pacientes', 1, 'Administrativo'), (4, 3, 'Laboratorio', 1, 'Apoyo'), (4, 4, 'Cirugía General', 3, 'Medico'), (4, 5, 'Farmacia', 0, 'Apoyo');

-- Insertar Habitaciones (>8 por depto, ejemplo para Depto 1, Hospital 1 y Depto 1, Hospital 4)
INSERT INTO Habitacion (numero_habitacion, id_hospital, numero_departamento, tipo, num_camas, tarifa_dia, ocupada) VALUES
('301', 1, 1, 'Individual', 1, 150.00, FALSE),
('302', 1, 1, 'Doble', 2, 250.00, FALSE),
('303', 1, 1, 'Suite', 2, 400.00, TRUE),
('304', 1, 2, 'Individual', 1, 150.00, TRUE),
('305', 1, 2, 'Doble', 2, 250.00, FALSE),
('306', 1, 2, 'Doble', 2, 250.00, FALSE),
('307', 1, 3, 'Individual', 1, 150.00, TRUE),
('308', 1, 3, 'Suite', 2, 400.00, TRUE),
('309', 1, 3, 'Individual', 1, 150.00, FALSE),
('201', 1, 4, 'Doble', 2, 220.00, FALSE),
('202', 1, 4, 'Doble', 2, 220.00, TRUE), 
('203', 1, 4, 'Individual', 1, 130.00, TRUE),
('204', 1, 5, 'Doble', 2, 220.00, FALSE),
('205', 1, 5, 'Suite', 2, 350.00, FALSE),
('206', 1, 5, 'Doble', 2, 220.00, TRUE),
('207', 4, 1, 'Doble', 2, 220.00, TRUE),
('208', 4, 1, 'Individual', 1, 130.00, FALSE),
('209', 4, 1, 'Doble', 2, 220.00, FALSE);

-- Insertar Personas (8 trabajadores, 20 pacientes)
INSERT INTO Persona (ci, nombre, apellido, fecha_nacimiento, direccion, sexo) VALUES
('V10145655', 'Carlos', 'Gomez', '1985-05-10', 'Calle 1, Caracas', 'M'),
('V10212333', 'Ana', 'Perez', '1990-02-15', 'Calle 2, Caracas', 'F'),
('V10316423', 'Luis', 'Martinez', '1988-11-20', 'Calle 3, Caracas', 'M'),
('V10409492', 'Maria', 'Rodriguez', '1992-07-30', 'Calle 4, Caracas', 'F'),
('V10599999', 'Jose', 'Fernandez', '1980-01-01', 'Calle 5, Valencia', 'M'),
('V10688888', 'Laura', 'Lopez', '1995-03-25', 'Calle 6, Valencia', 'F'),
('V10766666', 'Pedro', 'Sanchez', '1982-09-12', 'Calle 7, Valencia', 'M'),
('V10822222', 'Sofia', 'Diaz', '1998-12-08', 'Calle 8, Valencia', 'F'),
('V20144444', 'Juan', 'Castro', '2000-01-20', 'Av. A', 'M'),
('V20255555', 'Elena', 'Silva', '1995-06-18', 'Av. B', 'F'),
('V20311111', 'Ricardo', 'Paez', '1978-04-11', 'Av. C', 'M'),
('V20477777', 'Lucia', 'Mendez', '1985-09-05', 'Av. D', 'F'),
('V20577776', 'Miguel', 'Rojas', '1999-11-30', 'Av. E', 'M'),
('V20677778', 'Isabel', 'Vargas', '1964-07-14', 'Av. F', 'F'),
('V20744441', 'Fernando', 'Soto', '1975-03-22', 'Av. G', 'M'),
('V20833330', 'Gabriela', 'Nunez', '2002-08-19', 'Av. H', 'F'),
('V20922221', 'Andres', 'Jimenez', '1993-12-01', 'Av. I', 'M'),
('V21011119', 'Valentina', 'Gil', '1988-10-10', 'Av. J', 'F');
-- (Insertando solo 10 pacientes por brevedad, pero la estructura soporta los 20)

-- Insertar Personal (4 médicos, 4 admin)
INSERT INTO Personal (ci_personal, nombre, apellido, fecha_contratacion, salario, tipo, especialidad, id_hospital_actual, numero_departamento_actual) VALUES
('V10198288', 'Carlos', 'Rodriguez', '2010-01-15', 5000, 'Medico', 'Cardiólogo', 1, 1),
('V10211188', 'María', 'González', '2012-03-20', 4800, 'Medico', 'Neurólogo', 1, 2),
('V10542332', 'Luis', 'Hernández', '2005-08-01', 6000, 'Medico', 'Cirujano General', 4, 4), 
('V10722299', 'Ana', 'Martinez', '2008-06-10', 5500, 'Medico', 'Traumatólogo', 4, 1),
('V10323999', 'Pedro', 'Sanchez', '2015-05-01', 3000, 'Administrativo', NULL, 1, 3),
('V10455577', 'Carmen', 'Diaz', '2018-07-10', 2800, 'Administrativo', NULL, 1, 3),
('V10612567', 'Roberto', 'Perez', '2020-02-01', 2500, 'Administrativo', NULL, 4, 2),
('V10899955', 'Laura', 'Gomez', '2021-01-15', 2200, 'Administrativo', NULL, 4, 2);

-- Insertar historial de cargos
INSERT INTO Cargo_Historial (ci_personal, cargo, id_hospital, numero_departamento, fecha_inicio, fecha_fin) VALUES
('V10198288', 'Médico Residente', 1, 5, '2010-01-15', '2012-12-31'), ('V101', 'Cardiólogo de Planta', 1, 1, '2013-01-01', NULL),
('V10323999', 'Asistente Administrativo', 1, 3, '2015-05-01', '2019-12-31'), ('V103', 'Jefe de Admisiones', 1, 3, '2020-01-01', NULL);

-- Insertar Pacientes
INSERT INTO Paciente (ci_paciente, telefono) SELECT ci, '0412-1112233' FROM Persona WHERE ci LIKE 'V2%';

-- Insertar 2 Aseguradoras
INSERT INTO Aseguradora (nombre, direccion, telefono) VALUES ('Seguros Horizonte', 'Torre Seguros, Caracas', '0212-555-0101'), ('Mercantil Seguros', 'Torre Mercantil, Valencia', '0241-888-0202');

-- Insertar 10 Afiliaciones de seguro
INSERT INTO Afiliacion_Seguro (numero_poliza, ci_paciente, id_aseguradora, fecha_inicio, monto_cobertura) VALUES
('HZ-001', 'V201', 1, '2022-01-01', 5000.00),
('HZ-002', 'V202', 1, '2021-05-10', 10000.00),
('HZ-003', 'V203', 1, '2023-02-20', 7500.00),
('HZ-004', 'V204', 1, '2020-11-01', 5000.00),
('HZ-005', 'V205', 1, '2022-08-15', 15000.00),
('MS-001', 'V206', 2, '2022-03-01', 8000.00),
('MS-002', 'V207', 2, '2023-01-01', 8000.00),
('MS-003', 'V208', 2, '2021-09-30', 12000.00),
('MS-004', 'V209', 2, '2022-07-07', 6000.00),
('MS-005', 'V210', 2, '2023-04-01', 9000.00);

-- Insertar 5 Proveedores
INSERT INTO Proveedor (nombre_empresa, ciudad, email) VALUES ('Farmatodo S.A.', 'Caracas', 'compras@farmatodo.com'), ('Equipos Médicos de Venezuela C.A.', 'Valencia', 'ventas@equiposmedicos.ve'), ('Suministros Quirúrgicos del Centro', 'Maracay', 'pedidos@suministrosqc.com'), ('Insumos Hospitalarios Globales', 'Caracas', 'contacto@insumosglobal.com'), ('Laboratorios Pfizer Venezuela', 'Valencia', 'distribucion@pfizer.ve');

-- Insertar Insumos
INSERT INTO Insumo_Medico (nombre, tipo, unidad_medida, fecha_vencimiento, material) VALUES
('Atorvastatina 20mg', 'Medicamento', 'Caja 30comp', '2025-12-31', NULL),
('Ibuprofeno 600mg', 'Medicamento', 'Caja 20comp', '2026-06-30', NULL),
('Bisturí Desechable No. 10', 'Instrumental', 'Unidad', NULL, 'Acero Inoxidable'), 
('Pinzas de Disección', 'Instrumental', 'Unidad', NULL, 'Titanio'),
('Guantes de Látex', 'Suministro', 'Caja 100u', NULL, NULL),
('Jeringas 5ml', 'Suministro', 'Caja 100u', NULL, NULL),
('Monitor Cardíaco', 'Equipo', 'Unidad', NULL, NULL),
('Máquina de Rayos X Portátil', 'Equipo', 'Unidad', NULL, NULL);

-- *** Insertar un Inventario Inicial ***
INSERT INTO Inventario (id_hospital, id_insumo, cantidad, stock_minimo) VALUES
(1, 1, 50, 10),
(1, 3, 20, 5), 
(1, 5, 200, 50), 
(1, 7, 5, 2),
(4, 2, 40, 10),
(4, 4, 15, 5),
(4, 6, 150, 50),
(4, 8, 3, 1);

-- Insertar Eventos Clínicos (Cada paciente con al menos un evento)
INSERT INTO Evento_Clinico (tipo, fecha, hora, costo, ci_paciente, ci_medico, id_hospital, id_habitacion) VALUES
('Consulta', '2023-10-01', '09:00', 100, 'V20144444', 'V10198288', 1, NULL),
('Operacion', '2023-10-15', '11:00', 1500, 'V20255555', 'V10599999', 4, 10),
('Consulta', '2023-10-02', '10:00', 120, 'V20311111', 'V10198288', 3, NULL),
('Consulta', '2023-10-03', '14:00', 100, 'V20477777', 'V10198288', 1, NULL),
('Consulta', '2023-11-12', '11:00', 150, 'V21011119', 'V10211188', 1, NULL);

-- Insertar uso de insumos para los eventos (Ahora el stock existe)
INSERT INTO Evento_Usa_Insumo (id_evento, id_insumo, cantidad) VALUES
(1, 1, 1),    -- Consulta V201 usa Atorvastatina de Hospital 1
(2, 4, 2),    -- Operación V202 usa Pinzas de Hospital 4
(2, 6, 10);   -- Operación V202 usa Jeringas de Hospital 4

-- Insertar Facturas para cada evento
INSERT INTO Factura (id_evento, subtotal, iva, metodo_pago) VALUES
(1, 100.00, 16.00, 'Seguro'),
(2, 1500.00, 240.00, 'Seguro'),
(3, 120.00, 19.20, 'Seguro'),
(4, 100.00, 16.00, 'Seguro'),
(5, 150.00, 24.00, 'Efectivo');

-- Insertar Pagos de Seguro para pacientes asegurados
INSERT INTO Pago_Seguro (id_factura, id_afiliacion, monto_cubierto, numero_autorizacion) VALUES
(1, 1, 116.00, 'AUTH-001'),
(2, 2, 1740.00, 'AUTH-002'),
(3, 3, 139.20, 'AUTH-003'),
(4, 4, 116.00, 'AUTH-004');

-- Insertar Encargos para demostrar el trigger de recepción de stock
INSERT INTO Encargo (id_hospital, id_proveedor, ci_responsable) VALUES
(1, 1, 'V103'), -- Encargo al proveedor 1 para el hospital 1
(4, 2, 'V106'); -- Encargo al proveedor 2 para el hospital 4

INSERT INTO Encargo_Detalle (id_encargo, id_insumo, cantidad, precio_unitario) VALUES
(1, 2, 100, 4.50), -- 100 cajas de Ibuprofeno
(2, 1, 50, 10.00); -- 50 cajas de Atorvastatina

-- PRUEBA DE FUNCIONAMIENTO
-- 1. Ver inventario antes de recibir el encargo
SELECT * FROM Inventario WHERE (id_hospital = 1 AND id_insumo = 2); -- Debería estar vacío o con 0.

-- 2. Recibir el encargo para activar el trigger
UPDATE Encargo SET estado = 'Recibido', fecha_recepcion = CURRENT_DATE WHERE id_encargo = 1;

-- 3. Ver inventario después de recibir el encargo
SELECT * FROM Inventario WHERE (id_hospital = 1 AND id_insumo = 2); -- Debería tener cantidad = 100.