2021-0802-01) PL/SQL(Procedual Language SQL)
    - ǥ�� SQL�� ����� Ȯ���� SQL
    - ������ ���డ���� ������ ���ȭ�� ���� ���α׷�
    - Block ������ ����
    - ���ȭ, ĸ��ȭ(������ ����ȭ, �ϳ��� ����� ����� �� �ܺο� ������ ������ �ȵ�, �ٸ� ��⿡ ������ �ؼ��� �ȵ�)
    - Anonymous Block, User Defined Function(Function), Stored Procedure(Procedure), Package, Trigger ���� ������
    -- Function�� Procedure�� ���� ����ϰ� ����
    -- ��ȯ���� ������ Function, ��ȯ���� ������ Procedure
    -- Package�� PL/SQL�� ��ü���� ��� ����� �� �ִ� ���, �Ѳ����� Ȥ�� �ʿ��� ��ɸ� ��� ����
    -- Trigger�� �߻��� �̺�Ʈ�� ���Ŀ� ó���Ǿ���� �Լ��� ������ ����ϴ� ���
    
  1. �͸���(Anoymous Block)
    - PL/SQL�� �⺻����
    - �ܼ� ��ũ��Ʈ���� ����Ǵ� ���
    -- �̸��� ���� ����̶� ������ �� ����, �׷��� ������ �ȵ�
    -- �͸��� ���� ���� �Ϳ� ���� Function, Procedure, Package, Trigger ���� �� �� ����
    -- �Ϲݺ����� 'V_'�� ���۵ǰ�, �Ű������� 'P_'�� ���۵�
    (�������)
      DECLARE
        �����(����, ���, Ŀ�� ����);
      BEGIN
        �����(����Ͻ� ������ ó���ϱ� ���� SQL��)
        [EXCEPTION -- ���û���
          ����ó����; -- WHEN OTHERS THEN?: ��� ����� ���ܸ� ó���� �� ����
        ]
      END;
      -- �������ʹ� ��ũ��Ʈ ���â�� �ƴ�, DBMS���â���� ��µǾ����
      -- DBMS���â�� �ڵ����� �������� ����
      -- ���찳 ��ư�� ���� ������ ��µ� ������ ������ �� ����

��뿹) Ű����� 10~110������ �μ���ȣ�� �Է¹޾� �ش�μ� ���� �� ���� �Ի����� ���� ��� ������ ����Ͻÿ�.
       Alias�� �����ȣ, �����, �Ի���, ��å
       ACCEPT P_DID PROMPT '�μ��ڵ�(10~110)' -- �Է�â�� ���� ���, P_DID�� VARCHAR2Ÿ�� ���ڿ�
       DECLARE
         V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE; -- ����Ÿ���� ����ϴ� ���, �ش��÷��� �ش�Ÿ�԰� �����ϰ� ��������
         V_NAME HR.EMPLOYEES.EMP_NAME%TYPE;
         V_HIRE HR.EMPLOYEES.HIRE_DATE%TYPE;
         V_JOBID HR.EMPLOYEES.JOB_ID%TYPE;
       BEGIN
         SELECT A.EMPLOYEE_ID, A.EMP_NAME, A.HIRE_DATE, A.JOB_ID
           INTO V_EID, V_NAME, V_HIRE, V_JOBID
           FROM (SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, JOB_ID
                   FROM HR.EMPLOYEES
                  WHERE DEPARTMENT_ID = TO_NUMBER('&P_DID')
                  ORDER BY 3) A
          WHERE ROWNUM = 1; -- �������� �ϳ��� �����͸� ������ �� ����
          
          DBMS_OUTPUT.PUT_LINE('�����ȣ : '||V_EID); -- �ڹ��� PACKAGE��� ����, �����ϴ� API�� ����ϰڴٴ� �ǹ�
          DBMS_OUTPUT.PUT_LINE('����� : '||V_NAME); -- PUT_LINE�� ����ϰ� ���� �ٲ���
          DBMS_OUTPUT.PUT_LINE('�Ի��� : '||V_HIRE); -- �ڹ��� SYSTEM.OUT.PRINTLN�� ���� ������ ���
          DBMS_OUTPUT.PUT_LINE('��å�ڵ� : '||V_JOBID); -- ()���� �μ��ϰ��� �ϴ� ������ ����
          
          EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('���ܹ߻� : '||SQLERRM);
       END;
       
    1) ������ ��� -- ����� ������ �� �� �ѹ� ������ ������ �����ϰ�, �������� �������� ������ �����, ����(Left-Value�ڸ�)�� �� �� ����
      . ����ο��� ����� ������ ���
      . SCLAR ���� : �ϳ��� �����͸� �����ϴ� ���� -- �� ������ �ϳ��� �����͸� ���� ����
        - REFERENCE ����(������ ����) : ������ ���̺� �����ϴ� �÷��� Ÿ�԰� ũ�⸦ �����ϴ� ����
        - COMPOISTE ����(�迭 ����) : PL/SQL���� ����ϴ� �迭 ����(RECORD TYPE - �� ���� �ٷ�, TABLE TYPE - �� ���̺��� �ٷ�)
        - BIND ���� : �Ķ���ͷ� �Ѱ����� IN(�ڷḦ �ۿ��� �Ѱܹ����� ���), OUT(�� ��⿡�� ó���� ����� ������ �������� ���)���� ���Ǵ� ����,
                     ���ϰ��� �����ϱ� ���� ���Ǵ� ����
      (�������)
        ������[CONSTANT] ������Ÿ��[(ũ��)]|���̺��.�÷���%TYPE|���̺��%ROWTYPE[:=�ʱⰪ];
        - 'CONSTANT' : ��� ����
        - '���̺��.�÷���%TYPE|���̺��%ROWTYPE' : ����Ÿ��, ROWTYPE�� �� �� ��ü�� ���
        - ������ ������ ��쿡�� �ݵ�� �ʱ�ȭ�� �ؾ���, �ʱ�ȭ���� ������ ��Ÿ�� ���� �߻�
        - ������Ÿ�� : SQL���� ����ϴ� ������ Ÿ��
          . BINARY_INTEGER, PLS_INTEGER : -2147483648 ~ 2147483647 ������ ������ ���
          . BOOLEAN : true, false, null�� ����ϴ� ���� ����(�ڹٿʹ� �޸� null�� �����),
                      ǥ��SQL������ ����� �� ��������, PL/SQL������ ��밡��,
                      ���������� ��밡��
                      
    2) �б���
      . ���α׷��� ���� ������ �����ϴ� ���
      . IF, CASE WHEN ���� ������
      (1) IF ��
        - ���߾���� IF ���� ������ ����� ������
        -- {}�� ������ ������ �� ���� ������ IF���� ������ END IF;�� �ٿ������
        -- ������ ()�� ���, ���� �ʾƵ� ��
        -- ELSIF������ E�� ������, ELSE������ E�� ������
        (������� - 01)
          IF ���� THEN
             ���1;
         [ELSE
             ���2;]
          END IF;
          
        (������� - 02)
          IF ���� THEN
             ���1;
          ELSIF ���� THEN
             ���2;]
               :
          ELSE
             ���n;
          END IF;          
          
        (������� - 03) -- ������ ���� �鿩����� ����⸦ ö���� �ؾ���
          IF ���� THEN
             ���1;
             IF ���� THEN
                ���2;
             ELSE
                ���3;
             END IF; -- ������ IF���� ���Ḧ ���� END IF;�� �ݵ�� �ٿ������
          ELSE
             ���n;
          END IF;

