ALTER TABLE orders 
MODIFY order_status ENUM('Delivered','Cancelled','Failed') NOT NULL;

ALTER TABLE deliveries
MODIFY delivery_status ENUM('Completed','Delayed') NOT NULL;

ALTER TABLE payments
MODIFY payment_status ENUM('Success','Failed') NOT NULL;

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_restaurant
FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id);

ALTER TABLE deliveries
ADD CONSTRAINT fk_deliveries_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE deliveries
ADD CONSTRAINT fk_deliveries_rider
FOREIGN KEY (rider_id) REFERENCES riders(rider_id);

ALTER TABLE payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);