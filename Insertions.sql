

-- Personas
INSERT INTO Persona (ci, nombre, apellido, fecha_nacimiento, sexo) VALUES
('V101', 'Carlos', 'Gomez', '1985-05-10', 'M'), ('V102', 'Ana', 'Perez', '1990-02-15', 'F'),
('V103', 'Luis', 'Martinez', '1988-11-20', 'M'), ('V104', 'Laura', 'Lopez', '1995-03-25', 'F'),
('V105', 'Pedro', 'Rojas', '1982-01-01', 'M'),
('V201', 'Juan', 'Castro', '2000-01-20', 'M'), ('V202', 'Elena', 'Silva', '1995-06-18', 'F'),
('V203', 'Ricardo', 'Paez', '1978-04-11', 'M');

-- Hospitales y Departamentos
INSERT INTO Hospital (nombre, ciudad_hos) VALUES ('Hospital Metropolitano', 'Caracas'), ('Centro Médico Valencia', 'Valencia');
INSERT INTO Departamento (id_hospital, nombre, tipo) VALUES
(1, 'Cardiología', 'medico'), (1, 'Administración', 'administrativo'), (1, 'Emergencia', 'medico'),
(2, 'Traumatología', 'medico'), (2, 'Gestión de Pacientes', 'administrativo');

-- Contratados y Asignaciones
INSERT INTO Contratado (ci, fecha_contratacion, cargo, salario) VALUES
('V101', '2010-01-15', 'Cardiólogo Jefe', 5000), ('V102', '2012-03-20', 'Traumatólogo', 4800),
('V103', '2015-05-01', 'Jefe de Admisiones', 3000), ('V104', '2020-02-01', 'Recepcionista', 2500),
('V105', '2018-05-05', 'Médico General', 4500);
INSERT INTO Asignado_A (ci_personal, id_departamento) VALUES
('V101', 1), ('V101', 3), ('V102', 4), ('V103', 2), ('V104', 5), ('V105', 3);

-- Personal y especializaciones
INSERT INTO Personal (ci, annios_serv) VALUES ('V101', 14), ('V102', 12), ('V103', 9), ('V104', 4), ('V105', 6);
INSERT INTO Medico (ci, especialidad) VALUES ('V101', 'Cardiología'), ('V102', 'Traumatología'), ('V105', 'Medicina Interna');
INSERT INTO Administrativo (ci) VALUES ('V103'), ('V104');

-- Pacientes y Seguros
INSERT INTO Paciente (ci, edad, requiere_resp, telefono) VALUES ('V201', 24, FALSE, '0412-111'), ('V202', 29, FALSE, '0414-222'), ('V203', 46, FALSE, '0416-333');
INSERT INTO Compania_Aseguradora (nombre_aseguradora, telefono) VALUES ('Seguros Horizonte', '0212-999');
INSERT INTO Seguro_Medico (num_poliza, nombre_aseguradora, ci_paciente, suma_asg) VALUES ('HZ-001', 'Seguros Horizonte', 'V201', 5000), ('HZ-002', 'Seguros Horizonte', 'V202', 15000);

-- Procedimientos, Consultas y Operaciones
INSERT INTO Procedimiento (nombre, precio) VALUES ('Consulta Cardiológica', 100), ('Consulta General', 80), ('Operación de Rodilla', 3000), ('Radiografía', 80);
INSERT INTO Consulta (hora, fecha, ci_medico, ci_paciente, id_procedimiento) VALUES
('09:00', '2023-10-10', 'V101', 'V201', 1), ('10:00', '2023-10-11', 'V101', 'V202', 1), ('11:00', '2023-10-12', 'V101', 'V203', 1),
('14:00', '2023-11-15', 'V105', 'V201', 2), ('15:00', '2023-11-16', 'V105', 'V202', 2), ('12:00', '2023-11-18', 'V201', 'V202', 2);
INSERT INTO Habitacion (num_habitacion, id_hospital, id_departamento, num_camas, tarifa, tipo) VALUES (301, 2, 4, 1, 200, 'individual');
INSERT INTO Operacion (id_procedimiento, id_departamento, id_hospital, ci_med, ci_paciente, id_habitacion, total, hora_operacion, fecha) VALUES
(3, 4, 2, 'V102', 'V202', 1, 3500, '08:00', '2023-11-20');

-- Facturas y Emisiones
-- *** CORRECCIÓN APLICADA AQUÍ ***
INSERT INTO Factura (num_poliza, metodo, fecha, monto, estado) VALUES
('HZ-001', 'mixto', '2023-10-10', 100, 'Pagada'),
('HZ-002', 'mixto', '2023-11-20', 3500, 'Pendiente'); -- Se cambió 'seguro' por 'mixto'
INSERT INTO Emitida (num_factura, ci_paciente, ci_administrativo) VALUES (1, 'V201', 'V103'), (2, 'V202', 'V104');

-- Proveedores, Insumos, Encargos y Necesitan
INSERT INTO Proveedor (nombre_compania, ciudad_prov) VALUES ('Farmatodo', 'Caracas'), ('Equipos Medicos VZLA', 'Valencia');
INSERT INTO Insumo_Medico (nombre, tipo_insumo, stock, precio) VALUES ('Bisturí', 'Instrumental', 0, 15), ('Guantes', 'Suministro', 0, 0.5);
INSERT INTO Encargo (fecha, ci_resp, id_insumo, nombre_compania, id_hospital, cantidad, costo_total) VALUES
(CURRENT_DATE, 'V104', 1, 'Equipos Medicos VZLA', 2, 100, 1500),
('2023-01-02', 'V104', 2, 'Equipos Medicos VZLA', 2, 1000, 500);
INSERT INTO Necesitan (id_procedimiento, id_insumo) VALUES (3, 1);

-- Horarios y Asignación de trabajo
INSERT INTO Horario_de_Atencion (hora_comienzo, dia, hora_finalizacion) VALUES
('08:00', 'L-V', '16:00'), ('08:00', 'L-S', '18:00');
INSERT INTO Trabaja_En (id_horario, ci_personal) VALUES
(1, 'V102'), (1, 'V104'), (1, 'V105'),
(2, 'V101'), (2, 'V103');
