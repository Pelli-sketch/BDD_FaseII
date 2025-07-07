-- Borrar todas las tablas 
DROP TABLE IF EXISTS Provee CASCADE;
DROP TABLE IF EXISTS Encargo CASCADE;
DROP TABLE IF EXISTS Inventario CASCADE;
DROP TABLE IF EXISTS Cuentan_con CASCADE;
DROP TABLE IF EXISTS Instrumental_Medico CASCADE;
DROP TABLE IF EXISTS Suministro_Limpieza CASCADE;
DROP TABLE IF EXISTS Medicamento CASCADE;
DROP TABLE IF EXISTS Suministro_Desechable CASCADE;
DROP TABLE IF EXISTS Equipo_Medico CASCADE;
DROP TABLE IF EXISTS Insumo_Medico CASCADE;
DROP TABLE IF EXISTS Proveedor CASCADE;
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
DROP TABLE IF EXISTS Horario_de_Atencion CASCADE;
DROP TABLE IF EXISTS Trabaja_En CASCADE;
DROP TABLE IF EXISTS Administrativo CASCADE;
DROP TABLE IF EXISTS Medico CASCADE;
DROP TABLE IF EXISTS TelefonosPersonal CASCADE;
DROP TABLE IF EXISTS Personal CASCADE;
DROP TABLE IF EXISTS Contratado CASCADE;
DROP TABLE IF EXISTS Habitacion CASCADE;
DROP TABLE IF EXISTS TelefonosDepartamento CASCADE;
DROP TABLE IF EXISTS Departamento CASCADE;
DROP TABLE IF EXISTS Hospital CASCADE;
DROP TABLE IF EXISTS Persona CASCADE;

-- Creación de las tablas
CREATE TABLE Hospital (
    id_hospital SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estado_hos VARCHAR(50),
    ciudad_hos VARCHAR(50),
    calle_hos VARCHAR(100),
    cod_postal_hos VARCHAR(10),
    num_camas INTEGER NOT NULL CHECK (num_camas >= 0)
);

CREATE TABLE Departamento (
    id_departamento SERIAL PRIMARY KEY,
    id_hospital INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    piso INTEGER,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('medico', 'administrativo', 'operativo')),
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE CASCADE
);

CREATE TABLE TelefonosDepartamento (
    id_departamento INTEGER NOT NULL,
    telefono VARCHAR(20) NOT NULL, 
    PRIMARY KEY (id_departamento, telefono),
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE CASCADE
);

CREATE TABLE Habitacion (
    num_habitacion INTEGER NOT NULL,
    id_hospital INTEGER NOT NULL,
    id_departamento INTEGER NOT NULL,
    ocupado BOOLEAN DEFAULT FALSE,
    num_camas INTEGER NOT NULL CHECK (num_camas > 0),
    tarifa NUMERIC(10, 2) NOT NULL CHECK (tarifa >= 0),
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('individual', 'compartida')),
    PRIMARY KEY (num_habitacion, id_hospital, id_departamento),
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE CASCADE
);

CREATE TABLE Persona (
    ci VARCHAR(20) PRIMARY KEY,
    fecha_nacimiento DATE NOT NULL,
    estado_per VARCHAR(50),
    ciudad_per VARCHAR(50),
    calle_per VARCHAR(100),
    cod_postal_per VARCHAR(10),
    sexo CHAR(1) NOT NULL CHECK (sexo IN ('M', 'F', 'N/A')), 
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL
);

CREATE TABLE Contratado (
    ci VARCHAR(20) PRIMARY KEY,
    id_departamento INTEGER NOT NULL,
    id_hospital INTEGER NOT NULL,
    fecha_contratacion DATE NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    fecha_retiro DATE,
    salario NUMERIC(12, 2) NOT NULL CHECK (salario >= 0),
    FOREIGN KEY (ci) REFERENCES Persona (ci) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE CASCADE,
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE CASCADE,
    CHECK (fecha_retiro IS NULL OR fecha_retiro >= fecha_contratacion)
);

CREATE TABLE Personal (
    ci VARCHAR(20) PRIMARY KEY,
    id_departamento INTEGER NOT NULL,
    annios_serv INTEGER NOT NULL CHECK (annios_serv >= 0),
    FOREIGN KEY (ci) REFERENCES Contratado (ci) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE CASCADE
);