��뿹) ������ ���� �Է¹޾� ¦������ Ȧ���� �Ǻ��Ͻÿ�.
       ACCEPT P_NUM PROMPT '�� �Է� : '
       DECLARE
         V_NUM NUMBER := TO_NUMBER('&P_NUM'); -- ':='�� ���Կ�����, '&'�� �ּҰ� �ƴ� ������ �����϶�� ��
         V_RES VARCHAR2(100);
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
         V_RES VARCHAR2(100);
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
         V_RES VARCHAR2(100);
         
         CURSOR CUR_MEM01 IS -- ���̺��� �ڷḦ �� �྿ ����
           SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
             FROM MEMBER;
       BEGIN
         OPEN CUR_MEM01;
         LOOP
           FETCH CUR_MEM01 INTO V_MID, V_NAME, V_MILE; -- FETCH : Ŀ���� �ִ� �ڷḦ �о�ͼ� ���� �����
           EXIT WHEN CUR_MEM01%NOTFOUND; -- CURSOR�� ����ִ� �ڷᰡ �ϳ��� ������ Ż����
           IF V_MILE >= 5000 THEN
              V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'VIPȸ��';
           ELSIF V_MILE >= 3000 THEN
              V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'��ȸ��';
           ELSE
              V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'��ȸ��';
           END IF;
           DBMS_OUTPUT.PUT_LINE(V_RES);
           DBMS_OUTPUT.PUT_LINE('===========================');
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
       ACCEPT P_NUM PROMPT '��뷮(��)'
       DECLARE
         V_NUM NUMBER := TO_NUMBER('&P_NUM');
         V_RES VARCHAR2(100);
       BEGIN
         IF V_NUM <= 10 THEN
           V_RES := TO_CHAR((V_NUM * 275) + (V_NUM * 120));
         ELSIF V_NUM BETWEEN 11 AND 20 THEN
           V_RES := TO_CHAR((10 * 275) + ((V_NUM - 10) * 305) + (V_NUM * 120));
         ELSIF V_NUM BETWEEN 21 AND 30 THEN
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + ((V_NUM - 20) * 350) + (V_NUM * 120));
         ELSIF V_NUM BETWEEN 31 AND 40 THEN
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (10 * 350) + ((V_NUM - 30) * 415) + (V_NUM * 120));
         ELSE
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (10 * 350) + (10 * 415) + ((V_NUM - 40) * 500) + (V_NUM * 120));
         END IF;
         
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
       
       COMMIT;