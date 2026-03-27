/*
 * Copyright 2024-2025 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

-- 创建schema
CREATE SCHEMA product_db;

-- 用户表
CREATE TABLE product_db.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE product_db.users IS '用户表';
COMMENT ON COLUMN product_db.users.id IS '用户ID，主键自增';
COMMENT ON COLUMN product_db.users.username IS '用户名';
COMMENT ON COLUMN product_db.users.email IS '用户邮箱';
COMMENT ON COLUMN product_db.users.created_at IS '用户注册时间';

-- 商品表
CREATE TABLE product_db.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE product_db.products IS '商品表';
COMMENT ON COLUMN product_db.products.id IS '商品ID，主键自增';
COMMENT ON COLUMN product_db.products.name IS '商品名称';
COMMENT ON COLUMN product_db.products.price IS '商品单价';
COMMENT ON COLUMN product_db.products.stock IS '商品库存数量';
COMMENT ON COLUMN product_db.products.created_at IS '商品上架时间';

-- 订单表
CREATE TABLE product_db.orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES product_db.users(id)
);
COMMENT ON TABLE product_db.orders IS '订单表';
COMMENT ON COLUMN product_db.orders.id IS '订单ID，主键自增';
COMMENT ON COLUMN product_db.orders.user_id IS '下单用户ID';
COMMENT ON COLUMN product_db.orders.order_date IS '下单时间';
COMMENT ON COLUMN product_db.orders.total_amount IS '订单总金额';
COMMENT ON COLUMN product_db.orders.status IS '订单状态（pending/completed/cancelled等）';

-- 订单明细表
CREATE TABLE product_db.order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES product_db.orders(id),
    FOREIGN KEY (product_id) REFERENCES product_db.products(id)
);
COMMENT ON TABLE product_db.order_items IS '订单明细表';
COMMENT ON COLUMN product_db.order_items.id IS '订单明细ID，主键自增';
COMMENT ON COLUMN product_db.order_items.order_id IS '订单ID';
COMMENT ON COLUMN product_db.order_items.product_id IS '商品ID';
COMMENT ON COLUMN product_db.order_items.quantity IS '购买数量';
COMMENT ON COLUMN product_db.order_items.unit_price IS '下单时商品单价';

-- 商品分类表
CREATE TABLE product_db.categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
COMMENT ON TABLE product_db.categories IS '商品分类表';
COMMENT ON COLUMN product_db.categories.id IS '分类ID，主键自增';
COMMENT ON COLUMN product_db.categories.name IS '分类名称';

-- 商品-分类关联表（多对多）
CREATE TABLE product_db.product_categories (
    product_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES product_db.products(id),
    FOREIGN KEY (category_id) REFERENCES product_db.categories(id)
);
COMMENT ON TABLE product_db.product_categories IS '商品与分类关联表';
COMMENT ON COLUMN product_db.product_categories.product_id IS '商品ID';
COMMENT ON COLUMN product_db.product_categories.category_id IS '分类ID';