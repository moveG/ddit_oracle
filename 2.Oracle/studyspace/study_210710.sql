��뿹) ���������� �����ڷ� 97�� �� ERD�� �����Ͽ� ���, �����, ���������, �ٹ� ���̺��� �����Ͻÿ�.
       [��� ���̺�]
       1)���̺�� : EMPLOYEE
       2)�÷�
       ---------------------------------------------
       �÷���      ������Ÿ��(ũ��)      N.N      PK/FK
       ---------------------------------------------
       EMP_ID     CHAR(4)            N.N        PK
       EMP_NAME   VARCHAR2(30)       N.N
       E_ADDR     VARCHAR2(80)
       E_TEL      VARCHAR2(20)
       E_POSITION VARCHAR2(30)
       E_DEPT     VARCHAR2(50)
       ---------------------------------------------
       CREATE TABLE EMPLOYEE (
         EMP_ID     CHAR(4)      NOT NULL,
         EMP_NAMEE  VARCHAR2(30) NOT NULL,
         E_ADDR     VARCHAR2(80),
         E_TEL      VARCHAR2(20),
         E_POSITION VARCHAR2(30),
         E_DEPT     VARCHAR2(50),
         CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EMP_ID));
  
��뿹) 
       [����� ���̺�]
       1)���̺�� : SITE
       2)�÷�
       ---------------------------------------------
       �÷���      ������Ÿ��(ũ��)      N.N      PK/FK
       ---------------------------------------------
       SITE_ID    CHAR(4)                      PK
       SITE_NAME  VARCHAR2(30)       N.N
       SITE_ADDR  VARCHAR2(80)
       REMARKS    VARCHAR2(255)
       ---------------------------------------------
       -- PK(�⺻Ű)�� �ߺ������� ���� �ڵ����� NOT NULL�� �ο���       
       CREATE TABLE SITE (
         SITE_ID   CHAR(4),
         SITE_NAME VARCHAR(30) NOT NULL,
         SITE_ADDR VARCHAR(80),
         REMARKS   VARCHAR2(255),
         CONSTRAINT PK_SITE PRIMARY KEY (SITE_ID));
       
��뿹) 
       [�ٹ� ���̺�]
       1)���̺�� : WORK
       2)�÷�
       ---------------------------------------------
       �÷���      ������Ÿ��(ũ��)      N.N      PK/FK
       ---------------------------------------------
       EMP_ID     CHAR(4)            N.N     PK % FK
       SITE_ID    CHAR(4)            N.N     PK % FK
       INPUT_DATE DATE
       ---------------------------------------------       
       CREATE TABLE WORK (
         EMP_ID     CHAR(4) NOT NULL,
         SITE_ID    CHAR(4) NOT NULL,
         INPUT_DATE DATE,
         CONSTRAINT PK_WORK PRIMARY KEY (EMP_ID, SITE_ID),
         CONSTRAINT FK_WORK_EMP FOREIGN KEY(EMP_ID)
           REFERENCES EMPLOYEE(EMP_ID),
         CONSTRAINT FK_WORK_SITE FOREIGN KEY(SITE_ID)
           REFERENCES SITE(SITE_ID));
       
��뿹) ��� ���̺�(EMPLOYEE)�� ���� �ڷḦ �Է��Ͻÿ�.
       -----------------------------------------------------------------------------------
       �����ȣ    �̸�       �ּ�                   ��ȭ��ȣ          ����        �μ�
       -----------------------------------------------------------------------------------
       A101      ȫ�浿      ������ �߱� ���ﵿ      042-222-8202      ���      ���� ���ߺ�
       A104      ������                                             �븮      ���������
       A105      �̼���                                             ����
       -----------------------------------------------------------------------------------
       INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, E_ADDR, E_TEL, E_POSITION, E_DEPT)
         VALUES ('A101', 'ȫ�浿', '������ �߱� ���ﵿ', '042-222-8202', '���', '���� ���ߺ�');
       INSERT INTO EMPLOYEE
         VALUES ('A104', '������', '', '', '�븮', '���������');
       INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, E_POSITION)
         VALUES ('A105', '�̼���', '����');
         
��뿹) ����� ���̺�(SITE)�� ���� �ڷḦ �Է��Ͻÿ�.
       -----------------------------------------------------------------------------------
       ������ȣ       ������                �ּ�                   ���
       -----------------------------------------------------------------------------------
       S100      �����ʵ��б���������      ������ �߱� ���ﵿ
       S200      �ǹ� ����
       -----------------------------------------------------------------------------------         
       INSERT INTO WORK (SITE_ID, SITE_NAME, SITE_ADDR)
         VALUES ('S100', '�����ʵ��б���������', '������ �߱� ���ﵿ');
       INSERT INTO
         VALUES ('S200', '�ǹ�����', NULL, '');
       
