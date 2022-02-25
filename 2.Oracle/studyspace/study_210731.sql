��뿹) 2005�� 4~6�� ��� �з��� ������Ȳ�� ��ȸ�Ͻÿ�.
       Alias�� �з��ڵ�, �з���, ���Լ���, ���Աݾ�
       (�Ϲݿܺ����� �������) -- ��� �з��� ��� �ȵ�
       SELECT B.LPROD_GU AS �з��ڵ�,
              B.LPROD_NM AS �з���,
              NVL(SUM(A.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(A.BUY_QTY * C.PROD_COST), 0) AS ���Աݾ�
         FROM BUYPROD A, LPROD B, PROD C
        WHERE A.BUY_PROD (+)= C.PROD_ID
          AND C.PROD_LGU (+)= B.LPROD_GU
          AND A.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630')
        GROUP BY B.LPROD_GU, B.LPROD_NM
        ORDER BY 1;
        
       (ANSI�ܺ����� �������)
       SELECT B.LPROD_GU AS �з��ڵ�,
              B.LPROD_NM AS �з���,
              NVL(SUM(A.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(A.BUY_QTY * C.PROD_COST), 0) AS ���Աݾ�
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD C ON (A.BUY_PROD = C.PROD_ID AND
              A.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630'))
        RIGHT OUTER JOIN LPROD B ON (C.PROD_LGU = B.LPROD_GU)
        GROUP BY B.LPROD_GU, B.LPROD_NM
        ORDER BY 1;

       (SUBQUERY + �Ϲݿܺ�����)
       -- D���̺��� �з��ڵ尡 TBLA�� BID���� �� ����
       -- D.LPROD_GU�� �з��ڵ尡 TBLA.BID �� ����
       SELECT D.LPROD_GU AS �з��ڵ�,
              D.LPROD_NM AS �з���,
              NVL(TBLA.BCNT, 0) AS ���Լ���,
              NVL(TBLA.BAMT, 0) AS ���Աݾ�
         FROM (SELECT B.LPROD_GU AS BID,
                      SUM(A.BUY_QTY) AS BCNT,
                      SUM(A.BUY_QTY * C.PROD_COST) AS BAMT
                 FROM BUYPROD A, LPROD B, PROD C
                WHERE A.BUY_PROD = C.PROD_ID
                  AND C.PROD_LGU = B.LPROD_GU
                  AND A.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630')
                GROUP BY B.LPROD_GU, B.LPROD_NM) TBLA,
              LPROD D
        WHERE D.LPROD_GU = TBLA.BID (+)
        ORDER BY 1;

��뿹) 2005�� 4~6�� ��� �з��� ������Ȳ�� ��ȸ�Ͻÿ�.
       Alias�� �з��ڵ�, �з���, �������, ����ݾ�
       (ANSI�ܺ����� �������)
       SELECT B.LPROD_GU AS �з��ڵ�,
              B.LPROD_NM AS �з���,
              NVL(SUM(A.CART_QTY), 0) AS �������,
              NVL(SUM(A.CART_QTY * C.PROD_PRICE), 0) AS ����ݾ�
         FROM CART A
        RIGHT OUTER JOIN PROD C ON (A.CART_PROD = C.PROD_ID AND
              SUBSTR(A.CART_NO, 1, 6) BETWEEN '200504' AND '200506')
        RIGHT OUTER JOIN LPROD B ON (B.LPROD_GU = C.PROD_LGU)
        GROUP BY B.LPROD_GU, B.LPROD_NM
        ORDER BY 1;
        
       (SUBQUERY + �Ϲݿܺ�����)
       SELECT D.LPROD_GU AS �з��ڵ�,
              D.LPROD_NM AS �з���,
              NVL(AAAA.CCNT, 0) AS �������,
              NVL(AAAA.CAMT, 0) AS ����ݾ�
         FROM (SELECT B.LPROD_GU AS CID,
                      SUM(A.CART_QTY) AS CCNT,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS CAMT
                 FROM CART A, LPROD B, PROD C
                WHERE A.CART_PROD = C.PROD_ID
                  AND C.PROD_LGU = B.LPROD_GU
                  AND SUBSTR(A.CART_NO, 1, 6) BETWEEN '200504' AND '200506'
               -- AND SUBSTR(A.CART_NO, 1, 6) IN(200504, 200505, 200506)
                GROUP BY B.LPROD_GU) AAAA,
              LPROD D
        WHERE D.LPROD_GU = AAAA.CID (+)
        ORDER BY 1;

��뿹) 2005�� 4~6�� ��� �з��� ����/������Ȳ�� ��ȸ�Ͻÿ�.
       Alias�� �з��ڵ�, �з���, ���Լ���, ���Աݾ�, �������, ����ݾ�
       (ANSI�ܺ����� �������)
       SELECT A.LPROD_GU AS �з��ڵ�,
              A.LPROD_NM AS �з���,
              NVL(SUM(B.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(B.BUY_QTY * D.PROD_COST), 0) AS ���Աݾ�,
              NVL(SUM(C.CART_QTY), 0) AS �������,
              NVL(SUM(C.CART_QTY * D.PROD_PRICE), 0) AS ����ݾ�
         FROM PROD D
        INNER JOIN BUYPROD B ON (B.BUY_PROD = D.PROD_ID AND
              B.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630'))
         LEFT OUTER JOIN CART C ON (D.PROD_ID = C.CART_PROD AND
              SUBSTR(C.CART_NO, 1, 6) BETWEEN '200504' AND '200506')
        RIGHT OUTER JOIN LPROD A ON (A.LPROD_GU = D.PROD_LGU)
        GROUP BY A.LPROD_GU, A.LPROD_NM
        ORDER BY 1;
        -- ���Լ��� �� �ݾ� ����, Ȯ��

       (SUBQUERY + �Ϲݿܺ�����)
       SELECT D.LPROD_GU AS �з��ڵ�,
              D.LPROD_NM AS �з���,
              NVL(TBLA.BCNT, 0) AS ���Լ���,
              NVL(TBLA.BAMT, 0) AS ���Աݾ�,
              NVL(TBLB.CCNT, 0) AS �������,
              NVL(TBLB.CAMT, 0) AS ����ݾ�
         FROM LPROD D,
              (SELECT B.LPROD_GU AS BID,
                      SUM(A.BUY_QTY) AS BCNT,
                      SUM(A.BUY_QTY * C.PROD_COST) AS BAMT
                 FROM BUYPROD A, LPROD B, PROD C
                WHERE A.BUY_PROD = C.PROD_ID
                  AND C.PROD_LGU = B.LPROD_GU
                  AND A.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630')
                GROUP BY B.LPROD_GU) TBLA,
              (SELECT B.LPROD_GU AS CID,
                      SUM(A.CART_QTY) AS CCNT,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS CAMT
                 FROM CART A, LPROD B, PROD C
                WHERE A.CART_PROD = C.PROD_ID
                  AND C.PROD_LGU = B.LPROD_GU
                  AND SUBSTR(A.CART_NO, 1, 6) BETWEEN '200504' AND '200506'
                GROUP BY B.LPROD_GU) TBLB
        WHERE D.LPROD_GU = TBLA.BID (+)
          AND D.LPROD_GU = TBLB.CID (+)
        ORDER BY 1;
        
��뿹) 2005�� 4~6�� ��� ��ǰ�� ����/������Ȳ�� ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, ���Լ���, ���Աݾ�, �������, ����ݾ�
       (ANSI�ܺ����� �������)
       SELECT A.PROD_ID AS ��ǰ�ڵ�,
              A.PROD_NAME AS ��ǰ��,
              NVL(SUM(B.BUY_QTY), 0) AS ���Լ���,
              NVL(SUM(B.BUY_QTY * A.PROD_COST), 0) AS ���Աݾ�,
              NVL(SUM(C.CART_QTY), 0)AS �������,
              NVL(SUM(C.CART_QTY * A.PROD_PRICE), 0) AS ����ݾ�
         FROM PROD A
         LEFT OUTER JOIN BUYPROD B ON (A.PROD_ID = B.BUY_PROD AND
              B.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630'))
         LEFT OUTER JOIN CART C ON (A.PROD_ID = C.CART_PROD AND
              SUBSTR(C.CART_NO, 1, 6) BETWEEN '200504' AND '200506')
        GROUP BY A.PROD_ID, A.PROD_NAME
        ORDER BY 1;
        
��뿹) 
       SELECT EMPLOYEE_ID, EMP_NAME
         FROM HR.EMPLOYEES
        WHERE (DEPARTMENT_ID, MANAGER_ID) = (SELECT DEPARTMENT_ID, MANAGER_ID -- �񱳵� �������� ���� ���ƾ���
                                               FROM HR.DEPARTMENTS
                                              WHERE MANAGER_ID = 121);        
        
��뿹) ��� ���̺��� ������ ���� 10�� �̻��� �μ��� ����Ͻÿ�.
       Alias�� �μ��ڵ�, �μ���
       (�������� : �μ��ڵ�, �μ��� ���)
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID = (��������)
        
       (�������� : ������ ���� 10�� �̻��� �Ǵ� �μ��� �μ��ڵ�)
       SELECT B.DID
         FROM (SELECT DEPARTMENT_ID AS DID,
                      COUNT(*)
                 FROM HR.EMPLOYEES
                GROUP BY DEPARTMENT_ID
               HAVING COUNT(*) >= 10) B;
       -- �����ռ��� COUNT�� WHERE���� �� �� ����, HAVING���� �־ ������ ����������

       (���� : ANY(=SOME) ������ ���)
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID = ANY (SELECT B.DID
                                       FROM (SELECT DEPARTMENT_ID AS DID,
                                                    COUNT(*)
                                               FROM HR.EMPLOYEES
                                              GROUP BY DEPARTMENT_ID
                                             HAVING COUNT(*) >= 10) B);
                                            
       (���� : IN ������ ���)
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID IN (SELECT B.DID
                                    FROM (SELECT DEPARTMENT_ID AS DID,
                                                 COUNT(*)
                                            FROM HR.EMPLOYEES
                                           GROUP BY DEPARTMENT_ID
                                          HAVING COUNT(*) >= 10) B);                                            

       (����: EXISTS ������ ���)
         - EXISTS ������ ������ ǥ����(�� OR �÷���)�� ����
         - EXISTS ������ �������� �ݵ�� ��������
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.DEPARTMENTS A
        WHERE EXISTS (SELECT 1 -- C.DID���ٴ� 1�� ���� �����
                        FROM (SELECT B.DEPARTMENT_ID AS DID,
                                     COUNT(*)
                                FROM HR.EMPLOYEES B
                               GROUP BY B.DEPARTMENT_ID
                              HAVING COUNT(*) >= 10) C
                       WHERE C.DID = 50 OR C.DID = 80); --A.DEPARTMENT_ID);        
        
