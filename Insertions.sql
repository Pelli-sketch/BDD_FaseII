-- =====================================================================
-- SCRIPT DE INSERCIÓN
-- =====================================================================

-- SECCIÓN 1: PERSONAS (BASE PARA PACIENTES Y PERSONAL)
INSERT INTO Persona (ci, nombre, apellido, fecha_nacimiento, sexo, estado_per, ciudad_per, calle_per, cod_postal_per) VALUES
-- Personal Original
('V101', 'Carlos', 'Gomez', '1985-05-10', 'M', 'Distrito Capital', 'Caracas', 'Av. Urdaneta', '1010'),
('V102', 'Ana', 'Perez', '1990-02-15', 'F', 'Carabobo', 'Valencia', 'Urb. La Viña', '2001'),
('V103', 'Luis', 'Martinez', '1988-11-20', 'M', 'Distrito Capital', 'Caracas', 'El Paraíso', '1020'),
('V104', 'Laura', 'Lopez', '1995-03-25', 'F', 'Carabobo', 'Valencia', 'Centro', '2001'),
('V105', 'Pedro', 'Rojas', '1982-01-01', 'M', 'Distrito Capital', 'Caracas', 'Av. Libertador', '1050'),
-- Pacientes Originales
('V201', 'Juan', 'Castro', '2000-01-20', 'M', 'Miranda', 'Guatire', 'Urb. Castillejo', '1221'),
('V202', 'Elena', 'Silva', '1995-06-18', 'F', 'Aragua', 'Maracay', 'Av. Las Delicias', '2101'),
('V203', 'Ricardo', 'Paez', '1978-04-11', 'M', 'Distrito Capital', 'Caracas', 'La Candelaria', '1011'),
-- Nuevo Personal
('V106', 'Sofia', 'Mendez', '1989-07-12', 'F', 'Zulia', 'Maracaibo', 'Av. 5 de Julio', '4001'),
('V107', 'Diego', 'Jimenez', '1992-09-30', 'M', 'Distrito Capital', 'Caracas', 'El Hatillo', '1083'),
('V108', 'Valeria', 'Guerrero', '1980-04-05', 'F', 'Lara', 'Barquisimeto', 'Av. Lara', '3001'),
('V109', 'Andres', 'Moreno', '1993-01-15', 'M', 'Carabobo', 'Valencia', 'San Diego', '2006'),
-- Nuevos Pacientes
('V204', 'Maria', 'Fernandez', '1965-03-14', 'F', 'Zulia', 'Maracaibo', 'Sector La Lago', '4002'),
('V205', 'Jorge', 'Salas', '2005-11-02', 'M', 'Miranda', 'Los Teques', 'El Tambor', '1201'),
('V206', 'Camila', 'Rios', '1998-08-21', 'F', 'Distrito Capital', 'Caracas', 'Catia', '1030'),
('V207', 'Mateo', 'Cordero', '1955-12-25', 'M', 'Carabobo', 'Valencia', 'Naguanagua', '2005');

-- SECCIÓN 2: INFRAESTRUCTURA HOSPITALARIA
INSERT INTO Hospital (nombre, estado_hos, ciudad_hos, calle_hos, cod_postal_hos) VALUES 
('Hospital Metropolitano', 'Distrito Capital', 'Caracas', 'Calle Principal de Caurimare', '1060'), 
('Centro Médico Valencia', 'Carabobo', 'Valencia', 'Av. Bolivar Norte', '2001'),
('Clínica La Sagrada Familia', 'Zulia', 'Maracaibo', 'Av. 8 Santa Rita', '4005'),
('Hospital de Clínicas Caracas', 'Distrito Capital', 'Caracas', 'Av. Panteón, San Bernardino', '1011');

