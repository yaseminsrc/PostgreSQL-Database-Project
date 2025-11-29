-- ==========================================================
--                  E-TİCARET YÖNETİM SİSTEMİ
--                  yasemin_şireci_proje.sql
-- ==========================================================
--  İçerik:
--  	Tablolar
--   	Örnek Veri Ekleme
--   	Fonksiyonlar
--   	Triggerlar
--   	Stored Procedure'ler
--  	View'lar
--   	Kompleks SQL Sorguları
-- ==========================================================



-- ==========================================================
--    TABLOLARI OLUŞTURMA
-- ==========================================================


-- ----------- CATEGORIES -----------
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT
);

-- ----------- PRODUCTS -----------
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INT REFERENCES categories(id) ON DELETE SET NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    stock INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------- CUSTOMERS -----------
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------- SHIPPING ADDRESSES -----------
CREATE TABLE shipping_addresses (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    address_line VARCHAR(255),
    district VARCHAR(100),
    postal_code VARCHAR(20),
    city VARCHAR(100),
    country VARCHAR(100)
);

-- ----------- ORDERS -----------
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    shipping_address_id INT REFERENCES shipping_addresses(id) ON DELETE SET NULL,
    total_price NUMERIC(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending'
);

-- ----------- ORDER ITEMS -----------
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT REFERENCES products(id) ON DELETE SET NULL,
    quantity INT CHECK(quantity > 0),
    unit_price NUMERIC(10,2)
);

