2021-0727-02)

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
        
        COMMIT;