��뿹) �ٹ� ���̺�(WORK)�� ���� �ڷḦ �Է��Ͻÿ�.
       (1) ȫ�浿 ����� ���úη� 'S200' ����忡�� �ٹ�       
       INSERT INTO WORK VALUES ('A101', 'S200', SYSDATE);
       (2) �̼��� ������ 2020�� 10�� 01�Ϻ��� 'S200' ����忡�� �ٹ�
       INSERT INTO WORK VALUES ('A105', 'S200', TO_DATE('20201001');
       (3) ������ �븮�� 'S100' ����忡�� �ٹ�
       INSERT INTO WORK (EMP_ID, SITE_ID) VALUES ('A104', 'S100');
       
��뿹) S200�� �ٹ��ϴ� ��������� ��ȸ�Ͻÿ�.
       Alias�� ������, �����ȣ, �����, ����, ��ȭ��ȣ�̴�.      
       SELECT A.SITE_NAME AS ������,
              B.EMP_ID AS �����ȣ,
              B.EMP_NAME AS �����,
              B.E_POSITION AS ����,
              B.E_TEL AS ��ȭ��ȣ
         FROM SITE A, EMPLOYEE B, WORK C
        WHERE A.SITE_ID=C.SITE_ID
          AND A.EMP_ID=C.EMP_ID
          AND A.SITE_ID=UPPER('S200');
       
��뿹) ��� ���̺��� 'A101' ��������� �����Ͻÿ�.
       DELETE EMPLOYEE
        WHERE UPPER(EMP_ID)='A101'
       -- ROLLBACK ����

��뿹) EMPLOYEE ���̺� ����
       DROP TABLE WORK;
       DROP TABLE EMPLOYEE;
       DROP TABLE SITE;
       -- ROLLBACK �Ұ���
       
��뿹) ȸ�����̺�(MEMBER)�� �ֹι�ȣ(MEM_REG01)�� ����Ͽ� ȸ���� ���̸� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �ֹι�ȣ, ����
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ,
              EXTRACT(YEAR FROM SYSDATE)-(TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))+1900) AS ����
         FROM MEMBER;

-- �ڹٴ� ���ڿ��� �ֿ켱 EX) "75" + 20 -> "75" + "20" -> 7520
-- ����Ŭ�� ���ڰ� �ֿ켱 EX) "75" + 20 ->   75 + 20   -> 95

��뿹) HR������ ������̺��� ���ʽ��� ����Ͽ� �޿��� ���޾��� ��ȸ�Ͻÿ�.
       ���ʽ� = �޿� * ���������ڵ�(COMMISSION_PCT)�� 35%
       ���޾� = �޿� + ���ʽ�
       ��� : �����ȣ, �����, �޿�, ���ʽ�, ���޾�
       SELECT EMPLOYEE_ID AS �����ȣ,
              FIRST_NAME||' '||LAST_NAME AS �����,
              SALARY AS �޿�,
              NVL(SALARY * COMMISSION_PCT * 0.35, 0) AS ���ʽ�,
              SALARY + NVL(SALARY * COMMISSION_PCT * 0.35, 0) AS ���޾�
       FROM HR.EMPLOYEES;
       
��뿹) ȸ�����̺��� ���ϸ����� 4000�̻��� ȸ���� ȸ����ȣ, ȸ����, ����, ���ϸ����� ��ȸ�Ͻÿ�.
       ���ϸ����� ���� ȸ������ ��ȸ�Ͻÿ�.
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE >= 200
        ORDER BY MEM_MILEAGE, 1 DESC;

