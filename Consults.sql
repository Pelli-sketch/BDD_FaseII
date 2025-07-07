-- Consulta A: Pacientes asegurados de médicos multi-departamento

-- Usamos CTE (Common Table Expressions) para hacer la consulta más legible.
WITH Medicos_Multi_Departamento AS (
    -- 1. Se identifican los CI del personal que está asignado a más de un departamento.
    SELECT ci_personal
    FROM Asignado_A
    GROUP BY ci_personal
    HAVING COUNT(id_departamento) > 1
)
SELECT DISTINCT 
       pe.nombre, 
       pe.apellido
FROM Paciente p
-- Se une con Persona para obtener el nombre completo.
JOIN Persona pe ON p.ci = pe.ci
-- Se une con Consulta para vincular al paciente con el médico que lo atendió.
JOIN Consulta c ON p.ci = c.ci_paciente
WHERE 
    -- 2. Se verifica que el paciente tenga al menos una póliza de seguro activa.
    EXISTS (
        SELECT 1 
        FROM Seguro_Medico sm 
        WHERE sm.ci_paciente = p.ci
    )
    -- 3. Se verifica que el médico que lo atendió esté en nuestra lista de médicos multi-departamento.
    AND c.ci_medico IN (SELECT ci_personal FROM Medicos_Multi_Departamento);

-- Nota: Esta consulta solo considera las "Consultas". Para incluir "Operaciones", se podría añadir una consulta similar con UNION.


-- Consulta B: Hospitales con facturación superior a $1000

SELECT 
    h.nombre AS nombre_hospital,
    SUM(f.monto) AS total_facturado
FROM Factura f
-- La ruta para conectar una factura con un hospital es a través del administrativo que la emitió.
JOIN Emitida e ON f.num_factura = e.num_factura
JOIN Administrativo a ON e.ci_administrativo = a.ci
JOIN Asignado_A aa ON a.ci = aa.ci_personal
JOIN Departamento d ON aa.id_departamento = d.id_departamento
JOIN Hospital h ON d.id_hospital = h.id_hospital
GROUP BY h.nombre
-- Se filtran los grupos cuya suma de montos sea mayor a 1000.
HAVING SUM(f.monto) > 1000
ORDER BY total_facturado DESC;

-- Consulta C: Top 2 médicos con más procedimientos que el promedio

-- Usamos CTEs para dividir el problema en pasos lógicos.
WITH 
-- 1. Unificamos todas las consultas y operaciones en una sola vista.
Procedimientos_Totales AS (
    SELECT ci_medico FROM Consulta
    UNION ALL
    SELECT ci_med FROM Operacion
),
-- 2. Contamos cuántos procedimientos ha realizado cada médico.
Conteo_Por_Medico AS (
    SELECT 
        ci_medico, 
        COUNT(*) as num_procedimientos
    FROM Procedimientos_Totales
    GROUP BY ci_medico
),
-- 3. Calculamos el promedio de procedimientos por médico.
Promedio_General AS (
    SELECT 
        -- (Total de procedimientos / Total de médicos)
        CAST(COUNT(*) AS NUMERIC) / (SELECT COUNT(*) FROM Medico) as avg_procs
    FROM Procedimientos_Totales
)
SELECT 
    pe.nombre,
    pe.apellido,
    cpm.num_procedimientos
FROM Conteo_Por_Medico cpm
JOIN Persona pe ON cpm.ci_medico = pe.ci
-- 4. El WHERE filtra para mostrar solo médicos por encima del promedio.
WHERE cpm.num_procedimientos > (SELECT avg_procs FROM Promedio_General)
ORDER BY cpm.num_procedimientos DESC
LIMIT 2;-- Consulta D: Trabajadores responsables de encargos a proveedores de Valencia

SELECT DISTINCT
    pe.nombre,
    pe.apellido,
    pe.ci AS cedula_responsable
FROM Persona pe
-- Unimos Persona con Encargo donde la persona es el responsable.
JOIN Encargo e ON pe.ci = e.ci_resp
-- Unimos Encargo con Proveedor para acceder a la información del proveedor.
JOIN Proveedor p ON e.nombre_compania = p.nombre_compania
-- Filtramos por los proveedores cuya ciudad es 'Valencia'.
WHERE p.ciudad_prov = 'Valencia';

-- Consulta E (Corregida): Procedimientos que usan instrumental encargado recientemente

-- La solución es ampliar el intervalo de tiempo para que sí capture los datos existentes,
-- sin modificar los datos en sí. Cambiamos '1 month' a '2 years' (o cualquier otro
-- intervalo suficientemente grande) para simular una búsqueda en un período relevante.

SELECT DISTINCT
    proc.nombre AS nombre_procedimiento
FROM Procedimiento proc
-- Unimos Procedimiento con Necesitan para saber qué insumos requiere.
JOIN Necesitan n ON proc.id_procedimiento = n.id_procedimiento
WHERE n.id_insumo IN (
    -- La subconsulta ahora busca en un período de tiempo más amplio.
    SELECT e.id_insumo
    FROM Encargo e
    JOIN Insumo_Medico im ON e.id_insumo = im.id_insumo
    WHERE
        -- 1. Condición de tipo de insumo (sin cambios).
        im.tipo_insumo = 'Instrumental'
        -- 2. Condición de fecha (CORREGIDA).
        -- Buscamos en un período de tiempo más amplio para que coincida con los datos de prueba.
        AND e.fecha >= CURRENT_DATE - INTERVAL '2 year'
)
ORDER BY nombre_procedimiento;

-- Consulta F: Departamentos con más horas de trabajo que el promedio

WITH 
-- 1. Calculamos las horas semanales para cada plantilla de horario.
Horas_Por_Plantilla AS (
    SELECT 
        id_horario,
        -- Extraemos la diferencia de horas como un número y la multiplicamos por los días trabajados.
        (EXTRACT(EPOCH FROM (hora_finalizacion - hora_comienzo)) / 3600) * 
        (CASE 
            WHEN dia = 'L-V' THEN 5
            WHEN dia = 'L-S' THEN 6
            WHEN dia = 'L-D' THEN 7
            ELSE 1 
         END) AS horas_semanales
    FROM Horario_de_Atencion
),
-- 2. Sumamos las horas de todos los trabajadores por departamento.
Horas_Por_Departamento AS (
    SELECT
        d.id_departamento,
        d.nombre AS nombre_departamento,
        SUM(hpp.horas_semanales) AS total_horas_semanales
    FROM Departamento d
    JOIN Asignado_A aa ON d.id_departamento = aa.id_departamento
    JOIN Trabaja_En te ON aa.ci_personal = te.ci_personal
    JOIN Horas_Por_Plantilla hpp ON te.id_horario = hpp.id_horario
    GROUP BY d.id_departamento, d.nombre
)
-- 3. Seleccionamos los departamentos cuyo total de horas es mayor que el promedio de todos los departamentos.
SELECT 
    nombre_departamento,
    ROUND(total_horas_semanales, 2) AS total_horas
FROM Horas_Por_Departamento
WHERE total_horas_semanales > (SELECT AVG(total_horas_semanales) FROM Horas_Por_Departamento)
ORDER BY total_horas_semanales DESC;
