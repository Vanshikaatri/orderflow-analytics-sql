CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX idx_orders_time ON orders(order_time);
CREATE INDEX idx_orders_status ON orders(order_status);

CREATE INDEX idx_deliveries_order ON deliveries(order_id);
CREATE INDEX idx_deliveries_rider ON deliveries(rider_id);
CREATE INDEX idx_deliveries_status ON deliveries(delivery_status);

CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_payments_status ON payments(payment_status);

CREATE INDEX idx_orders_covering 
ON orders(order_status, order_time, customer_id, total_amount);

CREATE INDEX idx_deliveries_status_rider 
ON deliveries (delivery_status, rider_id);

CREATE INDEX idx_riders_city 
ON riders (city);

CREATE INDEX idx_delivery_status_rider_minutes
ON deliveries (delivery_status, rider_id, delivery_minutes);

CREATE INDEX idx_orders_customer_time_status
ON orders(customer_id, order_time, order_status);