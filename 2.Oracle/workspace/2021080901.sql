2021-0809-01)

��뿹) ������̺��� �����ȣ 125��(Julia Nayer) ����� ������ 'ST_CLERK'���� 'ST_MAN'���� �����Ǿ���.
       �� ������ ������̺� �ݿ��ϰ� �� �� �������� ���̺��� �����Ͻÿ�.
       -- �����ڵ�, ����, �̷� ���̺� ����
       -- HR�������� �۵���
       (����� Ʈ����)
       CREATE OR REPLACE TRIGGER TG_JOB_CHANGE
         AFTER UPDATE ON EMPLOYEES
         FOR EACH ROW
       DECLARE
         V_EID EMPLOYEES.EMPLOYEE_ID%TYPE := :OLD.EMPLOYEE_ID; -- OLD.EMPLOYEE_ID ��� 125�� �����ȣ�� �Է��ص� ��
         V_CNT NUMBER := 0; -- JOB_HISTORY�� �����ȣ 125���� �����ϳ� �Ǵ�
         V_SDATE DATE;
         V_EDATE DATE;
       BEGIN
         SELECT COUNT(*) INTO V_CNT
           FROM JOB_HISTORY
          WHERE EMPLOYEE_ID = 125;
         
         IF V_CNT = 0 THEN -- JOB_HISTORY�� ���� ����� ���� ���
           V_SDATE := :OLD.HIRE_DATE; -- �Ի����� �� ���� ������
           V_EDATE := SYSDATE - 1; -- ������ �Ϸ����� �� ���� ������
         ELSE -- JOB_HISTORY�� ���� ����� �ִ� ���
           SELECT A.END_DATE INTO V_SDATE
             FROM (SELECT START_DATE, END_DATE
                     FROM JOB_HISTORY
                    WHERE EMPLOYEE_ID = 125
                    ORDER BY 2 DESC) A
            WHERE ROWNUM = 1;
           V_SDATE := V_SDATE + 1;
           V_EDATE := SYSDATE - 1;
         END IF;
         INSERT INTO JOB_HISTORY
           VALUES(V_EID, V_SDATE, V_EDATE, :OLD.JOB_ID, :OLD.DEPARTMENT_ID);
       END;
       
       (����)
       DECLARE
       BEGIN
         UPDATE EMPLOYEES
            SET (SALARY, JOB_ID) = (SELECT A.MIN_SALARY, 'ST_MAN'
                                      FROM (SELECT MIN_SALARY
                                              FROM JOBS
                                             WHERE JOB_ID = 'ST_MAN') A)
          WHERE EMPLOYEE_ID = 125;
       END;