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

-- ��������� ��������� �������
INSERT INTO manufacturers VALUES (1, '�����');
INSERT INTO manufacturers VALUES (2, '������');

INSERT INTO toys VALUES (1, '����������', 500, '����', '�����', 2);
INSERT INTO toys VALUES (2, '�������', 300, '������', '�����', 1);
INSERT INTO toys VALUES (3, '�����', 800, '�������', '�������', 1);
COMMIT;

-- 1. SELECT 
DECLARE
    v_price NUMBER;
BEGIN
    SELECT price INTO v_price
    FROM toys
    WHERE name = '����������';
    
    DBMS_OUTPUT.PUT_LINE('���������� ����� ' || v_price || ' ������');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('����� ������� ��� � ��������');
END;


-- 2. INSERT
BEGIN
    INSERT INTO toys 
    VALUES (5, '�������', 5000, '�������', '�����', 1); 
    
    DBMS_OUTPUT.PUT_LINE('��������� ����� �������!');
    COMMIT;
END;


-- 3. UPDATE 
BEGIN
    UPDATE toys
    SET price = price + 50
    WHERE name LIKE '�����%';
    
    DBMS_OUTPUT.PUT_LINE('���� �� ����� ���������!');
    COMMIT;
END;


-- 4. DELETE
BEGIN
    DELETE FROM toys
    WHERE condition = '�������'; 
    
    DBMS_OUTPUT.PUT_LINE('��������� ������� ���������! �������: ' || SQL%ROWCOUNT || ' ��.');
    COMMIT;
END;


-- 5. ������� ������
DECLARE
    CURSOR toy_cursor IS
        SELECT name, price
        FROM toys
        ORDER BY price;
    
    v_name VARCHAR2(100);
    v_price NUMBER;
BEGIN
    OPEN toy_cursor;
    
    DBMS_OUTPUT.PUT_LINE('������ �������:');
    DBMS_OUTPUT.PUT_LINE('---------------');
    
    LOOP
        FETCH toy_cursor INTO v_name, v_price;
        EXIT WHEN toy_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(v_name || ' - ' || v_price || ' ���.');
    END LOOP;
    
    CLOSE toy_cursor;
END;

-- 6. ������ � JOIN
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
    DBMS_OUTPUT.PUT_LINE('������� � �� �������������:');
    DBMS_OUTPUT.PUT_LINE('---------------------------');
    
    LOOP
        FETCH toys_with_manufacturers INTO v_name, v_price, v_country;
        EXIT WHEN toys_with_manufacturers%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_price || ' ���. | ������: ' || v_country);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('�����: ' || toys_with_manufacturers%ROWCOUNT || ' �������');
    CLOSE toys_with_manufacturers;
END;

--5 ����� ���

DECLARE
    CURSOR toy_cursor IS
        SELECT name, price
        FROM toys
        ORDER BY price;
    v_count NUMBER := 0;  -- ������� �����
BEGIN
    DBMS_OUTPUT.PUT_LINE('������ �������:');
    DBMS_OUTPUT.PUT_LINE('---------------');
    
    -- �������������� ��������, ������� � �������� �������
    FOR toy_rec IN toy_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(toy_rec.name || ' - ' || toy_rec.price || ' ���.');
        v_count := v_count + 1;  -- ����������� �������
    END LOOP;
    
    -- ������� ���������� ����� ����������-�������
    DBMS_OUTPUT.PUT_LINE('����� �������: ' || v_count);
END;

-- 6 ����� ���
DECLARE
    CURSOR toys_with_manufacturers IS
        SELECT t.name, t.price, m.country
        FROM toys t
        JOIN manufacturers m ON t.manufacturer_id = m.id;
    v_count NUMBER := 0; -- ������� �������
BEGIN
    DBMS_OUTPUT.PUT_LINE('������� � �� �������������:');
    DBMS_OUTPUT.PUT_LINE('---------------------------');

    FOR item IN toys_with_manufacturers LOOP
        DBMS_OUTPUT.PUT_LINE(
            item.name || ' | ' || 
            item.price || ' ���. | ' || 
            '������: ' || item.country
        );
        v_count := v_count + 1; -- ����������� �������
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('����� �������: ' || v_count);
END;


DROP TABLE toys;
DROP TABLE manufacturers;