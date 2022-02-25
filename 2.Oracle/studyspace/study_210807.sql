��뿹) Ű����� 10~110������ �μ���ȣ�� �Է¹޾� �ش�μ� ���� �� ���� �Ի����� ���� ��� ������ ����Ͻÿ�.
       Alias�� �����ȣ, �����, �Ի���, ��å
       ACCEPT P_DID PROMPT '�μ��ڵ�(10~100)'
       DECLARE
         V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE;
         V_NAME HR.EMPLOYEES.EMP_NAME%TYPE;
         V_HIRE HR.EMPLOYEES.HIRE_DATE%TYPE;
         V_JOBID HR.EMPLOYEES.JOB_ID%TYPE;
       BEGIN
         SELECT A.EMPLOYEE_ID, A.EMP_NAME, A.HIRE_DATE, A.JOB_ID
           INTO V_EID, V_NAME, V_HIRE, V_JOBID
           FROM (SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, JOB_ID
                   FROM HR.EMPLOYEES
                  WHERE DEPARTMENT_ID = TO_NUMBER(&P_DID)
                  ORDER BY 3) A
          WHERE  ROWNUM = 1;
          
          DBMS_OUTPUT.PUT_LINE('�����ȣ : '||V_EID);
          DBMS_OUTPUT.PUT_LINE('����� : '||V_NAME);
          DBMS_OUTPUT.PUT_LINE('�Ի��� : '||V_HIRE);
          DBMS_OUTPUT.PUT_LINE('��å�ڵ� : '||V_JOBID);
          
          EXCEPTION WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('���ܹ߻� : '||SQLERRM);
       END;

��뿹) ������ ���� �Է¹޾� ¦������ Ȧ���� �Ǻ��Ͻÿ�.
       ACCEPT P_NUM PROMPT '�� �Է�';
       DECLARE
         V_NUM NUMBER := TO_NUMBER(&P_NUM);
         V_RES VARCHAR2(200);
       BEGIN
         IF MOD(V_NUM, 2) = 0 THEN
           V_RES := TO_CHAR(V_NUM)||'��/�� ¦���Դϴ�.';
         ELSE
           V_RES := TO_CHAR(V_NUM)||'��/�� Ȧ���Դϴ�.';
         END IF;
         
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;
       
       DECLARE
         V_FLAG BOOLEAN := TRUE;
         V_RES VARCHAR2(200);
       BEGIN
         IF V_FLAG THEN
            V_RES := 'TRUE';
         ELSIF V_FLAG IS NULL THEN
            V_RES := 'NULL';
         ELSE
            V_RES := 'FALSE';
         END IF;
         
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;
       
��뿹) ȸ�� ���̺��� ȸ������ ���ϸ����� ��ȸ�Ͽ�,
       �� ���� 5000�̻��̸� 'VIPȸ��',
       �� ���� 3000�̻��̸� '��ȸ��',
       �� �����̸� '��ȸ��'�� ����Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���ϸ���       
       DECLARE
         V_MID MEMBER.MEM_ID%TYPE;
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_MILE MEMBER.MEM_MILEAGE%TYPE;
         V_RES VARCHAR2(200);
         
         CURSOR CUR_MEM01 IS
           SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
             FROM MEMBER;
       BEGIN
         OPEN CUR_MEM01;
         LOOP
           FETCH CUR_MEM01 INTO V_MID, V_NAME, V_MILE;
           EXIT WHEN CUR_MEM01%NOTFOUND;
           IF V_MILE >= 5000 THEN
             V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'VIPȸ��';
           ELSIF V_MILE >= 3000 THEN
             V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'��ȸ��';
           ELSE  
             V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'��ȸ��';
           END IF;
           DBMS_OUTPUT.PUT_LINE(V_RES);
           DBMS_OUTPUT.PUT_LINE('================================');
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('ȸ���� : '||CUR_MEM01%ROWCOUNT||'��');
         CLOSE CUR_MEM01;
       END;
       