INSERT INTO Departamento (id_hospital, nombre, tipo, piso) VALUES
-- Hospital Metropolitano (1)
(1, 'Cardiología', 'medico', 3),
(1, 'Administración', 'administrativo', 1), 
(1, 'Emergencia', 'medico', 0),
(1, 'Gastroenterología', 'medico', 3),
(1, 'Operaciones', 'operativo', -1),
-- Centro Médico Valencia (2)
(2, 'Traumatología', 'medico', 2), 
(2, 'Gestión de Pacientes', 'administrativo', 0),
(2, 'Pediatría', 'medico', 1),
-- Clínica La Sagrada Familia (3)
(3, 'Neurología', 'medico', 4),
(3, 'Admisiones', 'administrativo', 0),
(3, 'Quirófano Central', 'operativo', 2),
-- Hospital de Clínicas Caracas (4)
(4, 'Oncología', 'medico', 5),
(4, 'Recursos Humanos', 'administrativo', 1),
(4, 'Unidad de Cuidados Intensivos', 'medico', 6);

INSERT INTO Habitacion (num_habitacion, id_hospital, id_departamento, num_camas, tarifa, tipo) VALUES
-- Hosp. Metropolitano (1)
(301, 1, 1, 1, 250, 'individual'),
(302, 1, 1, 2, 180, 'compartida'),
(310, 1, 4, 1, 260, 'individual'),
-- Centro Médico Valencia (2)
(201, 2, 6, 1, 200, 'individual'),
(101, 2, 8, 2, 150, 'compartida'),
-- Clínica La Sagrada Familia (3)
(401, 3, 9, 1, 300, 'individual'),
-- Hosp. de Clínicas Caracas (4)
(505, 4, 12, 1, 400, 'individual'),
(601, 4, 14, 1, 800, 'individual');

-- SECCIÓN 3: PERSONAL Y CONTRATACIONES
INSERT INTO Contratado (ci, fecha_contratacion, cargo, salario) VALUES
('V101', '2010-01-15', 'Cardiólogo Jefe', 5000),
('V102', '2012-03-20', 'Traumatólogo', 4800),
('V103', '2015-05-01', 'Jefe de Admisiones', 3000),
('V104', '2020-02-01', 'Recepcionista', 2500),
('V105', '2018-05-05', 'Médico General', 4500),
('V106', '2014-06-10', 'Neurólogo', 5200),
('V107', '2021-08-01', 'Oncólogo Jefe', 6000),
('V108', '2011-02-20', 'Gerente de RRHH', 3500),
('V109', '2022-11-10', 'Pediatra', 4700);

-- Un empleado puede estar asignado a varios departamentos
INSERT INTO Asignado_A (ci_personal, id_departamento) VALUES
('V101', 1), ('V101', 3), -- Dr. Gomez (Cardiólogo) atiende en Cardiología y Emergencia
('V102', 6),
('V103', 2),
('V104', 7),
('V105', 3), -- Dr. Rojas (General) atiende en Emergencia
('V106', 9),
('V107', 12), ('V107', 14), -- Dr. Jimenez (Oncólogo) atiende en Oncología y UCI
('V108', 13),
('V109', 8);

INSERT INTO Personal (ci, annios_serv) VALUES 
('V101', 14), ('V102', 12), ('V103', 9), ('V104', 4), ('V105', 6),
('V106', 10), ('V107', 3), ('V108', 13), ('V109', 2);

INSERT INTO Medico (ci, especialidad) VALUES 
('V101', 'Cardiología'),
('V102', 'Traumatología'),
('V105', 'Medicina Interna'),
('V106', 'Neurología'),
('V107', 'Oncología'),
('V109', 'Pediatría');

INSERT INTO Administrativo (ci) VALUES
('V103'), ('V104'), ('V108');

