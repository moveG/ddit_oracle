��뿹) ȸ�� ���̺��� �泲�� �����ϴ� ȸ�������� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �ֹι�ȣ, �ּ��̸�, �ֹι�ȣ�� 'XXXXXX-XXXXXXX'�������� ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '�泲%'
        ORDER BY 1;

��뿹) ȸ�� ���̺��� �泲�� �����ϴ� ȸ�������� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �ֹι�ȣ, �ּ��̸�, �ֹι�ȣ�� 'XXXXXX-XXXXXXX'�������� ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              CONCAT(CONCAT(MEM_REGNO1, '-'), MEM_REGNO2) AS �ֹι�ȣ,
              CONCAT(CONCAT(MEM_ADD1, ' '), MEM_ADD2) AS �ּ�
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '�泲%'
        ORDER BY 1;

��뿹) ������ 2005�� 4�� 1���� ��� CART_NO�� �ڵ� �����Ͻÿ�.
       SELECT TO_CHAR(SYSDATE, 'YYYYMMDD')||TRIM(TO_CHAR(TO_NUMBER(SUBSTR((CART_NO), 9)) + 1, '00000'))
         FROM CART
        WHERE CART_NO LIKE '20050401%';
        
       SELECT MAX(CART_NO) + 1
         FROM CART
        WHERE CART_NO LIKE '20050401%';

��뿹) 
       SELECT REPLACE('���������� �߱� ���ﵿ', '��������', '����'),
              REPLACE('���������� �߱� ���ﵿ', '����'),
              REPLACE('���������� �߱� ���ﵿ', ' '),
              REPLACE('���������� �߱� ���ﵿ', '��')
         FROM DUAL;
         
��뿹) 
       SELECT INSTR('APPLE PERSIMON PEAR BEAR', 'E'),
              INSTR('APPLE PERSIMON PEAR BEAR', 'P', 5),
              INSTR('APPLE PERSIMON PEAR BEAR', 'P', 5, 2),
              INSTR('APPLE PERSIMON PEAR BEAR', 'P', 5, 3)
         FROM DUAL;
         
��뿹) 
       SELECT GREATEST(50, 70, 90),
              LEAST(50, 70, 90)
         FROM DUAL;
         
��뿹) ȸ�� ���̺��� ���ϸ����� 1000 �̸��� ��� ȸ���� ���ϸ����� 1000���� ���� ����Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���� ���ϸ���, �������ϸ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS "���� ���ϸ���",
              GREATEST(MEM_MILEAGE, 1000) AS "���� ���ϸ���"
         FROM MEMBER;
         
       SELECT MAX(MEM_NAME) FROM MEMBER;


         
��뿹) ȸ�� ���̺��� ���ϸ����� 1000 �̸��� ��� ȸ���� ���ϸ����� 1000���� ���� ����Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���� ���ϸ���, �������ϸ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS "���� ���ϸ���",
              GREATEST(MEM_MILEAGE, 1000) AS "���� ���ϸ���"
         FROM MEMBER;
         
       SELECT GRREATEST(MEM_NAME) FROM MEMBER; -- ����
       SELECT MAX(MEM_NAME) FROM MEMBER; -- ����

��뿹) ��� ���̺��� �޿��� ���޾��� ����Ͽ� ����Ͻÿ�.
       Alias�� �����ȣ, �����, �޿�, ����, ���޾�
       ���� = �޿����� 17%
       ���޾��� �޿� - ����
       �Ҽ��� 1�ڸ����� ���
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              SALARY AS �޿�,
              TRUNC(SALARY * 0.17, 1) AS ����,
              SALARY - TRUNC(SALARY * 0.17, 1) AS ���޾�
         FROM HR.EMPLOYEES;
       
