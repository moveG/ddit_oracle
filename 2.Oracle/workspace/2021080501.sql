2021-0805-01) User Defined Function(�Լ�)
    - ���ν����� ���� ���� ������
    - ��ȯ���� ���� -- ���ν����� ��ȯ���� ����
    - ���� ���Ǵ� �������� �Ǵ� ������ ����� ���� �Լ��� ����
    - SELECT ���� SELECT��, WHERE���� ����� ������ -- ���ν����� �Ϲ����� ������ ����� �Ұ���, ���������� ������
    -- �޼���, ���ν���, �Լ� ���� �ϳ��� ���� ��ȯ�ϵ��� �����ϴ� ���� ����
    (�������)
      CREATE [OR REPLACE] FUNCTION �Լ���[(
        �Ű����� [MODE] Ÿ�� [:=��][,
          :
        �Ű����� [MODE] Ÿ�� [:=��]])]
        RETURN ������ Ÿ�� -- �⺻�� ������ Ÿ�Ը� ��밡����, ������ ������ Ÿ���� ��� �Ұ�����
      IS|AS -- �� �κ��� DECLARE��� �����ϸ��
        ���𿵿�
      BEGIN
        ���࿵��
        RETURN ��|expr; -- ���� ��ȯ�Ǵ� ��, �ϳ��� ��ȯ����
      END;
      . 'RETURN ������ Ÿ��' : ��ȯ�� ������ Ÿ��
      . 'RETURN ��|expr' : ��ȯ�ؾ��ϴ� �� �Ǵ� ���� �����ϴ� ���� ������ �ݵ�� 1�� �̻� �����ؾ���
      -- CREATE�� RETURN ������ Ÿ�԰� BEGIN�� RETURN ���� ������ Ÿ���� �����ؾ���
      
��뿹) '����'�� �����ϴ� ȸ���� ȸ����ȣ�� �Է¹޾� �ش� �ؿ��� 2005�� 6�� ���űݾ��� ����ϴ� �Լ��� �ۼ��Ͻÿ�.
       (�������)
       CREATE OR REPLACE FUNCTION FN_SUM01 (
         P_MID MEMBER.MEM_ID%TYPE)
         RETURN NUMBER
       IS
         V_SUM NUMBER := 0; -- ���űݾ��հ�
         V_CNT NUMBER := 0; -- 2005�� 6���� �ش� ȸ�� �ڷ�(CART)�� �������� Ȯ��
       BEGIN
         SELECT COUNT(*) INTO V_CNT
           FROM CART
          WHERE CART_NO LIKE '200506%'
            AND CART_MEMBER = P_MID;
         IF V_CNT != 0 THEN
           SELECT SUM(A.CART_QTY * B.PROD_PRICE) INTO V_SUM
             FROM CART A, PROD B
            WHERE CART_NO LIKE '200506%'
              AND CART_MEMBER = P_MID
              AND A.CART_PROD = B.PROD_ID;
         ELSE
           V_SUM := 0;
         END IF;
         RETURN V_SUM;
       END;

       (������� - ����)
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              FN_SUM01 (MEM_ID) AS ���űݾ�
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '����%'
        ORDER BY 1;
       
��뿹) ��ǰ�ڵ�� �⵵ �� ���� �Է¹޾� �ش� ��ǰ�� ���ż����� ���űݾ��� ����ϴ� �Լ��� �ۼ��Ͻÿ�.
       (������� - �Լ�) : FN_BUY01 -- �Լ� ���ο��� ���Ż�� ���� �Ǵ�
       CREATE OR REPLACE FUNCTION FN_BUY01 (
         P_PID IN PROD.PROD_ID%TYPE, -- IN�� �����ص� ����, �����ϸ� IN���� ����, OUT�� ������ ����ؾ���
         P_YEAR CHAR,
         P_MONTH CHAR)
         RETURN VARCHAR2 -- �� ���� ��ȯ���� �� �����Ƿ� ��� ��ȯ
       IS
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- '01'�� �ٿ��� �������� ��
         V_AMT NUMBER := 0; -- ���Լ����� ������
         V_SUM NUMBER := 0; -- ���Աݾ� �հ踦 ������
         V_CNT NUMBER := 0; -- �ڷ�� ������ �Ǵ���
         V_RES VARCHAR2(100);
       BEGIN
         SELECT COUNT(*) INTO V_CNT -- ���Լ��� ���� ������ �Ǵ�
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
            AND BUY_PROD = P_PID; -- BUY_PROD�� �Ѱܹ��� ��ǰ�ڵ�� �������� �Ǵ�
            
         IF V_CNT != 0 THEN
           SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_AMT, V_SUM -- ���ż����� ���űݾ��� ���� V_AMT�� V_SUM�� ����
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
              AND BUY_PROD = P_PID;
         ELSE
           V_SUM := 0;
           V_AMT := 0;
         END IF;
         V_RES := '���ż��� : '||V_AMT||', '||'���űݾ� :'||V_SUM; -- �� ���� ��ȯ�� �� �����Ƿ� ��� ��ȯ
         RETURN V_RES;
       END;
       
       (������� - ����)       
       SELECT '2005-05', PROD_ID, PROD_NAME, FN_BUY01(PROD_ID, '2005', '05')
         FROM PROD;
       
       (������� - �Լ�) : FN_BUY02 -- �Լ� ���ο��� ���Ż�� ���� �Ǵ�
       CREATE OR REPLACE FUNCTION FN_BUY02 (
         P_PID IN PROD.PROD_ID%TYPE, -- IN�� �����ص� ����, �����ϸ� IN���� ����, OUT�� ������ ����ؾ���
         P_YEAR CHAR,
         P_MONTH CHAR,
         P_AMT OUT NUMBER) -- ��¿� �Ű�����, ���Լ��� �հ谡 �Ű������� ���� ������ ��µ�
         RETURN NUMBER
       IS
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- '01'�� �ٿ��� �������� ��
         V_AMT NUMBER := 0; -- ���Լ����� ������
         V_SUM NUMBER := 0; -- ���Աݾ� �հ踦 ������
         V_CNT NUMBER := 0; -- �ڷ�� ������ �Ǵ���
       BEGIN
         SELECT COUNT(*) INTO V_CNT -- ���Լ��� ���� ������ �Ǵ�
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
            AND BUY_PROD = P_PID; -- BUY_PROD�� �Ѱܹ��� ��ǰ�ڵ�� �������� �Ǵ�
            
         IF V_CNT != 0 THEN
           SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_AMT, V_SUM -- ���ż����� ���űݾ��� ���� V_AMT�� V_SUM�� ����
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
              AND BUY_PROD = P_PID;
         ELSE
           V_SUM := 0;
           V_AMT := 0;
         END IF;
         P_AMT := V_AMT;
         RETURN V_SUM;
       END;
       
       (������� - ����) -- SELECT���� ����ϸ� �Ѳ����� ó���ǹǷ� �ϳ��ϳ� ó���� �Ұ�����, �׷��� Ŀ���� ����� ������
       DECLARE
         V_AMT NUMBER := 0;
         V_SUM NUMBER := 0;
         CURSOR CUR_PROD IS
           SELECT PROD_ID, PROD_NAME
             FROM PROD;
       BEGIN
         FOR REC IN CUR_PROD LOOP
           V_SUM := FN_BUY02(REC.PROD_ID, '2005', '05', V_AMT);
           DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '||REC.PROD_ID);
           DBMS_OUTPUT.PUT_LINE('��ǰ�� : '||REC.PROD_NAME);
           DBMS_OUTPUT.PUT_LINE('���Լ��� : '||V_AMT);
           DBMS_OUTPUT.PUT_LINE('���Աݾ� : '||V_SUM);
           DBMS_OUTPUT.PUT_LINE('============================');
         END LOOP;  
       END;
       
