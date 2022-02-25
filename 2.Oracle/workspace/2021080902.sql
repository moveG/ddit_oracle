2021-0809-02) PACKAGE
    - ���� �������� �ִ� PL/SQL�� ����, ���Ŀ��, �������α׷�(�Լ�, ���ν���)���� �׸��� ������� ��ü
    - �ٸ� ��ü���� ��Ű�� �׸���� �����ϰ� ������
    - ���ȭ ����� ������
    - ���α׷� ������ ���̼��� ������
    - ĸ��ȭ ����� ������
    - ����ο� �����η� ������
    
  1. ��Ű�� �����
    - ��Ű������ ����� ����, ��� �Լ� ���� ���𿵿�(��)
    (�������)
      CREATE [OR REPLACE] PACKAGE ��Ű���� IS
        ����, ���, Ŀ�� ����;
        FUNCTION �Լ���[(�Ű����� list)]
          RETURN ��ȯŸ��;
                    :
       PROCEDURE ���ν�����(�Ű����� list);
                    :
      END ��Ű����;
      
  2. ��Ű�� ������
    - ����ο��� ����� PL/SQL��ü���� ���������� �����
    (�������)
      CREATE [OR REPLACE] PACKAGE BODY ��Ű���� IS
        ������ Ÿ��;
        ����� CONSTANT Ÿ��;
        Ŀ�� ����;
        
        FUNCTION �Լ���[(�Ű����� list)]
          RETURN Ÿ��
        IS
          �����;
        BEGIN
          �����;
          RETURN expr;
        END �Լ���; -- �Լ����� ������ ����������, END�� ������ �����Ƿ� ������ ���� �Լ����� ������ִ� ���� ����
                     :
        PROCEDURE ���ν�����[(�Ű����� list)]
        IS
          �����;
        BEGIN
          �����;
        END ���ν�����; -- ���ν������� ������ ����������, ������ ���� �Լ����� ������ִ� ���� ����
      END ��Ű����;
      
  ** ��� ���̺� �������� �÷��� �߰��Ͻÿ�.
     -- HR�������� �۵���
     �÷���           Ÿ��           NULL ����
     RETIRE_DATE     DATE -- �Ի��ϸ鼭 �������ڸ� ���س����� �ʱ� ������ NULL�� ����ؾ���(NULL �����̸� �ٹ���)
     
     ALTER TABLE EMPLOYEES
       ADD RETIRE_DATE DATE ;
     
     COMMIT;

��뿹) ��������� �ʿ��� �Լ� ���� ����
       - ��Ű���� : PKG_EMP
       - FN_GET_NAME : �����ȣ�� �Է¹޾� �̸��� ��ȯ�ϴ� �Լ�
       - PROC_NEW_EMP : �űԻ������ �Է� ���ν���(�����ȣ, LAST_NAME, �̸���, �Ի���, JOB_ID)
                                              -- NOT NULL�׸��̶� �ݵ�� �Է��ؾ���
       - PROC_RETIRE_EMP : ������ó�� ���ν���
       (��Ű�� �����)
       CREATE OR REPLACE PACKAGE PKG_EMP
       IS
         -- �����ȣ�� �Է¹޾� �̸��� ��ȯ�ϴ� �Լ�
         FUNCTION FN_GET_NAME( -- �Լ��� �����ϴ� �����
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE) -- �����ȣ�� �Է¹��� ����
           RETURN VARCHAR2;
         
         -- �űԻ������ �Է� ���ν���
         PROCEDURE PROC_NEW_EMP(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
           P_LNAME IN EMPLOYEES.LAST_NAME%TYPE,
           P_EMAIL IN EMPLOYEES.EMAIL%TYPE,
           -- �Ի����� ���ó�¥�̶� ���� ���⿡ �Է��� ������ ��� ������
           P_JOB_ID IN JOBS.JOB_ID%TYPE);
           
         -- ������ó�� ���ν���
         PROCEDURE PROC_RETIRE_EM(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE);
       END PKG_EMP;
       -- ������ ���� ����� �����ε� �������� ������
       
       (��Ű�� ������)
       CREATE OR REPLACE PACKAGE BODY PKG_EMP -- �����ο��� BODY�� �ٿ������
       IS
         FUNCTION FN_GET_NAME(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE)
           RETURN VARCHAR2
         IS
           V_ENAME EMPLOYEES.EMP_NAME%TYPE;
         BEGIN
           SELECT EMP_NAME INTO V_ENAME
             FROM EMPLOYEES
            WHERE EMPLOYEE_ID = P_EID;
           RETURN V_ENAME;
         END FN_GET_NAME;
       
         PROCEDURE PROC_NEW_EMP(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
           P_LNAME IN EMPLOYEES.LAST_NAME%TYPE,
           P_EMAIL IN EMPLOYEES.EMAIL%TYPE,
           P_JOB_ID IN JOBS.JOB_ID%TYPE)
         IS
         BEGIN
           INSERT INTO EMPLOYEES(EMPLOYEE_ID, LAST_NAME, EMAIL, JOB_ID, HIRE_DATE, EMP_NAME)
             VALUES(P_EID, P_LNAME, P_EMAIL, P_JOB_ID, SYSDATE - 1, P_LNAME||'�浿');
           COMMIT; -- Ʈ���ſ����� COMMIT�� ������� ��������, ���ν����� �Լ������� ����� �� ����
         END PROC_NEW_EMP;
         
         PROCEDURE PROC_RETIRE_EM(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE)
         IS
         BEGIN
           UPDATE EMPLOYEES
              SET RETIRE_DATE = SYSDATE
            WHERE EMPLOYEE_ID = P_EID;
           COMMIT;
         END PROC_RETIRE_EM;
       END PKG_EMP;
       
       (��Ű�� ����)
       SELECT PKG_EMP.FN_GET_NAME(EMPLOYEE_ID)
         FROM EMPLOYEES
        WHERE DEPARTMENT_ID = 60; 
       
       EXECUTE PKG_EMP.PROC_NEW_EMP(250, 'ȫ', 'gdhong@gmail.com', 'FI_ACCOUNT');
       
       EXEC PKG_EMP.PROC_RETIRE_EM(150);