��뿹) 80�� �μ����� �޿��� ��� �̻��� ����� ��ȸ�Ͻÿ�.
       Alias�� �����ȣ, �޿�, �μ��ڵ�
       (PARWISE ��� �����)
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.SALARY �޿�,
              A.DEPARTMENT_ID AS �μ��ڵ�
         FROM HR.EMPLOYEES A
        WHERE (A.EMPLOYEE_ID, A.DEPARTMENT_ID) IN (SELECT B.EMPLOYEE_ID, B.DEPARTMENT_ID
                                                     FROM HR.EMPLOYEES B
                                                    WHERE B.SALARY >= (SELECT AVG(C.SALARY)
                                                                         FROM HR.EMPLOYEES C
                                                                        WHERE C.DEPARTMENT_ID = B.DEPARTMENT_ID)
                                                      AND B.DEPARTMENT_ID = 80)
        ORDER BY 3, 2;

       (������ ���)
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.SALARY �޿�,
              A.DEPARTMENT_ID AS �μ��ڵ�
         FROM HR.EMPLOYEES A
        WHERE A.DEPARTMENT_ID = 80
          AND A.SALARY >= (SELECT AVG(SALARY)
                             FROM HR.EMPLOYEES
                            WHERE DEPARTMENT_ID = 80)
        ORDER BY 3, 2;        
        
