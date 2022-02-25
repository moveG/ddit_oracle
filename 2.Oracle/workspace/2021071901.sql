2021-0719-01)
  2. AVG(expr)
   - 'expr'�� ���ǵ� �÷��̳� ������ ���� ���� ������ ���� ��ȯ
   
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
      
  3. COUNT(column��|*)
   - �׷쳻�� ���� ��(�ڷ��� ����)�� ��ȯ
   - �ܺ����ο��꿡 ���Ǵ� ��� '*'�� ����ϸ� ����Ȯ�� ����� ��ȯ�ϱ� ������ �ش� ���̺��� �÷����� ����ؾ� ��
   -- '*'�� ����ϸ� NULL�� �÷��� 1�� ��������, �÷����� ���� NULL�� �÷��� ������ ����
   
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
        COMMIT;
