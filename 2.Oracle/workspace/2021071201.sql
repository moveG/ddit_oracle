2021-0712-01) ������ Ÿ��
 - ����Ŭ���� ���Ǵ� ������ Ÿ���� ���ڿ�, ����, ��¥, 2���ڷ����� ����
  1. ���ڿ� �ڷ�
   - ����Ŭ�� ���ڿ��� ''(����ǥ)�� ���� ǥ��
   - ��������(CHAR) Ÿ�԰�, ��������(VARCHAR, VARCHAR2, LONG, NVARCHAR2, CLOB) Ÿ������ ����
   - ����, ����, Ư������(����, ����ǥ ��)�� 1BYTE�� �ѱ�(�ʼ�, �߼�, ����)�� 3BYTE�� ǥ��
   -- ����ŬSQL������ ���ڿ�('')�� �����ϰ� ��ҹ��� ������ ���� ����
   -- �������� Ÿ�� : ���� ���̸� �����ϰ� �ݳ���
   -- ����Ŭ������ VARCHAR���� VARCHAR2 ����� ������
   -- LONG : ����� ���������� ���񽺴� �ߴܵ� (�ڹ��� LONG: ���� Ÿ�� / ����Ŭ�� LONG: ���ڿ� Ÿ��)
   -- 'N'VARCHAR2 : ������ ������ BYTE�� �ƴ϶�, ������ ����
   -- �������� Ÿ�Կ��� ���̸� �����ϴ� ����: ���� �������̸� ����� ���� ����
   1) CHAR
    . ���ǵ� ũ���� �������� �ڷḦ �����ϰ� ���� ������ �������� ä��
    . �����ʹ� MSB���� LSB������ ���� (���ʺ��� ä��)
    -- MSB : ���� ��ȭũ�Ⱑ ū BIT (+ , -)
    -- LSB : ���� ��ȭũ�Ⱑ ���� BIT (2^0�ڸ�)
   (�������)
    �÷��� CHAR(ũ�� [BYTE|CHAR]);
     - �ִ� 2000BYTE ���� ���� ����
     - 'BYTE|CHAR' : �����ϸ� BYTE�� ��޵Ǹ�, 'CHAR'�� ���Ǹ� 'ũ��'�� ���ڼ��� ��Ÿ��. �ٸ�, CHAR�� ����ص� 2000BYTE�� �ʰ��� �� ����
     - �ַ� ���̰� ������ �÷��̳� �⺻Ű �÷��� ������ Ÿ������ ��� (EX)�ֹι�ȣ)
     
��뿹) 
       CREATE TABLE T_CHAR(
        COL1 CHAR(20),
        COL2 CHAR(20 CHAR),
        COL3 CHAR(20 BYTE));
       
       INSERT INTO T_CHAR(COL1, COL2, COL3)
        VALUES('����ȭ ���� ��', '����ȭ ���� ��', '����ȭ');
       
       SELECT * FROM T_CHAR;
       
       SELECT LENGTHB(COL1), LENGTHB(COL2), LENGTHB(COL3)
         FROM T_CHAR;
       
       INSERT INTO T_CHAR(COL1, COL2, COL3)
        VALUES('����ȭ ���� ��', '����ȭ ���� �Ǿ����ϴ�', '����ȭ');
       
       -- LENGTHB : �÷��� ���̸� BYTE�� ǥ���ϴ� �Լ�
       -- COL2 : '����ȭ ���� ��'�� 8���� ���(20 BYTE) + 12���� ����(12BYTE - ������ ����) = 32BYTE
       
    2) VARCHAR2
     . �������� �ڷ� ���忡 �̿�
    (�������)
     �÷��� VARCHAR2(ũ��[BYTE|CHAR])
      - �ִ� 4000BYTE���� ���� ����
      - ����ڰ� ������ �����͸�ŭ ����ϰ� ���� ������ SYSTEM�� ��ȯ
       
��뿹) 
       CREATE TABLE T_VARCHAR2(
         COL1 VARCHAR(500),
         COL2 VARCHAR(50 CHAR),
         COL3 VARCHAR(50 BYTE));
         
       INSERT INTO T_VARCHAR2
        VALUES('IL POSTONO', '�ʸ� ���ͷ�', '���ø� Ʈ���̽�');
        
       INSERT INTO T_VARCHAR2
        VALUES('PERSIMON BANNA APPLE', 'PERSIMON BANNA', 'PERSIMON');   
       
       SELECT * FROM T_VARCHAR2;
       
       SELECT LENGTHB(COL1), LENGTHB(COL2), LENGTHB(COL3)
         FROM T_VARCHAR2;
         
    3) VARCHAR, NVARCHAR, NVARCHAR2
     . �⺻������ NVARCHAR2�� �������� ������
     . NVARCHAR, NVARCHAR2�� UTF-8(��������), UTP-16(��������) ����� �ڵ�� ��ȯ�Ͽ� �ڷḦ ������(����ǥ���ڵ� ����)
    
    4) LONG
     . �������� �ڷḦ ����
    (�������)
     �÷��� LONG
      - �ִ� 2GB���� ���� ����
      - �� ���̺� �ϳ��� Į���� ��밡��(�������)
      - CLOB�� ��ü��
      - ���ڿ� �Լ�(LENGTH, LENGTHB, SUBSTR ��) ����� ���ѵ�
       
