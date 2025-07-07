

-- Borrar todas las tablas en orden inverso de dependencias
DROP TABLE IF EXISTS Provee CASCADE;
DROP TABLE IF EXISTS Encargo CASCADE;
DROP TABLE IF EXISTS Inventario CASCADE;
DROP TABLE IF EXISTS Cuentan_con CASCADE;
DROP TABLE IF EXISTS Necesitan CASCADE;
DROP TABLE IF EXISTS Se_realiza CASCADE;
DROP TABLE IF EXISTS Tratamiento CASCADE;
DROP TABLE IF EXISTS Operacion CASCADE;
DROP TABLE IF EXISTS Consulta CASCADE;
DROP TABLE IF EXISTS Emitida CASCADE;
DROP TABLE IF EXISTS Factura CASCADE;
DROP TABLE IF EXISTS Seguro_Medico CASCADE;
DROP TABLE IF EXISTS Compania_Aseguradora CASCADE;
DROP TABLE IF EXISTS Medicamentos_Reg CASCADE;
DROP TABLE IF EXISTS Condicion_Paciente CASCADE;
DROP TABLE IF EXISTS Paciente CASCADE;
DROP TABLE IF EXISTS Trabaja_En CASCADE;
DROP TABLE IF EXISTS Horario_de_Atencion CASCADE;
DROP TABLE IF EXISTS Administrativo CASCADE;
DROP TABLE IF EXISTS Medico CASCADE;
DROP TABLE IF EXISTS TelefonosPersonal CASCADE;
DROP TABLE IF EXISTS Personal CASCADE;
DROP TABLE IF EXISTS Contratado CASCADE;
DROP TABLE IF EXISTS Habitacion CASCADE;
DROP TABLE IF EXISTS TelefonosDepartamento CASCADE;
DROP TABLE IF EXISTS Departamento CASCADE;
DROP TABLE IF EXISTS Hospital CASCADE;
DROP TABLE IF EXISTS Procedimiento CASCADE;
DROP TABLE IF EXISTS Insumo_Medico CASCADE;
DROP TABLE IF EXISTS Proveedor CASCADE;
DROP TABLE IF EXISTS Persona CASCADE;

-- Creación de las tablas
CREATE TABLE Persona (
    ci VARCHAR(20) PRIMARY KEY,
    fecha_nacimiento DATE NOT NULL,
    estado_per VARCHAR(50),
    ciudad_per VARCHAR(50),
    calle_per VARCHAR(100),
    cod_postal_per VARCHAR(10),
    sexo CHAR(1) NOT NULL CHECK (sexo IN ('M', 'F')), 
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL
);

CREATE TABLE Hospital (
    id_hospital SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    estado_hos VARCHAR(50),
    ciudad_hos VARCHAR(50),
    calle_hos VARCHAR(100),
    cod_postal_hos VARCHAR(10),
    num_camas INTEGER NOT NULL DEFAULT 0 CHECK (num_camas >= 0)
);

CREATE TABLE Departamento (
    id_departamento SERIAL PRIMARY KEY,
    id_hospital INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    piso INTEGER,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('medico', 'administrativo', 'operativo')),
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE CASCADE
);

CREATE TABLE Habitacion (
    id_habitacion SERIAL PRIMARY KEY,
    num_habitacion INTEGER NOT NULL,
    id_hospital INTEGER NOT NULL,
    id_departamento INTEGER NOT NULL,
    ocupado BOOLEAN DEFAULT FALSE,
    num_camas INTEGER NOT NULL CHECK (num_camas > 0),
    tarifa NUMERIC(10, 2) NOT NULL CHECK (tarifa >= 0),
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('individual', 'compartida')),
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE CASCADE,
    UNIQUE(id_hospital, id_departamento, num_habitacion)
);

-- tabla Contratado y añadir Asignado_A
CREATE TABLE Contratado (
    ci VARCHAR(20) PRIMARY KEY,
    -- id_departamento INTEGER NOT NULL,  <-- SE ELIMINA DE AQUÍ
    fecha_contratacion DATE NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    fecha_retiro DATE,
    salario NUMERIC(12, 2) NOT NULL CHECK (salario >= 0),
    FOREIGN KEY (ci) REFERENCES Persona (ci) ON DELETE CASCADE,
    -- FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE CASCADE, <-- SE ELIMINA
    CHECK (fecha_retiro IS NULL OR fecha_retiro >= fecha_contratacion)
);

-- NUEVA TABLA para que un empleado pueda estar en varios departamentos
CREATE TABLE Asignado_A (
    ci_personal VARCHAR(20) NOT NULL,
    id_departamento INTEGER NOT NULL,
    PRIMARY KEY (ci_personal, id_departamento),
    FOREIGN KEY (ci_personal) REFERENCES Contratado(ci) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento) ON DELETE CASCADE
);

