create or replace procedure sp_crear_pedido(
p_usuario_id bigint,
p_forma_pago forma_pago,
p_items jsonb  
) as $$
declare
v_pedido_id bigint ;
v_item jsonb ;
v_producto_id bigint ; 
v_cantidad integer ; 
v_stock integer;

begin

insert into pedido (usuario_id, forma_pago)
values (p_usuario_id, p_forma_pago)
returning id into v_pedido_id;

FOR v_item IN SELECT * FROM jsonb_array_elements(p_items) LOOP
v_producto_id := (v_item->>'producto_id')::BIGINT;
v_cantidad    := (v_item->>'cantidad')::INTEGER;

SELECT stock INTO v_stock FROM producto 
WHERE id = v_producto_id FOR UPDATE;

IF v_stock < v_cantidad THEN
RAISE EXCEPTION 'Stock insuficiente para el producto ID %', v_producto_id;
END IF;

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, subtotal)
VALUES (
v_pedido_id, 
v_producto_id, 
v_cantidad, 
(SELECT precio FROM producto WHERE id = v_producto_id),
(v_cantidad * (SELECT precio FROM producto WHERE id = v_producto_id))
);

UPDATE producto SET stock = stock - v_cantidad WHERE id = v_producto_id;

END LOOP;
	
end;
$$ language plpgsql;
