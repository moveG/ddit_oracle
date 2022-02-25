2021-0720-02) NULLó�� �Լ�
  - ����Ŭ���� �� �÷��� �⺻ �ʱⰪ�� ��� NULL��
  - NULL�ڷῡ ���� ��Ģ���� ����� ��� NULL��
  - NULL�ڷῡ ���� ������ �� �Լ��� IS NULL, IS NOT NULL, NVL, NVL2, NULLIF ���� ����
  -- NULL���� ���� ��ü�� ���������� ���꿡 �����ϰ� �Ǹ� ������ ��
  -- � ������ �ص� NULL���� ����ϹǷ� ���ϴ� ������� ���� �� ����
  -- �׷��Ƿ� NULL���� ���� ó���� �ʿ���

  1. IS NULL, IS NOT NULL
   - Ư�� �÷��̳� ���� ���� NULL���� �Ǻ��ϱ� ���� ���
   - '=' �����ڷ� NULL�� ���θ� �Ǻ����� ����
   
��뿹) ��� ���̺��� ���������ڵ�(COMMISSION_PCT)�� NULL�� �ƴ� ����� ��ȸ�Ͻÿ�.
       Alias�� �����ȣ, �����, �Ի���, �μ��ڵ�, �޿�
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              HIRE_DATE AS �Ի���,
              DEPARTMENT_ID AS �μ��ڵ�,
              SALARY AS �޿�
         FROM HR.EMPLOYEES
        WHERE COMMISSION_PCT != NULL -- <> NULL
        ORDER BY 1;
        -- != NULL / <> NULL: NULL�� �Ǻ����� ����, ���ǿ� �´� ���� ��� ��µ��� ����
   
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              HIRE_DATE AS �Ի���,
              DEPARTMENT_ID AS �μ��ڵ�,
              SALARY AS �޿�
         FROM HR.EMPLOYEES
        WHERE COMMISSION_PCT IS NOT NULL
        ORDER BY 1;
        -- IS NOT NULL: ������µ�
   
  2. NVL(c, val)
   - 'c'�� ���� �Ǵ��Ͽ� �� ���� NULL�̸� 'val' ���� ��ȯ�ϰ�, NULL�� �ƴϸ� 'c'�� ���� ��ȯ��
   - 'c'�� 'val'�� ������ Ÿ���� �����ؾ���
   -- ���ڿ��� �������̶�� ������ �߻�������, ���ڿ��� ���ڷ� ��ȯ�� �� �ִ� ���ڿ��̶�� �ڵ����� ����ȯ�Ǿ� ������ �߻����� ����
   
��뿹) ��ǰ ���̺��� PROD_SIZE ���� NULL�̸� '��ǰũ������ ����' ���ڿ��� ����Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, ũ��, ���Դܰ�
       SELECT PROD_ID AS ��ǰ�ڵ�,
              PROD_NAME AS ��ǰ��,
              NVL(PROD_SIZE, '��ǰũ������ ����') AS ũ��,
              PROD_COST AS ���Դܰ�
         FROM PROD;
   
��뿹) ��� ���̺��� �����ȣ, �����, �μ��ڵ�, �����ڵ带 ����Ͻÿ�. ��, �μ��ڵ尡 NULL�̸� 'CEO'�� ����Ͻÿ�.
       Alias�� �����ȣ, �����, �μ��ڵ�, �����ڵ�
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              NVL(TO_CHAR(DEPARTMENT_ID), 'CEO') AS �μ��ڵ�,
              JOB_ID AS �����ڵ�
         FROM HR.EMPLOYEES
        ORDER BY 3 DESC;
        -- DEPARTMENT_ID�� NUMBER Ÿ���̰�, CEO�� ���ڿ��̹Ƿ� Ÿ���� �޶� ������ �߻���
        -- DEPARTMENT_ID�� TO_CHAR �Լ��� ���ڿ��� �ٲ�� NVL�� �����۵���
        
