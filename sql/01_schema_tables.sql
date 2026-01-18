CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL references customers(customer_id),
    status text not null check (status in ('open', 'completed','cancelled' )),
    created_at timestamp not null default now()
);

create table order_items (
    order_item_id serial primary key,
    order_id int not null references orders(order_id) on delete cascade,
    product_id int not null references products(product_id),
    quantity int not null check (quantity > 0),
    unit_price numeric(10,2) not null check (unit_price >= 0),
    unique (order_id, product_id)
);

create table inventory_audit (
    audit_id serial primary key,
    product_id int not null, 
    change_qty int not null,
    reason text not null,
    changed_at timestamp not null default now()
);



