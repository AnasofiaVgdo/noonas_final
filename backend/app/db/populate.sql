-- Datos de demostración. PostgreSQL ejecuta este archivo solo al crear un
-- volumen nuevo. Todos los usuarios usan la contraseña: admin123.

INSERT INTO rol (id_rol, descripcion) VALUES
    (1, 'admin'), (2, 'dueña'), (3, 'repartidor'),
    (4, 'pastelero'), (5, 'vendedor');

INSERT INTO usuario (id_usuario, id_rol, nombre, contrasena_hash) VALUES
    (1, 1, 'admin', '$2b$12$gNwMiL6wZNjZdimqMNMh5OxiKpjSUvgOaCGHLvu5rtaFK5Bv764G2'),
    (2, 2, 'sofia', '$2b$12$gNwMiL6wZNjZdimqMNMh5OxiKpjSUvgOaCGHLvu5rtaFK5Bv764G2'),
    (3, 3, 'repartidor', '$2b$12$gNwMiL6wZNjZdimqMNMh5OxiKpjSUvgOaCGHLvu5rtaFK5Bv764G2'),
    (4, 2, 'mariana', '$2b$12$gNwMiL6wZNjZdimqMNMh5OxiKpjSUvgOaCGHLvu5rtaFK5Bv764G2'),
    (5, 3, 'carlos', '$2b$12$gNwMiL6wZNjZdimqMNMh5OxiKpjSUvgOaCGHLvu5rtaFK5Bv764G2');

INSERT INTO cliente (id_cliente, nombre, apellido, telefono) VALUES
    (1, 'María', 'López', '8112345678'),
    (2, 'Andrea', 'García', '8187654321'),
    (3, 'Luis', 'Martínez', '8111223344'),
    (4, 'Fernanda', 'Ramírez', '8188990011'),
    (5, 'Jorge', 'Hernández', '8123456789');
INSERT INTO direccion (id_direccion, id_cliente, descripcion) VALUES
    (1, 1, 'Av. Principal 123, Centro'),
    (2, 2, 'Calle Magnolia 45, Mitras'),
    (3, 3, 'Av. Universidad 890, San Nicolás'),
    (4, 4, 'Calle Naranjo 32, Cumbres'),
    (5, 5, 'Av. Las Torres 210, Guadalupe');
INSERT INTO estado (id_estado, descripcion) VALUES
    (1, 'pendiente'), (2, 'en proceso'), (3, 'listo para entregar'),
    (4, 'entregado'), (5, 'cancelado');
INSERT INTO pedidos (id_pedido, id_direccion, id_estado, id_cliente, fecha_entrega, fecha_pedido, comentario, tipo_entrega, subtotal, total) VALUES
    (1, 1, 1, 1, CURRENT_TIMESTAMP + INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '1 day', 'Pastel de cumpleaños con fresas', FALSE, 450.00, 450.00),
    (2, 2, 2, 2, CURRENT_TIMESTAMP + INTERVAL '1 day', CURRENT_TIMESTAMP - INTERVAL '2 days', 'Cupcakes para 20 personas', TRUE, 600.00, 680.00),
    (3, 3, 3, 3, CURRENT_TIMESTAMP + INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '3 days', 'Pastel de chocolate con dedicatoria', FALSE, 520.00, 520.00),
    (4, 4, 4, 4, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '7 days', 'Galletas decoradas para evento', TRUE, 350.00, 400.00),
    (5, 5, 5, 5, CURRENT_TIMESTAMP + INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '1 day', 'Pedido cancelado por cliente', FALSE, 300.00, 300.00);
