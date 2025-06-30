CREATE TABLE toys (
    id              NUMBER PRIMARY KEY,
    name            VARCHAR2(100) NOT NULL,
    price           NUMBER,
    material        VARCHAR2(50),
    condition       VARCHAR2(50),  
    manufacturer_id NUMBER
);

CREATE TABLE manufacturers (
    id      NUMBER PRIMARY KEY,
    country VARCHAR2(50)
);

-- Заполняем тестовыми данными
INSERT INTO manufacturers VALUES (1, 'Китай');
INSERT INTO manufacturers VALUES (2, 'Россия');

INSERT INTO toys VALUES (1, 'Медвежонок', 500, 'плюш', 'новая', 2);
INSERT INTO toys VALUES (2, 'Машинка', 300, 'металл', 'новая', 1);
INSERT INTO toys VALUES (3, 'Кукла', 800, 'пластик', 'сломано', 1);
COMMIT;

-- 1. SELECT 
DECLARE
    v_price NUMBER;
BEGIN
    SELECT price INTO v_price
    FROM toys
    WHERE name = 'Медвежонок';
    
    DBMS_OUTPUT.PUT_LINE('Медвежонок стоит ' || v_price || ' рублей');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Такой игрушки нет в магазине');
END;


-- 2. INSERT
BEGIN
    INSERT INTO toys 
    VALUES (5, 'Машинка', 5000, 'пластик', 'новая', 1); 
    
    DBMS_OUTPUT.PUT_LINE('Добавлена новая игрушка!');
    COMMIT;
END;


-- 3. UPDATE 
BEGIN
    UPDATE toys
    SET price = price + 50
    WHERE name LIKE 'Кукла%';
    
    DBMS_OUTPUT.PUT_LINE('Цены на куклы обновлены!');
    COMMIT;
END;


-- 4. DELETE
BEGIN
    DELETE FROM toys
    WHERE condition = 'сломано'; 
    
    DBMS_OUTPUT.PUT_LINE('Сломанные игрушки выброшены! Удалено: ' || SQL%ROWCOUNT || ' шт.');
    COMMIT;
END;


-- 5. Простой курсор
DECLARE
    CURSOR toy_cursor IS
        SELECT name, price
        FROM toys
        ORDER BY price;
    
    v_name VARCHAR2(100);
    v_price NUMBER;
BEGIN
    OPEN toy_cursor;
    
    DBMS_OUTPUT.PUT_LINE('Список игрушек:');
    DBMS_OUTPUT.PUT_LINE('---------------');
    
    LOOP
        FETCH toy_cursor INTO v_name, v_price;
        EXIT WHEN toy_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(v_name || ' - ' || v_price || ' руб.');
    END LOOP;
    
    CLOSE toy_cursor;
END;

-- 6. Курсор с JOIN
DECLARE
    CURSOR toys_with_manufacturers IS
        SELECT t.name, t.price, m.country
        FROM toys t
        JOIN manufacturers m ON t.manufacturer_id = m.id;
    
    v_name      VARCHAR2(100);
    v_price     NUMBER;
    v_country   VARCHAR2(50);
BEGIN
    OPEN toys_with_manufacturers;
    DBMS_OUTPUT.PUT_LINE('Игрушки и их производители:');
    DBMS_OUTPUT.PUT_LINE('---------------------------');
    
    LOOP
        FETCH toys_with_manufacturers INTO v_name, v_price, v_country;
        EXIT WHEN toys_with_manufacturers%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_price || ' руб. | Страна: ' || v_country);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Всего: ' || toys_with_manufacturers%ROWCOUNT || ' записей');
    CLOSE toys_with_manufacturers;
END;

--5 через фор

DECLARE
    CURSOR toy_cursor IS
        SELECT name, price
        FROM toys
        ORDER BY price;
    v_count NUMBER := 0;  -- Счетчик строк
BEGIN
    DBMS_OUTPUT.PUT_LINE('Список игрушек:');
    DBMS_OUTPUT.PUT_LINE('---------------');
    
    -- Автоматическое открытие, выборка и закрытие курсора
    FOR toy_rec IN toy_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(toy_rec.name || ' - ' || toy_rec.price || ' руб.');
        v_count := v_count + 1;  -- Увеличиваем счетчик
    END LOOP;
    
    -- Выводим количество через переменную-счетчик
    DBMS_OUTPUT.PUT_LINE('Всего игрушек: ' || v_count);
END;

-- 6 через фор
DECLARE
    CURSOR toys_with_manufacturers IS
        SELECT t.name, t.price, m.country
        FROM toys t
        JOIN manufacturers m ON t.manufacturer_id = m.id;
    v_count NUMBER := 0; -- Счетчик записей
BEGIN
    DBMS_OUTPUT.PUT_LINE('Игрушки и их производители:');
    DBMS_OUTPUT.PUT_LINE('---------------------------');

    FOR item IN toys_with_manufacturers LOOP
        DBMS_OUTPUT.PUT_LINE(
            item.name || ' | ' || 
            item.price || ' руб. | ' || 
            'Страна: ' || item.country
        );
        v_count := v_count + 1; -- Увеличиваем счетчик
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Всего записей: ' || v_count);
END;


DROP TABLE toys;
DROP TABLE manufacturers;