CREATE TABLE Personal (
    ci VARCHAR(20) PRIMARY KEY,
    annios_serv INTEGER NOT NULL CHECK (annios_serv >= 0),
    FOREIGN KEY (ci) REFERENCES Contratado (ci) ON DELETE CASCADE
);

CREATE TABLE Medico (
    ci VARCHAR(20) PRIMARY KEY,
    especialidad VARCHAR(100) NOT NULL,
    FOREIGN KEY (ci) REFERENCES Personal (ci) ON DELETE CASCADE
);

CREATE TABLE Administrativo (
    ci VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (ci) REFERENCES Personal (ci) ON DELETE CASCADE
);

CREATE TABLE Paciente (
    ci VARCHAR(20) PRIMARY KEY,
    edad INTEGER NOT NULL CHECK (edad >= 0),
    requiere_resp BOOLEAN NOT NULL,
    contacto_emerg VARCHAR(100),
    telefono VARCHAR(20) NOT NULL,
    FOREIGN KEY (ci) REFERENCES Persona (ci) ON DELETE CASCADE
);

CREATE TABLE Compania_Aseguradora (
    nombre_aseguradora VARCHAR(100) PRIMARY KEY,
    estado_comp VARCHAR(50),
    ciudad_comp VARCHAR(50),
    calle_comp VARCHAR(100),
    cod_postal_comp VARCHAR(10),
    telefono VARCHAR(20) NOT NULL
);

CREATE TABLE Seguro_Medico (
    num_poliza VARCHAR(50) PRIMARY KEY,
    nombre_aseguradora VARCHAR(100) NOT NULL,
    ci_paciente VARCHAR(20) NOT NULL, 
    suma_asg NUMERIC(12, 2) NOT NULL CHECK (suma_asg >= 0),
    condiciones TEXT,
    FOREIGN KEY (nombre_aseguradora) REFERENCES Compania_Aseguradora (nombre_aseguradora) ON DELETE RESTRICT,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente (ci) ON DELETE CASCADE
);

CREATE TABLE Factura (
    num_factura SERIAL PRIMARY KEY,
    num_poliza VARCHAR(50),
    metodo VARCHAR(50) NOT NULL CHECK (metodo IN ('transferencia', 'efectivo', 'punto de venta', 'mixto')),
    fecha DATE NOT NULL,
    monto NUMERIC(12, 2) NOT NULL CHECK (monto >= 0),
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('Pendiente', 'Pagada', 'Cancelada', 'Reembolsada')),
    FOREIGN KEY (num_poliza) REFERENCES Seguro_Medico (num_poliza) ON DELETE SET NULL
);

CREATE TABLE Emitida (
    num_factura INTEGER NOT NULL,
    ci_paciente VARCHAR(20) NOT NULL,
    ci_administrativo VARCHAR(20) NOT NULL,
    PRIMARY KEY (num_factura, ci_paciente, ci_administrativo),
    FOREIGN KEY (num_factura) REFERENCES Factura (num_factura) ON DELETE CASCADE,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente (ci) ON DELETE CASCADE,
    FOREIGN KEY (ci_administrativo) REFERENCES Administrativo (ci) ON DELETE CASCADE
);

CREATE TABLE Procedimiento (
    id_procedimiento SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    instrucciones TEXT,
    precio NUMERIC(10, 2) NOT NULL CHECK (precio >= 0)
);

CREATE TABLE Consulta (
    id_consulta SERIAL PRIMARY KEY,
    hora TIME NOT NULL,
    fecha DATE NOT NULL,
    ci_medico VARCHAR(20) NOT NULL,
    ci_paciente VARCHAR(20) NOT NULL,
    id_procedimiento INTEGER NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (ci_medico) REFERENCES Medico (ci) ON DELETE RESTRICT,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente (ci) ON DELETE RESTRICT,
    FOREIGN KEY (id_procedimiento) REFERENCES Procedimiento (id_procedimiento) ON DELETE CASCADE
);

CREATE TABLE Operacion (
    id_procedimiento INTEGER PRIMARY KEY,
    id_departamento INTEGER NOT NULL,
    id_hospital INTEGER NOT NULL,
    ci_med VARCHAR(20) NOT NULL,
    ci_paciente VARCHAR(20) NOT NULL,
    id_habitacion INTEGER NOT NULL,
    total NUMERIC(10, 2) NOT NULL CHECK (total >= 0),
    hora_operacion TIME NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (id_procedimiento) REFERENCES Procedimiento (id_procedimiento) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE RESTRICT,
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE RESTRICT,
    FOREIGN KEY (ci_med) REFERENCES Medico (ci) ON DELETE RESTRICT,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente (ci) ON DELETE RESTRICT,
    FOREIGN KEY (id_habitacion) REFERENCES Habitacion (id_habitacion) ON DELETE RESTRICT
);

