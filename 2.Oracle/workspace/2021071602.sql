2021-0716-02) �����Լ�
  - �־��� �ڷḦ Ư�� �÷��� �������� �׷����� ������, �׷� ���� �ڷῡ ���� ���踦 ��ȯ�ϴ� �Լ�
  - SUM, AVG, COUNT, MIN, MAX
  -- ���� ���ĳ��� ������ ��
  -- SELECT���� �����ؾ���, SELECT���� �߸� �����ϸ� ���ϴ� �ڷḦ ��� �����
  -- �Ϲ��÷��� �����Լ��� �Բ� ������, �Ϲ��÷��� �������� �׷��� �̷� �����Լ��� ����� �����
  -- �μ��ڵ�, �ο���, ����ӱ��� ������, �Ϲ��÷��� �μ��ڵ带 �������� �׷��� �̷� �����Լ��� �̿��� �ο����� ����ӱ��� ����ϸ� ��
  -- �����Լ��� ������ ���� �Ϲ��÷��� GROUP BY�� ��� ����ؼ� ���������
  -- ���ʿ��� ���������� ������ �׷� ũ�Ⱑ �۾���(��׷� => �ұ׷�)
  -- �׷� �ȿ�, �׷� �ȿ�, �׷� �ȿ�... ��ø�� �׷��� ��
  
  (�������)
   SELECT [�÷�list],
          SUM|AVG|MIN|MAX(expr)|COUNT(column|*),
                      :
     FROM ���̺��
   [WHERE ����]
   [GROUP BY �÷���[, �÷���,...]]
  [HAVING ����]
   [ORDER BY �÷���|�÷��ε���[ASC|DESC][, �÷���|�÷��ε���[ASC|DESC],...]];
   -- []���� ���� ������ ������ �κ���
   -- HAVING, WHERE�� ������ ������ ����
   -- WHERE���� �Ϲ����� ������ �����
   -- HAVING���� �����Լ���(SUM, AVG, MIN MAX, COUNT) �ο��� ������ �����
   -- WHERE, GROUP BY, HAVING, ORDER BY ������ ���� ���°� ����
 
  1. SUM(expr)
   - 'expr'�� ǥ���Ǵ� ���� �Ǵ� �÷��� ���� ���� �հ踦 ��ȯ

��뿹) ��� ���̺��� ��� ����� �޿� �Ѿ��� ���Ͻÿ�.
       SELECT SUM(SALARY)
         FROM HR.EMPLOYEES;
         -- �Ϲ��÷��� �����ϸ� GROUP BY�� �ʼ� ������, �Ϲ��÷��� ������ GROUP BY�� ���ʿ���
        
��뿹) ��� ���̺��� �μ��� �޿� �հ踦 ���Ͻÿ�.
       -- **��: **�� �⺻�÷��� �Ǿ����
       SELECT DEPARTMENT_ID AS �μ��ڵ�,
              SUM(SALARY) AS �޿��հ�
         FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID
        ORDER BY 1;
        -- �Ϲ��÷��� GROUP BY�� �̿��� ���������
   
��뿹) ��� ���̺��� �μ��� �޿� �հ踦 ���ϵ�, �հ谡 10000�̻��� �μ��� ��ȸ�Ͻÿ�.
       ���� : �հ谡 10000�̻�
       SELECT DEPARTMENT_ID AS �μ��ڵ�,
              SUM(SALARY) AS �޿��հ�
         FROM HR.EMPLOYEES
     -- WHERE SUM(SALARY) >= 10000
        WHERE DEPARTMENT_ID IS NOT NULL -- �μ��ڵ尡 ���� ������ ����, ����ŬSQL�� '!=' ��ȣ�� �ν����� ����
        GROUP BY DEPARTMENT_ID
       HAVING SUM(SALARY) >= 10000 -- �����Լ��� ���� ������ HAVING �κп� ����ؾ���
        ORDER BY 1;
   
��뿹) 2005�� 5�� ȸ���� ������Ȳ(ȸ����ȣ, ���ż����հ�, ���űݾ��հ�)�� ��ȸ�Ͻÿ�.
       SELECT A.CART_MEMBER AS ȸ����ȣ,
              SUM(A.CART_QTY) AS ���ż����հ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS ���űݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER;

��뿹) 2005�� ���� ȸ���� ������Ȳ(���ſ�, ȸ����ȣ, ���ż����հ�, ���űݾ��հ�)�� ��ȸ�Ͻÿ�.
       SELECT SUBSTR(A.CART_NO, 5, 2) AS ���ſ�,            -- �Ϲ��÷�
              A.CART_MEMBER AS ȸ����ȣ,                    -- �Ϲ��÷�
              SUM(A.CART_QTY) AS ���ż����հ�,               -- �����Լ�
              SUM(A.CART_QTY * B.PROD_PRICE) AS ���űݾ��հ� -- �����Լ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID            
          AND SUBSTR(A.CART_NO, 1, 4) = '2005'          -- 2005��
        GROUP BY SUBSTR(A.CART_NO, 5, 2), A.CART_MEMBER -- ����, ȸ���� / �Ϲ��÷� ������
        ORDER BY 1, 2;
   
��뿹) ȸ�� ���̺��� ������ ���ϸ��� �հ踦 ���Ͻÿ�.
       SELECT MEM_JOB AS ����,                  -- �Ϲ��÷�
              SUM(MEM_MILEAGE) AS "���ϸ��� �հ�" -- �����Լ�
         FROM MEMBER
        GROUP BY MEM_JOB                       -- ������ / �Ϲ��÷��� ������
        ORDER BY 1;
        -- �������� ��� �հ踦 ���ϴ� ���� ����Ŭ�� �ؾ��� ���̹Ƿ�, WHERE���� �̸� ���ϱ� ���� ������ ����� �ʿ䰡 ����
   
����) ��� ���̺��� �ٹ������� �޿��հ踦 ���Ͻÿ�.
     SELECT D.COUNTRY_ID AS �����ڵ�,
            D.COUNTRY_NAME AS ������,
            COUNT(*) AS �����,
            TO_CHAR(SUM(A.SALARY), '999,990') AS �޿��հ�
       FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C, HR.COUNTRIES D
      WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        AND B.LOCATION_ID = C.LOCATION_ID
        AND C.COUNTRY_ID = D.COUNTRY_ID
      GROUP BY D.COUNTRY_ID, D.COUNTRY_NAME -- D.COUNTRY_NAME�� ���� �ǹ̰� ������, GROUP BY ���� ������ ���߱� ���� ���������
      ORDER BY 1;
      
��뿹) ��� ���̺��� �� �μ��� ���ʽ� �հ踦 ���Ͻÿ�.
       Alias�� �μ��ڵ�, �μ���, ���ʽ� �հ��̰�, ���ʽ��� ��������(COMMISSION_PCT)�� �޿��� ���� ����� 30%
       UPDATE HR.EMPLOYEES
          SET COMMISSION_PCT = 0.2
        WHERE EMPLOYEE_ID = 107;
        
        COMMIT;
     
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              B.DEPARTMENT_NAME AS �μ���,
              NVL(SUM(A.COMMISSION_PCT * A.SALARY) * 0.3, 0) AS "���ʽ� �հ�"
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        GROUP BY A.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
        -- ���� JOIN�� JOIN ������ ���� ������, �� ���� ������
        
        COMMIT;
