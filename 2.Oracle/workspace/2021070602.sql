2021-0706-02)SQL ����� ����
 1)Query
  . ���� �� ��ȸ
  . SELECT ��
  --SELECT * FROM ���̺��;
 2)DML(Data Manipulation Language:������ ���۾�)
  . INSERT, UPDATE, DELETE ��
  --UPDATE, DELETE: ���� �����Ͱ� �����ؾ� ��� ����
 3)DCL(Data Control Language:������ �����)
  . COMMIT, ROLLBACK, SAVEPOINT, GRANT
  --COMMIT: ����
  --ROLLBACK: �� ������ Ŀ���� ���·� �ǵ�����
  --SAVEPOINT: ��ġ �����ؼ� ����
  --GRANT: ���� �ο�
 4)DDL(Data Definition Language:������ ���Ǿ�)
  . CREATE, DROP, ALTER
  --CREATE: ����
  --DROP: ����
  --ALTER: ����

 (1) CREATE
  . ����Ŭ ��ü�� ����
  (�������)
  CREATE ��üŸ�� ��ü��;
   - ��üŸ�� : �����Ϸ� �ϴ� ��ü�� ������ USER, VIEW, INDEX, SYNONYM, TABLE... etc
   
  **���̺� �������
  CREATE TABLE ���̺��(
    �÷��� ������Ÿ��[(ũ��)] [NOT NULL] [DEFAULT ��][,]
    -- ���̺���� ������ ������ �� �ֵ��� ���, ������ �ܾ ���ٸ� TBL_�� �ٿ� ����
    -- NOT NULL: NULL�� ������� ����, �����͸� �Է������ ��
    -- DEFAULT ��: NULL ��� DEFAULT�� ���⸦ ���ϴ� ��
    -- , (�޸�): �ϳ� �̻��� �÷��� ���� ��� �ݵ�� �����Ѵ�
                     :
    �÷��� ������Ÿ��[(ũ��)] [NOT NULL] [DEFAULT ��][,]
    
   [CONSTRAINT �⺻Ű������ PRIMARY KEY(�÷���[,�÷���,...])][,]
   --CONSTRAINT: TABLE�� ����Ǵ� ��������
   --�⺻Ű������: �Ϲ������� PK_���̺������ ���
   --�ܷ�Ű������: �Ϲ������� FK_���̺��_���̺������ ���
   --����Ű: �÷���[,�÷���]���� �߰�
   [CONSTRAINT �ܷ�Ű������ FOREIGN KEY(�÷���[,�÷���,...])
     REFERENCES ���̺��(�÷���)][,]
     --REFERENCE"S" �������̺��� ���� �÷���
                         :
   [CONSTRAINT �ܷ�Ű������ FOREIGN KEY(�÷���[,�÷���,...])
     REFERENCES ���̺��(�÷���)]);
      
     . '������Ÿ��' : CHAR, VARCHAR2, DATE, NUMBER, CLOB, BLOB �� ���
     -- CLOB: ��뷮, ��������
     -- BLOB: 2�� Ÿ��
     -- ����Ŭ������ ��� ���ڸ� ���ڿ��� �ν�, �ٸ� �������̿� �������̸� ������
     -- �������̴� ������ ���̸� ��� ���, ������ ũ�⺸�� ū ���� �Է��ϸ� ������ ���
     -- �������̴� ����� ���� �ܿ��� �ݳ���
     . 'DEFAULT ��' : ����ڰ� ������ �Է½�(INSERT��) �����͸� ������� ���� ��� ����Ǵ� ��
     . '�⺻Ű������', '�ܷ�Ű������' : �⺻Ű �� �ܷ�Ű ������ �����ϱ� ���� �ο��� �ε��������� ������ �ĺ��� �̾�� ��
     . 'REFERENCES ���̺��(�÷���)' : �������̺��(�θ����̺��)�� �װ����� ���� �÷���
     -- �ĺ�����: �θ��� �⺻Ű
     -- ��ĺ�����: �θ��� ��⺻Ű
     -- *: �ֽ�Ʈ��, ALL ���δ�
     -- &: ���ۻ���, �׸���
     -- @: ��, ��� ǥ��
     -- |: ������ ��ȣ

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
       
       CREATE TABLE EMPLOYEE(
         EMP_ID     CHAR(4) NOT NULL,
         EMP_NAME   VARCHAR2(30) NOT NULL,
         E_ADDR     VARCHAR2(80),
         E_TEL      VARCHAR2(20),
         E_POSITION VARCHAR2(30),
         E_DEPT     VARCHAR2(50),
         CONSTRAINT PK_EMPLOYEE PRIMARY KEY(EMP_ID));

--������: Block + Ctrl + Enter

COMMIT;

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
       
       CREATE TABLE SITE(
         SITE_ID   CHAR(4),
         SITE_NAME VARCHAR2(30) NOT NULL,
         SITE_ADDR VARCHAR2(80),
         REMARKS   VARCHAR2(255),
         CONSTRAINT PK_SITE PRIMARY KEY(SITE_ID));

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
     
       CREATE TABLE WORK(
         EMP_ID     CHAR(4) NOT NULL,
         SITE_ID    CHAR(4) NOT NULL,
         INPUT_DATE DATE,
         CONSTRAINT PK_WORK PRIMARY KEY(EMP_ID, SITE_ID),
         CONSTRAINT FK_WORK_EMP FOREIGN KEY(EMP_ID)
          REFERENCES EMPLOYEE(EMP_ID),
         CONSTRAINT FK_WORK_SITE FOREIGN KEY(SITE_ID)
          REFERENCES SITE(SITE_ID));
          