2021-0727-01)
  ** ��� ����ó���� ���� ���̺��� �����Ͻÿ�.
    1) ���̺��: REMAIN
    2) �÷���
    ----------------------------------------------------------------
         �÷���         ������ Ÿ��       NULL��뿩��         �������
    ----------------------------------------------------------------
      REMAIN_YEAR     CHAR(4)             N.N            PK
      PROD_ID         VARCHAR2(10)        N.N            PK/FK
      REMAIN_J_00     NUMBER(5)                          DEFAULT 0 -- �������
      REMAIN_I        NUMBER(5)                          DEFAULT 0 -- �԰�
      REMAIN_O        NUMBER(5)                          DEFAULT 0 -- ���
      REMAIN_J_99     NUMBER(5)                          DEFAULT 0 -- �⸻���(�� ���)
      REMAIN_DATE     DATE                                         -- �ֽų�¥
    ----------------------------------------------------------------
    
    CREATE TABLE REMAIN(
      REMAIN_YEAR     CHAR(4),
      PROD_ID         VARCHAR2(10),
      REMAIN_J_00     NUMBER(5)  DEFAULT 0,
      REMAIN_I        NUMBER(5)  DEFAULT 0,
      REMAIN_O        NUMBER(5)  DEFAULT 0,
      REMAIN_J_99     NUMBER(5)  DEFAULT 0,
      REMAIN_DATE     DATE,
      
    CONSTRAINT pk_remain PRIMARY KEY(REMAIN_YEAR, PROD_ID),
    CONSTRAINT fk_remain_prod FOREIGN KEY(PROD_ID)
      REFERENCES PROD(PROD_ID));        
        