��뿹) ����ڷκ��� ������뷮(�� ����)�� �Է¹޾� ��������� ����Ͽ� ����Ͻÿ�.
       ��뷮(��)   �����ܰ�(��)
        01-10        275
        11-20        305
        21-30        350
        31-40        415
        41�� �̻�     500��
        
       �ϼ��� ����� : ��뷮 * 120��
       ---------------------------------
       ex) 27���� ����� ���
       ---------------------------------
       01-10�� : 275 * 10 = 2,750��
       11-20�� : 305 * 10 = 3,050��
       21-27�� : 350 * 7  = 2,450��
       ---------------------------------
       �ϼ��� ����� : 27 * 120 = 3,240��
       ---------------------------------
                       ������� : 11,490��
       ---------------------------------       
       ACCEPT P_NUM PROMPT '��뷮(��)';
       DECLARE
         V_NUM NUMBER := TO_NUMBER(&P_NUM);
         V_RES VARCHAR2(100);
       BEGIN
         IF V_NUM <= 10 THEN
           V_RES := TO_CHAR(V_NUM * 275);
         ELSIF V_NUM <= 20 THEN
           V_RES := TO_CHAR((10 * 275) + (MOD(V_NUM, 10) * 305));
         ELSIF V_NUM <= 30 THEN
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (MOD(V_NUM, 10) * 350));
         ELSIF V_NUM <= 40 THEN
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (10 * 350) + (MOD(V_NUM, 10) * 415));
         ELSE
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (10 * 350) + (10 * 415) + ((V_NUM - 40) * 500));
         END IF;
           V_RES := V_RES + (V_NUM * 120);
         
         DBMS_OUTPUT.PUT_LINE('��뷮 : '||V_NUM||'��');
         DBMS_OUTPUT.PUT_LINE('������� : '||V_RES||'��');
       END;
       
       ACCEPT P_NUM PROMPT '��뷮(��)'
       DECLARE
         V_NUM NUMBER := TO_NUMBER('&P_NUM');
         V_RES NUMBER(30);
       BEGIN
         IF V_NUM <= 10 THEN
           V_RES := V_NUM * 275;
         ELSIF V_NUM <= 20 THEN
           V_RES := (10 * 275) + ((V_NUM - 10) * 305);
         ELSIF V_NUM <= 30 THEN
           V_RES := (10 * 275) + (10 * 305) + ((V_NUM - 20) * 350);
         ELSIF V_NUM <= 40 THEN
           V_RES := (10 * 275) + (10 * 305) + (10 * 350) + ((V_NUM - 30) * 415);
         ELSE
           V_RES := (10 * 275) + (10 * 305) + (10 * 350) + (10 * 415) + ((V_NUM - 40) * 500);
         END IF;
         V_RES := V_RES + (V_NUM * 120);
         
         DBMS_OUTPUT.PUT_LINE('��뷮 : '||V_NUM||'��');
         DBMS_OUTPUT.PUT_LINE('������� : '||V_RES||'��');
       END;       
       
��뿹) 10-100 ������ ������ �߻����� ������ �ش��ϴ� �μ��� ���� ��� �� ù��° ����� �޿��� ��ȸ�Ͽ�
       5000�����̸� '���ӱ� ���', 10000�����̸� '����ӱ� ���', �� �̻��̸� '���ӱ� ���'�� ����Ͻÿ�.
       Alias�� �����ȣ, �����, �μ���       
       DECLARE
         V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE; -- �����ȣ
         V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE; -- ����̸�
         V_DNAME HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE; -- �μ���
         V_SAL HR.EMPLOYEES.SALARY%TYPE; -- �޿�
         V_MESSAGE VARCHAR2(20); -- ����(���ӱ� ���, ����ӱ� ���, ���ӱ� ���)
         V_DID HR.EMPLOYEES.DEPARTMENT_ID%TYPE; -- ������ �߻���Ų �μ��ڵ�
       BEGIN
         V_DID := TRUNC(SYS.DBMS_RANDOM.VALUE(10, 110), -1); -- ������ ���� �߻�, TRUNC(~, -1)�� 1�� �ڸ��� ����
         SELECT A.EMPLOYEE_ID, A.EMP_NAME, B.DEPARTMENT_NAME, A.SALARY
           INTO V_EID, V_ENAME, V_DNAME, V_SAL -- INTO�� ������� ������ ���� �߻�, PL/SQL������ �ݵ�� INTO�� ����ؾ���
           FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
          WHERE A.DEPARTMENT_ID = V_DID
            AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
            AND ROWNUM = 1; -- ù��° ����� ��ȸ
         CASE WHEN V_SAL < 5000 THEN
                   V_MESSAGE := '���ӱ� ���';
              WHEN V_SAL < 10000 THEN
                   V_MESSAGE := '����ӱ� ���';
              ELSE
                   V_MESSAGE := '���ӱ� ���';
         END CASE;
         
         DBMS_OUTPUT.PUT_LINE('�μ��� : '||V_DNAME);
         DBMS_OUTPUT.PUT_LINE('�����ȣ : '||V_EID);
         DBMS_OUTPUT.PUT_LINE('����� : '||V_ENAME);
         DBMS_OUTPUT.PUT_LINE('��� : '||V_MESSAGE);
       END;
       