CREATE TABLE TelefonosPersonal (
    ci VARCHAR(20) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    PRIMARY KEY (ci, telefono),
    FOREIGN KEY (ci) REFERENCES Personal (ci) ON DELETE CASCADE
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

CREATE TABLE Horario_de_Atencion (
    id_horario SERIAL PRIMARY KEY,
    id_departamento INTEGER NOT NULL,
    hora_comienzo TIME NOT NULL,
    dia CHAR(2) NOT NULL CHECK (dia IN ('L', 'M', 'Mi', 'J', 'V', 'S', 'D')),
    hora_finalizacion TIME NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE CASCADE,
    CHECK (hora_finalizacion > hora_comienzo)
);

CREATE TABLE Trabaja_En (
    id_horario INTEGER NOT NULL,
    id_departamento INTEGER NOT NULL,
    id_hospital INTEGER NOT NULL,
    ci VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_horario, id_departamento, id_hospital, ci),
    FOREIGN KEY (id_horario) REFERENCES Horario_de_Atencion (id_horario) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE CASCADE,
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE CASCADE,
    FOREIGN KEY (ci) REFERENCES Personal (ci) ON DELETE CASCADE
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
    ci VARCHAR(20) NOT NULL, 
    suma_asg NUMERIC(12, 2) NOT NULL CHECK (suma_asg >= 0),
    condiciones TEXT,
    FOREIGN KEY (nombre_aseguradora) REFERENCES Compania_Aseguradora (nombre_aseguradora) ON DELETE RESTRICT,
    FOREIGN KEY (ci) REFERENCES Persona (ci) ON DELETE CASCADE
);

CREATE TABLE Factura (
    num_factura SERIAL PRIMARY KEY,
    num_poliza VARCHAR(50),
    metodo VARCHAR(50) NOT NULL CHECK (metodo IN ('transferencia', 'efectivo', 'punto de venta', 'mixto')),
    fecha DATE NOT NULL,
    monto NUMERIC(12, 2) NOT NULL CHECK (monto >= 0),
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('Pendiente', 'Pagada', 'Cancelada', 'Reembolsada')),
    monto_pagado NUMERIC(12, 2) CHECK (monto_pagado >= 0),
    cobertura NUMERIC(5, 2) CHECK (cobertura >= 0 AND cobertura <= 100),
    FOREIGN KEY (num_poliza) REFERENCES Seguro_Medico (num_poliza) ON DELETE SET NULL
);

CREATE TABLE Paciente (
    ci VARCHAR(20) PRIMARY KEY,
    id_medicamento_reg INTEGER,
    id_condicion INTEGER,
    edad INTEGER NOT NULL CHECK (edad >= 0),
    requiere_resp BOOLEAN NOT NULL,
    contacto_emerg VARCHAR(100),
    telefono VARCHAR(20) NOT NULL,
    FOREIGN KEY (ci) REFERENCES Persona (ci) ON DELETE CASCADE
);

CREATE TABLE Condicion_Paciente (
    id_condicion SERIAL PRIMARY KEY,
    ci_paciente VARCHAR(20) NOT NULL,
    nombre_condicion VARCHAR(100) NOT NULL,
    descripcion_condicion TEXT,
    tipo_condicion VARCHAR(100),
    fecha_diagnostico DATE NOT NULL,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente (ci) ON DELETE CASCADE
);

CREATE TABLE Medicamentos_Reg (
    id_medicamento_reg SERIAL PRIMARY KEY,
    ci_paciente VARCHAR(20) NOT NULL,
    id_insumo_medicamento INTEGER,
    dosis_medicamento VARCHAR(50),
    via_administracion VARCHAR(50),
    inicio_medicamento DATE NOT NULL,
    fin_medicamento DATE,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente (ci) ON DELETE CASCADE
);