��뿹) 
       CREATE TABLE T_LONG(
         COL1 VARCHAR(100),
         COL2 LONG,
         COL3 CHAR(100));
         
       INSERT INTO T_LONG
        VALUES('PERSIMON BANNA APPLE', 'PERSIMON BANNA', 'PERSIMON');
      
       SELECT * FROM T_LONG;
         
       SELECT COL1, COL2, TRIM(COL3) FROM T_LONG;
       
       SELECT LENGTHB(COL1), LENGTHB(TRIM(COL2, 1, 3)), LENGTHB(COL3)
         FROM T_LONG;
       -- ���� �߻�  

    5) CLOB(Char Large OBject)
     . �������� �ڷḦ ����
    (�������)
     �÷��� CLOB
      - �ִ� 4GB���� ���� ����
      - ���� �÷��� �ϳ��� ���̺� ���� ����
      - �Ϻ� ����� DBMS_LOB API�� ������ �޾ƾ� ��� ����(LENGTH, SUBSTR ��)
     
��뿹) 
       CREATE TABLE T_CLOB(
         COL1 CLOB,
         COL2 CLOB,
         COL3 VARCHAR2(4000),
         COL4 LONG);
       
       INSERT INTO T_CLOB(COL1, COL2, COL4)
        VALUES('������ �߱� ���ﵿ ���κ���', '������ �߱� ���ﵿ ���κ���', '������ �߱� ���ﵿ ���κ���');
       
       SELECT * FROM T_CLOB;
       
       SELECT DBMS_LOB.GETLENGTH(COL1),
           -- DBMS_LOB.GETLENGTHB(COL2), -- LENGTH'B'�� �������� ����(���� ������ ���� �����ϴ� �����̹Ƿ�)
              SUBSTR(COL1, 5, 6),
              DBMS_LOB.SUBSTR(COL1, 5, 6)
           -- LOB������ �Ű����� ��ġ�� �ٲ�(EX) 5��°���� 6���ڰ�, 6��°���� 5���ڷ� �ٲ�)
         FROM T_CLOB;
       
       -- SUBSTR �ڹ� ����Ŭ ����
       -- ABCDEFG��� ���ڿ��� �ڸ� ��
       -- �ڹ� : SUBSTRING(2, 4)�� �ϸ� "CD"�� ����� ����.
       -- ����ŬSQL : SUBSTR(2, 4)�� �ϸ� 'CDEF'�� ����� ����.

  2. ���� �ڷ�
   - NUMBER Ÿ���� ����
   (�������)
    �÷��� NUMBER[(���е�|*[, ������])]
     . ������� : 1.0 * 10^-130 ~ 9.999...9 * 10^125
     . ���е� : ��ü �ڸ���(1 ~ 30)
     . ������(���) : �Ҽ��� ������ �ڸ���
       ������(����) : ���� �κ��� �ڸ���
     . 20 BYTE�� ǥ��
      
     EX) NUMBER, NUMBER(10), NUMBER(10, 2), NUMBER(*, 2), ...
     -----------------------------------------------
         �Է°�         ����              ���Ǵ� ��
     -----------------------------------------------
      123456.6789    NUMBER            123456.6789
      123456.6789    NUMBER(10)        123457
      123456.6789    NUMBER(7, 2)      ����       -- 7�� ��ü �ڸ��� / 2�� �Ҽ��� �Ʒ� �ڸ��� / ������ 5�ڸ��� �Ҵ������ 6�ڸ��� ���� �߻�
      123456.6789    NUMBER(*, 2)      123456.68 -- *�� AUTO / 2�� �Ҽ��� �Ʒ� �ڸ���
      123456.6789    NUMBER(10, -2)    123500    -- 10�� ��ü �ڸ��� / -2�� ���� �κ��� �ڸ��� / 10�� �ڸ����� �ݿø� �߻�
     -----------------------------------------------  
       
��뿹) 
       CREATE TABLE T_NUMBER(
         COL1 NUMBER,
         COL2 NUMBER(10), -- �ڵ� ��ȯ�Ǿ� (10, 0)���� ����ȴ�.
         COL3 NUMBER(7, 2),
         COL4 NUMBER(*, 2), -- *�� �ִ밪�� 38
         COL5 NUMBER(10, -2));
         
       INSERT INTO T_NUMBER VALUES(123456.6789, 123456.6789, 123456.6789, 123456.6789, 123456.6789); -- ���� �߻�
       
       INSERT INTO T_NUMBER(COL1) VALUES(123456.6789);
       INSERT INTO T_NUMBER(COL2) VALUES(123456.6789);
    -- INSERT INTO T_NUMBER(COL3) VALUES(123456.6789); ���� �߻�
       INSERT INTO T_NUMBER(COL3) VALUES(12345.6789);
       INSERT INTO T_NUMBER(COL4) VALUES(123456.6789);
       INSERT INTO T_NUMBER(COL5) VALUES(123456.6789);
       
       SELECT * FROM T_NUMBER;
       
    ** ������ > ���е� -- �ſ� ����� ���
       . ������ : �Ҽ��� ������ ������ ��
       . ������ - ���е� : �Ҽ��� ���Ͽ� �����ؾ��� 0�� ����
       . ���е� : �Ҽ��� ������ 0�� �ƴ� �ڷ��
       
       EX)
       -----------------------------------------------------------
           �Է°�      ����           ���Ǵ� ��
       -----------------------------------------------------------       
        1.234       NUMBER(4, 5)    ����(���� �κп� 0�� �ƴ� �� ����)
        0.23        NUMBER(3, 5)    ����(0.00���� ����)
        0.0023      NUMBER(3, 5)    ����(��ȿ ���ڰ� ����)
        0.0023      NUMBER(2, 4)    0.0023
        0.012345    NUMBER(3, 4)    0.0123
        0.012356    NUMBER(3, 4)    0.0124
       ----------------------------------------------------------- 
       
       COMMIT;