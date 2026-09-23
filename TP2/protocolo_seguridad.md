# Protocolo de Seguridad de Datos

1. Copia:Todo script generado por OpenCode o Kiro se prueba primero en una base de desarrollo aislada (`createdb -T foodstore_template foodstore_dev`), nunca sobre los datos reales.
2. Transacción: Toda escritura o modificación se envuelve obligatoriamente en un bloque `BEGIN; ... ROLLBACK;` para auditar los mensajes del motor y las filas afectadas antes de ejecutar el `COMMIT` final.
3. Respaldo:Antes de aplicar cambios estructurales (DDL como `ALTER` o `DROP`), se realiza un `pg_dump` de la copia de trabajo para garantizar un punto de restauración seguro e independiente.