��뿹) �������� 7���� ����ϴ� ����� �ۼ��Ͻÿ�.
       DECLARE
         V_CNT NUMBER := 1; -- ���ں����� �ݵ�� �ʱⰪ�� �����������, �׷��� ������ �����ɶ� NULL���� �����ǹǷ� ������ �߻���
         V_RES NUMBER := 0;
       BEGIN
         LOOP
           V_RES := 7 * V_CNT;
           EXIT WHEN V_CNT > 9;
           DBMS_OUTPUT.PUT_LINE(7||' * '||V_CNT||' = '||V_RES);
           V_CNT := V_CNT + 1;
         END LOOP;  
       END;
       
��뿹) �������� ��� ���� ����ϴ� ����� �ۼ��Ͻÿ�.
       DECLARE
         V_NUM NUMBER := 2;
         V_CNT NUMBER := 1;
         V_RES NUMBER := 0;
       BEGIN
         LOOP
         EXIT WHEN V_NUM > 9;
           LOOP
           V_RES := V_NUM * V_CNT;
           EXIT WHEN V_CNT > 9;
           DBMS_OUTPUT.PUT_LINE(V_NUM||' * '||V_CNT||' = '||V_RES);
           V_CNT := V_CNT + 1;
           END LOOP;
           V_CNT := 1;
           V_NUM := V_NUM + 1;
           DBMS_OUTPUT.PUT_LINE('');
         END LOOP;
       END;
       
��뿹) �������� 7���� ����ϴ� ����� �ۼ��Ͻÿ�.
       DECLARE
         V_CNT NUMBER := 0;
         V_RES NUMBER := 0;
       BEGIN
         WHILE V_CNT < 9 LOOP
           V_CNT := V_CNT + 1;
           V_RES := V_CNT * 7;
           DBMS_OUTPUT.PUT_LINE(7||' * '||V_CNT||' = '||V_RES);
         END LOOP;
       END;       
       
��뿹) �������� 7���� ����ϴ� ����� �ۼ��Ͻÿ�.       
       DECLARE
         -- ����ΰ� ��� �ۼ� ����
       BEGIN
         FOR I IN 1..9 LOOP
           DBMS_OUTPUT.PUT_LINE(7||' * '||I||' = '||7 * I);
         END LOOP;
       END;

��뿹) �������� ��� ���� ����ϴ� ����� �ۼ��Ͻÿ�.
       DECLARE
         -- ����ΰ� ��� �ۼ� ����
       BEGIN
         FOR J IN 2..9 LOOP
           FOR I IN 1..9 LOOP
             DBMS_OUTPUT.PUT_LINE(J||' * '||I||' = '||J * I);
           END LOOP;
           DBMS_OUTPUT.PUT_LINE('');
         END LOOP; 
       END;
       
��뿹) ù���� 100���� �����ϰ�, �� ���������� ������ 2�辿 ������ ��, ���ʷ� 200������ �Ѵ� ���� ����ݾ��� ���Ͻÿ�.
       -- ��Ȯ�� ���� �𸣹Ƿ� ���� �� �ֱ��� FOR���� �ۼ��ϰ� 200������ ������ FOR���� ���������� �ϸ� ��
       DECLARE
         V_SUM NUMBER := 0; -- �����հ� �ݾ�
         V_DSUM NUMBER := 100; -- �Ϻ� ����׼�
         V_DAYS NUMBER := 0; -- ��¥, ��¥�� I�� �� �� �ִµ�, I�� FOR�� �ۿ��� ����� �� �����Ƿ� I�� ������ ������ ��������
       BEGIN
         FOR I IN 1..1000 LOOP
           V_SUM := V_SUM + V_DSUM;
           V_DAYS := I;
           IF V_SUM >= 2000000 THEN
             EXIT;
           END IF;
           V_DSUM := V_DSUM * 2;
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('�ϼ� : '||V_DAYS||'��');
         DBMS_OUTPUT.PUT_LINE('����ݾ� : '||V_SUM||'��');
       END;
       
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
         
