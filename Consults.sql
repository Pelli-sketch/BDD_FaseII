/*
 * SCRIPT DE CONSULTAS SQL
 * Responde a los requerimientos de consulta del proyecto.
 */

-- A. Obtener los nombres de los pacientes asegurados atendidos por médicos que han tenido más de un cargo en el hospital.
SELECT DISTINCT p.nombre, p.apellido
FROM Persona p
JOIN Paciente pa ON p.ci = pa.ci_paciente
JOIN Afiliacion_Seguro afs ON pa.ci_paciente = afs.ci_paciente
JOIN Evento_Clinico ec ON pa.ci_paciente = ec.ci_paciente
WHERE ec.ci_medico IN (
    -- Subconsulta para obtener los médicos con más de un cargo registrado
    SELECT ci_personal
    FROM Cargo_Historial
    GROUP BY ci_personal
    HAVING COUNT(id_cargo) > 1
);
-- PRUEBA: Debería listar a Juan Castro, Elena Silva, Ricardo Paez, etc., si fueron atendidos por Carlos Gomez (CI V101).


-- B. Listar los hospitales que hayan facturado más de $1000.
SELECT h.nombre, SUM(f.total) AS facturacion_total
FROM Hospital h
JOIN Evento_Clinico ec ON h.id_hospital = ec.id_hospital
JOIN Factura f ON ec.id_evento = f.id_evento
GROUP BY h.id_hospital, h.nombre
HAVING SUM(f.total) > 1000;
-- PRUEBA: Debería listar al 'Centro Médico Valencia' y 'Hospital Metropolitano Central' debido a las operaciones costosas.


-- C. Top 2 de médicos con más procedimientos realizados que el promedio.
WITH ConteoProcedimientos AS (
    SELECT ci_medico, COUNT(id_evento) as num_procedimientos
    FROM Evento_Clinico
    GROUP BY ci_medico
),
PromedioGlobal AS (
    SELECT AVG(num_procedimientos) as promedio
    FROM ConteoProcedimientos
)
SELECT p.nombre, p.apellido, cp.num_procedimientos
FROM ConteoProcedimientos cp
JOIN Persona p ON cp.ci_medico = p.ci
WHERE cp.num_procedimientos > (SELECT promedio FROM PromedioGlobal)
ORDER BY cp.num_procedimientos DESC
LIMIT 2;
-- PRUEBA: Dependerá de la distribución de eventos en los datos, pero buscará a los médicos más activos.


-- D. Listar los trabajadores que han sido responsables de encargos a proveedores de "Valencia".
SELECT DISTINCT p.nombre, p.apellido
FROM Persona p
JOIN Personal pe ON p.ci = pe.ci_personal
JOIN Encargo e ON pe.ci_personal = e.ci_responsable
JOIN Proveedor pr ON e.id_proveedor = pr.id_proveedor
WHERE pr.ciudad = 'Valencia';
-- PRUEBA: Debería listar a Laura Lopez (CI V106), que gestionó encargos para el proveedor 'Equipos Médicos de Venezuela C.A.' y 'Pfizer' de Valencia.


-- E. Listar los procedimientos que necesiten instrumental que ha sido encargado en el último mes.
SELECT ec.id_evento, ec.tipo, ec.descripcion, p.nombre AS paciente
FROM Evento_Clinico ec
JOIN Evento_Usa_Insumo eui ON ec.id_evento = eui.id_evento
JOIN Insumo_Medico im ON eui.id_insumo = im.id_insumo
JOIN Persona p ON ec.ci_paciente = p.ci
WHERE im.tipo = 'Instrumental' AND eui.id_insumo IN (
    -- Subconsulta para obtener insumos encargados en el último mes
    SELECT DISTINCT ed.id_insumo
    FROM Encargo_Detalle ed
    JOIN Encargo en ON ed.id_encargo = en.id_encargo
    WHERE en.fecha_encargo >= (CURRENT_DATE - INTERVAL '1 month')
);
-- PRUEBA: Listaría el evento 5 (operación) si el encargo de 'Monitor Cardíaco' se hizo en el último mes.


-- F. Departamentos que tengan más horas de trabajo que el promedio.
WITH HorasPorDepto AS (
    SELECT
        p.id_hospital_actual,
        p.numero_departamento_actual,
        SUM(EXTRACT(EPOCH FROM (ht.hora_salida - ht.hora_entrada)) / 3600) AS horas_semanales_totales
    FROM Horario_Trabajo ht
    JOIN Personal p ON ht.ci_personal = p.ci_personal
    WHERE p.id_hospital_actual IS NOT NULL
    GROUP BY p.id_hospital_actual, p.numero_departamento_actual
),
PromedioHoras AS (
    SELECT AVG(horas_semanales_totales) as promedio_general
    FROM HorasPorDepto
)
SELECT h.nombre AS hospital, d.nombre AS departamento, hpd.horas_semanales_totales
FROM HorasPorDepto hpd
JOIN Departamento d ON hpd.id_hospital_actual = d.id_hospital AND hpd.numero_departamento_actual = d.numero_departamento
JOIN Hospital h ON hpd.id_hospital_actual = h.id_hospital
WHERE hpd.horas_semanales_totales > (SELECT promedio_general FROM PromedioHoras);
-- PRUEBA: Listará los departamentos con más personal o con jornadas más largas, superando la media.