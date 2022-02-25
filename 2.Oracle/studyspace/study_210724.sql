��뿹) ��� ȸ������ ��� ���ϸ����� ��ȸ�Ͻÿ�.
       SELECT ROUND(AVG(MEM_MILEAGE), 2) AS "��� ���ϸ���"
         FROM MEMBER;
         
��뿹) ��� ���� ȸ������ ��� ���ϸ����� ��ȸ�Ͻÿ�.   
       SELECT ROUND(AVG(MEM_MILEAGE), 2) AS "��� ���ϸ���"
         FROM MEMBER
        WHERE SUBSTR(MEM_REGNO2, 1, 1) IN('2', '4');
        
��뿹) ȸ������ ���� ��� ���ϸ����� ��ȸ�Ͻÿ�.
       SELECT CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '2'
                     OR SUBSTR(MEM_REGNO2, 1, 1) = '4' THEN
                        '����ȸ��'
                   ELSE 
                        '����ȸ��' END AS ����,
              ROUND(AVG(MEM_MILEAGE)) AS "��� ���ϸ���"
         FROM MEMBER
        GROUP BY CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '2'
                        OR SUBSTR(MEM_REGNO2, 1, 1) = '4' THEN
                           '����ȸ��'
                      ELSE 
                           '����ȸ��' END;

��뿹) ��� ���̺��� �� �μ��� ��ձ޿��� ���Ͻÿ�.
       Alias�� �μ��ڵ�, �μ���, ��ձ޿�
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              B.DEPARTMENT_NAME AS �μ���,
              '$'||TO_CHAR(ROUND(AVG(SALARY)), '99,999') AS ��ձ޿�
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        GROUP BY A.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
        -- DEPARTMENT_IDó�� ���� ���̺��� ���Ǵ� �÷��� ���� ��Ī�� �ٿ�, Ȯ���ϰ� �����������
        -- B.DEPARTMENT_NAMEó�� �� ���̺����� ����ϴ� �÷��� ��Ī(B)�� ���� ����������, �� �� ������ ���� ��Ī�� �ٿ��ִ°� ����
        
��뿹) 2005�� 1~6�� ���� ��� ���Ծ��� ��ȸ�Ͻÿ�.
       -- ���Ծ� BUYPROD, �����ڷ� CART, ��ǰ�ڷ� PROD, ȸ���ڷ� MEMBER, �ŷ�ó�ڷ� BUYER
       SELECT EXTRACT(MONTH FROM BUY_DATE)||'��' AS ��,
              TO_CHAR(ROUND(AVG(BUY_QTY * BUY_COST)), '99,999,999')||' ��' AS "��� ���Ծ�"
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050630')
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
        ORDER BY 1;
        
��뿹) 2005�� 1~6�� ���� ��� ���Ծװ� ���Ծ� �հ踦 ��ȸ�ϵ�, ��� ���Ծ��� 400���� �̻��� ���� ��ȸ�Ͻÿ�.
       SELECT EXTRACT(MONTH FROM BUY_DATE)||'��' AS ��,
              TO_CHAR(ROUND(AVG(BUY_QTY * BUY_COST)), '99,999,999')||' ��' AS "��� ���Ծ�",
              TO_CHAR(SUM(BUY_QTY * BUY_COST), '999,999,999')||' ��' AS "���Ծ� �հ�"
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050630')
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
       HAVING AVG(BUY_QTY * BUY_COST) >= 4000000
        ORDER BY 1;        
        
��뿹) 2005�� 1~6�� ���� ��� ���Ծװ� ���Ծ� �հ�� ���԰Ǽ��� ��ȸ�ϵ�, ��� ���Ծ��� 400���� �̻��� ���� ��ȸ�Ͻÿ�.
       SELECT EXTRACT(MONTH FROM BUY_DATE)||'��' AS ��,
              COUNT(*)||' ��' AS ���԰Ǽ�,
              TO_CHAR(ROUND(AVG(BUY_QTY * BUY_COST)), '99,999,999')||' ��' AS "��� ���Ծ�",
              TO_CHAR(SUM(BUY_QTY * BUY_COST), '999,999,999')||' ��' AS "���Ծ� �հ�"
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050630')
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
       HAVING AVG(BUY_QTY * BUY_COST) >= 4000000
        ORDER BY 1;
        
