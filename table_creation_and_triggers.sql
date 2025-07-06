/*
 * SCRIPT DE CREACIÓN DE TABLAS Y TRIGGERS PARA GESTIÓN HOSPITALARIA (PostgreSQL)
 * Modelo optimizado y normalizado basado en el análisis de los requerimientos.
 */

-- Limpieza inicial en orden inverso de dependencias
DROP TABLE IF EXISTS Pago_Seguro;
DROP TABLE IF EXISTS Factura;
DROP TABLE IF EXISTS Evento_Usa_Insumo;
DROP TABLE IF EXISTS Evento_Clinico;
DROP TABLE IF EXISTS Encargo_Detalle;
DROP TABLE IF EXISTS Encargo;
DROP TABLE IF EXISTS Proveedor_Suministra;
DROP TABLE IF EXISTS Inventario;
DROP TABLE IF EXISTS Insumo_Medico;
DROP TABLE IF EXISTS Proveedor;
DROP TABLE IF EXISTS Afiliacion_Seguro;
DROP TABLE IF EXISTS Aseguradora;
DROP TABLE IF EXISTS Historial_Medico;
DROP TABLE IF EXISTS Paciente;
DROP TABLE IF EXISTS Cargo_Historial;
DROP TABLE IF EXISTS Horario_Trabajo;
DROP TABLE IF EXISTS Telefono_Personal;
DROP TABLE IF EXISTS Personal;
DROP TABLE IF EXISTS Persona;
DROP TABLE IF EXISTS Telefono_Departamento;
DROP TABLE IF EXISTS Habitacion;
DROP TABLE IF EXISTS Departamento;
DROP TABLE IF EXISTS Hospital;

-- ========= ENTIDADES FUERTES Y PRINCIPALES =========

CREATE TABLE Hospital (
    id_hospital SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    direccion TEXT NOT NULL,
    num_camas INTEGER NOT NULL DEFAULT 0 -- Atributo derivado, gestionado por trigger
);

CREATE TABLE Persona (
    ci TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    direccion TEXT NOT NULL,
    sexo CHAR(1) NOT NULL CHECK (sexo IN ('M', 'F'))
);

CREATE TABLE Aseguradora (
    id_aseguradora SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    direccion TEXT,
    telefono TEXT
);

CREATE TABLE Proveedor (
    id_proveedor SERIAL PRIMARY KEY,
    nombre_empresa TEXT NOT NULL UNIQUE,
    direccion TEXT,
    ciudad TEXT,
    telefono TEXT,
    email TEXT UNIQUE
);

CREATE TABLE Insumo_Medico (
    id_insumo SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    tipo TEXT NOT NULL CHECK (tipo IN ('Medicamento', 'Instrumental', 'Suministro', 'Equipo')),
    -- Atributos adicionales para especializaciones
    unidad_medida TEXT,
    fecha_vencimiento DATE, -- Solo para Medicamentos
    material TEXT -- Solo para Instrumental
);

-- ========= ENTIDADES DÉBILES Y ESPECIALIZACIONES =========

CREATE TABLE Departamento (
    numero_departamento INTEGER NOT NULL,
    id_hospital INTEGER NOT NULL,
    nombre TEXT NOT NULL,
    piso INTEGER NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('Medico', 'Administrativo', 'Apoyo')),
    PRIMARY KEY (id_hospital, numero_departamento),
    FOREIGN KEY (id_hospital) REFERENCES Hospital(id_hospital) ON DELETE CASCADE
);

CREATE TABLE Habitacion (
    id_habitacion SERIAL PRIMARY KEY,
    numero_habitacion INTEGER NOT NULL,
    id_hospital INTEGER NOT NULL,
    numero_departamento INTEGER NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('Individual', 'Doble', 'Suite')),
    num_camas INTEGER NOT NULL CHECK (num_camas > 0),
    tarifa_dia NUMERIC(10, 2) NOT NULL CHECK (tarifa_dia >= 0),
    ocupada BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_hospital, numero_departamento) REFERENCES Departamento(id_hospital, numero_departamento) ON DELETE CASCADE,
    UNIQUE (id_hospital, numero_departamento, numero_habitacion)
);

CREATE TABLE Personal (
    ci_personal TEXT PRIMARY KEY,
    fecha_contratacion DATE NOT NULL,
    salario NUMERIC(10, 2) NOT NULL CHECK (salario >= 0),
    tipo TEXT NOT NULL CHECK (tipo IN ('Medico', 'Administrativo')),
    especialidad TEXT, -- Solo para Medicos
    id_hospital_actual INTEGER,
    numero_departamento_actual INTEGER,
    FOREIGN KEY (ci_personal) REFERENCES Persona(ci) ON DELETE CASCADE,
    FOREIGN KEY (id_hospital_actual, numero_departamento_actual) REFERENCES Departamento(id_hospital, numero_departamento) ON DELETE SET NULL,
    CHECK ((tipo = 'Medico' AND especialidad IS NOT NULL) OR (tipo <> 'Medico' AND especialidad IS NULL))
);

