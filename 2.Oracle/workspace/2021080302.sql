2021-0803-02) Ŀ��(CURSOR)
    - ����Ŭ SQL��ɾ ���Ͽ� ������ ���� ����� ����
    - SELECT���� ���� ��ȯ�� ��� ������ ����� ���ʴ�� �����ؾ� �ϴ� ��� �����
    - �����ڰ� ����� ���������� ������ �ʿ䰡 �ִ� ��� ���
    - IMPLICITE, EXPLICITE CURSOR
    - Ŀ���� ����� FOR���� �����ϰ� ����(����) -> OPEN -> FETCH -> CLOSE �ܰ踦 ���ʴ�� ����
    
  1. �͸�Ŀ��(IMPLICITE CURSOR)
    - �̸��� ���� Ŀ��
    - SELECT���� ����Ǹ� ���(Ŀ��)�� �ڵ����� OPEN�� �ǰ�, ��� ����� �Ϸ�� ���Ŀ� �ڵ����� CLOSE ��(���� �Ұ���)
    - Ŀ���Ӽ�
      . SQL%ISOPEN : Ŀ���� OPEN �����̸� ��(true) ��ȯ - �׻� ����(false)
      . SQL%NOTFOUND : Ŀ���� �ڷᰡ �������� ������ ��(true) ��ȯ
      . SQL%FOUND : Ŀ���� �ڷᰡ ���������� ��(true) ��ȯ -- WHILE���� ���ǹ��� ����� �� ����
      . SQL%ROWCOUNT : Ŀ���� �����ϴ� �ڷ��� ����
      -- �̸��� �����ϴ� Ŀ���� SQL�ڸ��� Ŀ���� �̸��� �����

  2. Ŀ��(EXPLICITE CURSOR)
    - �̸��� �ο��� Ŀ��
    - ����ο��� ����
    (�������� - �����)
      CURSOR Ŀ����[(������ Ÿ�Ը�[,������ Ÿ�Ը�,...])] -- �ʿ������ ������� �ʾƵ� ��, ������� Ÿ�Ը� �����(ũ�� ����)
      IS
        SELECT ��;
        
    (�������� - �����)
      OPEN Ŀ����[(�Ű�����[,�Ű�����,...])]; -- ���� Ŀ���� ���� Ÿ���̾����

      FETCH Ŀ���� INTO ����list;
      
      CLOSE Ŀ����;

��뿹) 2005�� 5�� �԰��ǰ�� �����Ȳ�� ��ȸ�ϴ� ����� Ŀ���� �̿��Ͽ� �ۼ��Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, ����
       -- �԰��ǰ�� �ϳ��� ������ CART TABLE���� ����
       DECLARE -- ����ϰ��� �ϴ� �κ��� �ݵ�� ����ؾ���
         V_PID PROD.PROD_ID%TYPE; -- ��ǰ�ڵ�
         V_PNAME PROD.PROD_NAME%TYPE; -- ��ǰ��
         V_AMT NUMBER := 0; -- �Ǹż���
         V_CNT NUMBER := 0; -- ������ �Ǿ����� ������ ���� ��츦 ���� ����
         
         CURSOR CUR_BUY01(PDATE DATE) IS -- ���Ի�ǰ�� Ŀ��, ��ǰ�ڵ� 36���� Ŀ���� ��, �̰��� �ϳ��� �о��, PDATE�� ������
           SELECT DISTINCT BUY_PROD --INTO�� BEGIN�������� ���
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN PDATE AND LAST_DAY(PDATE); -- TO_DATE('20050501') AND TO_DATE('20050531') ��� ����
       BEGIN
         OPEN CUR_BUY01(TO_DATE('20050501')); -- CUR_BUY01 Ŀ���� ������, TO_DATE('20050501')�� PDATE�� ����, �������� �־���
         LOOP
           FETCH CUR_BUY01 INTO V_PID; -- CUR_BUY01�� ���� ����ͼ� V_PID�� �־���
           EXIT WHEN CUR_BUY01%NOTFOUND;
           SELECT COUNT(*) INTO V_CNT
             FROM CART
            WHERE CART_PROD = V_PID
              AND CART_NO LIKE '200505%';
           
           IF V_CNT !=0 THEN
             SELECT PROD_NAME, SUM(CART_QTY) INTO V_PNAME, V_AMT
               FROM CART, PROD
              WHERE CART_PROD = V_PID
                AND CART_PROD = PROD_ID
                AND CART_NO LIKE '200505%'
              GROUP BY PROD_NAME;
           
             DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '||V_PID);
             DBMS_OUTPUT.PUT_LINE('��ǰ�� : '||V_PNAME);
             DBMS_OUTPUT.PUT_LINE('�Ǹż��� : '||V_AMT);
             DBMS_OUTPUT.PUT_LINE('---------------------------');
           END IF;  
         END LOOP;
         CLOSE CUR_BUY01;
       END;