-- Añadir FKs faltantes en Paciente (ahora que Condicion_Paciente y Medicamentos_Reg están definidos)
ALTER TABLE Paciente
ADD CONSTRAINT fk_id_medicamento_reg
FOREIGN KEY (id_medicamento_reg) REFERENCES Medicamentos_Reg (id_medicamento_reg) ON DELETE SET NULL,
ADD CONSTRAINT fk_id_condicion
FOREIGN KEY (id_condicion) REFERENCES Condicion_Paciente (id_condicion) ON DELETE SET NULL;

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
    id_procedimiento INTEGER,
    precio_consulta NUMERIC(10, 2) NOT NULL CHECK (precio_consulta >= 0),
    observaciones TEXT,
    total NUMERIC(10, 2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (ci_medico) REFERENCES Medico (ci) ON DELETE RESTRICT,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente (ci) ON DELETE RESTRICT,
    FOREIGN KEY (id_procedimiento) REFERENCES Procedimiento (id_procedimiento) ON DELETE SET NULL
);

CREATE TABLE Operacion (
    id_procedimiento INTEGER PRIMARY KEY,
    id_departamento INTEGER NOT NULL,
    id_hospital INTEGER NOT NULL,
    ci_med VARCHAR(20) NOT NULL,
    ci_paciente VARCHAR(20) NOT NULL,
    num_habitacion INTEGER NOT NULL,
    total NUMERIC(10, 2) NOT NULL CHECK (total >= 0),
    hora_operacion TIME NOT NULL,
    fecha DATE NOT NULL,
    duracion_estimada INTERVAL,
    FOREIGN KEY (id_procedimiento) REFERENCES Procedimiento (id_procedimiento) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE RESTRICT,
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE RESTRICT,
    FOREIGN KEY (ci_med) REFERENCES Medico (ci) ON DELETE RESTRICT,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente (ci) ON DELETE RESTRICT,
    FOREIGN KEY (num_habitacion, id_hospital, id_departamento) REFERENCES Habitacion (num_habitacion, id_hospital, id_departamento) ON DELETE RESTRICT
);

CREATE TABLE Tratamiento (
    id_procedimiento INTEGER PRIMARY KEY,
    tipo VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_procedimiento) REFERENCES Procedimiento (id_procedimiento) ON DELETE CASCADE
);

CREATE TABLE Proveedor (
    nombre_compania VARCHAR(100) PRIMARY KEY,
    telefono_proveedor VARCHAR(20), 
    correo_proveedor VARCHAR(100),
    estado_prov VARCHAR(50),
    ciudad_prov VARCHAR(50),
    calle_prov VARCHAR(100),
    cod_postal_prov VARCHAR(10)
);

CREATE TABLE Insumo_Medico (
    id_insumo SERIAL PRIMARY KEY,
    nombre_compania VARCHAR(100) NOT NULL,
    descripcion TEXT,
    stock INTEGER NOT NULL CHECK (stock >= 0),
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL CHECK (precio >= 0),
    tipo_insumo VARCHAR(50),
    FOREIGN KEY (nombre_compania) REFERENCES Proveedor (nombre_compania) ON DELETE RESTRICT
);

CREATE TABLE Equipo_Medico (
    id_insumo INTEGER PRIMARY KEY,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE CASCADE
);

CREATE TABLE Suministro_Desechable (
    id_insumo INTEGER PRIMARY KEY,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE CASCADE
);

CREATE TABLE Medicamento (
    id_insumo INTEGER PRIMARY KEY,
    fecha_vencimiento DATE,
    presentacion VARCHAR(50) CHECK (presentacion IN ('Tabletas', 'Cápsulas', 'Jarabe', 'Inyectable', 'Pomada', 'Polvo', 'Suspensión')),
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE CASCADE
);

CREATE TABLE Suministro_Limpieza (
    id_insumo INTEGER PRIMARY KEY,
    tipo_suministro VARCHAR(50) CHECK (tipo_suministro IN ('Desinfectante', 'Detergente', 'Jabón', 'Alcohol', 'Guantes', 'Toallas', 'Mascarillas')),
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE CASCADE
);

CREATE TABLE Instrumental_Medico (
    id_insumo INTEGER PRIMARY KEY,
    material VARCHAR(100),
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE CASCADE
);

ALTER TABLE Medicamentos_Reg
ADD CONSTRAINT fk_id_insumo_medicamento
FOREIGN KEY (id_insumo_medicamento) REFERENCES Medicamento (id_insumo) ON DELETE SET NULL;

