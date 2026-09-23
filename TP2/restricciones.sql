-- Regla de negocio 1: Evitar sobreventa de stock usando transacciones atómicas
CREATE OR REPLACE PROCEDURE sp_crear_pedido(
    p_usuario_id BIGINT, p_forma_pago forma_pago, p_items JSONB
) AS $$ DECLARE     v_pedido_id BIGINT; v_item JSONB; v_producto_id BIGINT;     v_cantidad INTEGER; v_stock INTEGER; BEGIN     INSERT INTO pedido (usuario_id, forma_pago) VALUES (p_usuario_id, p_forma_pago)     RETURNING id INTO v_pedido_id;      FOR v_item IN SELECT * FROM jsonb_array_elements(p_items) LOOP         v_producto_id := (v_item->>'producto_id')::BIGINT;         v_cantidad    := (v_item->>'cantidad')::INTEGER;          -- Bloqueo explícito de la fila para evitar concurrencia         SELECT stock INTO v_stock FROM producto          WHERE id = v_producto_id AND eliminado = FALSE FOR UPDATE;          IF v_stock < v_cantidad THEN             RAISE EXCEPTION 'Stock insuficiente para el producto \%', v_producto_id;         END IF;          INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)         VALUES (v_pedido_id, v_producto_id, v_cantidad, (SELECT precio FROM producto WHERE id = v_producto_id));          UPDATE producto SET stock = stock - v_cantidad WHERE id = v_producto_id;     END LOOP; END; $$ LANGUAGE plpgsql;

-- Regla de negocio 2: Impedir transición de estado inválida
CREATE OR REPLACE FUNCTION fn_validar_estado_pedido() RETURNS TRIGGER AS $$ BEGIN     IF OLD.estado = 'CONFIRMADA' AND NEW.estado = 'PENDIENTE' THEN         RAISE EXCEPTION 'Un pedido CONFIRMADO no puede volver a PENDIENTE';     END IF;     RETURN NEW; END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_estado BEFORE UPDATE ON pedido
FOR EACH ROW EXECUTE FUNCTION fn_validar_estado_pedido();