��뿹) 2005�� 1�� ~ 3�� ��ǰ�з��� ��ո��Ծ��� ��ȸ�Ͻÿ�.
       Alias�� �з��ڵ�, �з���, ��ո��Աݾ�
       ��ո��Աݾ��� ������(�Ҽ��� ����) ǥ��, 1�� �ڸ����� �ݿø�
       SELECT C.PROD_LGU AS �з��ڵ�,
              B.LPROD_NM AS �з���,
              ROUND(AVG(A.BUY_QTY * C.PROD_COST), -1) AS ��ո��Աݾ�
         FROM BUYPROD A, LPROD B, PROD C
        WHERE A.BUY_PROD = C.PROD_ID
          AND C.PROD_LGU = B.LPROD_GU
          AND A.BUY_DATE BETWEEN '20050101' AND '20050331'
        GROUP BY C.PROD_LGU, B.LPROD_NM
        ORDER BY 1;
       
��뿹) 
       SELECT FLOOR(12.5), CEIL(12.5),
              FLOOR(12), CEIL(12),
              FLOOR(-12.5), CEIL(-12.5)
         FROM DUAL;

��뿹) ������ �⵵�� �Է¹޾� ����� ����� �����Ͻÿ�.
       ����: (4�� ����̸鼭 100�� ����� �ƴϰų�),
            (400�� ����� �Ǵ� ��)
       ACCEPT P_YEAR  PROMPT '�⵵ �Է�'
       DECLARE
         V_YEAR NUMBER(4) := TO_NUMBER('&P_YEAR');
         V_RES VARCHAR(100);
       BEGIN
         IF (MOD(V_YEAR, 4) = 0 AND MOD(V_YEAR, 100) != 0) OR MOD(V_YEAR, 400) = 0 THEN
            V_RES := TO_CHAR(V_YEAR)||'���� �����Դϴ�.';
         ELSE
            V_RES := TO_CHAR(V_YEAR)||'���� ����Դϴ�.';
         END IF;
         
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;
       
��뿹) 
       SELECT WIDTH_BUCKET(90, 0, 100, 10) FROM DUAL;       
       
��뿹) ȸ�� ���̺��� ȸ������ ���ϸ����� 3���� �׷����� ������ �� ȸ������ ���ϸ����� ���� �׷��� ��ȸ�Ͽ�
       1�׷쿡 ���� ȸ���� '���� ȸ��',
       2�׷쿡 ���� ȸ���� '���� ȸ��',
       3�׷쿡 ���� ȸ���� 'VIP ȸ��'�� ������ ����Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ����, ���ϸ���, ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���,
              CASE WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 3) = 1 THEN
                        '���� ȸ��'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 3) = 2 THEN
                        '���� ȸ��'
                   ELSE
                        'VIP ȸ��'
              END AS ���
         FROM MEMBER;

��뿹)         
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���,
              CASE WHEN WIDTH_BUCKET(MEM_MILEAGE, (SELECT MIN(MEM_MILEAGE)
                                                     FROM MEMBER),
                                                  (SELECT MAX(MEM_MILEAGE) + 1
                                                     FROM MEMBER), 3) = 1 THEN
                        '���� ȸ��'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, (SELECT MIN(MEM_MILEAGE)
                                                     FROM MEMBER),
                                                  (SELECT MAX(MEM_MILEAGE) + 1
                                                     FROM MEMBER), 3) = 2 THEN
                        '���� ȸ��'
                   ELSE
                        'VIP ȸ��'
              END AS ���
         FROM MEMBER;

��뿹) ȸ�� ���̺��� ȸ������ ���ϸ����� 5���� �׷����� ������ ����� ������ ����Ͻÿ�.
       ����� ���ϸ����� ���� ȸ���� 1����̰�, ���� ���� ȸ���� 5����̴�.
       Alias�� ȸ����ȣ, ȸ����, ����, ���ϸ���, ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���,
              CASE WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 1 THEN
                        '5���'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 2 THEN
                        '4���'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 3 THEN
                        '3���'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 4 THEN
                        '2���'
                   ELSE
                        '1���'
              END AS ���
         FROM MEMBER
        ORDER BY 5;
       
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS ���ϸ���,
              WIDTH_BUCKET(MEM_MILEAGE, 9000, 500, 5)||'���' AS ���
         FROM MEMBER
        ORDER BY 4;
       
