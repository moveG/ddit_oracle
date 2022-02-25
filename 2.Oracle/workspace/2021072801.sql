2021-0728-01) ���տ�����
  - ���տ����ڴ� SELECT���� ����� ������� ������ ����
  - ������ ���������� ������ ���� �� ����
  - �������� SELECT���� �ϳ��� ���� ���� ����
  - UNION ALL, UNION, INTERSECT, MINUS ����
  ** ���ǻ���
    - �� SELECT���� ���� ����, ���� Ÿ���� �÷��� ��ȸ�ؾ���
    - �� SELECT������ �������� �÷��� ��ȸ�ϴ� ��� ��� �÷��� ���� ���տ����� ����
    - ORDER BY�� ����� �� ������ ���� ������ SELECT�������� ����� ����
    - ����� ù��° SELECT���� ���� ������

  1) UNION
    . �������� ����� ��ȯ
    . ������ �κ�(����κ�)�� �ߺ��� ������
    
��뿹) ��� ���̺��� 'Seattle'�� �ٹ��ϴ� ����� 'IT'�μ��� �ٹ��ϴ� ����� ��ȸ�Ͻÿ�.
       1) 'Seattle'�� �ٹ��ϴ� ���
       Alias�� �����ȣ, �����, ������, ������
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              C.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        ORDER BY 1;
              
       2) 'IT'�μ��� �ٹ��ϴ� ���
       Alias�� �����ȣ, �����, ������, ������       
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              B.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'IT'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;
              
       3) ���� : UNION
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              C.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              B.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'IT'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;
     -- UNION�� �� �� ORDER BY���� ���������� ���� �� ����        
              
       4) 'Administration'�μ��� �ٹ��ϴ� ���
       Alias�� �����ȣ, �����, ������, ������       
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              B.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Administration'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;  
  
       5) ���� : UNION
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              C.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              B.JOB_TITLE AS �μ���
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Administration'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;  
  
       6) ���� : UNION
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              C.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              B.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Accounting'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;
  
       7) ���� : UNION ALL -- �� ���̺��� �ߺ� ���� �ߺ� �����
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              C.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION ALL
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              D.CITY AS ������,
              B.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Accounting'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;  
  
��뿹) ȸ�� ���̺��� ���ϸ����� 3000�̻��� ȸ���� ������ �������� ȸ���� ��ȸ�Ͻÿ�.
       1) ���ϸ����� 3000�̻��� ȸ��
       Alias�� ȸ����ȣ, ȸ����, �ּ�, ���ϸ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
        
       2) ������ �������� ȸ��
       Alias�� ȸ����ȣ, ȸ����, �ּ�, ���ϸ���  
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_JOB = '������';
        
       3) ���� : UNION -- ���ϸ����� 3000�̻��� ȸ�� 7��, ������ �������� 4���� ���� �������� ��� �����ϴ� 1���� �ߺ��� �����ؼ� 10���� ��µ�
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000
        UNION
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_JOB = '������';

       4) ���� : UNION -- Ÿ���� �޶� ����� �Ұ�����
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000
        UNION
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_JOB AS ���� -- Ÿ���� �޶� ����� �Ұ�����
         FROM MEMBER
        WHERE MEM_JOB = '������';

       5) ���� : UNION -- ���ϸ����� �ֹι�ȣ1�� Ÿ���� ���������� ���� �޶� �ߺ����� �Ǵ����� �ʰ� ������ ��� �����
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000
        UNION
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              TO_NUMBER(MEM_REGNO1) AS �ֹι�ȣ1
         FROM MEMBER
        WHERE MEM_JOB = '������';
        -- �� �� ������ ���� �����ִ� ���� ����

  2) UNION ALL
    . �������� ����� ��ȯ
    . ������ �κ�(����κ�)�� �ߺ��Ǿ� ��µ�

��뿹) ȸ�� ���̺��� ���ϸ����� 2000�̻��� ȸ���� ������ �ֺ��� ȸ���� ��ȸ�Ͻÿ�.
       1) ���ϸ����� 2000�̻��� ȸ��
       Alias�� ȸ����ȣ, ȸ����, �ּ�, ���ϸ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE >= 2000;
        
       2) ������ �ֺ��� ȸ��
       Alias�� ȸ����ȣ, ȸ����, �ּ�, ���ϸ���  
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_JOB = '�ֺ�';
        
       3) ���� : UNION
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE >= 2000
        UNION
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_JOB = '�ֺ�';

       4) ���� : UNION ALL -- f001 ���� ��� ���ϸ����� 2000�̻��̾ ��µǰ�, ������ �ֺζ� ��µ�, �ߺ��� �������� ����
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE >= 2000
        UNION ALL
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_JOB = '�ֺ�';

��뿹) 2005�� 4���� 7���� �ȸ� ��ǰ������ ��ȸ�Ͻÿ�.
       1) 2005�� 4���� �ȸ� ��ǰ���� -- 67�� ���
       Alias�� ��ǰ�ڵ�, ��ǰ��, �ǸŰ���, �ŷ�ó��
       SELECT DISTINCT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              B.PROD_PRICE AS �ǸŰ���,
              C.BUYER_NAME AS �ŷ�ó��
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        ORDER BY 1;

       2) 2005�� 7���� �ȸ� ��ǰ����
       Alias�� ��ǰ�ڵ�, ��ǰ��, �ǸŰ���, �ŷ�ó�� -- 20�� ���
       SELECT DISTINCT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              B.PROD_PRICE AS �ǸŰ���,
              C.BUYER_NAME AS �ŷ�ó��
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;

       3) ���� : UNION -- 68�� ���
       SELECT DISTINCT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              B.PROD_PRICE AS �ǸŰ���,
              C.BUYER_NAME AS �ŷ�ó��
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        UNION
       SELECT DISTINCT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              B.PROD_PRICE AS �ǸŰ���,
              C.BUYER_NAME AS �ŷ�ó��
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;

       3) ���� : UNION ALL -- 87�� ���
       SELECT DISTINCT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              B.PROD_PRICE AS �ǸŰ���,
              C.BUYER_NAME AS �ŷ�ó��
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        UNION ALL
       SELECT DISTINCT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              B.PROD_PRICE AS �ǸŰ���,
              C.BUYER_NAME AS �ŷ�ó��
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;

  3) INTERSECT
    . ������(����κ�)�� ����� ��ȯ