-- Cada pedido tiene responsable: la UI nunca mostrará “Sin usuario”.
INSERT INTO usuario_has_pedidos (id_usuario, id_pedido) VALUES
    (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

INSERT INTO estado_pago (id_estado_pago, descripcion) VALUES
    (1, 'pendiente'), (2, 'anticipo recibido'), (3, 'pago parcial'),
    (4, 'pagado'), (5, 'reembolsado');
INSERT INTO tipo_pago (id_tipo_pago, descripcion) VALUES
    (1, 'efectivo'), (2, 'transferencia'), (3, 'tarjeta'),
    (4, 'depósito'), (5, 'mercado pago');
INSERT INTO pago (id_pago, id_pedido, id_estado_pago, id_tipo_pago, anticipo, monto, fecha) VALUES
    (1, 1, 2, 1, TRUE, 200.00, CURRENT_TIMESTAMP - INTERVAL '1 day'),
    (2, 2, 3, 2, TRUE, 300.00, CURRENT_TIMESTAMP - INTERVAL '2 days'),
    (3, 3, 4, 3, FALSE, 520.00, CURRENT_TIMESTAMP - INTERVAL '3 days'),
    (4, 4, 4, 4, FALSE, 400.00, CURRENT_TIMESTAMP - INTERVAL '6 days'),
    (5, 5, 5, 5, TRUE, 300.00, CURRENT_TIMESTAMP - INTERVAL '1 day');

INSERT INTO unidad_medida (id_unidad, descripcion, abreviatura) VALUES
    (1, 'Kilogramo', 'kg'), (2, 'Litro', 'l'), (3, 'Pieza', 'pza'),
    (4, 'Gramo', 'g'), (5, 'Mililitro', 'ml');
INSERT INTO materia_prima (id_materia, id_unidad, descripcion, precio_unitario, minimo, maximo, stock_actual, imagen, activo) VALUES
    (1, 1, 'Harina de trigo', 28.00, 2.00, 25.00, 10.00, NULL, TRUE),
    (2, 3, 'Huevo', 4.00, 12.00, 120.00, 48.00, NULL, TRUE),
    (3, 1, 'Azúcar', 30.00, 2.00, 20.00, 8.00, NULL, TRUE),
    (4, 1, 'Chocolate semi amargo', 180.00, 1.00, 10.00, 4.00, NULL, TRUE),
    (5, 2, 'Crema para batir', 95.00, 1.00, 15.00, 6.00, NULL, TRUE);
INSERT INTO receta (id_receta, id_usuario, descripcion) VALUES
    (1, 1, 'Pan de vainilla'),
    (2, 2, 'Pan de chocolate'),
    (3, 4, 'Betún de queso crema'),
    (4, 2, 'Cupcake de red velvet'),
    (5, 1, 'Galleta de mantequilla');
INSERT INTO receta_materia_prima (id_receta, id_materia, cantidad) VALUES
    (1, 1, 0.50), (2, 4, 0.35), (3, 5, 0.50),
    (4, 2, 4.00), (5, 3, 0.20);

INSERT INTO categoria (id_categoria, descripcion) VALUES
    (1, 'Pasteles'), (2, 'Cupcakes'), (3, 'Galletas'),
    (4, 'Postres individuales'), (5, 'Temporada');
INSERT INTO producto (id_producto, id_categoria, id_receta, descripcion, precio_unitario, imagen, activo) VALUES
    (1, 1, 1, 'Pastel de vainilla', 450.00, NULL, TRUE),
    (2, 1, 2, 'Pastel de chocolate', 520.00, NULL, TRUE),
    (3, 2, 4, 'Caja de cupcakes red velvet', 600.00, NULL, TRUE),
    (4, 3, 5, 'Docena de galletas decoradas', 350.00, NULL, TRUE),
    (5, 4, 3, 'Vaso de betún de queso crema', 120.00, NULL, TRUE);
INSERT INTO pedidos_has_producto (id_pedido, id_producto, cantidad, precio_diseño, precio_envio) VALUES
    (1, 1, 1, 0.00, 0.00), (2, 3, 1, 50.00, 30.00),
    (3, 2, 1, 0.00, 0.00), (4, 4, 1, 0.00, 50.00),
    (5, 5, 2, 60.00, 0.00);

INSERT INTO proveedor (id_proveedor, descripcion, direccion, contacto) VALUES
    (1, 'Insumos del Norte', 'Monterrey, Nuevo León', '8111122233'),
    (2, 'Distribuidora Dulce', 'San Nicolás, Nuevo León', '8188881122'),
    (3, 'Lácteos La Granja', 'Guadalupe, Nuevo León', '8199993344'),
    (4, 'Empaques Creativos', 'Apodaca, Nuevo León', '8188776655'),
    (5, 'Chocolate Selecto', 'Santa Catarina, Nuevo León', '8110102020');
INSERT INTO compra (id_compra, id_proveedor, fecha, total) VALUES
    (1, 1, CURRENT_TIMESTAMP - INTERVAL '10 days', 280.00),
    (2, 2, CURRENT_TIMESTAMP - INTERVAL '8 days', 192.00),
    (3, 3, CURRENT_TIMESTAMP - INTERVAL '6 days', 570.00),
    (4, 4, CURRENT_TIMESTAMP - INTERVAL '4 days', 250.00),
    (5, 5, CURRENT_TIMESTAMP - INTERVAL '2 days', 720.00);
INSERT INTO materia_prima_compra (id_materia, id_compra, cantidad, precio_individual) VALUES
    (1, 1, 10.00, 28.00), (2, 2, 48.00, 4.00), (3, 3, 19.00, 30.00),
    (5, 4, 2.63, 95.00), (4, 5, 4.00, 180.00);

-- Avanza las secuencias después de insertar IDs explícitos.
SELECT setval(pg_get_serial_sequence('rol', 'id_rol'), (SELECT MAX(id_rol) FROM rol));
SELECT setval(pg_get_serial_sequence('usuario', 'id_usuario'), (SELECT MAX(id_usuario) FROM usuario));
SELECT setval(pg_get_serial_sequence('cliente', 'id_cliente'), (SELECT MAX(id_cliente) FROM cliente));
SELECT setval(pg_get_serial_sequence('direccion', 'id_direccion'), (SELECT MAX(id_direccion) FROM direccion));
SELECT setval(pg_get_serial_sequence('estado', 'id_estado'), (SELECT MAX(id_estado) FROM estado));
SELECT setval(pg_get_serial_sequence('pedidos', 'id_pedido'), (SELECT MAX(id_pedido) FROM pedidos));
SELECT setval(pg_get_serial_sequence('estado_pago', 'id_estado_pago'), (SELECT MAX(id_estado_pago) FROM estado_pago));
SELECT setval(pg_get_serial_sequence('tipo_pago', 'id_tipo_pago'), (SELECT MAX(id_tipo_pago) FROM tipo_pago));
SELECT setval(pg_get_serial_sequence('pago', 'id_pago'), (SELECT MAX(id_pago) FROM pago));
SELECT setval(pg_get_serial_sequence('unidad_medida', 'id_unidad'), (SELECT MAX(id_unidad) FROM unidad_medida));
SELECT setval(pg_get_serial_sequence('materia_prima', 'id_materia'), (SELECT MAX(id_materia) FROM materia_prima));
SELECT setval(pg_get_serial_sequence('receta', 'id_receta'), (SELECT MAX(id_receta) FROM receta));
SELECT setval(pg_get_serial_sequence('categoria', 'id_categoria'), (SELECT MAX(id_categoria) FROM categoria));
SELECT setval(pg_get_serial_sequence('producto', 'id_producto'), (SELECT MAX(id_producto) FROM producto));
SELECT setval(pg_get_serial_sequence('proveedor', 'id_proveedor'), (SELECT MAX(id_proveedor) FROM proveedor));
SELECT setval(pg_get_serial_sequence('compra', 'id_compra'), (SELECT MAX(id_compra) FROM compra));