��뿹) ������ ���̺�(REMAIN)�� PROD ���̺��� �ڷḦ �̿��Ͽ� ���� �����͸� �Է��Ͻÿ�.
       �⵵ : '2005'
       ��ǰ�ڵ� : PROD ���̺��� ��ǰ�ڵ�(PROD_ID)
       ���������� : PROD ���̺��� PROD_PROPERSTOCK
       �԰� �� ��� ���� : ����
       �⸻������ : PROD ���̺��� PROD_PROPERSTOCK
       ��¥ : '2004-12-31'
       -- SELECT ���� VALUES���� ������ ��
       -- SELECT ���� �÷��� ������ ������ ���̺� INSERT�Ǵ� �÷��� ������ ������ ���ƾ���.
       
       INSERT INTO REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_J_99, REMAIN_DATE)
         SELECT '2005', PROD_ID, PROD_PROPERSTOCK, PROD_PROPERSTOCK, TO_DATE('20041231')
           FROM PROD;
       
       SELECT * FROM REMAIN;        
        
��뿹) 2005�� 1�� ��ǰ�� ���������� �̿��Ͽ� REMAIN ���̺��� �����Ͻÿ�.
       (��������)
       UPDATE REMAIN
          SET REMAIN_I = (��������1),
              REMAIN_J_99 = (��������2),
              REMAIN_DATE = TO_DATE('20050131')
        WHERE ����
       -- ��������1 : ��ǰ�� ���Լ��� ���� �� �������� ���ο�� �����հ���Ѿ���

       UPDATE REMAIN
          SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) = (��������1)
        WHERE ����

       (�������� : 2005�� 1�� ��ǰ�� ��������)
       SELECT BUY_PROD,
              SUM(BUY_QTY)
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY BUY_PROD;
        
       COMMIT;

       (����)
       UPDATE REMAIN B
          SET (B.REMAIN_I, B.REMAIN_J_99, B.REMAIN_DATE) =
              (SELECT B.REMAIN_I + A.AMT, B.REMAIN_J_99 + A.AMT, TO_DATE('20050131') -- �����ؾ��� �κ�, ���� �׻� �������������
                 FROM (SELECT BUY_PROD AS BID,
                              SUM(BUY_QTY) AS AMT
                         FROM BUYPROD
                        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
                        GROUP BY BUY_PROD) A
                WHERE B.PROD_ID = A.BID)       
        WHERE REMAIN_YEAR = '2005'
          AND B.PROD_ID IN (SELECT DISTINCT BUY_PROD AS BID -- �����ؾ��� �κ�, ������Ʈ�� �� ���� ã�� ����
                              FROM BUYPROD                  -- �� WHERE���� �� �ۼ������ ���Ե� �κи� ������Ʈ �� 
                             WHERE BUY_DATE BETWEEN TO_DATE('20050101')
                                   AND TO_DATE('20050131'));
       -- ���� �ٱ��� WHERE���� �⺻Ű�� ��� ��޵Ǿ�� ���� ȿ������ ������ ��
       
       ROLLBACK; 
         
       SELECT * FROM REMAIN;         
        