CREATE TABLE Proveedor (
    nombre_compania VARCHAR(100) PRIMARY KEY,
    telefono_proveedor VARCHAR(20), 
    ciudad_prov VARCHAR(50)
);

CREATE TABLE Insumo_Medico (
    id_insumo SERIAL PRIMARY KEY,
    descripcion TEXT,
    stock INTEGER NOT NULL CHECK (stock >= 0),
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL CHECK (precio >= 0),
    tipo_insumo VARCHAR(50) CHECK (tipo_insumo IN ('Medicamento', 'Instrumental', 'Equipo', 'Suministro'))
);

CREATE TABLE Inventario (
    id_hospital INTEGER NOT NULL,
    id_insumo INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad >= 0),
    PRIMARY KEY (id_hospital, id_insumo),
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE CASCADE,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE CASCADE
);

CREATE TABLE Encargo (
    num_encargo SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    ci_resp VARCHAR(20) NOT NULL,
    id_insumo INTEGER NOT NULL,
    nombre_compania VARCHAR(100) NOT NULL,
    id_hospital INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    costo_total NUMERIC(12, 2) NOT NULL CHECK (costo_total >= 0),
    FOREIGN KEY (ci_resp) REFERENCES Administrativo (ci) ON DELETE RESTRICT,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE RESTRICT,
    FOREIGN KEY (nombre_compania) REFERENCES Proveedor (nombre_compania) ON DELETE RESTRICT,
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE RESTRICT
);

CREATE TABLE Necesitan (
    id_procedimiento INTEGER NOT NULL,
    id_insumo INTEGER NOT NULL,
    PRIMARY KEY (id_procedimiento, id_insumo),
    FOREIGN KEY (id_procedimiento) REFERENCES Procedimiento (id_procedimiento) ON DELETE CASCADE,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE CASCADE
);

CREATE TABLE Horario_de_Atencion (
    id_horario SERIAL PRIMARY KEY,
    hora_comienzo TIME NOT NULL,
    dia VARCHAR(10) NOT NULL,
    hora_finalizacion TIME NOT NULL,
    CHECK (hora_finalizacion > hora_comienzo)
);

CREATE TABLE Trabaja_En (
    id_horario INTEGER NOT NULL,
    ci_personal VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_horario, ci_personal),
    FOREIGN KEY (id_horario) REFERENCES Horario_de_Atencion (id_horario) ON DELETE CASCADE,
    FOREIGN KEY (ci_personal) REFERENCES Personal (ci) ON DELETE CASCADE
);

-- ========================= TRIGGERS =========================
-- TRIGGER 1: Actualizar el stock de un insumo en un hospital al recibir un encargo.
CREATE OR REPLACE FUNCTION trg_actualizar_stock_al_recibir_encargo()
    RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Insumo_Medico
        SET stock = stock + NEW.cantidad
        WHERE id_insumo = NEW.id_insumo;

        INSERT INTO Inventario (id_hospital, id_insumo, cantidad)
        VALUES (NEW.id_hospital, NEW.id_insumo, NEW.cantidad)
        ON CONFLICT (id_hospital, id_insumo) DO UPDATE
        SET cantidad = Inventario.cantidad + EXCLUDED.cantidad;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_encargo_insert
AFTER INSERT ON Encargo
FOR EACH ROW
EXECUTE FUNCTION trg_actualizar_stock_al_recibir_encargo();

-- TRIGGER 2: Actualizar número de camas del hospital (atributo derivado).
CREATE OR REPLACE FUNCTION trg_actualizar_num_camas()
RETURNS TRIGGER AS $$
DECLARE
    v_id_hospital INTEGER;
BEGIN
    IF TG_OP = 'DELETE' THEN v_id_hospital := OLD.id_hospital;
    ELSE v_id_hospital := NEW.id_hospital; END IF;

    UPDATE Hospital
    SET num_camas = (SELECT COALESCE(SUM(h.num_camas), 0) FROM Habitacion h WHERE h.id_hospital = v_id_hospital)
    WHERE id_hospital = v_id_hospital;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_habitacion_change
AFTER INSERT OR UPDATE OR DELETE ON Habitacion
FOR EACH ROW
EXECUTE FUNCTION trg_actualizar_num_camas();
