
-- 1. СОЗДАНИЕ ПАРТИЦИОННЫХ ТАБЛИЦ

-- Таблица с RANGE секционированием (по NUMBER)
CREATE TABLE Range_Table (
    ID NUMBER,
    DESCRIPTION NVARCHAR2(30)
)
PARTITION BY RANGE (ID) (
    PARTITION RANGE_0 VALUES LESS THAN (100),
    PARTITION RANGE_1 VALUES LESS THAN (200),
    PARTITION RANGE_OTHER VALUES LESS THAN (MAXVALUE)
);

-- Таблица с INTERVAL секционированием (по DATE)
CREATE TABLE Interval_Table (
    ID NUMBER,
    EventTime DATE
)
PARTITION BY RANGE (EventTime)
INTERVAL (NUMTOYMINTERVAL(1, 'MONTH')) (
    PARTITION INTERVAL_LOWER VALUES LESS THAN (DATE '2024-01-01')
);

-- Таблица с HASH секционированием (по VARCHAR2)
CREATE TABLE Hash_Table (
    ID NUMBER,
    DESCRIPTION VARCHAR2(30)
)
PARTITION BY HASH (DESCRIPTION)
PARTITIONS 3;

-- Таблица со LIST секционированием (по CHAR)
CREATE TABLE List_Table (
    ID CHAR(1),
    DESCRIPTION NVARCHAR2(30)
)
PARTITION BY LIST (ID) (
    PARTITION LIST_ABCD VALUES ('A', 'B', 'C', 'D'),
    PARTITION LIST_EFGH VALUES ('E', 'F', 'G', 'H'),
    PARTITION LIST_OTHER VALUES (DEFAULT)
);

-- 2. ВСТАВКА ДАННЫХ

-- RANGE
INSERT INTO Range_Table VALUES(54, 'first');
INSERT INTO Range_Table VALUES(156, 'second');
INSERT INTO Range_Table VALUES(347, 'third');
COMMIT;

-- INTERVAL
INSERT INTO Interval_Table VALUES(1, TO_DATE('02-12-2023', 'DD-MM-YYYY'));
INSERT INTO Interval_Table VALUES(2, TO_DATE('02-01-2024', 'DD-MM-YYYY'));
INSERT INTO Interval_Table VALUES(3, TO_DATE('02-02-2024', 'DD-MM-YYYY'));
COMMIT;

-- HASH
INSERT INTO Hash_Table VALUES(1, 'EUIGXF');
INSERT INTO Hash_Table VALUES(2, 'GCYICR');
INSERT INTO Hash_Table VALUES(3, 'ERASDP');
COMMIT;

-- LIST
INSERT INTO List_Table VALUES('A', 'first');
INSERT INTO List_Table VALUES('G', 'second');
INSERT INTO List_Table VALUES('Y', 'third');
COMMIT;

-- 3. ПРОСМОТР СОДЕРЖИМОГО СЕКЦИЙ

-- Просмотр всех секций таблиц
SELECT * FROM USER_TAB_PARTITIONS WHERE TABLE_NAME IN (
    'RANGE_TABLE', 'INTERVAL_TABLE', 'HASH_TABLE', 'LIST_TABLE'
);

-- Просмотр данных по секциям RANGE
SELECT * FROM Range_Table PARTITION(RANGE_0);
SELECT * FROM Range_Table PARTITION(RANGE_1);
SELECT * FROM Range_Table PARTITION(RANGE_OTHER);
select * from Range_Table;
-- INTERVAL: системные имена секций (найти через USER_TAB_PARTITIONS)
SELECT * FROM Interval_Table PARTITION(INTERVAL_LOWER);
-- Пример доступа по имени SYS_Pxxx
SELECT * FROM Interval_Table PARTITION FOR (TO_DATE('02-01-2024', 'DD-MM-YYYY'));

-- HASH
SELECT * FROM Hash_Table;
-- Уточнение: секции можно определить через:
SELECT PARTITION_NAME, HIGH_VALUE FROM USER_TAB_PARTITIONS WHERE TABLE_NAME = 'HASH_TABLE';