��뿹) ��ٱ��� ���̺��� 2005�� 5�� ȸ����ȣ�� 'p001'�� �ڷḦ �����Ͻÿ�.
       (�������� : 2005�� 5�� ȸ����ȣ�� 'p001'�� �ڷ� ��ȸ)
       SELECT A.CART_MEMBER,
              B.MEM_NAME
         FROM CART A, MEMBER B
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_MEMBER = 'p001'
       -- AND UPPER(A.CART_MEMBER) = 'P001'
          AND A.CART_NO LIKE '200505%';
       
       (�������� : ���������� ��� �ڷḦ ����)
       DELETE CART C
        WHERE C.CART_MEMBER = 'p001'
          AND C.CART_NO LIKE '200505%';

��뿹) 2005�� 6�� ��ǰ 'P302000001'�� �����ڷ� �� �Ǹ� ������ 5�� �̻��� �ڷḸ �����Ͻÿ�.
       (�������� : 2005�� 6�� ��ǰ��ȣ�� 'P302000001'�� �����ڷ� �� �Ǹ� ������ 5�� �̻��� �ڷ�
             
       (�������� : ���������� ��� �ڷḦ ����)
       
��뿹) 2005�� 4�� �Ǹ��ڷ� �� �Ǹ� �ݾ��� 5���� ������ �ڷḸ �����Ͻÿ�.
       (�������� : 2005�� 4�� �Ǹ��ڷ� �� �Ǹ� �ݾ��� 5���� ������ �ڷ�)
       SELECT CART_PROD,
              CART_QTY * PROD_PRICE
         FROM CART, PROD
        WHERE CART_PROD = PROD_ID
          AND CART_NO LIKE '200504%'
          AND CART_QTY * PROD_PRICE <= 50000;

       (�������� : ��ٱ��� ���̺��� �ڷ� ����)
       DELETE FROM CART A
        WHERE EXISTS (SELECT 1
                        FROM PROD
                       WHERE A.CART_PROD = PROD_ID
                         AND A.CART_QTY * PROD_PRICE <= 50000)
          AND A.CART_NO LIKE '200504%';
       -- ������ EXISTS ������ ��� ����
       
��뿹) ȸ�� ���̺��� ��� ���ϸ������� ���� ���ϸ����� ������ ȸ���� ȸ����ȣ, ȸ����, ���ϸ����� ����Ͻÿ�.
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE > (��� ���ϸ��� : ��������);
         
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE > (SELECT AVG(MEM_MILEAGE)
                               FROM MEMBER);
        
��뿹) ȸ�� ���̺��� ��� ���ϸ������� ���� ���ϸ����� ������ ȸ���� ȸ����ȣ, ȸ����, ���ϸ���, ��� ���ϸ����� ����Ͻÿ�.        
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS ���ϸ���,
              (SELECT ROUND(AVG(MEM_MILEAGE))
                 FROM MEMBER) AS ��ո��ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE > (SELECT AVG(MEM_MILEAGE)
                               FROM MEMBER);
                               
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS ���ϸ���,
              A.AMILE AS ��ո��ϸ���
         FROM MEMBER, (SELECT ROUND(AVG(MEM_MILEAGE)) AS AMILE
                       FROM MEMBER) A
        WHERE MEM_MILEAGE > A.AMILE;

