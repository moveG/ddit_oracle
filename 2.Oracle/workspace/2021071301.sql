2021-0713-01)
  3. ��¥ �ڷ� -- ��¥ �񱳴� LIKE(���ڿ�)���ٴ� BETWEEN�� ����ض�
   - DATE, TIMESTAMP Ÿ�� ����
   - ������ ������ ���
   1) DATE
    . �⺻ ��¥��
   (�������)
    �÷��� DATE; -- ���ǰ� ���� ������ 0���� �ʱ�ȭ
     - ��, ��, ��, ��, ��, �� ������ ���� �� ����
     - ��¥�� �ڷ��� ���� : �� ��¥ ������ �ϼ� ��ȯ -- NUMBER������ ��ȯ
     - ��¥�� + ���� : '��¥'���� '����'��ŭ ����� ���� ��¥ ��ȯ -- ��¥������ ��ȯ
     - ��¥�� - ���� : '��¥'���� '����'��ŭ ������ ��¥ ��ȯ -- ��¥������ ��ȯ
     
   2) TIMESTAMP
    . �ð��� ������ ������ �ð�(10����� 1��) ����
   (�������)
    �÷��� TIMESTAMP; -- �ð��� ���� ���� ��¥ ���� 
    �÷��� TIMESTAMP WITH TIME ZONE; -- �ð��� ����(���ø�/�����)�� ��¥ ����
    �÷��� TIMESTAMP WITH LOCAL TIME ZONE; -- ������ ��ġ�� ������ �ð��� ����(���ø�/�����)�� ��¥ ����

��뿹) 
       CREATE TABLE T_DATE(
         COL1 DATE,
         COL2 DATE,
         COL3 TIMESTAMP,
         COL4 TIMESTAMP WITH TIME ZONE,
         COL5 TIMESTAMP WITH LOCAL TIME ZONE);
        
       INSERT INTO T_DATE VALUES(SYSDATE, TO_DATE('20201015')+30, SYSDATE, SYSDATE, SYSDATE);
       -- +30: 30���� ���ض�
       SELECT * FROM T_DATE;
       
       SELECT TO_CHAR(COL1, 'YYYY-MM-DD PM HH24:MI:SS'), -- AM�� PM�� �� �� �� ����ص� ����/���� �������ִ� ���Ҹ� ������
              TRUNC(COL1 - COL2) -- TRUNC : ������ ���� ���
         FROM T_DATE;
       
  4. ��Ÿ �ڷ�
   - 2�� �ڷḦ ����
   - RAW, LONG RAW, BLOB, BFILE
   -- RAW, LONG RAW�� �ʱ⿡ ����, ������ ����� �ʹ� �۾� ��� �󵵰� ����
   1) BFILE
    . 2�� �ڷḦ ����
    . ���� �ڷḦ �����ͺ��̽� �ܺο� �����ϰ� �����ͺ��̽����� ��� ������ ����
    . 4GB ���� ����
   (�������)
    �÷��� BEFILE;
     - ����Ŭ������ ���� �ڷ�(2�� �ڷ�)�� ���ؼ� �ؼ��ϰų� ��ȯ���� ����
     - 2�� �ڷ� ������ ���� DIRECTORY ��ü�� �ʿ�
     
��뿹) 
       CREATE TABLE T_BFILE(
         COL1 BFILE);
         
      1. ���丮 ��ü ����  
       CREATE DIRECTORY ���丮��Ī AS �����θ�

       CREATE DIRECTORY TEMP_DIR AS 'D:\A_TeachingMaterial\2.Oracle';
       
      2. �̹��� �ڷ� ����
       INSERT INTO ���̺��
         VALUES(BFILENAME('���丮 ��Ī', '���ϸ�'));
  
       INSERT INTO T_BFILE
         VALUES(BFILENAME('TEMP_DIR', 'SAMPLE.jpg'));
       
       SELECT * FROM T_BFILE; 
        
   2) BLOB
    . 2�� �ڷḦ ����
    . ���� �ڷḦ �����ͺ��̽� ���ο� ����
    . 4GB ���� ����
    -- BLOB�� ����� ��ٷӴ�
    (�������)
    �÷��� BLOB;
    
    ** BLOB ������
     (1) ���̺� ����
     (2) ���丮 ��ü ����
     (3) �͸��� ����
   
��뿹) 
       a) ���̺� ����
        CREATE TABLE T_BLOB(
          COL1 BLOB);
       
       b) ���丮 ��ü ����
        TEMP_DIR ���
        
       C) �͸��� ����
        DECLARE
           L_DIR VARCHAR2(20) := 'TEMP_DIR';
          L_FILE VARCHAR2(30) := 'SAMPLE.jpg';
         L_BFILE BFILE;
          L_BLOB BLOB;
        -- �����: ����, ���, Ŀ�� �ִ� �κ�
        -- ���� ����
        -- �ѱ۷� �� ���ϸ��� ���� �� ����
        -- ''(����ǥ) ���� ���ϸ�� Ȯ������ ��ҹ��ڴ� ��Ȯ�� ��������� ��
        BEGIN
          INSERT INTO T_BLOB(COL1) VALUES(EMPTY_BLOB())
            RETURN COL1 INTO L_BLOB;
          L_BFILE := BFILENAME(L_DIR, L_FILE);
          -- L_DIR, L_FILE�� ���ս��� L_BFILE�� ����
          DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
          -- BFILE�� ����ִ� �׸����ϰ� �����θ� �б��������� �о���� ���� ���½�Ŵ
          DBMS_LOB.LOADFROMFILE(L_BLOB, L_BFILE, DBMS_LOB.GETLENGTH(L_BFILE));
          -- BFILE�� ���̸�ŭ �߶� �����ͺ��̽� �÷� ������ �����ͼ� ������
          DBMS_LOB.FILECLOSE(L_BFILE);
          -- �� ���� ������ ����
          
          COMMIT;
        END;
        
        SELECT * FROM T_BLOB;
        -- ����Ŭ������ �ؼ��̳� ��ȯ�� ������ ����
        -- �ٸ� ���α׷��� TOAD������ ��ȯ ����
        
        COMMIT;
        