��뿹) 2005�� �з��� ��� �Ǹűݾ��� ��ȸ�Ͻÿ�.
       SELECT B.LPROD_GU AS �з��ڵ�,
              B.LPROD_NM AS �з���,
              TO_CHAR(ROUND(AVG(A.CART_QTY * C.PROD_PRICE)), '9,999,999')||' ��' AS "��� �Ǹűݾ�"
         FROM CART A, LPROD B, PROD C
        WHERE A.CART_PROD = C.PROD_ID
          AND C.PROD_LGU = B.LPROD_GU
          AND SUBSTR(A.CART_NO, 1, 4) = '2005'
        GROUP BY B.LPROD_GU, B.LPROD_NM
        ORDER BY 1;

��뿹) 2005�� ȸ���� ���ɴ뺰 ��� �Ǹűݾ��� ��ȸ�Ͻÿ�.
       SELECT TRUNC((EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM C.MEM_BIR)) / 10) * 10||'��' AS ���ɴ�,
              TO_CHAR(ROUND(AVG(A.CART_QTY * B.PROD_PRICE)), '9,999,999')||' ��' AS "��� �Ǹűݾ�"
         FROM CART A, PROD B, MEMBER C
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_MEMBER = C.MEM_ID
          AND A.CART_NO LIKE '2005%'
        GROUP BY TRUNC((EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM C.MEM_BIR)) / 10) * 10
        ORDER BY 1;

����) ����� �� �ڱⰡ ���� �μ��� ��ձ޿����� ���� �޿��� �޴� ���������� ��ȸ�Ͻÿ�.
     Alias�� �����ȣ, �����, �μ���ȣ, �μ���, �޿�, �μ���ձ޿�
     �������� : 2021�� 7�� 31�ϱ���
     ������ : ����� PC ���������� ����(SEM-PC D:\��������\oracle\homework)
     ����Ÿ�� : �޸��忡 ����� TEXT����
     �����̸� : �����̸�_0731.TXT
     SELECT TBLB.EMPLOYEE_ID AS �����ȣ,
            TBLB.EMP_NAME AS �����,
            TBLA.DEPT_ID AS �μ���ȣ,
            TBLA.DEPT_NAME AS �μ���,
            TBLB.SALARY AS �޿�,
            TBLA.DEPT_AVG AS �μ���ձ޿�
       FROM (SELECT A.DEPARTMENT_ID AS DEPT_ID,
                    A.DEPARTMENT_NAME AS DEPT_NAME,
                    ROUND(AVG(B.SALARY)) AS DEPT_AVG
               FROM HR.DEPARTMENTS A, HR.EMPLOYEES B
              WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
              GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME) TBLA,
            HR.EMPLOYEES TBLB
      WHERE TBLA.DEPT_ID = TBLB.DEPARTMENT_ID
        AND TBLB.SALARY < TBLA.DEPT_AVG
      ORDER BY 3;
      
��뿹) ��� ���̺��� �� �μ��� ������� ��ȸ�Ͻÿ�.
       SELECT DEPARTMENT_ID AS �μ��ڵ�,
              COUNT(*) AS �����1,
              COUNT(LAST_NAME) AS �����2
         FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID
        ORDER BY 1;
        
       SELECT DEPARTMENT_ID AS �μ��ڵ�,
              COUNT(*) AS �����1,
              COUNT(LAST_NAME) AS �����2
         FROM HR.EMPLOYEES
        GROUP BY ROLLUP(DEPARTMENT_ID)
        ORDER BY 1;        
        
��뿹) 2005�� 5�� �з��ڵ庰 �ǸŰǼ��� ��ȸ�Ͻÿ�.
       SELECT B.PROD_LGU AS �з��ڵ�,
              COUNT(*) AS �ǸŰǼ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY B.PROD_LGU
        ORDER BY 1;
        
��뿹) 2005�� 5~6�� ȸ���� ����Ƚ���� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ����Ƚ��
       SELECT A.CID AS ȸ����ȣ,
              COUNT(*) AS ���԰Ǽ�
         FROM (SELECT DISTINCT CART_NO AS CNO,
                      CART_MEMBER AS CID
                 FROM CART
                WHERE SUBSTR(CART_NO, 1, 6) IN('200505', '200506')
                ORDER BY 2)A
        GROUP BY A.CID
        ORDER BY 1;
       
