# Ejercicio de Lectura Crítica

## Script 1: UPDATE funcion SET activa = FALSE;
Efecto real: Al no tener una cláusula `WHERE`, este script genera un Table Scan y da de baja TODAS las funciones de la tabla, destruyendo la cartelera activa completa.
Versión corregida:
`UPDATE funcion SET activa = FALSE WHERE fecha_emision < CURRENT_DATE;`

## Script 2: DELETE FROM categoria WHERE id NOT IN (SELECT categoria_id FROM producto);
Efecto real:Si la subconsulta retorna un solo valor `NULL` (ej: un producto temporal sin categoría), el operador `NOT IN` evalúa la condición como "Desconocida". El resultado es que no se borra nada, fallando silenciosamente.
Versión corregida:
`DELETE FROM categoria WHERE id NOT IN (SELECT categoria_id FROM producto WHERE categoria_id IS NOT NULL);`