** ��ǰ ���̺��� �з��ڵ尡 P301�� ��ǰ�� �ǸŰ��� ���԰��� 90%�� UPDATE�Ͻÿ�.
   UPDATE PROD
      SET PROD_PRICE = PROD_COST
    WHERE LOWER(PROD_LGU) = 'p301';
    -- �з��ڵ��� ��ҹ��ڸ� ��Ȯ�� ��������ϹǷ�, LOWER�� �̿��� PROD_LGU ��ü�� �ҹ��ڷ� �ٲ� ����, p301�� �νĽ�Ŵ.
    COMMIT;

��뿹) 2005�� 7�� ��� ��ǰ�� ���� �Ǹ������� ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, �Ǹż����հ�, �Ǹűݾ��հ�
       SELECT A.CART_PROD AS ��ǰ�ڵ�,
              SUM(A.CART_QTY) AS �Ǹż����հ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS �Ǹűݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD (+)= B.PROD_ID
        GROUP BY A.CART_PROD
        ORDER BY 1;
        -- ��ǰ�ڵ�� CART���� PROD ���̺� �� �����Ƿ� B ���̺��� �÷����� ����ϴ� ���� ����
        -- B.RPOD_ID���� A.CART_PROD�� �� �����Ƿ� A.CART_PROD�ʿ� (+)�� �ٿ������
        -- �ȸ� ���� ���� ���� NULL������ �����
       
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              SUM(A.CART_QTY) AS �Ǹż����հ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS �Ǹűݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD (+)= B.PROD_ID
        GROUP BY B.PROD_ID
        ORDER BY 1;
        -- A.CART_PROD ��ǰ�ڵ� ���� �� ���� B.PROD_ID�� ����ϸ� NULL��� ��ǰ�ڵ尡 ����� ��µ�.
        
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              SUM(A.CART_QTY) AS �Ǹż����հ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS �Ǹűݾ��հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD (+)= B.PROD_ID
          AND A.CART_NO LIKE '200507%'
        GROUP BY B.PROD_ID
        ORDER BY 1;
        -- �ܺ����� ��� ���������� �Ǿ ��Ȯ�� ���� ��µ��� �ʰ� 20���� ���� ��µ�
        -- �ܺ����ο��� ��Ȯ�� ����� ���ؼ��� �������� �Ǵ� ANSI JOIN�� ����ؾ���
       
       (ANSI JOIN ���) 
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              SUM(A.CART_QTY) AS �Ǹż����հ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS �Ǹűݾ��հ�
         FROM CART A
        RIGHT OUTER JOIN PROD B ON(A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200507%')
        GROUP BY B.PROD_ID
        ORDER BY 1;
        
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              NVL(SUM(A.CART_QTY), 0) AS �Ǹż����հ�,
              NVL(SUM(A.CART_QTY * B.PROD_PRICE), 0) AS �Ǹűݾ��հ�
         FROM CART A
        RIGHT OUTER JOIN PROD B ON(A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200507%')
        GROUP BY B.PROD_ID
        ORDER BY 1;
        -- NVL�� ����Ͽ� NULL�� ��� 0�� �����
        
  3. NVL2(c, val1, val2)
   - 'c'�� ���� �Ǵ��Ͽ� �� ���� NULL�̸� 'val2' ���� ��ȯ�ϰ�, NULL�� �ƴϸ� 'val1'�� ���� ��ȯ��
   - 'val1'�� 'val2'�� ������ Ÿ���� �����ؾ���
   - 'c'���� ������ Ÿ���� ������ �ʾƵ� ��
   -- ���ڿ��� �������̶�� ������ �߻�������, ���ڿ��� ���ڷ� ��ȯ�� �� �ִ� ���ڿ��̶�� �ڵ����� ����ȯ�Ǿ� ������ �߻����� ����
   -- NVL(c, val1)�� NVL2(c, c, val2)�������� �� ���� ����
   
��뿹) ��� ���̺��� �����ȣ, �����, �μ��ڵ�, �����ڵ带 ����Ͻÿ�. ��, �μ��ڵ尡 NULL�̸� 'CEO'�� ����Ͻÿ�.
       Alias�� �����ȣ, �����, �μ��ڵ�, �����ڵ�
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              NVL2(TO_CHAR(DEPARTMENT_ID), TO_CHAR(DEPARTMENT_ID), 'CEO') AS �μ��ڵ�,
              JOB_ID AS �����ڵ�
         FROM HR.EMPLOYEES
        ORDER BY 3 DESC;
              
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              NVL2(DEPARTMENT_ID, TO_CHAR(DEPARTMENT_ID), 'CEO') AS �μ��ڵ�,
              JOB_ID AS �����ڵ�
         FROM HR.EMPLOYEES
        ORDER BY 3 DESC;
        -- 'c'���� 'val1', 'val2'���� ������ Ÿ���� ������ �ʾƵ� ��
              
��뿹) ��ǰ ���̺��� ��ǰ�� ��������(PROD_COLOR)�� ���� NULL�̸� '�������� ���� ��ǰ'��, NULL�� �ƴϸ� '�������� ���� ��ǰ'�� ����Ͻÿ�.
       Alias�� PROD_ID, PROD_NAME, PROD_COLOR
       SELECT PROD_ID,
              PROD_NAME,
              NVL(PROD_COLOR, '����') AS ��������,
              NVL2(PROD_COLOR, '�������� ���� ��ǰ', '�������� ���� ��ǰ') AS ��������
         FROM PROD;
        
  4. NULLIF(c1, c2)
   - 'c1'�� 'c2'�� ���Ͽ� ������ NULL�� ��ȯ�ϰ�, ���� ������ 'c1'�� ��ȯ��

��뿹) ��ǰ ���̺��� �ǸŰ��� ���԰��� ���Ͽ� �ǸŰ��� ���� ������ '�����ǰ'�� ������ '������ǰ'�� ������ ����Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, ���԰�, �ǸŰ�, ���
       SELECT PROD_ID AS ��ǰ�ڵ�,
              PROD_NAME AS ��ǰ��,
              PROD_COST AS ���԰�,
              PROD_PRICE AS �ǸŰ�,
              NULLIF(PROD_PRICE, PROD_COST) AS ���
         FROM PROD;
         -- NULLIF���� PROD_PRICE Ȥ�� NULL�� ��µ�

       SELECT PROD_ID AS ��ǰ�ڵ�,
              PROD_NAME AS ��ǰ��,
              PROD_COST AS ���԰�,
              PROD_PRICE AS �ǸŰ�,
              NVL2(NULLIF(PROD_PRICE, PROD_COST), '�����ǰ', '������ǰ') AS ���
         FROM PROD;
         -- NULLIF���� ��ȯ�� PROD_PRICE �Ǵ� NULL��, NVL2�� '�����ǰ'�� '������ǰ'�� �����

��뿹) ��ǰ ���̺��� �ǸŰ��� ���԰��� ���Ͽ� �ǸŰ��� ���԰��� ���� ������ �ǸŰ���, ������ '������ǰ'�� �ǸŰ����� ����Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, ���԰�, �ǸŰ�, ���
       SELECT PROD_ID AS ��ǰ�ڵ�,
              PROD_NAME AS ��ǰ��,
              PROD_COST AS ���԰�,
              NVL2(NULLIF(PROD_PRICE, PROD_COST), TO_CHAR(PROD_PRICE), '������ǰ') AS �ǸŰ�
         FROM PROD;
         
       SELECT PROD_ID AS ��ǰ�ڵ�,
              PROD_NAME AS ��ǰ��,
              PROD_COST AS ���԰�,
              NVL(LPAD(TO_CHAR(NULLIF(PROD_PRICE, PROD_COST)), 10), LPAD(TRIM('������ǰ'), 12)) AS �ǸŰ�
         FROM PROD;
      
         COMMIT;
         