��뿹) 2005�⵵ ��ǰ�� �԰�����հ踦 ����ϴ� ����� �ۼ��Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �԰����
       DECLARE
         V_NUM NUMBER := 1;
         -- DECLARE���� ���������� ���� �ʾƵ� ��
         CURSOR CUR_BUY02 IS
           SELECT B.BUY_PROD AS BID,
                  A.PROD_NAME AS PNAME,
                  SUM(B.BUY_QTY) AS AMT
             FROM PROD A, BUYPROD B
            WHERE A.PROD_ID = B.BUY_PROD
              AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
            GROUP BY B.BUY_PROD, A.PROD_NAME;
       BEGIN
         FOR REC1 IN CUR_BUY02 LOOP -- Ŀ���� �� ���� �� ���ڵ�(REC1), �ڵ����� Ŀ���� �� �྿ ����
           DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '||REC1.BID);
           DBMS_OUTPUT.PUT_LINE('��ǰ�� : '||REC1.PNAME);
           DBMS_OUTPUT.PUT_LINE('�Ǹż��� : '||REC1.AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------'||V_NUM);
           V_NUM := V_NUM + 1;
         END LOOP;
       END;         
         
��뿹) 2005�⵵ ��ǰ�� �԰�����հ踦 ����ϴ� ����� �ۼ��Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �԰����
       DECLARE
       BEGIN
         FOR REC1 IN (SELECT B.BUY_PROD AS BID, A.PROD_NAME AS PNAME, SUM(B.BUY_QTY) AS AMT
                        FROM PROD A, BUYPROD B
                       WHERE A.PROD_ID = B.BUY_PROD
                         AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
                       GROUP BY B.BUY_PROD, A.PROD_NAME)
         LOOP
           DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '||REC1.BID);
           DBMS_OUTPUT.PUT_LINE('��ǰ�� : '||REC1.PNAME);
           DBMS_OUTPUT.PUT_LINE('�Ǹż��� : '||REC1.AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------');
         END LOOP;
       END;
       
��뿹) �⵵�� ���� ��ǰ�ڵ带 �Է¹޾� �ش���ǰ�� �԰������ �����Ͽ� ���������̺��� �ش���ǰ�� ��� �����ϴ� ���ν����� �ۼ��Ͻÿ�.
       (�������)
       CREATE OR REPLACE PROCEDURE PROC_BUY_REMAIN(
         P_YEAR  IN CHAR, -- �Է��̴� IN(�ܺο��� �������� IN, �ܺη� �������� OUT)
         P_MONTH IN VARCHAR2, -- �Է��̴� IN
         P_PID   IN VARCHAR2) -- �Է��̴� IN
       IS
         V_IAMT NUMBER(5) := 0; -- ���Լ���
         V_FLAG NUMBER := 0; -- �����ڷ� ��������
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- ���Թ߻� ���� ���۳�¥
       BEGIN
         SELECT COUNT(*), SUM(BUY_QTY) INTO V_FLAG, V_IAMT
           FROM BUYPROD
          WHERE BUY_PROD = P_PID
            AND BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE);
            
         IF V_FLAG != 0 THEN
           UPDATE REMAIN
              SET REMAIN_I = REMAIN_I + V_IAMT,
                  REMAIN_J_99 = REMAIN_J_99 + V_IAMT,
                  REMAIN_DATE = LAST_DAY(V_DATE)
            WHERE REMAIN_YEAR = P_YEAR
              AND PROD_ID = P_PID;
         END IF;
       END;
       (������� - ����)
       EXECUTE PROC_BUY_REMAIN('2005', '03', 'P201000017');
       
       ROLLBACK;
       
