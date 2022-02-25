2021-0803-01)
      (2) CASE ��
        - ǥ�� SQL�� SELECT ���� ���Ǵ� CASE ǥ���İ� ������
        - ���� �б� ��� ����
        -- ��� CASE���� IF������ ��ȯ�� ����������, IF���� ��� CASE������ ��ȯ�ϴ� ���� �Ұ�����
        -- JAVA�� Switch-Case�� �޸� break�� �ʿ����
        (������� - 01)
          CASE ����|���� WHEN ��1 THEN
                            ���1;
                       WHEN ��2 THEN
                            ���2;
                             :
                       ELSE ���n;
          END CASE;
          
        (������� - 02)
          CASE WHEN ����1 THEN
                    ���1;
               WHEN ����2 THEN
                    ���2;
                     :
               ELSE ���n;
          END CASE;
          
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
          
    3) �ݺ���
      . ����Ŭ�� �ݺ����� LOOP, WHILE, FOR ���� ������
      (1) LOOP ��
        - �ݺ����� �⺻ ����
        (�������)
          LOOP
            �ݺ�ó����ɹ�(��);
            [EXIT WHEN ����;]
          END LOOP;
          . �⺻������ ���ѷ���
          . 'EXIT WHEN ����' : ������ ��(true)�̸� �ݺ��� ���(END LOOP �������� ���� �̵�)
          -- FOR��, WHILE�� ���ο� LOOP���� ������
          -- EXIT�� JAVA�� Break�� ������
          
��뿹) �������� 7���� ����ϴ� ����� �ۼ��Ͻÿ�.
       DECLARE
         V_CNT NUMBER := 1; -- ���ں����� �ݵ�� �ʱⰪ�� �����������, �׷��� ������ �����ɶ� NULL���� �����ǹǷ� ������ �߻���
         V_RES NUMBER := 0;
       BEGIN
         LOOP
           V_RES := V_CNT * 7;
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

      (2) WHILE ��
        - ���߾���� WHILE���� ���� ��� �� ����
        (�������)
          WHILE ���� LOOP
            �ݺ�ó����ɹ�(��);
            [EXIT WHEN ����;]
          END LOOP;
          . '����'�� ���̸� �ݺ� ����
          
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
       
       COMMIT;