-- DB�� �̷� Ȯ�强�� �ִ� ���·� ����Ǿ����

��뿹) ��� �μ��� ������� ��ȸ�Ͻÿ�. (NULL �μ��ڵ�� ����)
       SELECT B.DEPARTMENT_ID AS �μ��ڵ�,
              B.DEPARTMENT_NAME AS �μ���,
              COUNT(JOB_ID) AS �����
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID (+)= B.DEPARTMENT_ID
        GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
        -- �ܺ������� �� ���� ���� ���� ���� ����ؾ���
        -- ���� ���� ���� ����ϸ� NULL�� ���Ե�
        -- �ܺ����� ������(+)�� ���� ���� �ʿ� �־���
        -- ����� ���� �μ��� ������� 1�� ��ȸ�� ������ NULL���� ����, NULL�� COUNT(*)�� �� ���� ī��Ʈ�ؼ� ������� 1�� ��
        -- COUNT(*) ��� COUNT(�÷���)�� ���� ����� ���� �μ��� ���������� ������� 0���� ��ȸ��
        -- B.DEPARTMENT_ID�� A.DEPARTMENT_ID���� ���� �����Ƿ� A.DEPARTMENT_ID�� (+)�� �ٿ��༭ B.DEPARTMENT_ID��ŭ Ȯ�������

��뿹) 2005�� ���� ���Ծ� �� �ִ������ǰ�� �ּҸ�����ǰ�� �ִ���Ծ�, �ּҸ��Ծ��� ��ȸ�Ͻÿ�.
       Alias�� ��, �ִ���Ծ�, �ּҸ��Ծ�
       SELECT EXTRACT(MONTH FROM BUY_DATE) AS ��,
              MAX(BUY_QTY * BUY_COST) AS �ִ���Ծ�,
              MIN(BUY_QTY * BUY_COST) AS �ּҸ��Ծ�
         FROM BUYPROD
        WHERE EXTRACT(YEAR FROM BUY_DATE) = 2005
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
        ORDER BY 1;
            
��뿹) 2005�� 5�� �ִ뱸�� �������� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���űݾ�
       -- �����ͺ��̽��� 1��(�θ�-�ڽ�)�� �ν�
       SELECT A.CART_MEMBER AS ȸ����ȣ,
              B.MEM_NAME AS ȸ����,
              SUM(A.CART_QTY * C.PROD_PRICE) AS ���űݾ�
         FROM CART A, MEMBER B, PROD C
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_PROD = C.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER, B.MEM_NAME
        ORDER BY 3 DESC;
        -- ��� ȸ���� ���űݾ��� ������������ �����
        -- �ִ뱸�� ȸ���� ����� ���� ����
        -- �ִ뱸�� ȸ�� �Ѹ� ����Ϸ��� ���������� ����ؾ���
        
       SELECT A.CART_MEMBER AS ȸ����ȣ,
              B.MEM_NAME AS ȸ����,
              MAX(SUM(A.CART_QTY * C.PROD_PRICE)) AS ���űݾ�
         FROM CART A, MEMBER B, PROD C
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_PROD = C.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER, B.MEM_NAME;
        -- MAX(SUM()): �����Լ� �ȿ� �����Լ��� ����� �� ����, ������ �߻���
        
       SELECT A.CART_MEMBER AS ȸ����ȣ,
              B.MEM_NAME AS ȸ����,
              SUM(A.CART_QTY * C.PROD_PRICE) AS ���űݾ�
         FROM CART A, MEMBER B, PROD C
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_PROD = C.PROD_ID
          AND A.CART_NO LIKE '200505%'
          AND ROWNUM = 1
        GROUP BY A.CART_MEMBER, B.MEM_NAME
        ORDER BY 3 DESC;
        -- ROWNUM�� ȸ����ȣ ���� ���ڸ� �ǹ��Ѵ�, �̰��� ����Ŭ���� ���Ƿ� �ο��� �ǻ��ڵ���
        -- ROWNUM 1�� �ص� �ִ뱸�� ���� �ſ����� �ƴ϶�, �ٸ� ����� ��µ�
        -- �����Ͱ� SORT�Ǳ� ���� �������� ī��Ʈ�ؼ� �ٸ� ����� ��µ�
        