��뿹) �����ȣ�� �Է¹޾� �ش����� �Ҽӵ� �μ��� �μ���, �ο���, ��ձ޿��� ��ȯ�޴� ���ν����� �ۼ��Ͻÿ�.
       -- ���ν����� ��ȯ���� ����, '��ȯ�޴�'�̶�� ���� OUT �Ű������� ����� ����϶�� ����
       (�������) -- HR�������� ��밡��
       CREATE OR REPLACE PROCEDURE PROC_EMP01(
         P_EID  IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE, -- 'HR.EMPLOYEES.EMPLOYEE_ID'�� ���� Ÿ������ �Ű����� ����
         P_DNAME OUT HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE, -- �μ���
         P_CNT OUT NUMBER, -- �ο���
         P_SAL OUT NUMBER) -- ��ձ޿�
       IS
         -- ������ ������ ������ �����
       BEGIN
         SELECT B.DEPARTMENT_NAME, COUNT(*), ROUND(AVG(SALARY))
           INTO P_DNAME, P_CNT, P_SAL
           FROM (SELECT DEPARTMENT_ID AS DID
                   FROM HR.EMPLOYEES
                  WHERE EMPLOYEE_ID = P_EID) A, DEPARTMENTS B, EMPLOYEES C
          WHERE A.DID = B.DEPARTMENT_ID
            AND C.DEPARTMENT_ID = B.DEPARTMENT_ID
          GROUP BY B.DEPARTMENT_NAME;
       END;
       (������� - ����) -- HR�������� ��밡��
       -- ������ �Ϸ��� ��ȯ���� �Ű������� �����ؾ���
       DECLARE
         V_DNAME HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE;
         V_CNT NUMBER := 0;
         V_SAL NUMBER := 0;
       BEGIN
         PROC_EMP01(109, V_DNAME, V_CNT, V_SAL); -- EXECUTE�� ������ �ȵ�
         DBMS_OUTPUT.PUT_LINE('�μ��� : '||V_DNAME);
         DBMS_OUTPUT.PUT_LINE('������ : '||V_CNT);
         DBMS_OUTPUT.PUT_LINE('��ձ޿� : '||V_SAL);
       END;       
       