-- ----------- REVIEWS -----------
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id) ON DELETE CASCADE,
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    rating INT CHECK(rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



-- ==========================================================
--    ÖRNEK VERİLER EKLEME
-- ==========================================================


-- Kategori verileri ekleme
INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Wearable items and apparel'),
('Cosmetics', 'Cosmetic and beauty products');

-- Ürün verileri ekleme
INSERT INTO products (category_id, name, description, price, stock) VALUES
-- Electronics
(1, 'Wireless Headphones', 'Bluetooth noise-canceling headphones', 89.99, 120),
(1, 'Smartphone X200', 'Latest model with 5G support', 799.00, 50),
(1, 'Laptop Pro 15', 'High performance laptop 16GB RAM', 1299.99, 30),
(1, 'Gaming Mouse', 'RGB 7200 DPI gaming mouse', 49.99, 200),
(1, 'Portable Charger 20000mAh', 'Fast charging power bank', 39.95, 250),
(1, 'Smartwatch S5', 'Fitness and health tracking smartwatch', 199.99, 80),

-- Clothing
(2, 'Men T-Shirt', 'Cotton slim fit t-shirt', 19.90, 300),
(2, 'Women Jacket', 'Waterproof outdoor jacket', 89.50, 60),
(2, 'Jeans Blue', 'Classic blue denim jeans', 49.99, 150),
(2, 'Sneakers White', 'Comfortable white sneakers', 59.95, 120),
(2, 'Hoodie Black', 'Unisex black hoodie', 44.99, 180),
(2, 'Summer Dress', 'Floral patterned dress', 34.99, 90),

-- Cosmetics
(3, 'Face Cream Hydra', 'Hydrating skincare cream', 24.90, 200),
(3, 'Lipstick Matte Red', 'Long-lasting matte lipstick', 12.99, 220),
(3, 'Perfume Aura 50ml', 'Fresh floral fragrance', 59.00, 70),
(3, 'Shampoo Natural 500ml', 'Organic shampoo for dry hair', 11.99, 140),
(3, 'Makeup Palette 12 Colors', 'Professional eye-shadow set', 29.99, 160),
(3, 'Beard Oil Premium', 'Organic beard softening oil', 15.50, 80),
(3, 'Hair Conditioner Silk', 'Keratin-based conditioner', 13.75, 100),
(3, 'Body Lotion Vanilla', 'Moisturizing body lotion', 9.95, 130);


-- Müşteri verileri ekleme
INSERT INTO customers (first_name, last_name, email, phone, password_hash) VALUES
('James', 'Walker', 'james.walker@ukmail.com', '447520998877', 'js-walk5'),           -- UK
('Anna', 'Schneider', 'anna.schneider@germany.de', '491512334455', 'hash_anna'),      -- Germany
('Michael', 'Johnson', 'michael.johnson@usa.com', '12125550123', 'hash_michael'),     -- USA
('Olga', 'Petrova', 'olga.petrova@ru.ru', '79269995544', 'petro-olga678'),            -- Russia
('Yasemin', 'Koç', 'yasemin.koc@example.com', '905551112233', 'ysmn1234'),      	  -- Turkey
('Emily', 'Fallon', 'emily.fln@ukmail.com', '447524768899', 'fallon789'),			  -- UK
('Li', 'Wei', 'li.wei@china.cn', '8613900112233', 'hash_li'),                         -- China
('Sofia', 'Bianchi', 'sofia.bianchi@italy.it', '393477665544', 'hash_sofia'),         -- Italy
('Marie', 'Dubois', 'marie.dubois@france.fr', '33755009922', 'hash_marie'),           -- France
('Carlos', 'Gonzalez', 'carlos.gonzalez@example.com', '346600112233', 'carlos22'),    -- Spain
('Jamie', 'Styles', 'styles.jamie@example.com', '447555768866', 'jamie-3444');		  -- UK


-- Gönderi/Teslimat Adresi verileri ekleme
INSERT INTO shipping_addresses (customer_id, address_line, district, postal_code, city, country) VALUES
(1, '221B Baker Street', 'London Central', 'NW1 6XE', 'London', 'UK'),
(2, 'Kurfürstendamm 32', 'Charlottenburg', '10719', 'Berlin', 'Germany'),
(3, '742 Evergreen Terrace', 'Springfield', '62704', 'Illinois', 'USA'),
(4, 'Tverskaya Street 14', 'Central District', '125009', 'Moscow', 'Russia'),
(5, 'İstiklal Cd. 125', 'Beyoğlu', '34430', 'İstanbul', 'Türkiye'),
(6, '14 Queen Street', 'Soho', 'W1D 3DE', 'London', 'UK'),
(7, 'Nanjing East Road 501', 'Huangpu', '200001', 'Shanghai', 'China'),
(8, 'Via Roma 20', 'Centro Storico', '00184', 'Rome', 'Italy'),
(9, 'Avenue des Champs-Élysées 50', '8th Arrondissement', '75008', 'Paris', 'France'),
(10, 'Calle Mayor 12', 'Centro', '28013', 'Madrid', 'Spain'),
(11, '5 Oxford Road', 'Manchester District', 'M1 5AN', 'Manchester', 'UK');


-- Sipariş verileri ekleme
INSERT INTO orders (customer_id, shipping_address_id, total_price, status) VALUES
(1, 1, 799.00, 'delivered'),       -- James: Smartphone X200
(2, 2, 125.47, 'delivered'),       -- Anna: Jacket + Shampoo
(3, 3, 1299.99, 'pending'),        -- Michael: Laptop Pro 15
(4, 4, 354.00, 'processing'),        -- Olga: Perfume Aura
(5, 5, 72.49, 'pending'),        -- Yasemin: Hoodie + Conditioner
(6, 6, 199.99, 'delivered'),       -- Emily: Smartwatch
(7, 7, 89.99, 'pending'),          -- Li Wei: Wireless Headphones
(8, 8, 34.99, 'delivered'),        -- Sofia: Summer Dress
(9, 9, 59.94, 'delivered'),       -- Marie: Body Lotion + Gaming Mouse
(10, 10, 49.99, 'delivered'),      -- Carlos: Jeans
(11, 11, 90.95, 'pending');     -- Jamie: Sneakers + Beard Oil

-- Sipariş detayları verileri ekleme
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
-- Order 1: James → Smartphone X200
(1, 2, 1, 799.00),

-- Order 2: Anna → Women Jacket + 3*Shampoo
(2, 8, 1, 89.50),
(2, 16, 3, 11.99),

-- Order 3: Michael (pending) → Laptop Pro 15
(3, 3, 1, 1299.99),

-- Order 4: Olga (processing) → 6*Perfume Aura
(4, 15, 6, 59.00),

-- Order 5: Yasemin (pending) → Hoodie + 2*Conditioner
(5, 11, 1, 44.99),
(5, 19, 2, 13.75),

-- Order 6: Emily → Smartwatch
(6, 6, 1, 199.99),

-- Order 7: Li Wei (pending) → Wireless Headphones
(7, 1, 1, 89.99),

-- Order 8: Sofia → Summer Dress
(8, 12, 1, 34.99),

-- Order 9: Marie → Body Lotion + Gaming Mouse
(9, 20, 1, 9.95),
(9, 4, 1, 49.99),

-- Order 10: Carlos → Jeans Blue
(10, 9, 1, 49.99),

-- Order 11: Jamie (pending) → Sneakers + 2*Beard Oil
(11, 10, 1, 59.95),
(11, 18, 2, 15.50);



-- Kullanıcı yorumları verileri ekleme
-- Sadece teslim edilen siparişler için kullanıcı yorum yapabilir.
INSERT INTO reviews (product_id, customer_id, rating, comment) VALUES

-- Order 1 – James → Smartphone X200
(2, 1, 5, 'Fantastic smartphone! Extremely fast, smooth performance and impressive 5G connectivity.'),

-- Order 2 – Anna → Women Jacket
(8, 2, 4, 'Great quality jacket and fits nicely. Could be a bit warmer.'),

-- Order 2 – Anna → Shampoo
(16, 2, 3, 'Decent shampoo, but the results were average and the scent fades quickly.'),

-- Order 6 – Emily → Smartwatch
(6, 6, 4, 'Good smartwatch with useful features, but the battery life could be better.'),

-- Order 8 – Sofia → Summer Dress
(12, 8, 5, 'Beautiful summer dress! Very comfortable and fits perfectly.'),

-- Order 9 – Marie → Body Lotion
(20, 9, 4, 'Moisturizes well, though the scent is a bit strong.'),

-- Order 9 – Marie → Gaming Mouse
(4, 9, 2, 'Tracking is inconsistent and the clicks feel flimsy.'),

-- Order 10 – Carlos → Jeans Blue
(9, 10, 4, 'Well-fitting jeans with good quality. Fabric softens after washing.');



-- ==========================================================
-- 1. FONKSİYONLAR
-- ==========================================================

/*  1.1 calculate_order_total(order_id) - Sipariş toplam tutarını hesaplayan fonksiyon

*  toplam tutar = ürün adeti × birim fiyat
*  Sipariş yoksa -> toplam tutar yok -> Null -> null ile sayısal işlem yapılmaz. -> COALESCE -> toplam tutar null yerine 0 döndürsün
*/

CREATE OR REPLACE FUNCTION calculate_order_total(p_order_id INT)
RETURNS NUMERIC
LANGUAGE SQL
AS $$
    SELECT COALESCE(SUM(quantity * unit_price), 0) -- COALESCE, null değerleri yakalayıp yerine 0 döndürecek. 
    FROM order_items
    WHERE order_id = p_order_id;
$$;

--test etmek için
 select calculate_order_total(7);
 
  
 
/*   1.2 customer_lifetime_value(customer_id) - Müşterinin toplam alışveriş tutarını hesaplayan fonksiyon
   
*  Bu fonksiyon Müşterinin toplam harcamasını hesaplayacak yani sadece tamamlanmış (delivered) siparişler hesaplanacak.
*  sipariş yoksa-> null -> sayısal işlem yapabilmek için total:0'a çevir
*/

CREATE OR REPLACE FUNCTION customer_lifetime_value(p_customer_id INT)
RETURNS NUMERIC
LANGUAGE SQL
AS $$
    SELECT COALESCE(SUM(total_price), 0)      -- NULL yerine 0 döndürmek için COALESCE kullandık.
    FROM orders
    WHERE customer_id = p_customer_id AND status = 'delivered';               -- tamamlanmış siparişler toplama dahil edilsin
$$;

--test etmek için
select customer_lifetime_value(4);



/*  1.3  stock_status(product_id) - Stok durumunu kontrol eden (Bol/Orta/Az/Tükendi) fonksiyon  */

CREATE OR REPLACE FUNCTION stock_status(p_product_id INT)
RETURNS TEXT
LANGUAGE plpgsql 
AS $$
DECLARE
    s INT;
BEGIN
    -- Ürün var mı kontrol et
    SELECT stock INTO s FROM products WHERE id = p_product_id;

    IF NOT FOUND THEN
        RETURN 'Bulunamadı!';    -- ürün yoksa
    END IF;

    -- Stok durumu kontrol
    IF s = 0 THEN
        RETURN 'Tükendi';
    ELSIF s <= 50 THEN
        RETURN 'Az';
    ELSIF s <= 100 THEN
        RETURN 'Orta';
    ELSE
        RETURN 'Bol';
    END IF;
END;
$$;

-- test etmek için
select stock_status(8);


-- ==========================================================
-- 2. TRİGGERLAR
-- ==========================================================

-- 2.1 Sipariş oluşturulduğunda stok miktarını düşüren trigger

-- Trigger function
CREATE OR REPLACE FUNCTION trg_reduce_stock()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE id = NEW.product_id;

    RETURN NEW;
END;
$$;

-- Trigger
CREATE TRIGGER reduce_stock_after_order
AFTER INSERT ON order_items 
FOR EACH ROW EXECUTE FUNCTION trg_reduce_stock();

-- test etmek için
INSERT INTO orders (customer_id, total_price, status) VALUES (1, 0, 'pending')   -- Önce orders tablosu üzerinden-> order_id üret
RETURNING id;

INSERT INTO order_items(order_id, product_id, quantity, unit_price) VALUES(13, 15, 4, 59); ---- Sonra order_items’a ürün ekleyip trigger’ı tetikle

SELECT stock FROM products WHERE id = 15;  -- Son olarak ürün id'sinden stoku kontrol et.




-- 2.2 Ürün fiyatı güncellendiğinde log tutan trigger

/*    Veri tabanında kolon her zaman tek bir değer saklar. Güncelleme yaptıkça eski fiyat hep kaybolur. Eski fiyat "overwritten" olur. 
      Fiyat geçmişi (history), birden fazla değer içerir → Log tablosu -> tüm fiyat geçmişini tutar. Bu tabloya her değişiklikte bir kayıt eklenecek. */

-- Log tablosu  oluştur -> değişiklikleri saklamak için.
CREATE TABLE product_price_logs (
    id SERIAL PRIMARY KEY,   -- Her log için benzersiz kimlik
    product_id INT,
    old_price NUMERIC(10,2),
    new_price NUMERIC(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 		-- otomatik timestamp 
);

-- Trigger fonksiyonu
CREATE OR REPLACE FUNCTION trg_log_price_change()
RETURNS trigger
AS $$
BEGIN
    IF NEW.price <> OLD.price THEN		 	-- Yalnızca fiyat değiştiyse log ekle, Aynı fiyat güncellemesi yapılırsa log eklenmez.
        INSERT INTO product_price_logs(product_id, old_price, new_price)
        VALUES(OLD.id, OLD.price, NEW.price);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER log_product_price_change
BEFORE UPDATE ON products 		-- ürün güncellenmeden önce trigger çalışır.
FOR EACH ROW
EXECUTE FUNCTION trg_log_price_change();

-- Test etmek için
 UPDATE products SET price = price + 100 WHERE id = 3;




-- 2.3  Sipariş iptal edildiğinde stokları geri yükleyen trigger

-- Trigger fonksiyonu 
CREATE OR REPLACE FUNCTION trg_restore_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'cancelled' AND OLD.status <> 'cancelled' THEN  	-- sipariş iptal ediliyorsa çalışır
        UPDATE products p 
		SET stock = stock + oi.quantity								-- İptal edilen siparişin ürünlerini bulur, stokları geri ekler
		FROM order_items oi
		WHERE oi.order_id = NEW.id AND oi.product_id = p.id; 	 -- Her ürünü doğru ürüne eklemek için order_items kayıtlarını bul   
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger 	
CREATE TRIGGER restore_stock_on_cancel
AFTER UPDATE ON orders 										-- orders tablosundaki UPDATE işlemine bağlanır
FOR EACH ROW EXECUTE FUNCTION trg_restore_stock();

-- Test etmek için
UPDATE orders SET status = 'cancelled' WHERE id = 11;
select * from orders;




-- ==========================================================
--   3. STORED PROCEDURES
-- ==========================================================

-- 3.1 sp_place_order() - Sipariş verme işlemi (stok kontrolü dahil)

-- sp_place_order(customer_id, product_id, quantity) prosedür: sipariş oluşturma prosedürü -> işlemi otomatikleştir
CREATE OR REPLACE PROCEDURE sp_place_order(
    p_customer_id INT,
    p_product_id INT,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    p_price NUMERIC;
    stock_left INT;
    new_order_id INT;
BEGIN

    SELECT price, stock INTO p_price, stock_left 		-- products tablosundan fiyat ve stok bilgisi al, price → p_price içine, stock → stock_left içine al
    FROM products WHERE id = p_product_id;

    IF stock_left < p_quantity THEN 				-- Eğer ürün stokta yeterli değilse -> sipariş oluşturMA, işlemi durdur
        RAISE EXCEPTION 'Yetersiz stok. Kalan: %', stock_left;    -- hata mesajı verir
    END IF;

    INSERT INTO orders(customer_id, total_price, status) 		-- sipariş tablosuna kayıt ekle yani burada yeni bir order oluşturuluyor
    VALUES(p_customer_id, p_price * p_quantity, 'pending')
    RETURNING id INTO new_order_id; 				-- oluşan siparişin id’si -> new_order_id değişkenine kaydet

    INSERT INTO order_items(order_id, product_id, quantity, unit_price)   -- Order Items(sipariş içeriği) kaydı oluştur -> Siparişin ürünleri doğru kaydedildiğini kontrol etmek için
    VALUES(new_order_id, p_product_id, p_quantity, p_price);
    RAISE NOTICE 'Sipariş oluşturuldu. ID = %', new_order_id;			-- Terminalde Sipariş ID’si ekrana yazdırarak bilgi mesajı göster

END;
$$;


-- Test etmek için 
 CALL sp_place_order(1, 1, 2);
/*
SELECT * FROM orders ORDER BY id DESC;  	 -- orders tablosu -> Sipariş oluşturulmuş mu? -> Yeni sipariş eklenmiş olmalı.
SELECT * FROM order_items ORDER BY id DESC;   -- order_items ->	Sipariş hangi ürünü içeriyor? -> Siparişin ürün detayı burada.
SELECT id, name, stock FROM products WHERE id = p_product_id;    -- products (stok tablosu) -> Trigger varsa stok düştü mü?
*/




-- 3.2	sp_cancel_order() - Sipariş iptal etme işlemi

-- Bu prosedür, bir siparişi tek komutla iptal etmeyi otomatik yapıyor. 

CREATE OR REPLACE PROCEDURE sp_cancel_order(p_order_id INT)  -- İptal etmek istediğimiz siparişin ID’si.
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET status = 'cancelled'  -- iptal işlemi yapılınca
    WHERE id = p_order_id;
    RAISE NOTICE 'Sipariş iptal edildi.'; -- -- kullanıcıya bilgi mesajı gönder
END;
$$;

-- Test etmek için:
CALL sp_cancel_order(3);




-- ==========================================================
-- 4. VIEW'LAR
-- ==========================================================

-- 4.1 Kategorilere göre ürün satış istatistikleri

CREATE OR REPLACE VIEW vw_category_sales AS
SELECT 
    c.name AS category,   -- kategorilerin gösterileceği kolona category takma adını ver
    SUM(oi.quantity) AS total_units_sold,    	-- miktar kolonuna total_units_sold takma adını ver
    SUM(oi.quantity * oi.unit_price) AS total_revenue   	-- toplam kolonuna total_revenue takma adını ver
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.id			-- ortak id üzerinden tabloları bağla
INNER JOIN categories c ON p.category_id = c.id
GROUP BY c.name;

-- Test etmek için:
SELECT * FROM vw_category_sales;



-- 4.2 Müşteri sipariş özeti(toplam sipariş, toplam tutar, ortalama sepet)

CREATE OR REPLACE VIEW vw_customer_order_summary AS
SELECT 
    c.id AS customer_id,    								-- müşteri id lerin gösterieceği kolon adı customer_id
    INITCAP(concat(c.first_name,' ', c.last_name)) as customer,		-- Ad Soyad şeklinde tam ad al -> kolonun takma adı customer olsun
    COUNT(o.id) AS total_orders, 		-- miktarı gösteren kolon adı total_orders olsun
    SUM(o.total_price) AS total_spent,  -- toplam tutarı gösteren kolon adı total_spent olsun
    AVG(o.total_price) AS average_order  -- ortalamayı gösteren kolon adı average_order 
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id   -- Her müşteriyi göster. Yani sipariş vermemiş müşteriler de listelenmeli. Null/0. İnner join sadece sipariş veren müşteriler görünür. 
GROUP BY c.id;

-- Test etmek için:
SELECT * FROM vw_customer_order_summary;



-- ==========================================================
-- 5. KOMPLEKS SORGULAR
-- ==========================================================

-- 5.1 En çok satan ürünler (TOP 10)

SELECT 
    p.id,
    p.name,
    SUM(oi.quantity) AS total_sold  -- total miktarın gösterileceği kolonun takma adı total_sold olsun
    FROM order_items oi			
INNER JOIN products p ON p.id = oi.product_id     --ortak id üzerinden tabloları bağla yani join işlemi yap
GROUP BY p.id, p.name 			-- ilk ürün id ve sonra ismine göre grupla
HAVING SUM(oi.quantity) > 0		-- having ile en az 1 satılmış ürünler yani gerçekten satılanları filtrele
ORDER BY total_sold desc		-- total miktara göre azalan sıralama yap
LIMIT 10;						-- 10 tane ile sınırla yani En çok satan ilk 10 ürünü getiriyor



-- 5.2	Kategorilere göre ortalama ürün fiyatları ve stok durumları

SELECT 
    c.name AS category,  	-- kategorilerin bulunduğu kolonun adı category olsun
    AVG(p.price) AS avg_price,  -- ürün fiyatının ortalamasının bulunduğu kolonun takma adı avg_price olsun
    SUM(p.stock) AS total_stock  -- total ürün stoğunun olduğu kolonun ismi total_stock olsun
FROM products p
INNER JOIN categories c ON c.id = p.category_id    --ortak id üzerinden tabloları bağla yani join işlemi yap
GROUP BY c.name 		-- kategori adına göre grupla
ORDER BY avg_price DESC;  -- ortalama ürün fiyatına göre azalan şekilde sırala



-- 5.3  Subquery ile: Ortalama sipariş tutarından yüksek siparişler

SELECT 
    o.id,				-- orders tablosundan göstermek istediğin kolonları seç -> id, customer_id, total_price
    o.customer_id,
    o.total_price
FROM orders o
WHERE o.total_price > (SELECT AVG(total_price) FROM orders)    -- toplam fiyatı, ortalama toplam fiyattan yüksek olan siparişleri filtrele
ORDER BY o.total_price DESC;  		 -- toplam fiyata göre, azalan sıralama yap