��뿹) 2005�� 5�� �ִ뱸�� �������� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���űݾ�
       (SUBQUERY)
       SELECT A.MID AS ȸ����ȣ,
              A.MNAME AS ȸ����,
              A.AMT AS ���űݾ�
         FROM (SELECT A.CART_MEMBER AS MID,
                      B.MEM_NAME AS MNAME,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS AMT
                 FROM CART A, MEMBER B, PROD C
                WHERE A.CART_MEMBER = B.MEM_ID
                  AND A.CART_PROD = C.PROD_ID
                  AND A.CART_NO LIKE '200505%'
                GROUP BY A.CART_MEMBER, B.MEM_NAME
                ORDER BY 3 DESC) A
        WHERE ROWNUM = 1;
        
       (SUBQUERY)
       SELECT D.MID AS ȸ����ȣ,
              D.MNAME AS ȸ����,
              E.MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              E.MEM_HP AS ����ó,
              D.AMT AS ���űݾ�
         FROM (SELECT A.CART_MEMBER AS MID,
                      B.MEM_NAME AS MNAME,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS AMT
                 FROM CART A, MEMBER B, PROD C
                WHERE A.CART_MEMBER = B.MEM_ID
                  AND A.CART_PROD = C.PROD_ID
                  AND A.CART_NO LIKE '200505%'
                GROUP BY A.CART_MEMBER, B.MEM_NAME
                ORDER BY 3 DESC) D, MEMBER E
        WHERE D.MID = E.MEM_ID
          AND ROWNUM = 1;
        -- MEMBER�� �������� �ȹ����� �ߺ� ����, ������ MEMBER�� �ٱ����� ����� �� ����
        -- �������� ������ ��Ī�� �ٱ��� ��Ī�� �ߺ��Ǿ ����� ����

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

��뿹) 
       SELECT COUNT(*)
         FROM CART, BUYPROD;
       -- 30636�� (207�� * 148��)
       SELECT COUNT(*)
         FROM BUYPROD;
       -- 207��
       SELECT COUNT(*)
         FROM CART;
       -- 148��  
       SELECT 207 * 148 FROM DUAL;
         
��뿹) 
       SELECT COUNT(*)
         FROM CART, BUYPROD, PROD;
         
       SELECT COUNT(*)
         FROM CART
        CROSS JOIN BUYPROD
        CROSS JOIN PROD;

��뿹) ���� ���̺��� 2005�� 1�� ��ǰ�� ������Ȳ�� ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, ���Լ����հ�, ���Աݾ��հ�
       (�Ϲ����� �������)
       SELECT A.BUY_PROD AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              SUM(A.BUY_QTY) AS ���Լ����հ�,
              SUM(A.BUY_QTY * B.PROD_COST) AS ���Աݾ��հ�
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD = B.PROD_ID -- ��������
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY A.BUY_PROD, B.PROD_NAME
        ORDER BY 1;
        
       (ANSI INNER JOIN �������)
       SELECT A.BUY_PROD AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              SUM(A.BUY_QTY) AS ���Լ����հ�,
              SUM(A.BUY_QTY * B.PROD_COST) AS ���Աݾ��հ�
         FROM BUYPROD A
        INNER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID)
        WHERE A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY A.BUY_PROD, B.PROD_NAME
        ORDER BY 1;
         
        SELECT A.BUY_PROD AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              SUM(A.BUY_QTY) AS ���Լ����հ�,
              SUM(A.BUY_QTY * B.PROD_COST) AS ���Աݾ��հ�
         FROM BUYPROD A
        INNER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'))
        GROUP BY A.BUY_PROD, B.PROD_NAME
        ORDER BY 1;
        -- ���̺��� �ΰ� �ۿ� ��� AND, WHERE �� �� ������ ����ص� ������

��뿹) ��� ���̺��� ������ �����ȣ�� 121���� �μ��� ���� ��� ������ ��ȸ�Ͻÿ�.
       Alias�� �����ȣ, �����, �μ���, ������
       (�Ϲ����� �������)
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              B.DEPARTMENT_NAME AS �μ���,
              C.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID -- ��������
          AND A.JOB_ID = C.JOB_ID -- ��������
          AND B.MANAGER_ID = 121
        ORDER BY 1;
        -- ������ �����ȣ�� 121���� "�μ�"�� ���� ��� ����: DEPARTMENTS ���̺��� MANAGER_ID�� ����ؾ���
        
       (ANSI INNER JOIN �������) 
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              B.DEPARTMENT_NAME AS �μ���,
              C.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A
        INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND B.MANAGER_ID = 121)
        INNER JOIN HR.JOBS C ON (A.JOB_ID = C.JOB_ID)
        ORDER BY 1;

       (ANSI INNER JOIN �������) 
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              B.DEPARTMENT_NAME AS �μ���,
              C.JOB_TITLE AS ������
         FROM HR.EMPLOYEES A
        INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
        INNER JOIN HR.JOBS C ON (A.JOB_ID = C.JOB_ID)
        WHERE B.MANAGER_ID = 121
        ORDER BY 1;

��뿹) 2005�� �ŷ�ó�� ������Ȳ�� ��ȸ�Ͻÿ�.
       Alias�� �ŷ�ó�ڵ�, �ŷ�ó��, ����ݾ��հ�
       (�Ϲ����� �������) �ŷ�ó���� ��ǰ�ϴ� ��ǰ���� �󸶳� ���� �ȷȳ�?
       -- �÷��� '_ID'�� ���� ���� ��κ� �⺻Ű
       -- �÷��� '_LGU'�� ���� ���� ��κ� �з��ڵ�
       -- ��¥�� ��κ� �Ϲ������̹Ƿ� WHERE���� �ۼ���
       -- EXTRACT�� ��¥ Ÿ�Կ� �����
       SELECT B.BUYER_ID AS �ŷ�ó�ڵ�,
              B.BUYER_NAME AS �ŷ�ó��,
              SUM(A.CART_QTY * C.PROD_PRICE) AS ����ݾ��հ�
         FROM CART A, BUYER B, PROD C
        WHERE A.CART_PROD = C.PROD_ID
          AND C.PROD_BUYER = B.BUYER_ID
          AND A.CART_NO LIKE '2005%'
       -- AND SUBSTR(A.CART_NO, 1, 4) = '2005'
        GROUP BY B.BUYER_ID, B.BUYER_NAME
        ORDER BY 1;

       (ANSI INNER JOIN �������)
       SELECT B.BUYER_ID AS �ŷ�ó�ڵ�,
              B.BUYER_NAME AS �ŷ�ó��,
              SUM(A.CART_QTY * C.PROD_PRICE) AS ����ݾ��հ�
         FROM BUYER B
        INNER JOIN PROD C ON (B.BUYER_ID = C.PROD_BUYER)
        INNER JOIN CART A ON (C.PROD_ID = A.CART_PROD
       -- AND A.CART_NO LIKE '2005%')
          AND SUBSTR(A.CART_NO, 1, 4) = '2005')
        GROUP BY B.BUYER_ID, B.BUYER_NAME
        ORDER BY 1;

��뿹) 2005�� 5�� ȸ���� �Ǹž��� ��ȸ�Ͽ� ����ϰ� ���� 5���� �ڷḦ ����Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���űݾ��հ�
       -- ORDER BY���� WHERE������ �ʰ� ����ǹǷ� 5���� �ڸ���, �� 5���� ������ ������
       -- ���������� ����ؾ�, ���űݾ��հ躰�� ������ �� ROWNUM���� �ڸ� �� ����
       -- FROM���� ���������� �����ϸ� �ݵ�� ����� ��µǾ����
       SELECT TBLA.CID AS ȸ����ȣ,
              TBLB.MEM_NAME AS ȸ����,
              TBLA.AMT AS ���űݾ��հ�
         FROM (SELECT A.CART_MEMBER AS CID,
                      SUM(A.CART_QTY * B.PROD_PRICE) AS AMT
                 FROM CART A, PROD B
                WHERE A.CART_PROD = B.PROD_ID
                  AND A.CART_NO LIKE '200505%'
                GROUP BY A.CART_MEMBER
                ORDER BY 2 DESC) TBLA,
              MEMBER TBLB
        WHERE TBLA.CID = TBLB.MEM_ID
          AND ROWNUM <= 5;
       
