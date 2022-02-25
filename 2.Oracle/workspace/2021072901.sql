2021-0729-01) ������(RANK �Լ�)
  - ����, �޿�, ���� ���� ������ ���� �� ���
  - ORDER BY���� ROWNUM�ǻ� �÷��� ����Ŭ�� WHERE���� ORDER BY���� ���� ���� ������ ��Ȯ�� ��� ��ȯ�� �Ұ�����
  -- WHERE���� ORDER BY���� ���� �����
  - �̸� �ذ��ϱ� ���� RANK�� DENSE_RANK �Լ��� ����
  - RANK�� DENSE_RANK �Լ��� ������
    . RANK : �ߺ� ������ �߻��ϸ� �ߺ� ������ŭ ���� �������� ����(ex 1, 1, 1, 4, 5,...)
    . DENSE_RANK : �ߺ� ������ �߻��ص� ���� ������ �������� ���� ����(ex 1, 1, 2, 3, 4,...)
    . ROW_NUMBER : �ߺ��� ������� ���� ������ ����(ex 1, 2, 3, 4, 5,...) -- ���ȣ�� �ο��� ��
  - SELECT ������ ���
  (�������)
    SELECT �÷�list,
           RANK() OVER(ORDER BY �����÷��� DESE|ASC) AS �÷���Ī,
                :
      FROM ���̺��;
      
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
        
        COMMIT;