��뿹) ȸ������ �ڷῡ�� ���� ��ո��ϸ����� ���ϰ� �ڽ��� ���� ��ո��ϸ������� ���� ���ϸ����� ������ ȸ���� 2005�� 4~6�� ������Ȳ�� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���űݾ��հ�
       1) ȸ������ �ڷῡ�� ���� ��ո��ϸ����� ���ϰ� �ڽ��� ���� ��ո��ϸ������� ���� ���ϸ����� ������ ȸ������
       (�������� : ȸ�� ���̺��� (��������) ������ �����ϴ� ȸ������ ���)
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����
         FROM MEMBER
        WHERE 
          AND MEM_MILEAGE < (��������)
       
       (�������� : ���� ��ո��ϸ���)
       SELECT C.MEM_ID,
              C.MEM_NAME,
              B.G1,
              C.MEM_MILEAGE,
              ROUND(B.AMILE)
         FROM (SELECT A.GEN AS G1,
                      AVG(A.MEM_MILEAGE) AS AMILE
                 FROM (SELECT MEM_ID, MEM_NAME,
                      CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '1' OR SUBSTR(MEM_REGNO2, 1, 1) = '3' THEN
                                        '��'
                      ELSE
                                        '��'
                      END AS GEN,
                      MEM_MILEAGE
                 FROM MEMBER) A
        GROUP BY A.GEN) B,         
                 (SELECT MEM_ID, MEM_NAME,
                      CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '1' OR SUBSTR(MEM_REGNO2, 1, 1) = '3' THEN
                                '��'
                      ELSE
                                '��'
                      END AS GEN,
                      MEM_MILEAGE
                 FROM MEMBER) C
        WHERE C.GEN = B.G1       
          AND C.MEM_MILEAGE >= B.AMILE
        ORDER BY 3, 4;
          
       2) 2005�� 4~6�� ������Ȳ
       SELECT CART_MEMBER AS ȸ����ȣ,
              TBLB.CNAME AS ȸ����,
              SUM(CART_QTY * PROD_PRICE) AS ���ű޾��հ�
         FROM CART, PROD,
              (SELECT C.MEM_ID AS CID,
                      C.MEM_NAME AS CNAME,
                      B.G1,
                      C.MEM_MILEAGE,
                      ROUND(B.AMILE)
                 FROM (SELECT A.GEN AS G1,
                              AVG(A.MEM_MILEAGE) AS AMILE
                         FROM (SELECT MEM_ID, MEM_NAME,
                               CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '1' OR SUBSTR(MEM_REGNO2, 1, 1) = '3' THEN
                                         '��'
                               ELSE
                                         '��'
                               END AS GEN,
                               MEM_MILEAGE
                          FROM MEMBER) A
                GROUP BY A.GEN) B,         
                         (SELECT MEM_ID, MEM_NAME,
                               CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '1' OR SUBSTR(MEM_REGNO2, 1, 1) = '3' THEN
                                         '��'
                               ELSE
                                         '��'
                               END AS GEN,
                               MEM_MILEAGE
                          FROM MEMBER) C
                WHERE C.GEN = B.G1       
                  AND C.MEM_MILEAGE >= B.AMILE
                ORDER BY 3, 4) TBLB
        WHERE CART_MEMBER = TBLB.CID 
          AND CART_PROD = PROD_ID
          AND SUBSTR(CART_NO, 1, 6) BETWEEN '200504' AND '200506'
        GROUP BY CART_MEMBER, TBLB.CNAME;       
       
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
       
��뿹) ȸ�� ���̺��� ���ϸ����� ���� ȸ������ ���ʴ�� ����(���)�� �ο��Ͻÿ�.
       Alias�� ȸ����ȣ, ���ϸ���, ���
       1) RANK ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_MILEAGE AS ���ϸ���,
              RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS ���
         FROM MEMBER;
         
       2) DENSE_RANK ���         
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_MILEAGE AS ���ϸ���,
              DENSE_RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS ���
         FROM MEMBER;
         
       3) ROW_NUMBER ���         
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_MILEAGE AS ���ϸ���,
              ROW_NUMBER() OVER(ORDER BY MEM_MILEAGE DESC) AS ���
         FROM MEMBER;
         
��뿹) ȸ�� ���̺��� ���ϸ����� ���� ȸ������ ���ʴ�� ����(���)�� �ο��ϰ� ���� 5���� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���ϸ���, ���
       SELECT A.MID AS  ȸ����ȣ,
              B.MEM_NAME AS ȸ����,
              B.MEM_MILEAGE AS ���ϸ���,
              A.MRK AS ���
         FROM (SELECT MEM_ID AS MID,
                      RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS MRK
                 FROM MEMBER) A, MEMBER B
        WHERE A.MID = B.MEM_ID
          AND A.MRK <= 5
        ORDER BY 4;

��뿹) ��ٱ��� ���̺��� 2005�� 5�� ���űݾ��� ���� ȸ������ ������ �ο��Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���űݾ�, ���
       SELECT A.CART_MEMBER AS ȸ����ȣ,
              C.MEM_NAME AS ȸ����,
              SUM(A.CART_QTY * B.PROD_PRICE) AS ���űݾ�,
              RANK() OVER(ORDER BY SUM(A.CART_QTY * B.PROD_PRICE) DESC) AS ���
         FROM CART A, PROD B, MEMBER C
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_MEMBER = C.MEM_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER, C.MEM_NAME
        ORDER BY 3 DESC;
        -- RANK() OVER �ȿ� �����Լ��� ���ٸ�, GROUP BY���� RANK() OVER~�� ��� �־������
               