��뿹)
       SELECT SYSDATE - 10,
              TO_CHAR(SYSDATE, 'YYYY MM DD HH24:MI:SS'),
              TRUNC(SYSDATE - TO_DATE('19900715'))
         FROM DUAL;
       
��뿹) ����� ���� �Ի����� �����Ⱓ 3������ ���� ��¥�̴�. �� ����� �� ȸ�翡 ó�� �Ի��� ��¥�� ���Ͻÿ�.
       Alias�� �����ȣ, �����, �Ի���, �����Ի���, �ҼӺμ�
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              A.HIRE_DATE AS �Ի���,
              ADD_MONTHS(A.HIRE_DATE, -3) AS �����Ի���,
              B.DEPARTMENT_NAME AS �ҼӺμ�
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        ORDER BY 5;
        
��뿹)
       SELECT NEXT_DAY(SYSDATE, '��'),
              NEXT_DAY(SYSDATE, '��'),
              NEXT_DAY(SYSDATE, '�Ͽ���')
         FROM DUAL;
       
��뿹) ���� ���̺�(BUYPROD)���� 2���� ���Ե� ���԰Ǽ��� ��ȸ�Ͻÿ�.
       --���԰Ǽ��� BUY_QTY�� ���(�ټ�)
       SELECT COUNT(*) AS ���԰Ǽ�
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050201') AND LAST_DAY(TO_DATE('20050201'));

��뿹)
       SELECT MONTHS_BETWEEN(SYSDATE, HIRE_DATE) AS �ټӰ�����
         FROM HR.EMPLOYEES;
         
       SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS �ټӰ�����
         FROM HR.EMPLOYEES;
 
       SELECT EMP_NAME,
              HIRE_DATE,
              TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) ||'�� '||
              MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), 12) ||'����' AS �ټӱⰣ
         FROM HR.EMPLOYEES;

��뿹) �̹� �޿� ������ �ִ� ȸ���� ������ ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �������
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_BIR AS �������
         FROM MEMBER
        WHERE EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM MEM_BIR);
        -- 7���� ������ ��� ����� ����
       
       SELECT EXTRACT(HOUR FROM SYSTIMESTAMP),
              EXTRACT(MINUTE FROM SYSTIMESTAMP),
              EXTRACT(SECOND FROM SYSTIMESTAMP)
         FROM DUAL;

��뿹) 
       SELECT MEM_NAME AS ȸ����,
              CAST(SUBSTR(MEM_REGNO1, 1, 2) AS NUMBER) + 1900 AS ����⵵,
              EXTRACT(YEAR FROM SYSDATE) - (CAST(SUBSTR(MEM_REGNO1, 1, 2) AS NUMBER) + 1900) AS ����
         FROM MEMBER
        WHERE NOT MEM_REGNO1 LIKE '0%'
    
��뿹) 
       SELECT SYSDATE FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'CC') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'CC BC YYYY"��"') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'CC BC YY"��"') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'CC BC YYYY"��" Q"�б�"') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'YYYY MON MONTH') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'YYYY MON DD DDD J') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'YYYY DAY DY D') FROM DUAL;

��뿹) 
       SELECT TO_CHAR(2345, '99,999') FROM DUAL;
       SELECT TO_CHAR(2345, '00,000') FROM DUAL;
       SELECT TO_CHAR(12345, 'L99,999') FROM DUAL;
       SELECT TO_CHAR(12345, '99,999L') FROM DUAL;
       SELECT TO_CHAR(12345, '$99,999') FROM DUAL;
       SELECT TO_CHAR(-12345, '99,999PR') FROM DUAL;
       SELECT TO_CHAR(12345, '99,999PR') FROM DUAL;
       SELECT TO_CHAR(255, 'XXXX') FROM DUAL;
       SELECT TO_CHAR(255, 'XX') FROM DUAL;
    
