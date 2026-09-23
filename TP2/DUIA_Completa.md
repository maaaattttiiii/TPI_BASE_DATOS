# Declaración de Uso de IA (DUIA) - Unidad 1 Práctica 2

### Parte 1: Restricciones
Herramienta: OpenCode.
Spec: "Necesito una restricción en PostgreSQL para evitar que el estado de un pedido vuelva de CONFIRMADA a PENDIENTE, y un procedimiento transaccional para descontar stock."
Decisión: Se aceptó el uso de `FOR UPDATE` para bloquear filas atómicamente.

### Parte 2 y 3: Concurrencia y Riesgos
Herramienta: Kiro.
Spec: "Explicar Lectura no repetible y el comportamiento de NOT IN con valores nulos."
Decisión: Se utilizaron las explicaciones de Kiro para formular los informes de escenarios, validando los niveles de aislamiento directamente en la consola `psql`.