CREATE TABLE Paciente (
    ci_paciente TEXT PRIMARY KEY,
    telefono TEXT,
    contacto_emergencia TEXT,
    telefono_emergencia TEXT,
    responsable_nombre TEXT, -- Para menores de edad
    responsable_telefono TEXT,
    FOREIGN KEY (ci_paciente) REFERENCES Persona(ci) ON DELETE CASCADE
);

-- ========= TABLAS PARA ATRIBUTOS MULTIVALUADOS =========

CREATE TABLE Telefono_Personal (
    ci_personal TEXT NOT NULL,
    telefono TEXT NOT NULL,
    PRIMARY KEY (ci_personal, telefono),
    FOREIGN KEY (ci_personal) REFERENCES Personal(ci_personal) ON DELETE CASCADE
);

CREATE TABLE Telefono_Departamento (
    id_hospital INTEGER NOT NULL,
    numero_departamento INTEGER NOT NULL,
    telefono TEXT NOT NULL,
    PRIMARY KEY (id_hospital, numero_departamento, telefono),
    FOREIGN KEY (id_hospital, numero_departamento) REFERENCES Departamento(id_hospital, numero_departamento) ON DELETE CASCADE
);

CREATE TABLE Horario_Trabajo (
    id_horario SERIAL PRIMARY KEY,
    ci_personal TEXT NOT NULL,
    dia_semana TEXT NOT NULL CHECK (dia_semana IN ('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')),
    hora_entrada TIME NOT NULL,
    hora_salida TIME NOT NULL,
    FOREIGN KEY (ci_personal) REFERENCES Personal(ci_personal) ON DELETE CASCADE
);

CREATE TABLE Historial_Medico (
    id_historial SERIAL PRIMARY KEY,
    ci_paciente TEXT NOT NULL,
    fecha DATE NOT NULL,
    tipo TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    FOREIGN KEY (ci_paciente) REFERENCES Paciente(ci_paciente) ON DELETE CASCADE
);

-- ========= TABLAS DE RELACIONES Y TRANSACCIONES =========

CREATE TABLE Cargo_Historial (
    id_cargo SERIAL PRIMARY KEY,
    ci_personal TEXT NOT NULL,
    cargo TEXT NOT NULL,
    id_hospital INTEGER NOT NULL,
    numero_departamento INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    FOREIGN KEY (ci_personal) REFERENCES Personal(ci_personal) ON DELETE CASCADE,
    FOREIGN KEY (id_hospital, numero_departamento) REFERENCES Departamento(id_hospital, numero_departamento) ON DELETE CASCADE
);

CREATE TABLE Inventario (
    id_hospital INTEGER NOT NULL,
    id_insumo INTEGER NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 0 CHECK (cantidad >= 0),
    stock_minimo INTEGER NOT NULL DEFAULT 10,
    PRIMARY KEY (id_hospital, id_insumo),
    FOREIGN KEY (id_hospital) REFERENCES Hospital(id_hospital) ON DELETE CASCADE,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico(id_insumo) ON DELETE CASCADE
);

CREATE TABLE Proveedor_Suministra (
    id_proveedor INTEGER NOT NULL,
    id_insumo INTEGER NOT NULL,
    precio_unitario NUMERIC(10, 2) NOT NULL CHECK (precio_unitario > 0),
    PRIMARY KEY (id_proveedor, id_insumo),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor) ON DELETE CASCADE,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico(id_insumo) ON DELETE CASCADE
);

CREATE TABLE Encargo (
    id_encargo SERIAL PRIMARY KEY,
    id_hospital INTEGER NOT NULL,
    id_proveedor INTEGER NOT NULL,
    ci_responsable TEXT NOT NULL,
    fecha_encargo DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_recepcion DATE,
    estado TEXT NOT NULL DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'Recibido', 'Cancelado')),
    FOREIGN KEY (id_hospital) REFERENCES Hospital(id_hospital) ON DELETE RESTRICT,
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor) ON DELETE RESTRICT,
    FOREIGN KEY (ci_responsable) REFERENCES Personal(ci_personal) ON DELETE RESTRICT
);

CREATE TABLE Encargo_Detalle (
    id_encargo INTEGER NOT NULL,
    id_insumo INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10, 2) NOT NULL CHECK (precio_unitario >= 0),
    PRIMARY KEY (id_encargo, id_insumo),
    FOREIGN KEY (id_encargo) REFERENCES Encargo(id_encargo) ON DELETE CASCADE,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico(id_insumo) ON DELETE RESTRICT
);

