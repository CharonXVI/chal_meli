---sql creacion de tablas del modelo de entidad relacion para el challenge de meli---


---tabla de customers---
create table customer (
  customer_id serial primary key not null,
  created_at timestamp not null default current_timestamp,
  email varchar not null,
  nombre varchar not null,
  apellido varchar not null,
  sexo varchar not null,
  direccion varchar not null,
  fecha_de_nacimiento date not null,
  telefono varchar not null,
  last_updated_at timestamp not null default current_timestamp,
  status enum('active','inactive') not null default 'active'
),

---tabla de items---
create table  item (
  item_id serial  primary key,
  category_id int not null,
  nombre varchar not null,
  descripcion varchar not null,
  price decimal(10,2) not null,
  status  ENUM('active', 'inactive', 'deleted') not null default 'active'
  created_at timestamp not null default current_timestamp,
  deleted_at timestamp 
  FOREIGN KEY (category_id) REFERENCES category(category_id)  
     ON DELETE SET NULL 
),

---tabla de orders---
create table order_item (
  order_item_id serial primary key not null,
  order_id int not null,
  item_id int not null,
  descripcion varchar not null,
  quantity int not null,
  price decimal(10,2) not null, --precio en el momento de la compra---
  order_date timestamp not null default current_timestamp, 
  FOREIGN KEY (order_id) REFERENCES "order"(order_id) ON DELETE CASCADE, 
  FOREIGN KEY (item_id) REFERENCES item(item_id),
  UNIQUE (order_id, item_id)    
),

create table order (
    order_id serial primary key not null,
    customer_id int not null,
    order_date  timestamp not null default current_timestamp
    status enum('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'returned') not null default 'pending', 
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
),


---tabla de categorias---
create table category {
  category_id serial  primary key not null,
  category_name varchar,
  category_path varchar(2083),
  constraint category_path_check CHECK (category_path LIKE 'http//%' OR category_path LIKE 'https//%')
}


---creamos view para order summary---

create or replace view order_summary as(
    select 
    order.order_id,
    order.customer_id,
    order.order_date,
    order.status,
    SUM(order_item.quantity * order_item.price) AS total_amount
FROM
    order
JOIN
    order_item  ON order.order_id = order_item.order_id
GROUP BY
    order.order_id, order.customer_id, order.order_date, order.status;
)
