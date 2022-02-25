2021-0720-01)
  4. MAX(column��), MIN(column��)
   - MAX : �־��� �÷��� �� �ִ밪�� ��ȯ
   - MIN : �־��� �÷��� �� �ּҰ��� ��ȯ
   - �����Լ��� �ٸ� �����Լ��� ������ �� ����.
   -- �����Լ��� ���� ����� �� ����
   -- �ߺ������ �ʿ��� ���� ���������� �����
   
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
        
        COMMIT;