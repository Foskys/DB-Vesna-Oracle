--1 задание
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World!');
END;

--2 задание
DECLARE
  x NUMBER; 
BEGIN
  DECLARE
    y NUMBER := 10;   
    z NUMBER := 4;    
  BEGIN
    x := y / z;      
    DBMS_OUTPUT.PUT_LINE('Вычисление: ' || y || ' / ' || z || ' = ' || x);
  END;
  
  DBMS_OUTPUT.PUT_LINE('Результат деления: ' || x);
END;


--3 задание 

BEGIN
  FOR i IN 1..10 LOOP
    IF MOD(i, 2) != 0 THEN  
      DBMS_OUTPUT.PUT_LINE('Нечетное число: ' || i);
    END IF;
  END LOOP;
END;

--4 задание

DECLARE
  number_value NUMBER := 16; 
BEGIN
  IF MOD(number_value, 2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Число ' || number_value || ' четное (делится на 2)');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Число ' || number_value || ' нечетное (не делится на 2)');
  END IF;
END;

-- 5 задание

DECLARE
  temperature NUMBER := 22;  
  weather_description VARCHAR2(30);
BEGIN
  weather_description := CASE 
    WHEN temperature > 30 THEN 'Жарко'
    WHEN temperature > 20 THEN 'Тепло'
    WHEN temperature > 10 THEN 'Прохладно'
    WHEN temperature > 0  THEN 'Холодно'
    ELSE 'Мороз'
  END;

  DBMS_OUTPUT.PUT_LINE('Температура: ' || temperature || '°C - ' || weather_description);
END;

--задание 6

DECLARE
  i NUMBER := 1;
BEGIN
  WHILE i <= 9 LOOP
    DBMS_OUTPUT.PUT_LINE('Число: ' || i);
    i := i + 1;
  END LOOP;
END;

-- просто луп
DECLARE
  i NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('Число: ' || i);
    i := i + 1;
    EXIT WHEN i > 9;  
  END LOOP;
END;

--просто фор 

BEGIN
  FOR i IN 1..9 LOOP
    DBMS_OUTPUT.PUT_LINE('Число: ' || i);
  END LOOP;
END;