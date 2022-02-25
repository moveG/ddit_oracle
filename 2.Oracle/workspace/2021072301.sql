2021-0721-01)
    4. SELF JOIN
      - �ϳ��� ���̺� ���� �ٸ� ��Ī�� �ο��Ͽ� �����ϴ� ����
      - ���� ���ǿ� '=' �����ڰ� ���� ����

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

    5. �ܺ�����(OUTER JOIN)
      - ���������� ���������� �����ϴ� �����͸� �������� ����� ��ȯ
      - �ܺ������� ���������� �������� ���ϴ� �����͸� �������� ������ ���̺� NULL ������ ä���� ���� �����Ͽ� ������ ����
      - �������ǿ��� ������ �����͸� ������ �ִ� ���̺� ���� ���̸� ������ '(+)' �����ڸ� �߰���
      -- �������� ���� ���� ������ �ƴ϶�, �������� ������ ���� �����̵�
      -- ��ǰ ���̺� ��ǰ�� ������ ���� ����, ���� ���̺� ������ ������ ���� ����, ���� ���̺� ���Ծ�ü�� ������ ���� ����
      - ���� ���������� �ܺ������� ����Ǿ�� �ϴ� ��� ��� '(+)' �����ڸ� ����ؾ���
      - ���ÿ� �� ���̺� �������� '(+)' �����ڸ� ����� �� ����
        ��, A, B, C ���̺��� �ܺ����ο� ������ ��, A�� �������� B�� Ȯ���԰� ���ÿ� C�� �������� B�� Ȯ���� �� ����
        (WHERE A = B (+) AND C = B (+) => ��� �� ��)
      - �Ϲݿܺ������� ��� �Ϲ������� ���Ǹ� �������� ����� ��ȯ(�ذ��� : ANSI �ܺ����� �Ǵ� �������� ���)
      - �ܺ������� ����� ó���ӵ��� ���� ����
    (�Ϲݿܺ����� �������)
      SELECT �÷�List
        FROM ���̺��1, ���̺��2[,���̺��3,...]
       WHERE ���̺��1.�÷�[(+)] = ���̺��2.�÷�[(+)]
       . ���� ��� ������ �ܺ������� ��� �ȵ�(WHERE A.COL(+) = B.COL(+)) -- (+)�� ��ġ�� ǥ���� ��, ���� ���ÿ� ����� ���� ����
      
    (ANSI�ܺ����� �������)
      SELECT �÷�List
        FROM ���̺��1
        LEFT|RIGHT|FULL OUTER JOIN ���̺��2 ON(��������1 [AND �Ϲ�����1])
       [LEFT|RIGHT|FULL OUTER JOIN ���̺��3 ON(��������2 [AND �Ϲ�����2])] --���̺�1, 2�� ������ ����� ���̺�3���� ������ ������ LEFT�� ���
                             :
      [WHERE �Ϲ�����n]
       . ���̺��1�� ���̺��2�� �ݵ�� ���� ������ ��
       -- ������ �÷��� �����ؾ���, ���̺�3�� ���̺�1�̳� ���̺�2 �� �� �ƹ� ���̳� ���εǾ��
       . �Ϲ�����1�� ���̺��1 �Ǵ� ���̺��2�� ���ѵ� ����
       . �Ϲ�����n�� ��ü ���̺� ����Ǵ� �������� ������ ��� ������ �� ����� -- ���� ���� ���������� �ɷ����� ��� ���
       . LEFT|RIGHT|FULL : ���̺��1�� ������ ������ �� ���� ��� LEFT, �ݴ��� ��� RIGHT, ���� ��� ������ ��� FULL ���
       
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
    
    