��뿹) ȸ�����̺� ���� ����
 1) d001 ȸ���� �ֹι�ȣ 460409-2000000, ��������� 1946/04/09 ->
               �ֹι�ȣ 010409-4234765, ��������� 2001/04/09
 2) n001 ȸ���� �ֹι�ȣ 750323-1011014, ��������� 1975/03/23 ->
               �ֹι�ȣ 000323-3011014, ��������� 2000/03/23
 3) v001 ȸ���� �ֹι�ȣ 520131-2402712, ��������� 1952/01/31 ->
               �ֹι�ȣ 020131-4402712, ��������� 2002/01/31
 1) UPDATE MEMBER
       SET MEM_REGNO1 = '010409',
           MEM_REGNO2 = '4234765',
           MEM_BIR = TO_DATE('20010409')
     WHERE MEM_ID = 'd001';
       
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ,
           MEM_BIR AS �������
      FROM MEMBER
     WHERE MEM_ID = 'd001'
     
 2) UPDATE MEMBER
       SET MEM_REGNO1 = '000323',
           MEM_REGNO2 = '3011014',
           MEM_BIR = TO_DATE('20000323')
     WHERE MEM_ID = 'n001';
     
     SELECT MEM_ID AS ȸ����ȣ,
            MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ,
            MEM_BIR AS �������
       FROM MEMBER
      WHERE MEM_ID = 'n001';
      
 3) UPDATE MEMBER
       SET MEM_REGNO1 = '020131',
           MEM_REGNO2 = '4402712',
           MEM_BIR = TO_DATE('2002/01/31') -- /�� ���� ������Ʈ ����
     WHERE MEM_ID = 'v001';
    
    SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
      FROM MEMBER
     WHERE MEM_ID='v001';
     
 4) SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
      FROM MEMBER
     WHERE MEM_ID IN('d001', 'n001', 'v001');   

��뿹) ȸ�����̺��� ����ȸ�������� ��ȸ�Ͻÿ�.
       Alias ȸ����ȣ, ȸ����, �������, ���ϸ���, ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_BIR AS �������,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE SUBSTR(MEM_REGNO2,1,1) = '2'
           OR SUBSTR(MEM_REGNO2,1,1) = '4';

��뿹) ������̺��� ��ձ޿� �̻� �޿��� �޴� ����� ��ȸ�Ͻÿ�.
       Alias �� �����ȣ, �����, �޿�, �μ���ȣ
       SELECT EMPLOYEE_ID AS �����ȣ,
              FIRST_NAME AS �����,
              SALARY AS �޿�,
              DEPARTMENT_ID AS �μ���ȣ,
              ROUND((SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES), 0) AS ��ձ޿�
         FROM HR.EMPLOYEES
        WHERE NOT SALARY < (SELECT AVG(SALARY)
                              FROM HR.EMPLOYEES)
        ORDER BY DEPARTMENT_ID;
     
       SELECT * FROM HR.JOBS;
       
       -- �÷�
       -- ALTER TABLE
       --   ADD, DROP COLUMN, RENAME COLUMN, MODIFY
       
��뿹) ������̺��� FIRST_NAME�� LAST_NAME�� ���� EMP_NAME�׸��� �����ÿ�.      
 1) ������̺��� EMP_NAME VARCHAR2(80) �÷��� �߰��Ͻÿ�.
    ALTER TABLE HR.EMPLOYEES
      ADD(EMP_NAME VARCHAR2(80));
       
 3) FIRST_NAME�� LAST_NAME���� EMP_NAME�� �����Ͻÿ�.
    UPDATE HR.EMPLOYEES
       SET EMP_NAME = FIRST_NAME||' '||LAST_NAME;
       
��뿹) ������̺�(HR����)���� 10, 30, 40, 60�� �μ��� ���� ������� �����ȣ, �����, �μ��ڵ�, �Ի����� ��ȸ�Ͻÿ�.
       (OR ������ ���)       
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              DEPARTMENT_ID AS �μ��ڵ�,
              HIRE_DATE AS �Ի���
         FROM HR.EMPLOYEES
        WHERE DEPARTMENT_ID=10
           OR DEPARTMENT_ID=30
           OR DEPARTMENT_ID=40
           OR DEPARTMENT_ID=60
        ORDER BY 3;
        
       (IN ������ ���)       
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              DEPARTMENT_ID AS �μ��ڵ�,
              HIRE_DATE AS �Ի���
         FROM HR.EMPLOYEES
        WHERE DEPARTMENT_ID IN(10, 30, 40, 60)
        ORDER BY 3;
       
       (ANY(SOME) ������ ���)
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              DEPARTMENT_ID AS �μ��ڵ�,
              HIRE_DATE AS �Ի���
         FROM HR.EMPLOYEES
     -- WHERE DEPARTMENT_ID = ANY(10, 30, 40, 60)
        WHERE DEPARTMENT_ID = SOME(10, 30, 40, 60)
        ORDER BY 3;       
       
