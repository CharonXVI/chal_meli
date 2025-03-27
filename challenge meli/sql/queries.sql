--- Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas realizadas en enero 2020 sea superior a 1500. ---

select 
c.customer_id,
c.email,
sum(os.total_amount) as total_enero_2020

from customer c
join order_summary os on c.customer_id = os.customer_id
where extract(month from c.fecha_de_nacimiento) = extract(month from current_date)
    and extract(day from c.fecha_de_nacimiento) = extract(day from current_date)
    and extract(date from os.order_date) >= '2020-01-01' and 
    extract (date from os.order_date) < '2020-02-01'
group by 
    c.customer_id, c.email
having 
    sum(os.total_amount) > 1500;



---2. Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la categoría Celulares.
---Se requiere el mes y año de análisis, nombre y apellido del vendedor, cantidad de ventas realizadas,
--- cantidad de productos vendidos y el monto total transaccionado. 


with ventas_mensuales as(
    select
    date_trunc('month',o.order_date) as mes_venta,
    date_trunc('year',o.order_date) as ano_venta,
    c.customer_id,
    c.email,
    count(distinct o.order_id) as total_ventas,
    sum(oi.quantity) as total_items_vendidos,
    sum(oi.quantity*oi.price) as total_valor_ventas

    from
        customer c  
    join order o on c.customer_id = o.customer_id
    join order_item oi ON o.order_id = oi.order_id
    join item i ON oi.item_id = i.item_id
    join category cat ON i.category_id = cat.category_id

    where cat.category_name = 'celulares'
    and extract(date from o.order_date) >= '2020-01-01' and 
    extract (date from o.order_date) < '2021-01-01'
    group by
    date_trunc ('month',o.order),
    c.email
),

rankventas as(
    select
        mes_venta,
        ano_venta,
        customer_id,
        email
        total_items_vendidos,
        total_valor_ventas,
        RANK() OVER (PARTITION BY total_ventas ORDER BY total_valor_ventas DESC) AS ventas_rank
    FROM
        ventas_mensuales
)


select
    concat(ano_venta,'-', mes_venta) AS mes_ano_venta, 
    email,
    total_ventas,
    total_items_vendidos,
    total_valor_ventas
FROM
    rankventas
WHERE
    ventas_rank <= 5
ORDER BY
    mes_ano_venta,
    ventas_rank;


---3. Se solicita poblar una nueva tabla con el precio y estado de los Ítems a fin del día. 
---Tener en cuenta que debe ser reprocesable. Vale resaltar que en la tabla Item, 
--vamos a tener únicamente el último estado informado por la PK definida. (Se puede resolver a través de StoredProcedure) 


create type item_status AS ENUM('active', 'inactive', 'deleted'); 

create table historial_item (
    id_legacy serial primary key,
    item_id int not null,
    price decimal(10, 2) not null
    status item_status not null, 
    record_date date not null, 
    FOREIGN KEY (item_id) REFERENCES item(item_id)
);

CREATE INDEX idx_item_date ON historial_item (item_id, record_date);

CREATE OR REPLACE PROCEDURE historizar_items(target_date DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM historial_item WHERE record_date = target_date;

    INSERT INTO historial_item (item_id, price, status, record_date)
    SELECT item_id, price, status, target_date
    FROM item;
END;
$$;