��뿹) ȸ�� ���̺��� ���ϸ����� 3000�̻��� ȸ���� ��� �����Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ����, ���ϸ���
       1) �÷�list ���
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE(MID, MNAME, MJOB, MMILE)
       AS
         SELECT MEM_ID AS ȸ����ȣ,
                MEM_NAME AS ȸ����,
                MEM_JOB AS ����,
                MEM_MILEAGE AS ���ϸ���
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000;
          
       2) �÷�list �̱�� : �÷���Ī�� ���� �÷������� ����
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE
       AS
         SELECT MEM_ID AS ȸ����ȣ,
                MEM_NAME AS ȸ����,
                MEM_JOB AS ����,
                MEM_MILEAGE AS ���ϸ���
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000;

       3) �÷�list�� �÷���Ī �̱��: ���� ���̺��� �÷����� ���� �÷������� ����   
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE
       AS
         SELECT MEM_ID,
                MEM_NAME,
                MEM_JOB,
                MEM_MILEAGE
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000;
               
         SELECT * FROM VIEW_MEM_MILEAGE;          
          
  ** ������ �� 'VIEW_MEM_MILEAGE'���� ȸ����ȣ 'e001'ȸ���� ���ϸ����� 500���� �����Ͻÿ�.
       UPDATE VIEW_MEM_MILEAGE
          SET ���ϸ��� = 500
        WHERE ȸ����ȣ = 'e001';
       -- ���� �÷����� ����ؾ���
       SELECT * FROM VIEW_MEM_MILEAGE;
       
       SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
         FROM MEMBER
        WHERE MEM_ID = 'e001';
       -- ���� �����͸� �����ϸ� ���� ���̺��� �����͵� ������
       -- ���� �����Ϳ� ���� �����Ͱ� ���� �ٸ��� ����� �߻��ϹǷ� ������ ���ϸ� �ٸ��ʵ� ���ؾ� ����� ����

  ** ȸ�� ���̺��� ȸ����ȣ 'g001'ȸ���� ���ϸ����� 800���� 15000���� �����Ͻÿ�.
       UPDATE MEMBER
          SET MEM_MILEAGE = 15000
        WHERE MEM_ID = 'g001';
       -- ���� ���̺��� �����͸� ����
        
       SELECT * FROM VIEW_MEM_MILEAGE; 
       -- ���� ���̺��� �����Ͱ� �����ϸ� ���� �����͵� ������       
       
��뿹) ��ǰ �з��� ��ǰ�� ���� ����ϴ� �� ����
       CREATE OR REPLACE VIEW VIEW_PROD_LGU
       AS
         SELECT PROD_LGU AS PLGU,
                COUNT(*) AS CNT
           FROM PROD
          GROUP BY PROD_LGU;
       
       SELECT * FROM VIEW_PROD_LGU;
       
  ** �� VIEW_PROD_LGU���� 'P102' �ڷḦ �����Ͻÿ�.
       DELETE VIEW_PROD_LGU
        WHERE PLGU = 'P102'
       -- �����Լ�(COUNT)�� ���� VIEW�� DML���(DELETE)�� ����� �� ����

��뿹) ȸ�� ���̺��� ���ϸ����� 3000�̻��� ȸ����� �����ǰ� ��������(CHECK OPTION)�� ����� �並 �����Ͻÿ�.
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE
       AS
         SELECT MEM_ID AS ȸ����ȣ,
                MEM_NAME AS ȸ����,
                MEM_JOB AS ����,
                MEM_MILEAGE AS ���ϸ���
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000
          
   --  WITH CHECK OPTION
       WITH READ ONLY;
       -- WITH CHECK OPTION�� WITH READ ONLY�� ���� ��Ÿ���̶� ���ÿ� ����� �� ����
       
       SELECT * FROM VIEW_MEM_MILEAGE;

  ** �� VIEW_MEM_MILEAGE���� ������ ȸ��('e001')�� ���ϸ����� 1500�� �����Ͻÿ�.
       UPDATE VIEW_MEM_MILEAGE
          SET ���ϸ��� = 1500
        WHERE ȸ����ȣ = 'e001';
        -- VIEW�� ������ �� WITH CHECK OPTION�� �־��� ������ WHERE���� ������ ����� ������ �� ����
        -- ���� ���̺��� ����, ����, �߰��ϴ� ���� ������, ���� ���̺��� ����� �����Ͱ� ���� �����Ϳ��� �ﰢ �ݿ���
        
        -- VIEW�� ������ �� WITH READ ONLY�� �־��� ������ VIEW�� ������ �� ���� �б� �������θ� ��� ������
        -- ���� ���̺��� ����, ����, �߰��ϴ� ���� ������, ���� ���̺��� ����� �����Ͱ� ���� �����Ϳ��� �ﰢ �ݿ���

  ** ȸ�� ���̺��� ������ ȸ��('e001')�� ���ϸ����� 1500�� �����Ͻÿ�.
       UPDATE MEMBER
          SET MEM_MILEAGE = 6500
        WHERE MEM_ID = 'e001';
        
       SELECT * FROM VIEW_MEM_MILEAGE;       
       