CREATE TABLE Evento_Clinico (
    id_evento SERIAL PRIMARY KEY,
    tipo TEXT NOT NULL CHECK (tipo IN ('Consulta', 'Operacion', 'Procedimiento')),
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    descripcion TEXT,
    costo NUMERIC(10, 2) NOT NULL DEFAULT 0 CHECK (costo >= 0),
    ci_paciente TEXT NOT NULL,
    ci_medico TEXT NOT NULL,
    id_hospital INTEGER NOT NULL,
    id_habitacion INTEGER, -- Puede ser una consulta ambulatoria
    FOREIGN KEY (ci_paciente) REFERENCES Paciente(ci_paciente) ON DELETE RESTRICT,
    FOREIGN KEY (ci_medico) REFERENCES Personal(ci_personal) ON DELETE RESTRICT,
    FOREIGN KEY (id_hospital) REFERENCES Hospital(id_hospital) ON DELETE RESTRICT,
    FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion) ON DELETE SET NULL
);

CREATE TABLE Evento_Usa_Insumo (
    id_evento INTEGER NOT NULL,
    id_insumo INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (id_evento, id_insumo),
    FOREIGN KEY (id_evento) REFERENCES Evento_Clinico(id_evento) ON DELETE CASCADE,
    FOREIGN KEY (id_insumo) REFERENCES Insumo_Medico(id_insumo) ON DELETE RESTRICT
);

CREATE TABLE Afiliacion_Seguro (
    id_afiliacion SERIAL PRIMARY KEY,
    numero_poliza TEXT NOT NULL UNIQUE,
    ci_paciente TEXT NOT NULL,
    id_aseguradora INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    monto_cobertura NUMERIC(12, 2) CHECK (monto_cobertura >= 0),
    FOREIGN KEY (ci_paciente) REFERENCES Paciente(ci_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_aseguradora) REFERENCES Aseguradora(id_aseguradora) ON DELETE RESTRICT
);

CREATE TABLE Factura (
    id_factura SERIAL PRIMARY KEY,
    id_evento INTEGER NOT NULL UNIQUE, -- Una factura por evento
    fecha_emision DATE NOT NULL DEFAULT CURRENT_DATE,
    subtotal NUMERIC(10, 2) NOT NULL,
    iva NUMERIC(10, 2) NOT NULL DEFAULT 0,
    total NUMERIC(10, 2) NOT NULL,
    estado TEXT NOT NULL DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'Pagada', 'Anulada')),
    metodo_pago TEXT CHECK (metodo_pago IN ('Efectivo', 'Tarjeta', 'Seguro', 'Mixto')),
    FOREIGN KEY (id_evento) REFERENCES Evento_Clinico(id_evento) ON DELETE RESTRICT
);

CREATE TABLE Pago_Seguro (
    id_pago SERIAL PRIMARY KEY,
    id_factura INTEGER NOT NULL,
    id_afiliacion INTEGER NOT NULL,
    monto_cubierto NUMERIC(10, 2) NOT NULL,
    fecha_pago DATE NOT NULL DEFAULT CURRENT_DATE,
    numero_autorizacion TEXT UNIQUE,
    FOREIGN KEY (id_factura) REFERENCES Factura(id_factura) ON DELETE RESTRICT,
    FOREIGN KEY (id_afiliacion) REFERENCES Afiliacion_Seguro(id_afiliacion) ON DELETE RESTRICT
);


-- ========================= TRIGGERS =========================

-- TRIGGER 1: Actualizar el stock de un insumo en un hospital al recibir un encargo.
CREATE OR REPLACE FUNCTION trg_actualizar_stock_al_recibir()
RETURNS TRIGGER AS $$
DECLARE
    v_id_hospital INTEGER;
BEGIN
    IF NEW.estado = 'Recibido' AND OLD.estado <> 'Recibido' THEN
        -- Obtener el hospital del encargo
        SELECT id_hospital INTO v_id_hospital FROM Encargo WHERE id_encargo = NEW.id_encargo;

        -- Actualizar el inventario para cada item en el detalle del encargo
        INSERT INTO Inventario (id_hospital, id_insumo, cantidad)
        SELECT v_id_hospital, id_insumo, cantidad
        FROM Encargo_Detalle
        WHERE id_encargo = NEW.id_encargo
        ON CONFLICT (id_hospital, id_insumo) DO UPDATE
        SET cantidad = Inventario.cantidad + EXCLUDED.cantidad;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_encargo_recibido
AFTER UPDATE ON Encargo
FOR EACH ROW
EXECUTE FUNCTION trg_actualizar_stock_al_recibir();


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