��뿹) ȸ���� ���ϸ����� ��ȸ�Ͽ� ���� 20%�� ���� ȸ������ 2005�� 4~6�� ������ ������ ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �ݾ�
       DECLARE
         V_ID MEMBER.MEM_ID%TYPE;
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_AMT NUMBER := 0;
         -- % ����Ÿ��
         CURSOR CUR_MEM01 IS -- Ŀ���� ������
           SELECT A.MID
             FROM (SELECT MEM_ID AS MID
                     FROM MEMBER
                    ORDER BY MEM_MILEAGE DESC) A
            WHERE ROWNUM <= ROUND((SELECT COUNT(*)
                                     FROM MEMBER) * 0.2);
       BEGIN
         OPEN CUR_MEM01; -- Ŀ���� ����
         LOOP -- LOOP ~ END LOOP���� �ݺ�
           FETCH CUR_MEM01 INTO V_ID; -- Ŀ���� ó������ ���ʴ�� �о�Ͷ�
           EXIT WHEN CUR_MEM01%NOTFOUND; -- Ŀ���� �� �̻� �о�� �ڷᰡ ���� �� ���̵Ǿ� ������ ��������
           
           SELECT C.MEM_NAME, SUM(A.CART_QTY * B.PROD_PRICE)
             INTO V_NAME, V_AMT
             FROM CART A, PROD B, MEMBER C
            WHERE A.CART_MEMBER = C.MEM_ID
              AND A.CART_PROD = B.PROD_ID
              AND A.CART_MEMBER = V_ID
              AND SUBSTR(A.CART_NO, 1, 6) BETWEEN '200504' AND '200506'
            GROUP BY C.MEM_NAME;
              
           DBMS_OUTPUT.PUT_LINE('ȸ����ȣ : '||V_ID);
           DBMS_OUTPUT.PUT_LINE('ȸ���� : '||V_NAME);
           DBMS_OUTPUT.PUT_LINE('���űݾ� : '||V_AMT);
           DBMS_OUTPUT.PUT_LINE('------------------------');
         END LOOP;
         
         CLOSE CUR_MEM01; --Ŀ���� ����
       END;
       
��뿹) 2005�� 5�� ���Ծװ� ������� ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �����հ�, �����հ�
       (5�� ��������)
       SELECT A.BUY_PROD AS ��ǰ�ڵ�,
              SUM(A.BUY_QTY * B.PROD_COST) AS �����հ�
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD = B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050501') AND TO_DATE('20050531')
        GROUP BY A.BUY_PROD
        ORDER BY 1;
        
       (5�� ��������)
       SELECT A.CART_PROD AS ��ǰ�ڵ�,
              SUM(A.CART_QTY * B.PROD_PRICE) AS �����հ�
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_PROD
        ORDER BY 1;
       
       (5�� ������ �������� - �Ϲ����� �������)
       SELECT PROD_ID AS ��ǰ�ڵ�,
              PROD_NAME AS ��ǰ��,
              NVL(TBLA.BAMT, 0) AS �����հ�,
              NVL(TBLB.CAMT, 0) AS �����հ�
         FROM (SELECT A.BUY_PROD AS BID,
                      SUM(A.BUY_QTY * B.PROD_COST) AS BAMT
                 FROM BUYPROD A, PROD B
                WHERE A.BUY_PROD = B.PROD_ID
                  AND A.BUY_DATE BETWEEN TO_DATE('20050501') AND TO_DATE('20050531')
                GROUP BY A.BUY_PROD) TBLA,
                         (SELECT A.CART_PROD AS CID,
                                 SUM(A.CART_QTY * B.PROD_PRICE) AS CAMT
                            FROM CART A, PROD B
                           WHERE A.CART_PROD = B.PROD_ID
                             AND A.CART_NO LIKE '200505%'
                           GROUP BY A.CART_PROD) TBLB,
              PROD
        WHERE TBLA.BID (+)= PROD_ID
          AND TBLB.CID (+)= PROD_ID
        ORDER BY 1;
        
       (5�� ������ �������� - ANSI INNER JOIN �������)
       SELECT A.PROD_ID AS ��ǰ�ڵ�,
              A.PROD_NAME AS ��ǰ��,
              NVL(SUM(A.PROD_COST * B.BUY_QTY), 0) AS �����հ�,
              NVL(SUM(A.PROD_PRICE * C.CART_QTY), 0) AS �����հ�
         FROM PROD A
         LEFT OUTER JOIN BUYPROD B ON (B.BUY_PROD = A.PROD_ID
              AND B.BUY_DATE BETWEEN TO_DATE('20050501') AND TO_DATE('20050531'))
         LEFT OUTER JOIN CART C ON (C.CART_PROD = A.PROD_ID
              AND C.CART_NO LIKE '200505%')
        GROUP BY A.PROD_ID, A.PROD_NAME
        ORDER BY 1;
        -- LEFT �ʿ� �� �پ��ϰ� ����� �÷��� ����

��뿹) ��� ���̺��� ������� ����ӱݺ��� �� ���� �ӱ��� �޴� ����� ����Ͻÿ�.
       Alias�� �����ȣ, �����, �μ���, �޿�, ��ձ޿�
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              B.DEPARTMENT_NAME AS �μ���,
              A.SALARY AS �޿�,
              C.ASAL AS ��ձ޿�
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B,
              (SELECT ROUND(AVG(SALARY)) AS ASAL
                 FROM HR.EMPLOYEES) C -- ���������� �ѹ��� ����Ǿ� ����� ASAL�� ����, ���� ȿ�����鿡�� ȿ������
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND A.SALARY >= C.ASAL
        ORDER BY 4;
      
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              B.DEPARTMENT_NAME AS �μ���,
              A.SALARY AS �޿�,
              (SELECT ROUND(AVG(SALARY))
                 FROM HR.EMPLOYEES) AS ��ձ޿�
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND A.SALARY > (SELECT ROUND(AVG(SALARY))
                            FROM HR.EMPLOYEES) -- ���������� ��������ŭ �����, ��ȿ������
        ORDER BY 4;

��뿹) �ŷ�ó '������'�� ������ ����(�����õ�)�� �����ϰ� �ִ� �ŷ�ó ������ ��ȸ�Ͻÿ�.
       Alias�� �ŷ�ó�ڵ�, �ŷ�ó��, �ּ�, �����
       -- B ���̺��� �����ҿ� ������ ������ �ŷ�ó�� ã�� ���� ���̺���
       SELECT B.BUYER_ID AS �ŷ�ó�ڵ�,
              B.BUYER_NAME AS �ŷ�ó��,
              B.BUYER_ADD1||' '||B.BUYER_ADD2 AS �ּ�,
              B.BUYER_CHARGER AS �����
         FROM BUYER A, BUYER B
        WHERE A.BUYER_NAME = '������' -- �Ϲ�����
          AND SUBSTR(A.BUYER_ADD1, 1, 2) = SUBSTR(B.BUYER_ADD1, 1, 2);
          
��뿹) �����ȣ 108�� ����� ���� �μ��� ���� ������� ��ȸ�Ͻÿ�.
       Alias�� �����ȣ, �����, �μ���, �����ڵ�
       SELECT B.EMPLOYEE_ID AS �����ȣ,
              B.EMP_NAME AS �����,
              C.DEPARTMENT_NAME AS �μ���,
              B.JOB_ID AS �����ڵ�
         FROM HR.EMPLOYEES A, HR.EMPLOYEES B, HR.DEPARTMENTS C
        WHERE A.EMPLOYEE_ID = 108
          AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
        ORDER BY 1;