��뿹) �⵵�� ���� 6�ڸ� ���ڿ��� �Է¹޾� �ش���� ���� ���� ��ǰ�� ����(�ݾױ���)�� ȸ���� �̸��� ���űݾ��� ����ϴ� �Լ��� �ۼ��Ͻÿ�.
       (������� - �Լ�) : FN_MAXMEM
       CREATE OR REPLACE FUNCTION FN_MAXMEM (
         P_DATE VARCHAR2)
         RETURN VARCHAR2
       IS
         V_DATE VARCHAR2(20) := P_DATE; -- ��¥
         V_CNT NUMBER := 0; --���ſ���?
         V_SUM NUMBER := 0; --���űݾ�
         V_NAME MEMBER.MEM_NAME%TYPE; --�̸�
         V_RES VARCHAR2(100); -- RETURN���� �ڵ�����ȯ�� �ֱ� ������ Ÿ���� �ణ �޶� ������
       BEGIN
         SELECT COUNT(CART_NO) INTO V_CNT
           FROM CART
          WHERE CART_NO LIKE V_DATE||'%';
         
         IF V_CNT > 0 THEN
           SELECT A.MNAME, A.MSUM INTO V_NAME, V_SUM
             FROM (SELECT B.MEM_NAME AS MNAME,
                          SUM(A.CART_QTY * C.PROD_PRICE) AS MSUM
                     FROM CART A, MEMBER B, PROD C
                    WHERE A.CART_MEMBER = B.MEM_ID
                      AND A.CART_PROD = C.PROD_ID
                      AND SUBSTR(A.CART_NO, 1, 6) = V_DATE
                    GROUP BY B.MEM_NAME
                    ORDER BY 2 DESC) A
            WHERE ROWNUM = 1;  
         ELSE
           V_NAME := '';
         END IF;
         V_RES := 'ȸ���� : '||V_NAME||', ���űݾ� : '||V_SUM;
         RETURN V_RES;
       END;
       
       (������� - ����)
       SELECT FN_MAXMEM('200506') FROM DUAL;
       
       (������� - �Լ�) : FN_MAXMEM
       CREATE OR REPLACE FUNCTION FN_MAXMEM (
         P_PERIOD IN CHAR)
         RETURN VARCHAR2
       IS
         V_RES VARCHAR2(100);
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_SUM NUMBER := 0;
         V_DATE CHAR(7) := P_PERIOD||'%';
       BEGIN
         SELECT A.MEM_NAME, A.AMT INTO V_NAME, V_SUM -- ��¿� ����
           FROM (SELECT MEM_NAME, -- ������ ��������
                        SUM(CART_QTY * PROD_PRICE) AS AMT
                   FROM CART, PROD, MEMBER
                  WHERE CART_PROD = PROD_ID
                    AND MEM_ID = CART_MEMBER
                    AND CART_NO LIKE V_DATE
                  GROUP BY MEM_NAME
                  ORDER BY 2 DESC) A
          WHERE ROWNUM = 1;
         V_RES := 'ȸ���� : '||V_NAME||', ���űݾ� : '||V_SUM;
         RETURN V_RES;
       END;
       
       (������� - ����)
       SELECT FN_MAXMEM('200506') FROM DUAL;
       
       (������� - �Է�)
       ACCEPT P_DATE PROMPT '���(YYYYMM) : '
       DECLARE
         V_RES VARCHAR2(100);
       BEGIN
         V_RES := FN_MAXMEM('&P_DATE');
         DBMS_OUTPUT.PUT_LINE(SUBSTR('&P_DATE', 1, 4)||'�� '||SUBSTR('&P_DATE', 5)||'��');
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;