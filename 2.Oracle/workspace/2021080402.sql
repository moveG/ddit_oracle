2021-0804-02) ���� ���ν���(Stored Procedure)
    - ������ ����� Ư�������� ���� �����ϵ� ���
    - ó���ӵ��� ��� : ���ν��� ���� ��� ������ �ϳ��� Batch�� �ν��Ͽ� �ѹ��� �м� �� ����ȭ�� ��Ű�� �����Ŵ
    - ��Ʈ��ũ�� Traffic ���� : Client���� Server�� ������ SQL������ ������ �̸� �����ϰ� �־�,
      Client���� �ٷ��� SQL���� ��� ���ν��� �̸��� �Ű������� ����
    - ��ȯ���� ����
    -- �ڹ��� VOID Ÿ�� �޼����� �����ϸ��, SELECT ���� ����� �� ����
    -- �Ű����� : ���� �����ϴ� ���
    (�������)
      CREATE [OR REPLACE] PROCEDURE ���ν�����[( -- ���ν��� �̸��� ���� 'PROC_'�� ������
        �Ű����� [MODE] Ÿ�� [:=��][,
          :
        �Ű����� [MODE] Ÿ�� [:=��]])]
      IS|AS -- �� �κ��� DECLARE��� �����ϸ��
        ���𿵿�
      BEGIN
        ���࿵��
      END;
      . 'OR REPLACE' : ���� �̸��� ���ν����� �����ϸ� OVERWRITE, ������ ���Ӱ� ����
      . 'MODE' : �Ű������� ������ ��Ÿ���� IN(�Է¿�), OUT(��¿�), INOUT(����� ����)�� ����� �� ������ �����ϸ� IN���� ����
      . 'Ÿ��' : �Ű������� ������ Ÿ������ ũ�⸦ �������� ����

    (������� - ����)
      EXEC|EXECUTE ���ν�����[(�Ű�����)list];
      
      OR
      
      ���ν�����[(�Ű�����)list]; -- �͸����̳� �ٸ� PL/SQL��ü ������ �����

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