��뿹) '����'�� �����ϴ� ȸ���� ȸ����ȣ�� �Է¹޾� �ش� �ؿ��� 2005�� 6�� ���űݾ��� ����ϴ� �Լ��� �ۼ��Ͻÿ�.
       (�������)       
       CREATE OR REPLACE FUNCTION FN_SUM01 (
         P_MID MEMBER.MEM_ID%TYPE)
         RETURN NUMBER
       IS
         V_SUM NUMBER := 0; -- ���űݾ� �հ�
         V_CNT NUMBER := 0; -- 2005�� 6���� �ش� ȸ���� �ڷ�(CART)�� �������� Ȯ��
       BEGIN
         SELECT COUNT(*) INTO V_CNT
           FROM CART
          WHERE CART_NO LIKE '200506%'
            AND CART_MEMBER = P_MID;
            
         IF V_CNT != 0 THEN
           SELECT SUM(CART_QTY * PROD_PRICE) INTO V_SUM
             FROM CART, PROD
            WHERE CART_NO LIKE '200506%'
              AND CART_MEMBER = P_MID
              AND CART_PROD = PROD_ID;
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
         P_PID IN PROD.PROD_ID%TYPE, -- IN�� �����ص� ����, OUT�� ������ ���, �����ϸ� IN���� ������
         P_YEAR CHAR,
         P_MONTH CHAR)
         RETURN VARCHAR2 -- 2���� ��ȯ���� �� �����Ƿ� ��� ��ȯ��
       IS
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- '01'�� �ٿ��� �������� ��
         V_AMT NUMBER := 0; -- ���Լ��� ����
         V_SUM NUMBER := 0; -- ���Աݾ��հ� ����
         V_CNT NUMBER := 0; -- �ڷ� �������� �Ǵ�
         V_RES VARCHAR2(100);
       BEGIN
         SELECT COUNT(*) INTO V_CNT -- ���Լ��� �������� �Ǵ�
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
            AND BUY_PROD = P_PID; -- BUY_PROD�� �Ѱܹ��� ��ǰ�ڵ�� �������� �Ǵ�
            
         IF V_CNT != 0 THEN
           SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_AMT, V_SUM
           -- ���ż����� ���űݾ��� ���� V_AMT, V_SUM�� ����
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
              AND BUY_PROD = P_PID;
         END IF;
         
         V_RES := '���ż��� : '||V_AMT||', '||'���űݾ� :'||V_SUM;
         -- �� ���� ��ȯ�� �� �����Ƿ� ��� ��ȯ
         RETURN V_RES;
       END;

       (������� - ����)
       SELECT PROD_ID, PROD_NAME, FN_BUY01(PROD_ID, '2005', '05')
         FROM PROD;

       (������� - �Լ�) : FN_BUY02 -- �Լ� ���ο��� ���Ż�� ���� �Ǵ�       
       CREATE OR REPLACE FUNCTION FN_BUY02 (
         P_PID IN PROD.PROD_ID%TYPE, -- IN�� �����ص� ����, OUT�� ������ ���, �����ϸ� IN���� ������
         P_YEAR CHAR,
         P_MONTH CHAR,
         P_AMT OUT NUMBER) -- ��¿� �Ű�����, ���Լ��� �հ谡 �Ű������� ���� ������ ��µ�
         RETURN NUMBER
       IS
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- '01'�� �ٿ��� �������� ��
         V_AMT NUMBER := 0; -- ���Լ��� ����
         V_SUM NUMBER := 0; -- ���Աݾ��հ� ����
         V_CNT NUMBER := 0; -- �ڷ� �������� �Ǵ�
       BEGIN
         SELECT COUNT(*) INTO V_CNT -- ���Լ��� �������� �Ǵ�
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
            AND BUY_PROD = P_PID; -- BUY_PROD�� �Ѱܹ��� ��ǰ�ڵ�� �������� �Ǵ�
            
         IF V_CNT != 0 THEN
           SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_AMT, V_SUM
           -- ���ż����� ���űݾ��� ���� V_AMT, V_SUM�� ����
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
              AND BUY_PROD = P_PID;
         END IF;
         
         P_AMT := V_AMT;
         RETURN V_SUM;
       END;
       
       (������� - ����) -- SELECT���� ����ϸ� �ѹ��� ó���Ǳ� ������, �ϳ��� ó���ϱ� ���� Ŀ���� �����
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
         V_DATE VARCHAR2(20) := P_DATE;
         V_CNT NUMBER := 0;
         V_SUM NUMBER := 0;
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_RES VARCHAR2(100);
       BEGIN
         SELECT COUNT(*) INTO V_CNT
           FROM CART
          WHERE CART_NO LIKE V_DATE||'%';
         
         IF V_CNT != 0 THEN
           SELECT A.MNAME, A.MSUM INTO V_NAME, V_SUM
             FROM (SELECT MEM_NAME AS MNAME,
                          SUM(CART_QTY * PROD_PRICE) AS MSUM
                     FROM CART, MEMBER, PROD
                    WHERE CART_MEMBER = MEM_ID
                      AND CART_PROD = PROD_ID
                      AND CART_NO LIKE V_DATE||'%'
                    GROUP BY MEM_NAME
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

��뿹) �⵵�� ���� 6�ڸ� ���ڿ��� �Է¹޾� �ش���� ���� ���� ��ǰ�� ����(�ݾױ���)�� ȸ���� �̸��� ���űݾ��� ����ϴ� �Լ��� �ۼ��Ͻÿ�.
       (������� - �Լ�) : FN_MAXMEM       
       CREATE OR REPLACE FUNCTION FN_MAXMEM (
         P_DATE IN VARCHAR2)
         RETURN VARCHAR2
       IS
         V_RES VARCHAR2(100);
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_SUM NUMBER := 0;
         V_DATE VARCHAR2(10) := P_DATE||'%';
       BEGIN
         SELECT A.MEM_NAME, A.AMT INTO V_NAME, V_SUM
           FROM (SELECT MEM_NAME,
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

��뿹) �з� ���̺� ���ο� �з��ڵ带 �����ϰ�, ���� �� '���ο� �з��� �߰��Ǿ����ϴ�.'�� ����ϴ� Ʈ���Ÿ� �ۼ��Ͻÿ�.
       [�з��ڵ� : 'P502', �з��� : '�ӻ깰', ���� : 11]
       (������� Ʈ����)
       CREATE OR REPLACE TRIGGER TG_LPROD_INSERT
         AFTER INSERT ON LPROD
       BEGIN
         DBMS_OUTPUT.PUT_LINE('���ο� �з��� �߰��Ǿ����ϴ�.');
       END;
       
       INSERT INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)
         VALUES (13, 'P504', '����깰');
         
       COMMIT;  
       
       SELECT * FROM LPROD;
       
       CREATE OR REPLACE TRIGGER TG_LPROD_INSERT
         AFTER DELETE ON LPROD
       BEGIN
         DBMS_OUTPUT.PUT_LINE('���ο� �з��� �����Ǿ����ϴ�.');
       END;
       
       DELETE LPROD
        WHERE LPROD_ID = 13;
        
       COMMIT;
       
       SELECT * FROM LPROD;       
       