��뿹) LPROD ���̺��� LPROD_ID�� ����� �������� �����Ͻÿ�.
       SELECT MAX(LPROD_ID) FROM LPROD; -- �ִ밪 9�� ��µ�
       
       CREATE SEQUENCE SEQ_LPROD
         START WITH 10; -- 9�� �̹� �����ϴ� ���̹Ƿ� 10���� �����ϴ� ���� ����
       
       SELECT SEQ_LPROD.CURRVAL FROM DUAL; -- SEQ_LPROD ���������� ���� CURRVAL�� ���ǵ��� �ʾ����Ƿ� NEXTVAL���� ����ؾ���
       
       INSERT INTO LPROD
         VALUES(SEQ_LPROD.NEXTVAL, 'P501', '��깰');
         
       SELECT * FROM LPROD;  
         
��뿹) ������ 2005�� 4�� 18���̶� �����ϰ�, CART_NO�� �����Ͻÿ�.
       SELECT TO_CHAR(TO_DATE('2005/04/18'), 'YYYYMMDD')||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(MAX(CART_NO), 9))+1, '00000'))
         FROM CART
        WHERE CART_NO LIKE '20050418%' 
        -- SEQUENCE�� ������� ������ �Լ��� �Ἥ �����ϰ� ����ؾ���
        -- NEXTVAL�̸� �����ϰ� 2005041800003�� ����� �� ����
        -- ������������ ����ϹǷ� �̸� ������ �����ϱ� ���� �˰����� ����Ⱑ ����
        -- SEQUENCE�� ������� �ʰ� ���� ������ ����� ����ϴ� ��쵵 ����       
       
��뿹) HR������ EMPLOYEES, DEPARTMENTS, JOB_HISTORY ���̺� ��Ī('�ó봽��') EMP, DEPT, JOBH �� �ο��Ͻÿ�.
       CREATE OR REPLACE SYNONYM EMP FOR HR.EMPLOYEES;
       CREATE OR REPLACE SYNONYM DEPT FOR HR.DEPARTMENTS;
       CREATE OR REPLACE SYNONYM JOBH FOR HR.JOB_HISTORY;
       
       SELECT * FROM EMP;
       SELECT * FROM DEPT; -- ���̺��(HR.DEPARTMENTS) ��� �ó봽��(DEPT)�� �����ϰ� ����� �� ����
       SELECT * FROM JOBH;
       -- ���̺��(HR.EMPLOYEES, HR.DEPARTMENTS, HR.JOB_HISTORY) ��� �ó봽��(EMP, DEPT, JOBH)�� �����ϰ� ����� �� ����
              
��뿹) ȸ�� ���̺��� �ֹι�ȣ �������� �ε����� �����Ͻÿ�.
       CREATE INDEX IDX_MEM_REGNO
         ON MEMBER(MEM_REGNO1, MEM_REGNO2);
       
       CREATE INDEX IDX_MEM_NAME
         ON MEMBER(MEM_NAME);
       
       DROP INDEX IDX_MEM_NAME;
         
       SELECT * FROM MEMBER
        WHERE MEM_ADD1 LIKE '����%';
       
       SELECT * FROM MEMBER
         WHERE MEM_NAME = '�ſ�ȯ';
         
��뿹) ȸ�� ���̺��� MEM_REGNO2�� �ֹι�ȣ �� 2~5��° ���ڷ� ������ �ε����� �����Ͻÿ�.
       CREATE INDEX IDX_MEM_REGNO_SUBSTR
         ON MEMBER(SUBSTR(MEM_REGNO2, 2, 4));
         
       SELECT * FROM MEMBER
         WHERE SUBSTR(MEM_REGNO2, 2, 4) = '4489';
         
         COMMIT;