��뿹) 2005�� 4���� �Ǹŵ� ��ǰ ��, 7������ �Ǹŵ� ��ǰ������ ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �ǸŰ���, �ŷ�ó��
       1) ���� : INTERSECT
       SELECT DISTINCT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              B.PROD_PRICE AS �ǸŰ���,
              C.BUYER_NAME AS �ŷ�ó��
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        INTERSECT
       SELECT DISTINCT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              B.PROD_PRICE AS �ǸŰ���,
              C.BUYER_NAME AS �ŷ�ó��
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;
  
��뿹) �μ����� 'Shipping'�� ���� ��� �� 'Matthew Weiss' ����� ���� �Ҽӵ� ������ ��ȸ�Ͻÿ�.
       1) �μ����� 'Shipping'�� ���� ��� -- 45�� ���
       Alias�� �����ȣ, �����, �μ���, �Ի���, �޿�
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              B.DEPARTMENT_NAME AS �μ���,
              A.HIRE_DATE AS �Ի���,
              A.SALARY AS �޿�
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE B.DEPARTMENT_NAME = 'Shipping'
          AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
        ORDER BY 1;

       2) 'Mattew Weiss' ����� ���� �Ҽӵ� ���� -- 8�� ���
       Alias�� �����ȣ, �����, �μ���, �Ի���, �޿�
       SELECT C.EMPLOYEE_ID AS �����ȣ,
              C.EMP_NAME AS �����,
              D.DEPARTMENT_NAME AS �μ���,
              C.HIRE_DATE AS �Ի���,
              C.SALARY AS �޿�
         FROM (SELECT A.EMPLOYEE_ID AS EID
                 FROM HR.EMPLOYEES A
                WHERE A.EMP_NAME = 'Matthew Weiss') B,
              HR.EMPLOYEES C, HR.DEPARTMENTS D
        WHERE C.MANAGER_ID = B.EID
          AND C.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY 1;
        
       3) ���� : INTERSECT -- 8�� ���
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              B.DEPARTMENT_NAME AS �μ���,
              A.HIRE_DATE AS �Ի���,
              A.SALARY AS �޿�
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND B.DEPARTMENT_NAME = 'Shipping'
        INTERSECT
       SELECT C.EMPLOYEE_ID AS �����ȣ,
              C.EMP_NAME AS �����,
              D.DEPARTMENT_NAME AS �μ���,
              C.HIRE_DATE AS �Ի���,
              C.SALARY AS �޿�
         FROM (SELECT A.EMPLOYEE_ID AS EID
                 FROM HR.EMPLOYEES A
                WHERE A.EMP_NAME = 'Matthew Weiss') B,
              HR.EMPLOYEES C, HR.DEPARTMENTS D
        WHERE C.MANAGER_ID = B.EID
          AND C.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY 1;

  4) MINUS
    . MINUS ������ �տ� ��ġ�� ������ ������� MINUS �ڿ� ����� ������ ����� ������ ����� ��ȯ

��뿹) ��ٱ��� ���̺��� 4���� 6���� �Ǹŵ� ��ǰ �� 4������ �Ǹŵ� ��ǰ�� ��ȸ�Ͻÿ�.
       1) 4���� �Ǹŵ� ��ǰ -- 67�� ���
       Alias�� ��ǰ��ȣ, ��ǰ��, �����հ�, �Ǹűݾ��հ�
       SELECT DISTINCT A.CART_PROD AS ��ǰ��ȣ,
              B.PROD_NAME AS ��ǰ��,
              SUM(A.CART_QTY) AS �����հ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS �Ǹűݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200504%'
        GROUP BY A.CART_PROD, B.PROD_NAME
        ORDER BY 1;
        
       2) 6���� �Ǹŵ� ��ǰ -- 15�� ���
       Alias�� ��ǰ��ȣ, ��ǰ��, �����հ�, �Ǹűݾ��հ�
       SELECT DISTINCT A.CART_PROD AS ��ǰ��ȣ,
              B.PROD_NAME AS ��ǰ��,
              SUM(A.CART_QTY) AS �����հ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS �Ǹűݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200506%'
        GROUP BY A.CART_PROD, B.PROD_NAME
        ORDER BY 1;
        
       3) ���� : MINUS -- 53�� ���
       SELECT DISTINCT A.CART_PROD AS ��ǰ��ȣ,
              B.PROD_NAME AS ��ǰ��
--            SUM(A.CART_QTY) AS �����հ�,
--            SUM(A.CART_QTY * B.PROD_PRICE) AS �Ǹűݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200504%'
--      GROUP BY A.CART_PROD, B.PROD_NAME
        MINUS
       SELECT DISTINCT A.CART_PROD AS ��ǰ��ȣ,
              B.PROD_NAME AS ��ǰ��
--            SUM(A.CART_QTY) AS �����հ�,
--            SUM(A.CART_QTY * B.PROD_PRICE) AS �Ǹűݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200506%'
--      GROUP BY A.CART_PROD, B.PROD_NAME
        ORDER BY 1;
        
        COMMIT;