��뿹) ���� ��¥�� 2005�� 6�� 11���̸� ��ǰ�ڵ尡 'P102000005'�� ��ǰ�� ó�� 10�� �����ߴ� �����ϰ�,
       �� ������ ���� ���̺� �����ϰ� ������ ���̺��� �����ϴ� Ʈ���Ÿ� �ۼ��Ͻÿ�.
       (����� Ʈ����)       
       CREATE OR REPLACE TRIGGER TG_BUYPROD_INSERT
         AFTER INSERT ON BUYPROD
         FOR EACH ROW
       DECLARE
         V_QTY NUMBER := :NEW.BUY_QTY;
         V_PROD PROD.PROD_ID%TYPE := :NEW.BUY_PROD;
       BEGIN
         UPDATE REMAIN
            SET REMAIN_I = REMAIN_J + V_QTY,
                REMAIN_J_PP = REMAIN_J_99 + V_QTY,
                REMAIN_DATE = TO_DATE(20050611)
          WHERE REMAIN_YEAR = '2005'
            AND PROD_ID = :NEW.BUY_PROD;
         DBMS_OUTPUT.PUT_LINE(:NEW.BUY_PROD||'��ǰ�� '||V_QTY||'�� �԰�Ǿ����ϴ�.');
       END;
       
       (����)
       INSERT INTO BUYPROD
         SELECT TO_DATE('20050611'), PROD_ID, 10, PROD_COST
           FROM PROD
          WHERE PROD_ID = 'P102000005';
       
       COMMIT;
       
��뿹) ����(2005�� 08�� 06��) 'h001'ȸ��(����ȣ)�� ��ǰ 'P202000019'�� 5�� �������� ��,
       CART ���̺�� ������ ���̺� �ڷḦ ���� �� �����Ͻÿ�.
       -- REMAIN_YEAR : ���⵵
       -- PROD_ID : ��� ��ǰ�ڵ�
       -- REMAIN DATE : �ֽų�¥
       -- REMAIN_J_00 : �������
       -- REMAIN_J_99 : �⸻���(�������)
       -- REMAIN_I : �԰�
       -- REMAIN_O : ���
       -- �ڵ����� : ���ϴ� ���� ��� + Ctrl + F7
       (����� Ʈ����)
       CREATE OR REPLACE TRIGGER TG_CART_CHANGE
         AFTER INSERT OR UPDATE OR DELETE ON CART
         FOR EACH ROW -- �� �ึ�� ó����
       DECLARE
         V_QTY NUMBER := 0; -- ���Լ���
         V_PID PROD.PROD_ID%TYPE; -- ��ǰ�ڵ�
         V_DATE DATE; -- ��¥
       BEGIN
         IF INSERTING THEN -- ��ǰ�� ������, ���(REMAIN_O) ����, ���(REMAIN_J_99) ����
           V_QTY := NVL(:NEW.CART_QTY, 0);
           V_PID := :NEW.CART_PROD;
           V_DATE := TO_DATE(SUBSTR(:NEW.CART_NO, 1, 8));
         ELSIF UPDATING THEN -- ��ǰ ���Լ����� ������(5 -> 2), 5�� OLD, 2�� NEW, ��� ����, ��� ����
           V_QTY := NVL(:NEW.CART_QTY, 0) - NVL(:OLD.CART_QTY, 0);
           V_PID := :NEW.CART_PROD;
           V_DATE := TO_DATE(SUBSTR(:NEW.CART_NO, 1, 8));
         ELSIF DELETING THEN -- ������ �����, ��� ����, ��� ����
           V_QTY := -(NVL(:OLD.CART_QTY, 0));
           V_PID := :OLD.CART_PROD;
           V_DATE := TO_DATE(SUBSTR(:OLD.CART_NO, 1, 8));
         END IF;
         
         UPDATE REMAIN
            SET REMAIN_O = REMAIN_O + V_QTY,
                REMAIN_J_99 = REMAIN_J_99 - V_QTY,
                REMAIN_DATE = V_DATE
          WHERE REMAIN_YEAR = '2005'
            AND PROD_ID = V_PID;
         
         EXCEPTION WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('�����߻� : '||SQLERRM);
       END;       
       
       
       
       
       
       