��뿹) ������̺�(HR����)���� 20, 40, 70�� �μ��� ���� ������� �޿����� �޿��� ���� ����� �����ȣ, �����, �޿�, �μ���ȣ�� ��ȸ�Ͻÿ�.
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              SALARY AS �޿�,
              DEPARTMENT_ID AS �μ���ȣ
         FROM HR.EMPLOYEES
        WHERE SALARY > ALL (SELECT SALARY
                              FROM HR.EMPLOYEES
                             WHERE DEPARTMENT_ID IN(20, 40, 70));
     -- WHERE SALARY > (SELECT MAX(SALARY)
     --                       FROM HR.EMPLOYEES
     --                      WHERE DEPARTMENT_ID IN(20, 40, 70));                                
       
��뿹) �����������̺�(BUYPROD)���� 2005�� 3�� ������Ȳ�� ����Ͻÿ�.
       Alias�� ��¥, ��ǰ�ڵ�, ���Լ���, ���Աݾ��̴�.       
       (AND ������ ���)       
       SELECT BUY_DATE AS ��¥,
              BUY_PROD AS ��ǰ�ڵ�,
              BUY_QTY AS ���Լ���,
              BUY_QTY * BUY_COST AS ���Աݾ�
         FROM BUYPROD
        WHERE BUY_DATE >= TO_DATE('20050301')
          AND BUY_DATE <= LAST_DAY(TO_DATE('20050301'));
          
       (BETWEEN ������ ���)
       SELECT BUY_DATE AS ��¥,
              BUY_PROD AS ��ǰ�ڵ�,
              BUY_QTY AS ���Լ���,
              BUY_QTY * BUY_COST AS ���Աݾ�
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050301') AND LAST_DAY(TO_DATE('20050301'));
       
��뿹) ȸ�����̺��� 40�� ȸ���� ȸ����ȣ, ȸ����, ���ϸ����� ��ȸ�Ͻÿ�.
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR) BETWEEN 40 AND 49;
       
��뿹) ȸ���� ������� �÷����� ���� �����Ͻÿ�.
       SELECT EXTRACT(MONTH FROM MEM_BIR),
              SUBSTR(MEM_BIR,6,2)
         FROM MEMBER;
         
��뿹) ȸ�����̺��� �̹����� ������ �ִ� ȸ����ȣ, ȸ������ ��ȸ�Ͻÿ�.
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����
         FROM MEMBER
        WHERE EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM MEM_BIR);
    --  WHERE EXTRACT(MONTH FROM SYSDATE) = SUBSTR(MEM_BIR,6,2); 
       
��뿹) �з��ڵ尡 P2�� �����ϴ� ��ǰ�� ���Ͽ� 2005�� 5�� �������(CART TABLE)�� ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �з��ڵ�, �з���, �Ǹż���, �ݾ��̴�.
       SELECT A.PID AS ��ǰ�ڵ�,
              A.PNAME AS ��ǰ��,
              LPROD_GU AS �з��ڵ�,
              LPROD_NM AS �з���,
              A.QAMT AS �Ǹż���,
              A.MAMT AS �ݾ�       
         FROM LPROD,(SELECT CART_PROD AS PID,
                            PROD_NAME AS PNAME,
                            SUM(CART_QTY) AS QAMT,
                            SUM(CART_QTY * PROD_PRICE) AS MAMT
                       FROM CART, PROD
                      WHERE CART_PROD = PROD_ID
                        AND CART_NO LIKE '200505%'
                        AND PROD_LGU BETWEEN 'P200' AND 'P299' -- ���ڿ��� BETWEEN ����
                      GROUP BY CART_PROD, PROD_NAME) A,
              PROD
        WHERE PROD_ID = A.PID
          AND PROD_LGU = LPROD_GU
        ORDER BY 1;
       
��뿹) ȸ�����̺��� ������ �����ϴ� ȸ������ ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �ּ�, ����, ���ϸ����̴�.
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '����%';   
        
��뿹) ��ٱ������̺��� 2005�� 7�� �Ǹ���Ȳ�� ��ȸ�Ͻÿ�.
       Alias�� ����, ��ǰ�ڵ�, �Ǹż����̴�.
       (LIKE ������ ���)
       SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS ����,
              CART_PROD AS ��ǰ�ڵ�,
              CART_QTY AS �Ǹż���
         FROM CART
        WHERE CART_NO LIKE '200507%';
       
       (BETWEEN ������ ���)
       SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS ����,
              CART_PROD AS ��ǰ�ڵ�,
              CART_QTY AS �Ǹż���
         FROM CART
        WHERE SUBSTR(CART_NO, 1, 6) BETWEEN TO_NUMBER('200506') AND TO_NUMBER('200507');
       
 commit;       