��뿹) ��� ��ǰ�� ������Ȳ�� ��ȸȭ�ÿ�.
       -- ���: OUTER JOIN, ��ǰ��: GROUP BY
       -- ���ʿ� ���ÿ� �����ϴ� �÷��� ��� SELECT���� ���� ���� ����ؾ���
       Alias�� ��ǰ�ڵ�, ��ǰ��, ���Լ���, ���Աݾ�
       (�Ϲݿܺ����� �������)
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              NVL(SUM(A.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS ���Աݾ�
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD (+)= B.PROD_ID
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
       
       (ANSI�ܺ����� �������)
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              NVL(SUM(A.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS ���Աݾ�
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID)
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;  
        
��뿹) 2005�� 1�� ��� ��ǰ�� ������Ȳ�� ��ȸȭ�ÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, ���Լ���, ���Աݾ�
       (�Ϲݿܺ����� �������)        
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              NVL(SUM(A.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS ���Աݾ�
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD (+)= B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131') -- �������εǾ� 39���� ����� �����
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
       
       -- �ذ���1 : ANSI�ܺ����� ���
       (ANSI�ܺ����� �������)
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              NVL(SUM(A.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS ���Աݾ�
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'))
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
        
       -- �ذ���2 : �ذ�ȵ�
       (ANSI�ܺ����� �������)
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              NVL(SUM(A.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS ���Աݾ�
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID)
        WHERE A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131') -- �������εǾ� 39���� ����� �����
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
        
       -- �ذ���3 : ���� 
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              NVL(SUM(A.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS ���Աݾ�
         FROM PROD B, (--2005�⵵ 1�� ��������(��������)) A
        WHERE B.�÷��� = A.�÷��� (+)
        ORDER BY 1;
       -- 2005�⵵ 1�� ��������(��������) 
       SELECT BUY_PROD AS BID,
              SUM(BUY_QTY) AS QAMT,
              SUM(BUY_QTY * BUY_COST) AS MAMT
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY BUY_PROD;        
       
       (SUBQUERY + �Ϲݿܺ�����)
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              NVL(A.QAMT, 0) AS ���Լ���,
              NVL(A.MAMT, 0) AS ���Աݾ�
         FROM PROD B, (SELECT BUY_PROD AS BID,
                              SUM(BUY_QTY) AS QAMT,
                              SUM(BUY_QTY * BUY_COST) AS MAMT
                         FROM BUYPROD
                        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
                        GROUP BY BUY_PROD) A
        WHERE B.PROD_ID = A.BID (+)
        ORDER BY 1;
        
��뿹) ��� �μ��� ������� ����Ͻÿ�.
       Alias�� �μ��ڵ�, �μ���, �����
       (�Ϲݿܺ����� �������)
       SELECT B.DEPARTMENT_ID AS �μ��ڵ�,
              B.DEPARTMENT_NAME AS �μ���,
              COUNT(A.EMPLOYEE_ID) AS �����
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID (+)
        GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
       -- COUNT(*): NULL ���� ���Ǿ� ����� ���� �μ��� ������� 1������ ��µ�
       -- COUNT(A.EMPLOYEE_ID): �μ��ڵ尡 ���� CEO�� �����ϱ⿡ 107���� �ƴ�, 106�� ��µ�
       
       (ANSI�ܺ����� �������)
       SELECT LPAD(NVL(TO_CHAR(B.DEPARTMENT_ID), '����'), 4) AS �μ��ڵ�, -- ���� Ÿ���� ���߱� ���� TO_CHAR�� �̿��� ����ȯ ����
              NVL(B.DEPARTMENT_NAME, '����') AS �μ���, -- ���� Ÿ���� �����ϹǷ� TO_CHAR�� �̿��� ����ȯ�� �ʿ����
              COUNT(A.EMPLOYEE_ID) AS �����
         FROM HR.EMPLOYEES A
         FULL OUTER JOIN HR.DEPARTMENTS B ON (B.DEPARTMENT_ID = A.DEPARTMENT_ID)
        GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
       
��뿹) 2005�� 4�� ��� ��ǰ�� ���� �Ǹ���Ȳ�� ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �Ǹż���, �Ǹűݾ�
       (SUBQUERY + �Ϲݿܺ�����)
       SELECT BBB.PROD_ID AS ��ǰ�ڵ�,
              BBB.PROD_NAME AS ��ǰ��,
              NVL(AAA.CQTY, 0) AS �Ǹż���,
              NVL(AAA.CPRI, 0) AS �Ǹűݾ�
         FROM PROD BBB, (SELECT A.CART_PROD AS CID,
                                SUM(A.CART_QTY) AS CQTY,
                                SUM(A.CART_QTY * B.PROD_PRICE) AS CPRI
                           FROM CART A, PROD B
                          WHERE A.CART_PROD = B.PROD_ID
                            AND A.CART_NO LIKE '200504%'
                          GROUP BY A.CART_PROD) AAA
        WHERE BBB.PROD_ID = AAA.CID (+)
        ORDER BY 1;
        
       (ANSI�ܺ����� �������)       
       SELECT B.PROD_ID AS ��ǰ�ڵ�,
              B.PROD_NAME AS ��ǰ��,
              NVL(SUM(A.CART_QTY), 0) AS �Ǹż���,
              NVL(SUM(A.CART_QTY * B.PROD_PRICE), 0) AS �Ǹűݾ�
         FROM CART A
        RIGHT OUTER JOIN PROD B ON (A.CART_PROD = B.PROD_ID AND
              A.CART_NO LIKE '200504%')
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
        
        COMMIT;