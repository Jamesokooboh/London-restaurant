CREATE TABLE menu (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2)
);

INSERT INTO menu (name, description, price) VALUES
('Traditional Fish & Chips', 'Beer-battered cod, chunky chips, mushy peas, and tartar sauce.', 18.50),
('Beef Wellington', 'Tender fillet steak coated in pâté and duxelles, wrapped in puff pastry.', 32.00),
('Sticky Toffee Pudding', 'Classic British dessert with warm toffee sauce and vanilla ice cream.', 8.50);