-- SECCIÓN 4: PACIENTES Y SEGUROS
INSERT INTO Paciente (ci, edad, requiere_resp, telefono, contacto_emerg) VALUES
('V201', 24, FALSE, '0412-1112233', 'Maria Castro'),
('V202', 29, FALSE, '0414-2223344', 'Carlos Silva'), 
('V203', 46, FALSE, '0416-3334455', 'Ana Paez'),
('V204', 59, FALSE, '0412-4445566', 'Luis Fernandez'),
('V205', 18, FALSE, '0424-5556677', 'Laura Salas'),
('V206', 26, TRUE, '0414-6667788', 'Pedro Rios'), -- Requiere respirador
('V207', 68, TRUE, '0416-7778899', 'Sofia Cordero');

INSERT INTO Compania_Aseguradora (nombre_aseguradora, telefono, estado_comp, ciudad_comp) VALUES 
('Seguros Horizonte', '0212-9998877', 'Distrito Capital', 'Caracas'),
('Mercantil Seguros', '0212-5031111', 'Distrito Capital', 'Caracas'),
('Mapfre La Seguridad', '0241-6178000', 'Carabobo', 'Valencia');

INSERT INTO Seguro_Medico (num_poliza, nombre_aseguradora, ci_paciente, suma_asg) VALUES 
('HZ-001', 'Seguros Horizonte', 'V201', 5000), 
('HZ-002', 'Seguros Horizonte', 'V202', 15000),
('MS-105', 'Mercantil Seguros', 'V204', 25000),
('MS-106', 'Mercantil Seguros', 'V207', 10000),
('MPF-301', 'Mapfre La Seguridad', 'V202', 20000); -- Paciente con 2 pólizas

-- SECCIÓN 5: PROCEDIMIENTOS, CONSULTAS Y OPERACIONES
INSERT INTO Procedimiento (nombre, precio, instrucciones) VALUES 
('Consulta Cardiológica', 100, 'Requiere ayuno de 4 horas.'),
('Consulta General', 80, NULL), 
('Operación de Rodilla', 3000, 'Requiere hospitalización y anestesia general.'),
('Radiografía de Tórax', 50, 'Quitarse objetos metálicos.'),
('Consulta Neurológica', 120, NULL),
('Quimioterapia', 1500, 'Ciclo de tratamiento ambulatorio.'),
('Operación de Apéndice', 2500, 'Cirugía de emergencia, anestesia general.'),
('Endoscopia Digestiva', 450, 'Requiere ayuno de 8 horas y sedación.');

INSERT INTO Consulta (hora, fecha, ci_medico, ci_paciente, id_procedimiento, observaciones) VALUES
('09:00', '2023-10-10', 'V101', 'V201', 1, 'Paciente refiere dolor leve en el pecho.'), 
('10:00', '2023-10-11', 'V101', 'V202', 1, 'Chequeo de rutina, sin novedad.'),
('11:00', '2023-10-12', 'V101', 'V203', 1, 'Evaluación pre-operatoria para cateterismo.'),
('14:00', '2023-11-15', 'V105', 'V201', 2, 'Síntomas de gripe común.'),
('15:00', '2023-11-16', 'V105', 'V202', 2, 'Control post-operatorio.'), 
('12:00', '2023-11-18', 'V105', 'V202', 2, 'Seguimiento de tratamiento.'),
('08:00', '2024-01-20', 'V106', 'V204', 5, 'Paciente presenta migrañas recurrentes.'),
('10:00', '2024-01-22', 'V107', 'V207', 6, 'Inicio de primer ciclo de quimioterapia.');

INSERT INTO Operacion (id_procedimiento, id_departamento, id_hospital, ci_med, ci_paciente, id_habitacion, total, hora_operacion, fecha) VALUES
(3, 6, 2, 'V102', 'V202', 4, 3500, '08:00', '2023-11-20'),
(7, 3, 1, 'V105', 'V206', 2, 2800, '22:00', '2024-01-25');