��뿹) 2005�⵵ ��ǰ�� �԰�����հ踦 ����ϴ� ����� Ŀ���� �̿��Ͽ� �ۼ��Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �԰����
      (2005�⵵ ��ǰ�� �԰�����հ� ����) -- Ŀ���� ����ϸ��
       SELECT B.BUY_PROD, A.PROD_NAME, SUM(B.BUY_QTY)
         FROM PROD A, BUYPROD B
        WHERE A.PROD_ID = B.BUY_PROD
          AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
        GROUP BY B.BUY_PROD, A.PROD_NAME;
        
       DECLARE
         V_PID PROD.PROD_ID%TYPE;
         V_PNAME PROD.PROD_NAME%TYPE;
         V_AMT NUMBER := 0; -- �������踦 ���� ����
                  
         CURSOR CUR_BUY02 IS
           SELECT B.BUY_PROD AS BID,
                  A.PROD_NAME AS PNAME,
                  SUM(B.BUY_QTY) AS AMT
             FROM PROD A, BUYPROD B
            WHERE A.PROD_ID = B.BUY_PROD
              AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
            GROUP BY B.BUY_PROD, A.PROD_NAME;
       BEGIN
         OPEN CUR_BUY02; -- Ŀ�� ����
         LOOP
           FETCH CUR_BUY02 INTO V_PID, V_PNAME, V_AMT; -- BID, PNAME, AMT�� ������� �����
           EXIT WHEN CUR_BUY02%NOTFOUND; -- ���ʴ�� �ڷḦ �дٰ� �ڷᰡ ������ Ż����
           
           DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '||V_PID); -- ���
           DBMS_OUTPUT.PUT_LINE('��ǰ�� : '||V_PNAME);
           DBMS_OUTPUT.PUT_LINE('�Ǹż��� : '||V_AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------');
         END LOOP; -- ���� ����
         DBMS_OUTPUT.PUT_LINE('�ڷ�� : '||CUR_BUY02%ROWCOUNT);
         CLOSE CUR_BUY02; -- Ŀ�� ����
       END;
       
����) WHILE���� ����Ͽ� �ۼ��Ͻÿ�.
��뿹) 2005�� 5�� �԰��ǰ�� �����Ȳ�� ��ȸ�ϴ� ����� �ۼ��Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, ����
       DECLARE
         V_PID PROD.PROD_ID%TYPE;
         V_PNAME PROD.PROD_NAME%TYPE;
         V_AMT NUMBER := 0;
         V_CNT NUMBER := 0;
         
         CURSOR CUR_BUY01(PDATE DATE) IS
           SELECT DISTINCT BUY_PROD
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN PDATE AND LAST_DAY(PDATE);
       BEGIN
         OPEN CUR_BUY01(TO_DATE('20050501'));
         FETCH CUR_BUY01 INTO V_PID;
         WHILE CUR_BUY01%FOUND LOOP
           SELECT COUNT(*) INTO V_CNT
             FROM CART
            WHERE CART_PROD = V_PID
              AND CART_NO LIKE '200505%';
           
           IF V_CNT !=0 THEN
             SELECT PROD_NAME, SUM(CART_QTY) INTO V_PNAME, V_AMT
               FROM CART, PROD
              WHERE CART_PROD = V_PID
                AND CART_PROD = PROD_ID
                AND CART_NO LIKE '200505%'
              GROUP BY PROD_NAME;
           
             DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '||V_PID);
             DBMS_OUTPUT.PUT_LINE('��ǰ�� : '||V_PNAME);
             DBMS_OUTPUT.PUT_LINE('�Ǹż��� : '||V_AMT);
             DBMS_OUTPUT.PUT_LINE('---------------------------');
           END IF;
           FETCH CUR_BUY01 INTO V_PID;
         END LOOP;
         CLOSE CUR_BUY01;
       END;

��뿹) 2005�⵵ ��ǰ�� �԰�����հ踦 ����ϴ� ����� �ۼ��Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �԰����
       DECLARE
         V_PID PROD.PROD_ID%TYPE;
         V_PNAME PROD.PROD_NAME%TYPE;
         V_AMT NUMBER := 0;
                  
         CURSOR CUR_BUY02 IS
           SELECT B.BUY_PROD AS BID,
                  A.PROD_NAME AS PNAME,
                  SUM(B.BUY_QTY) AS AMT
             FROM PROD A, BUYPROD B
            WHERE A.PROD_ID = B.BUY_PROD
              AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
            GROUP BY B.BUY_PROD, A.PROD_NAME;
       BEGIN
         OPEN CUR_BUY02;
        FETCH CUR_BUY02 INTO V_PID, V_PNAME, V_AMT;
        WHILE CUR_BUY02%FOUND LOOP
           DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '||V_PID);
           DBMS_OUTPUT.PUT_LINE('��ǰ�� : '||V_PNAME);
           DBMS_OUTPUT.PUT_LINE('�Ǹż��� : '||V_AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------');
           FETCH CUR_BUY02 INTO V_PID, V_PNAME, V_AMT;
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('�ڷ�� : '||CUR_BUY02%ROWCOUNT);
         CLOSE CUR_BUY02;
       END;
       
       COMMIT;