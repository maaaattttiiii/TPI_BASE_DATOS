# Laboratorio de Concurrencia

## Escenario 1: Espera por Bloqueo
Cómo se reprodujo: 
  Sesión A: `BEGIN; SELECT stock FROM producto WHERE id = 1 FOR UPDATE;`
  Sesión B: `UPDATE producto SET stock = stock - 1 WHERE id = 1;`
Qué se observó: La Sesión B quedó congelada esperando liberación.
Explicación IA / Verificación: El motor utiliza MVCC y bloqueos explícitos a nivel de fila (`RowShareLock`). Hasta que A no haga `COMMIT`, B no puede escribir. Se verificó correctamente.

## Escenario 2: Lectura no repetible
Cómo se reprodujo:
  Sesión A: `BEGIN; SELECT precio FROM producto WHERE id = 1;` (Da 1000)
  Sesión B: `UPDATE producto SET precio = 1500 WHERE id = 1; COMMIT;`
  Sesión A: Vuelve a ejecutar el `SELECT` y lee 1500 dentro de la misma transacción.
Explicación IA / Verificación: En `READ COMMITTED`, cada sentencia ve los datos confirmados más recientes. Se evita cambiando a `SET TRANSACTION ISOLATION LEVEL REPEATABLE READ`. Al verificarlo en el motor, la Sesión A retuvo el valor 1000 original.

## Escenario 3: Lectura fantasma
Cómo se reprodujo:
  Sesión A: `BEGIN; SELECT COUNT(*) FROM pedido;` (Da 10)
  Sesión B: `INSERT INTO pedido (usuario_id, forma_pago) VALUES (1, 'EFECTIVO'); COMMIT;`
  Sesión A: Repite el `COUNT(*)` y obtiene 11.
Explicación IA / Verificación: Las inserciones rompen las agregaciones. En PostgreSQL, usar `REPEATABLE READ` o superior congela el snapshot completo y previene esto. Comprobado.