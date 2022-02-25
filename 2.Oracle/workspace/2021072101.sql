2021-0721-01) ���̺� ����
  - ������ �����ͺ��̽��� �ٽ� ���
  - �������� ���̺� �л�� �ڷḦ ��ȸ�ϱ� ����
  - ���̺� ���̿� ����(Relationship)�� �ξ��� �־�� ��
  - ����
    . �Ϲ����� / ANSI JOIN
      - �Ϲ����� - CARTESIAN PRODUCT, EQUI JOIN, NON EQUI JOIN, SELF JOIN, OUTER JOIN
      -- <��������>
        -- NON EQUI JOIN: '=' �̿��� �����ڸ� ����� ����
        -- SELF JOIN: �ϳ��� ���̺��� �ΰ��� ������ �ڽ��� ����
      -- <�ܺ�����>
        -- OUTER JOIN: ���������� ���� �ʴ� ���� ������ ������ �´� �͸� ���
      - ANSI JOIN - CROSS JOIN, NATURAL JOIN, INNER JOIN, OUTER JOIN
      -- <��������>
        -- NATURAL JOIN: ���� ������ ������� �ʾƵ� �ڵ����� ����, ��� �󵵰� ����
      -- <�ܺ�����>
        -- OUTER JOIN: �Ϲ����κ��� �ξ� �� ��Ȯ��
    . �������� / �ܺ�����
    
    (�Ϲ����� �������)
      SELECT �÷�list
        FROM ���̺��1 [��Ī1], ���̺��2 [��Ī2], [���̺��3 [��Ī3],... ]
       WHERE ��������1
        [AND ��������2]
        [AND �Ϲ�����]...
      - ���ο� ���� ���̺��� n���� ��, ���������� ������ n-1�� �̻��̾����
      - �������ǰ� �Ϲ������� ��� ������ �ǹ̾���
      
    (ANSI INNER JOIN �������)
      SELECT �÷�list
        FROM ���̺��1 [��Ī1]
       INNER JOIN ���̺��2 [��Ī2] ON(��������1 [AND �Ϲ�����1])
      [INNER JOIN ���̺��3 [��Ī3] ON(��������2 [AND �Ϲ�����2])]
            :
      [WHERE �Ϲ�����n]...
      - '���̺��1'�� '���̺��2'�� �ݵ�� ���� ������ ���̺��� ��
      - '���̺��3'���ʹ� '���̺��1'�� '���̺��2'�� ����� ����
      - ON ���� ���Ǵ� �Ϲ�����1�� '���̺��1'�� '���̺��2'���� �ش�Ǵ� ��������
      - WHERE ���� ���������� ��� ���̺� ����Ǵ� ��������

    1. CARTESIAN PRODUCT
      - ��� ������ ����� ������ ����� ��ȯ
      - ANSI������ CROSS JOIN�� �̿� �ش�
      - Ư���� ���� �̿ܿ��� ������ ����
      - ���������� ���ų� �߸��� ��� �߻�
      
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

    2. Equi-Join
      - ���� ����
      - ���� ���ǿ� '=' �����ڰ� ���� ����
      - ANSI JOIN�� INNER JOIN�� �̿� �ش�
      - �������� �Ǵ� SELECT�� ���Ǵ� �÷� �� �� ���̺��� ���� �÷�������
        ���ǵ� ��� '���̺��.�÷���' �Ǵ� '���̺� ��Ī.�÷���' �������� ���
        
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
       
        COMMIT;
        