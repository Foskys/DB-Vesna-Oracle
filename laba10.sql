--1 �������
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World!');
END;

--2 �������
DECLARE
  x NUMBER; 
BEGIN
  DECLARE
    y NUMBER := 10;   
    z NUMBER := 4;    
  BEGIN
    x := y / z;      
    DBMS_OUTPUT.PUT_LINE('����������: ' || y || ' / ' || z || ' = ' || x);
  END;
  
  DBMS_OUTPUT.PUT_LINE('��������� �������: ' || x);
END;


--3 ������� 

BEGIN
  FOR i IN 1..10 LOOP
    IF MOD(i, 2) != 0 THEN  
      DBMS_OUTPUT.PUT_LINE('�������� �����: ' || i);
    END IF;
  END LOOP;
END;

--4 �������

DECLARE
  number_value NUMBER := 16; 
BEGIN
  IF MOD(number_value, 2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE('����� ' || number_value || ' ������ (������� �� 2)');
  ELSE
    DBMS_OUTPUT.PUT_LINE('����� ' || number_value || ' �������� (�� ������� �� 2)');
  END IF;
END;

-- 5 �������

DECLARE
  temperature NUMBER := 22;  
  weather_description VARCHAR2(30);
BEGIN
  weather_description := CASE 
    WHEN temperature > 30 THEN '�����'
    WHEN temperature > 20 THEN '�����'
    WHEN temperature > 10 THEN '���������'
    WHEN temperature > 0  THEN '�������'
    ELSE '�����'
  END;

  DBMS_OUTPUT.PUT_LINE('�����������: ' || temperature || '�C - ' || weather_description);
END;

--������� 6

DECLARE
  i NUMBER := 1;
BEGIN
  WHILE i <= 9 LOOP
    DBMS_OUTPUT.PUT_LINE('�����: ' || i);
    i := i + 1;
  END LOOP;
END;

-- ������ ���
DECLARE
  i NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('�����: ' || i);
    i := i + 1;
    EXIT WHEN i > 9;  
  END LOOP;
END;

--������ ��� 

BEGIN
  FOR i IN 1..9 LOOP
    DBMS_OUTPUT.PUT_LINE('�����: ' || i);
  END LOOP;
END;