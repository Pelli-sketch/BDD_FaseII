

-- A. Pacientes asegurados de médicos con >1 cargo/departamento.
SELECT DISTINCT p.nombre, p.apellido
FROM Persona p
JOIN Paciente pa ON p.ci = pa.ci
JOIN Seguro_Medico sm ON pa.ci = sm.ci_paciente
WHERE pa.ci IN (
    SELECT DISTINCT c.ci_paciente FROM Consulta c
    WHERE c.ci_medico IN (SELECT ci_personal FROM Asignado_A GROUP BY ci_personal HAVING COUNT(*) > 1)
    UNION
    SELECT DISTINCT o.ci_paciente FROM Operacion o
    WHERE o.ci_med IN (SELECT ci_personal FROM Asignado_A GROUP BY ci_personal HAVING COUNT(*) > 1)
);

-- B. Hospitales que hayan facturado más de $1000.
SELECT h.nombre, SUM(f.monto) as facturacion_total
FROM Hospital h
JOIN Departamento d ON h.id_hospital = d.id_hospital
JOIN Asignado_A aa ON d.id_departamento = aa.id_departamento
JOIN Administrativo a ON aa.ci_personal = a.ci
JOIN Emitida e ON a.ci = e.ci_administrativo
JOIN Factura f ON e.num_factura = f.num_factura
GROUP BY h.nombre
HAVING SUM(f.monto) > 1000;

-- C. Top 2 de médicos con más procedimientos realizados que el promedio.
WITH MedicoProcedimientos AS (
    SELECT ci_medico AS ci, COUNT(*) as num_procedimientos FROM Consulta GROUP BY ci_medico
    UNION ALL
    SELECT ci_med AS ci, COUNT(*) as num_procedimientos FROM Operacion GROUP BY ci_med
),
TotalProcedimientos AS (
    SELECT ci, SUM(num_procedimientos) as total_procs FROM MedicoProcedimientos GROUP BY ci
)
SELECT p.nombre, p.apellido, tp.total_procs
FROM TotalProcedimientos tp
JOIN Persona p ON tp.ci = p.ci
WHERE tp.total_procs > (SELECT AVG(total_procs) FROM TotalProcedimientos)
ORDER BY tp.total_procs DESC
LIMIT 2;

-- D. Trabajadores responsables de encargos a proveedores de "Valencia".
SELECT DISTINCT p.nombre, p.apellido
FROM Persona p
JOIN Encargo e ON p.ci = e.ci_resp
JOIN Proveedor pr ON e.nombre_compania = pr.nombre_compania
WHERE pr.ciudad_prov = 'Valencia';

-- E. Procedimientos que necesiten instrumental encargado en el último mes.
SELECT proc.nombre
FROM Procedimiento proc
JOIN Necesitan n ON proc.id_procedimiento = n.id_procedimiento
JOIN Insumo_Medico im ON n.id_insumo = im.id_insumo
WHERE im.tipo_insumo = 'Instrumental' AND n.id_insumo IN (
    SELECT id_insumo FROM Encargo WHERE fecha >= (CURRENT_DATE - INTERVAL '1 month')
);

-- F. Departamentos que tengan más horas de trabajo que el promedio.
WITH HorasPorDepto AS (
    SELECT
        a.id_departamento,
        COUNT(te.ci_personal) * (EXTRACT(EPOCH FROM (h.hora_finalizacion - h.hora_comienzo)) / 3600) AS horas_totales
    FROM Horario_de_Atencion h
    JOIN Trabaja_En te ON h.id_horario = te.id_horario
    JOIN Asignado_A a ON te.ci_personal = a.ci_personal
    GROUP BY a.id_departamento, h.hora_finalizacion, h.hora_comienzo
),
SumaHorasDepto AS (
    SELECT id_departamento, SUM(horas_totales) as total_horas
    FROM HorasPorDepto GROUP BY id_departamento
)
SELECT h.nombre as hospital, d.nombre as departamento, shd.total_horas
FROM SumaHorasDepto shd
JOIN Departamento d ON shd.id_departamento = d.id_departamento
JOIN Hospital h ON d.id_hospital = h.id_hospital
WHERE shd.total_horas > (SELECT AVG(total_horas) FROM SumaHorasDepto);
