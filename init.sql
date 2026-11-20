CREATE TABLE menu (
    id SERIAL PRIMARY KEY,
    category VARCHAR(30) NOT NULL DEFAULT 'Mains',
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    image VARCHAR(100)
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO menu (category, name, description, price) VALUES
('Starters', 'Scotch Egg', 'Soft-yolk egg wrapped in spiced sausage meat, crumbed and fried, with piccalilli.', 8.00),
('Starters', 'Smoked Salmon Blinis', 'Scottish smoked salmon, crème fraîche, dill and lemon on buckwheat blinis.', 11.50),
('Starters', 'Leek & Potato Soup', 'Velvety soup with chive oil and a warm crusty roll.', 7.50),
('Starters', 'Welsh Rarebit', 'Cheddar and ale sauce grilled on sourdough with Worcestershire sauce.', 8.50),
('Starters', 'Prawn Cocktail', 'Brown shrimp and king prawns, Marie Rose sauce, baby gem.', 10.50),
('Mains', 'Traditional Fish & Chips', 'Beer-battered cod, chunky chips, mushy peas, and tartar sauce.', 18.50),
('Mains', 'Beef Wellington', 'Tender fillet steak coated in pâté and duxelles, wrapped in puff pastry.', 32.00),
('Mains', 'Shepherd''s Pie', 'Slow-cooked lamb, root vegetables and a buttery mash crust.', 17.00),
('Mains', 'Bangers & Mash', 'Cumberland sausages, creamy mash, onion gravy and garden peas.', 16.00),
('Mains', 'Sunday Roast Sirloin', 'Roast beef, Yorkshire pudding, roast potatoes, seasonal veg and gravy.', 24.00),
('Mains', 'Steak & Ale Pie', 'Braised beef in ale gravy under golden shortcrust, with mash.', 19.50),
('Mains', 'Chicken Tikka Masala', 'London''s adopted national dish: tandoori chicken, creamy tomato sauce, basmati rice.', 18.00),
('Mains', 'Festive Nut Roast', 'Chestnut, mushroom and herb roast with roast potatoes and rich onion gravy. Vegan.', 21.00),
('Mains', 'Pan-Roasted Sea Bass', 'Crisp-skinned fillet, samphire, new potatoes and caper butter.', 23.00),
('Sides', 'Triple-Cooked Chips', 'Fluffy inside, crisp outside, sea salt.', 5.00),
('Sides', 'Buttered Green Beans', 'Fine green beans tossed in garlic butter and sea salt.', 5.00),
('Sides', 'Cauliflower Cheese', 'Baked cauliflower in a mature cheddar sauce.', 6.00),
('Desserts', 'Sticky Toffee Pudding', 'Classic British dessert with warm toffee sauce and vanilla ice cream.', 8.50),
('Desserts', 'Eton Mess', 'Crushed meringue, strawberries and whipped cream.', 8.00),
('Desserts', 'Apple Crumble & Custard', 'Bramley apples under a buttery oat crumble with proper custard.', 8.00),
('Desserts', 'Banoffee Pie', 'Toffee, banana and cream on a biscuit base.', 7.50),
('Drinks', 'Pint of Real Ale', 'Rotating cask ale from a local London brewery.', 6.50),
('Drinks', 'London Gin & Tonic', 'Small-batch London dry gin, premium tonic, citrus.', 9.00),
('Drinks', 'Pot of English Breakfast Tea', 'Loose-leaf tea served with milk and a shortbread biscuit.', 3.50),
('Drinks', 'Pimm''s Cup', 'Pimm''s No.1, lemonade, cucumber, mint and strawberries.', 8.50);

UPDATE menu SET image = '/img/' || lpad(id::text, 2, '0') || '.jpg';