-- SECCIÓN 6: FACTURACIÓN
INSERT INTO Factura (num_poliza, metodo, fecha, monto, estado) VALUES
('HZ-001', 'mixto', '2023-10-10', 100, 'Pagada'),
(NULL, 'punto de venta', '2024-01-20', 120, 'Pagada'), -- Paciente V204 sin seguro registrado
('HZ-002', 'mixto', '2023-11-20', 3500, 'Pendiente'),
(NULL, 'transferencia', '2024-01-25', 2800, 'Pagada');

INSERT INTO Emitida (num_factura, ci_paciente, ci_administrativo) VALUES 
(1, 'V201', 'V103'), 
(2, 'V204', 'V104'),
(3, 'V202', 'V104'),
(4, 'V206', 'V103');

-- SECCIÓN 7: PROVEEDORES, INSUMOS E INVENTARIO
INSERT INTO Proveedor (nombre_compania, ciudad_prov, telefono_proveedor) VALUES 
('Farmatodo', 'Caracas', '0212-2080000'), 
('Equipos Medicos VZLA', 'Valencia', '0241-8325555'),
('Behrens C.A.', 'Caracas', '0212-6001234');

INSERT INTO Insumo_Medico (nombre, tipo_insumo, stock, precio) VALUES 
('Bisturí Desechable #11', 'Instrumental', 0, 15),       -- ID 1
('Guantes de Nitrilo (Caja 100u)', 'Suministro', 0, 10), -- ID 2
('Sutura Absorbible 3-0', 'Suministro', 0, 8),          -- ID 3
('Gasa Estéril (Paquete 10u)', 'Suministro', 0, 5),      -- ID 4
('Cisplatino 50mg', 'Medicamento', 0, 500);             -- ID 5

INSERT INTO Encargo (fecha, ci_resp, id_insumo, nombre_compania, id_hospital, cantidad, costo_total) VALUES
('2024-01-10', 'V104', 1, 'Equipos Medicos VZLA', 2, 100, 1500),
('2024-01-11', 'V104', 2, 'Equipos Medicos VZLA', 2, 50, 500),
('2024-01-15', 'V103', 1, 'Behrens C.A.', 1, 200, 3000),
('2024-01-16', 'V103', 3, 'Behrens C.A.', 1, 150, 1200),
('2024-01-18', 'V103', 5, 'Behrens C.A.', 4, 20, 10000);

INSERT INTO Necesitan (id_procedimiento, id_insumo) VALUES 
(3, 1), (3, 2), (3, 3), (3, 4), -- Operación de rodilla
(6, 2), (6, 5),                 -- Quimioterapia
(7, 1), (7, 2), (7, 3), (7, 4), -- Operación de apéndice
(8, 2);                         -- Endoscopia

-- SECCIÓN 8: HORARIOS DE TRABAJO
-- ================== CORRECCIÓN APLICADA AQUÍ ==================
-- El turno de noche (19:00 a 07:00) se divide en dos para cumplir la restricción CHECK.
INSERT INTO Horario_de_Atencion (hora_comienzo, dia, hora_finalizacion) VALUES
('08:00', 'L-V', '16:00'), -- Horario Diurno (ID 1)
('07:00', 'L-S', '19:00'), -- Horario Extendido (ID 2)
('19:00', 'L-D', '23:59'), -- Guardia Nocturna - Parte 1 (Noche) (ID 3)
('00:00', 'L-D', '07:00'); -- Guardia Nocturna - Parte 2 (Madrugada) (ID 4)

-- El personal nocturno es asignado a AMBOS registros de horario.
INSERT INTO Trabaja_En (id_horario, ci_personal) VALUES
(1, 'V102'), (1, 'V104'), (1, 'V108'), (1, 'V109'), -- Personal con horario diurno estándar
(2, 'V101'), (2, 'V103'), (2, 'V106'), (2, 'V107'), -- Personal con horario extendido
(3, 'V105'), -- Dr. Rojas, guardia nocturna (parte 1)
(4, 'V105'); -- Dr. Rojas, guardia nocturna (parte 2)