-- LIST
SELECT * FROM List_Table PARTITION(LIST_ABCD);
SELECT * FROM List_Table PARTITION(LIST_EFGH);
SELECT * FROM List_Table PARTITION(LIST_OTHER);

-- 4. ОБНОВЛЕНИЕ С ПЕРЕМЕЩЕНИЕМ СТРОК

-- Включение перемещения строк
ALTER TABLE Range_Table ENABLE ROW MOVEMENT;
ALTER TABLE Interval_Table ENABLE ROW MOVEMENT;
ALTER TABLE Hash_Table ENABLE ROW MOVEMENT;
ALTER TABLE List_Table ENABLE ROW MOVEMENT;

-- RANGE: перемещение строки
UPDATE Range_Table SET ID = 154 WHERE ID = 54;
SELECT * FROM Range_Table PARTITION(RANGE_1);
-- откат
UPDATE Range_Table SET ID = 54 WHERE ID = 154;

-- INTERVAL
UPDATE Interval_Table SET EventTime = TO_DATE('03-01-2024', 'DD-MM-YYYY')
WHERE EventTime = TO_DATE('02-12-2023', 'DD-MM-YYYY');
-- откат
UPDATE Interval_Table SET EventTime = TO_DATE('02-12-2023', 'DD-MM-YYYY')
WHERE EventTime = TO_DATE('03-01-2024', 'DD-MM-YYYY');

-- HASH
UPDATE Hash_Table SET DESCRIPTION = 'SJKLHV' WHERE DESCRIPTION = 'EUIGXF';
-- откат
UPDATE Hash_Table SET DESCRIPTION = 'EUIGXF' WHERE DESCRIPTION = 'SJKLHV';

-- LIST
UPDATE List_Table SET ID = 'E' WHERE ID = 'A';
SELECT * FROM List_Table PARTITION(LIST_EFGH);
-- откат
UPDATE List_Table SET ID = 'A' WHERE ID = 'E';

-- 5. ALTER TABLE MERGE

ALTER TABLE List_Table MERGE PARTITIONS LIST_ABCD, LIST_EFGH INTO PARTITION LIST_ABCDEFGH;
SELECT * FROM List_Table PARTITION(LIST_ABCDEFGH);

-- ==========================
-- 6. ALTER TABLE SPLIT
-- ==========================

ALTER TABLE Range_Table SPLIT PARTITION RANGE_OTHER AT (300) INTO (
    PARTITION RANGE_2,
    PARTITION RANGE_OTHER
);
SELECT PARTITION_NAME, HIGH_VALUE FROM USER_TAB_PARTITIONS WHERE TABLE_NAME = 'RANGE_TABLE';

-- 7. ALTER TABLE EXCHANGE

-- Таблица для обмена
CREATE TABLE Range_Table_Exchanged (
    ID NUMBER,
    DESCRIPTION NVARCHAR2(30)
);

-- Переместим данные из секции в отдельную таблицу
ALTER TABLE Range_Table EXCHANGE PARTITION RANGE_OTHER WITH TABLE Range_Table_Exchanged;
SELECT * FROM Range_Table_Exchanged;

-- 8. АНАЛИТИКА СЕКЦИЙ

-- Все секционированные таблицы
SELECT * FROM USER_PART_TABLES;

-- Все секции конкретной таблицы
SELECT * FROM USER_TAB_PARTITIONS WHERE TABLE_NAME = 'RANGE_TABLE';

-- Значения в секции по имени
SELECT * FROM Range_Table PARTITION(RANGE_0);

-- Значения в секции по значению ключа
SELECT * FROM Range_Table PARTITION FOR (156);

-- 9. УДАЛЕНИЕ ТАБЛИЦ (по завершению)

DROP TABLE Range_Table PURGE;
DROP TABLE Interval_Table PURGE;
DROP TABLE Hash_Table PURGE;
DROP TABLE List_Table PURGE;
DROP TABLE Range_Table_Exchanged PURGE;