��뿹) 
       SELECT TO_NUMBER('12345', '99999'),
              TO_NUMBER('12345', '9999999'),
              TO_NUMBER('12345', '9000000'),
              TO_NUMBER('12345', '9900000'),
           -- TO_NUMBER('12345', '0000009'),
           -- TO_NUMBER('12345', '99,999'),
           -- TO_NUMBER('-12345', '99999PR'),
              TO_NUMBER('12345', '99999PR'),
              TO_NUMBER('12345')
         FROM DUAL;

��뿹) 
       SELECT TO_DATE('20200320'),
              TO_DATE('20200320', 'YYYYMMDD'),
              TO_DATE('20200320', 'YYYY/MM/DD'),
              TO_DATE('20200320', 'YYYY MM DD')
           -- TO_DATE('20200332', 'YYYY MM DD')
           -- TO_DATE('20200320', 'AM YYYYMMDD')
           -- TO_DATE('20200320', 'YYYY MONTH DD')
         FROM DUAL;

��뿹) ��� ���̺��� ��� ����� �޿� �Ѿ��� ���Ͻÿ�.
       SELECT SUM(SALARY)
         FROM HR.EMPLOYEES;
           
��뿹) ��� ���̺��� �μ��� �޿� �հ踦 ���Ͻÿ�.
       -- **��: **�� �⺻�÷��� �Ǿ����
       SELECT DEPARTMENT_ID AS �μ��ڵ�,
              SUM(SALARY) AS �޿��հ�
         FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID
        ORDER BY 1;

��뿹) ��� ���̺��� �μ��� �޿� �հ踦 ���ϵ�, �հ谡 10000�̻��� �μ��� ��ȸ�Ͻÿ�.
       ���� : �հ谡 10000�̻�
       SELECT DEPARTMENT_ID AS �μ��ڵ�,
              SUM(SALARY) AS �޿��հ�
         FROM HR.EMPLOYEES
        WHERE DEPARTMENT_ID IS NOT NULL
        GROUP BY DEPARTMENT_ID
       HAVING SUM(SALARY) >= 10000
        ORDER BY 1;

��뿹) 2005�� 5�� ȸ���� ������Ȳ(ȸ����ȣ, ���ż����հ�, ���űݾ��հ�)�� ��ȸ�Ͻÿ�.
       SELECT A.CART_MEMBER AS ȸ����ȣ,
              SUM(A.CART_QTY) AS ���ż����հ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS ���űݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY CART_MEMBER
        ORDER BY 1;
        
��뿹) 2005�� ���� ȸ���� ������Ȳ(���ſ�, ȸ����ȣ, ���ż����հ�, ���űݾ��հ�)�� ��ȸ�Ͻÿ�.
       SELECT SUBSTR(A.CART_NO, 5, 2) AS ���ſ�,
              A.CART_MEMBER AS ȸ����ȣ,
              SUM(A.CART_QTY) AS ���ż����հ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS ���űݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO, 1, 4) = '2005'
        GROUP BY SUBSTR(A.CART_NO, 5, 2), A.CART_MEMBER
        ORDER BY 1, 2;

��뿹) ȸ�� ���̺��� ������ ���ϸ��� �հ踦 ���Ͻÿ�.
       SELECT MEM_JOB AS ����,
              SUM(MEM_MILEAGE) AS "���ϸ��� �հ�"
         FROM MEMBER
        GROUP BY MEM_JOB
        ORDER BY 2;
       
��뿹) ��� ���̺��� �ٹ������� �޿��հ踦 ���Ͻÿ�
       SELECT A.COUNTRY_NAME AS �ٹ�����,
              SUM(B.SALARY) AS �޿��հ�
         FROM HR.COUNTRIES A, HR.EMPLOYEES B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE A.COUNTRY_ID = D.COUNTRY_ID
          AND D.LOCATION_ID = C.LOCATION_ID
          AND C.DEPARTMENT_ID = B.DEPARTMENT_ID
        GROUP BY A.COUNTRY_NAME
        ORDER BY 1;
    
        COMMIT;