CREATE TABLE Necesitan (
    id_procedimiento INTEGER NOT NULL,
    id_insumo INTEGER NOT NULL,
    PRIMARY KEY (id_procedimiento, id_insumo),
    FOREIGN KEY (id_procedimiento) REFERENCES Procedimiento (id_procedimiento) ON DELETE CASCADE,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE CASCADE
);

CREATE TABLE Se_realiza (
    id_realizacion SERIAL PRIMARY KEY,
    hora_operacion TIME NOT NULL,
    fecha DATE NOT NULL,
    id_departamento INTEGER NOT NULL,
    id_hospital INTEGER NOT NULL,
    id_procedimiento INTEGER NOT NULL,
    ci_med VARCHAR(20) NOT NULL,
    ci_paciente VARCHAR(20) NOT NULL,
    num_habitacion INTEGER NOT NULL,
    total NUMERIC(10, 2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE RESTRICT,
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE RESTRICT,
    FOREIGN KEY (id_procedimiento) REFERENCES Procedimiento (id_procedimiento) ON DELETE RESTRICT,
    FOREIGN KEY (ci_med) REFERENCES Medico (ci) ON DELETE RESTRICT,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente (ci) ON DELETE RESTRICT,
    FOREIGN KEY (num_habitacion, id_hospital, id_departamento) REFERENCES Habitacion (num_habitacion, id_hospital, id_departamento) ON DELETE RESTRICT
);

CREATE TABLE Cuentan_con (
    id_insumo INTEGER NOT NULL,
    ci_resp VARCHAR(20),
    id_hospital INTEGER NOT NULL,
    id_departamento INTEGER NOT NULL,
    PRIMARY KEY (id_insumo, id_hospital, id_departamento),
    FOREIGN KEY (id_insumo) REFERENCES Equipo_Medico (id_insumo) ON DELETE CASCADE,
    FOREIGN KEY (ci_resp) REFERENCES Medico (ci) ON DELETE SET NULL,
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE RESTRICT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento (id_departamento) ON DELETE RESTRICT
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
    num_lote VARCHAR(50),
    costo_total NUMERIC(12, 2) NOT NULL CHECK (costo_total >= 0),
    FOREIGN KEY (ci_resp) REFERENCES Administrativo (ci) ON DELETE RESTRICT,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE RESTRICT,
    FOREIGN KEY (nombre_compania) REFERENCES Proveedor (nombre_compania) ON DELETE RESTRICT,
    FOREIGN KEY (id_hospital) REFERENCES Hospital (id_hospital) ON DELETE RESTRICT
);

CREATE TABLE Provee (
    id_insumo INTEGER NOT NULL,
    nombre_compania VARCHAR(100) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL CHECK (precio >= 0),
    PRIMARY KEY (id_insumo, nombre_compania),
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico (id_insumo) ON DELETE CASCADE,
    FOREIGN KEY (nombre_compania) REFERENCES Proveedor (nombre_compania) ON DELETE CASCADE
);


-- ========================= TRIGGERS =========================
-- TRIGGER 1: Actualizar el stock de un insumo en un hospital al recibir un encargo.
CREATE OR REPLACE FUNCTION trg_actualizar_stock_al_recibir_encargo()
    RETURNS TRIGGER AS $$
    BEGIN
        -- Actualizar el stock global del insumo en la tabla Insumo_Medico
        UPDATE Insumo_Medico
        SET stock = stock + NEW.cantidad
        WHERE id_insumo = NEW.id_insumo;

        -- Actualizar o insertar la cantidad del insumo en el Inventario del hospital específico.
        -- Si el insumo ya existe en el inventario del hospital, se suma la cantidad.
        -- Si no existe, se inserta un nuevo registro.
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











-- Corregir los triggers 2,3,4,5,6 (creo que hay que corregirlos todos)
-- TRIGGER 2: Descontar insumos del inventario cuando se usan en un evento clínico.
CREATE OR REPLACE FUNCTION trg_descontar_insumo_usado()
RETURNS TRIGGER AS $$
DECLARE
    v_id_hospital INTEGER;
BEGIN
    -- Obtener el hospital donde ocurrió el evento
    SELECT id_hospital INTO v_id_hospital FROM Evento_Clinico WHERE id_evento = NEW.id_evento;

    -- Actualizar (restar) la cantidad del insumo en el inventario del hospital
    UPDATE Inventario
    SET cantidad = cantidad - NEW.cantidad
    WHERE id_hospital = v_id_hospital AND id_insumo = NEW.id_insumo;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El insumo ID % no existe en el inventario del hospital ID %.', NEW.id_insumo, v_id_hospital;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_insumo_usado
AFTER INSERT ON Evento_Usa_Insumo
FOR EACH ROW
EXECUTE FUNCTION trg_descontar_insumo_usado();


-- TRIGGER 3: Verificar que hay stock suficiente ANTES de usar un insumo.
CREATE OR REPLACE FUNCTION trg_verificar_stock_antes_de_uso()
RETURNS TRIGGER AS $$
DECLARE
    v_stock_actual INTEGER;
    v_id_hospital INTEGER;
BEGIN
    SELECT id_hospital INTO v_id_hospital FROM Evento_Clinico WHERE id_evento = NEW.id_evento;

    SELECT cantidad INTO v_stock_actual
    FROM Inventario
    WHERE id_hospital = v_id_hospital AND id_insumo = NEW.id_insumo;

    IF v_stock_actual IS NULL OR v_stock_actual < NEW.cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para el insumo ID %. Solicitado: %, Disponible: %', NEW.id_insumo, NEW.cantidad, COALESCE(v_stock_actual, 0);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insumo_usado
BEFORE INSERT ON Evento_Usa_Insumo
FOR EACH ROW
EXECUTE FUNCTION trg_verificar_stock_antes_de_uso();


-- TRIGGER 4: Actualizar el número total de camas de un hospital (atributo derivado).
CREATE OR REPLACE FUNCTION trg_actualizar_num_camas()
RETURNS TRIGGER AS $$
DECLARE
    v_id_hospital INTEGER;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_id_hospital := OLD.id_hospital;
    ELSE
        v_id_hospital := NEW.id_hospital;
    END IF;

    UPDATE Hospital
    SET num_camas = (
        SELECT COALESCE(SUM(h.num_camas), 0)
        FROM Habitacion h
        WHERE h.id_hospital = v_id_hospital
    )
    WHERE id_hospital = v_id_hospital;

    RETURN NULL; -- El resultado es ignorado para triggers AFTER
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_habitacion_change
AFTER INSERT OR UPDATE OR DELETE ON Habitacion
FOR EACH ROW
EXECUTE FUNCTION trg_actualizar_num_camas();

-- TRIGGER 5: Calcular el total de la factura automáticamente.
CREATE OR REPLACE FUNCTION trg_calcular_total_factura()
RETURNS TRIGGER AS $$
BEGIN
    NEW.total := NEW.subtotal + NEW.iva;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_factura_insert_update
BEFORE INSERT OR UPDATE ON Factura
FOR EACH ROW
EXECUTE FUNCTION trg_calcular_total_factura();


-- TRIGGER 6: Actualizar el estado de la factura a 'Pagada' cuando el monto cubierto es suficiente.
CREATE OR REPLACE FUNCTION trg_actualizar_estado_factura_pago()
RETURNS TRIGGER AS $$
DECLARE
    v_total_factura NUMERIC;
    v_total_pagado NUMERIC;
BEGIN
    -- Calcular el total de la factura
    SELECT total INTO v_total_factura FROM Factura WHERE id_factura = NEW.id_factura;
    
    -- Calcular el total pagado hasta ahora para esa factura (incluyendo este nuevo pago)
    SELECT COALESCE(SUM(monto_cubierto), 0) INTO v_total_pagado 
    FROM Pago_Seguro 
    WHERE id_factura = NEW.id_factura;

    IF v_total_pagado >= v_total_factura THEN
        UPDATE Factura
        SET estado = 'Pagada'
        WHERE id_factura = NEW.id_factura;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_pago_realizado
AFTER INSERT ON Pago_Seguro
FOR EACH ROW
EXECUTE FUNCTION trg_actualizar_estado_factura_pago();
