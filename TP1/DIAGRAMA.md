erDiagram
    CATEGORIA ||--o{ PRODUCTO : "agrupa"
    USUARIO ||--o{ PEDIDO : "realiza"
    PEDIDO ||--|{ DETALLE_PEDIDO : "contiene"
    PRODUCTO ||--o{ DETALLE_PEDIDO : "figura en"

    CATEGORIA {
        BIGINT id PK
        VARCHAR nombre
        BOOLEAN eliminado
    }
    
    PRODUCTO {
        BIGINT id PK
        VARCHAR nombre
        NUMERIC precio
        INTEGER stock
        BOOLEAN disponible
        BOOLEAN eliminado
        BIGINT categoria_id FK
    }
    
    USUARIO {
        BIGINT id PK
        VARCHAR nombre
        VARCHAR apellido
        VARCHAR mail
        BOOLEAN eliminado
        TIMESTAMPTZ created_at
    }
    
    PEDIDO {
        BIGINT id PK
        DATE fecha
        NUMERIC total
        VARCHAR estado
        VARCHAR forma_pago
        BOOLEAN eliminado
        BIGINT usuario_id FK
    }
    
    DETALLE_PEDIDO {
        BIGINT pedido_id PK, FK
        BIGINT producto_id PK, FK
        INTEGER cantidad
        NUMERIC precio_unitario
        NUMERIC subtotal
        BOOLEAN eliminado
    }