2021-0729-02)
  1. VIEW ��ü
    - ������ ���̺�
    - SELECT ���� ���ӵ��� ���� ������ ��ü
    - �ʿ��� �ڷᰡ �������� ���̺� �����Ǿ� �ִ� ��� ���
    - Ư�� ���̺��� ������ �����ϰ� �ʿ��� ������ �����ؾ� �ϴ� ��� ���
    (�������)
      CREATE [OR REPLACE] VIEW ���̸�[(�÷�list)]
      AS
        SELECT ��
        [WITH CHECK OPTION]
        [WITH READ ONLY];
      . 'OR REPLACE' : ���� �̸��� �䰡 �����ϸ� �̸� ��ü�ϰ�, �������� ������ ���Ӱ� ����
      . '�÷�list' : �信�� ����� �÷���, �����ϸ� SELECT���� ���� �÷���Ī �Ǵ� �÷����� ���� �÷������� ����
      . 'WITH CHECK OPTION' : �並 �����ϴ� SELECT���� ���� ������ üũ�Ͽ� �̸� �����ϴ� DML����� �信 ������� ���ϰ� ��
      . 'WITH READ ONLY' : �б����� �� ����
      -- ���̸��� �Ϲ������� ���� ���� ǥ���ϱ� ���� 'VIEW_'�� ������
      -- SELECT���� ����� VEIW�� ��
      -- ��� �������̺��� ���� ����Ǿ�����
      -- ���� �����͸� �����ϸ� �������̺��� �����͵� �����ǹǷ�, �̸� �����ϱ� ���� 'WITH READ ONLY'�� ���� ���� ������ ����
      -- ������ WHERE���� �˻��Ͽ� �̸� �����ϴ� DML����� �並 ������� ������� ���ϵ��� ��, ���� ���̺����� �����ο� ����� ����
      -- ����� ������ �ϴ� 'WITH CHECK OPTION'�� ��� ��ü�� ���� 'WITH READ ONLY'�� ���� ��Ÿ���̶� ���� ����� �Ұ�����
      -- SELECT���� ��������� �̸��� �ο����� ���� �䰡 ������, �ٽ� SELECT���� ����ϸ� ���ο� �䰡 ������ �並 ���
    
��뿹) ȸ�� ���̺��� ���ϸ����� 3000�̻��� ȸ���� ��� �����Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ����, ���ϸ���
       1) �÷�list ���
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE(MID, MNAME, MJOB, MMILE)
       AS
         SELECT MEM_ID AS ȸ����ȣ,
                MEM_NAME AS ȸ����,
                MEM_JOB AS ����,
                MEM_MILEAGE AS ���ϸ���
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000;
          
       2) �÷�list �̱�� : �÷���Ī�� ���� �÷������� ����
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE
       AS
         SELECT MEM_ID AS ȸ����ȣ,
                MEM_NAME AS ȸ����,
                MEM_JOB AS ����,
                MEM_MILEAGE AS ���ϸ���
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000;

       3) �÷�list�� �÷���Ī �̱��: ���� ���̺��� �÷����� ���� �÷������� ����   
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE
       AS
         SELECT MEM_ID,
                MEM_NAME,
                MEM_JOB,
                MEM_MILEAGE
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000;
               
         SELECT * FROM VIEW_MEM_MILEAGE;          
          
  ** ������ �� 'VIEW_MEM_MILEAGE'���� ȸ����ȣ 'e001'ȸ���� ���ϸ����� 500���� �����Ͻÿ�.
       UPDATE VIEW_MEM_MILEAGE
          SET ���ϸ��� = 500
        WHERE ȸ����ȣ = 'e001';
       -- ���� �÷����� ����ؾ���
       SELECT * FROM VIEW_MEM_MILEAGE;
       
       SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
         FROM MEMBER
        WHERE MEM_ID = 'e001';
       -- ���� �����͸� �����ϸ� ���� ���̺��� �����͵� ������
       -- ���� �����Ϳ� ���� �����Ͱ� ���� �ٸ��� ����� �߻��ϹǷ� ������ ���ϸ� �ٸ��ʵ� ���ؾ� ����� ����

  ** ȸ�� ���̺��� ȸ����ȣ 'g001'ȸ���� ���ϸ����� 800���� 15000���� �����Ͻÿ�.
       UPDATE MEMBER
          SET MEM_MILEAGE = 15000
        WHERE MEM_ID = 'g001';
       -- ���� ���̺��� �����͸� ����
        
       SELECT * FROM VIEW_MEM_MILEAGE; 
       -- ���� ���̺��� �����Ͱ� �����ϸ� ���� �����͵� ������

  ** VIEW ���� ���ǻ���
    - WITH ���� ���� ��� ORDER BY�� ��� ����
    - �����Լ�, DISTINCT�� ���� VIEW�� ������� DML��� ����� �� ���� -- DISTINCT : �ߺ� ����
    - ǥ����(CASE WHEN ~ THEN, DECODE ��)�̳� �Ϲ��Լ��� �����Ͽ� �䰡 ������ ��� �ش� �÷��� ������� ����, ���� �� ��� ����
    - CURRVAL, NEXTVAL �� �ǻ��÷�(Pseudo Column) ��� ����
    - ROWNUM, ROWID �� ���� ��Ī�� ����ؾ���
    
��뿹) ��ǰ �з��� ��ǰ�� ���� ����ϴ� �� ����
       CREATE OR REPLACE VIEW VIEW_PROD_LGU
       AS
         SELECT PROD_LGU AS PLGU,
                COUNT(*) AS CNT
           FROM PROD
          GROUP BY PROD_LGU;
       
       SELECT * FROM VIEW_PROD_LGU;
       
  ** �� VIEW_PROD_LGU���� 'P102' �ڷḦ �����Ͻÿ�.
       DELETE VIEW_PROD_LGU
        WHERE PLGU = 'P102'
       -- �����Լ�(COUNT)�� ���� VIEW�� DML���(DELETE)�� ����� �� ����

��뿹) ȸ�� ���̺��� ���ϸ����� 3000�̻��� ȸ����� �����ǰ� ��������(CHECK OPTION)�� ����� �並 �����Ͻÿ�.
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE
       AS
         SELECT MEM_ID AS ȸ����ȣ,
                MEM_NAME AS ȸ����,
                MEM_JOB AS ����,
                MEM_MILEAGE AS ���ϸ���
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000
          
   --  WITH CHECK OPTION
       WITH READ ONLY;
       -- WITH CHECK OPTION�� WITH READ ONLY�� ���� ��Ÿ���̶� ���ÿ� ����� �� ����
       
       SELECT * FROM VIEW_MEM_MILEAGE;

  ** �� VIEW_MEM_MILEAGE���� ������ ȸ��('e001')�� ���ϸ����� 1500�� �����Ͻÿ�.
       UPDATE VIEW_MEM_MILEAGE
          SET ���ϸ��� = 1500
        WHERE ȸ����ȣ = 'e001';
        -- VIEW�� ������ �� WITH CHECK OPTION�� �־��� ������ WHERE���� ������ ����� ������ �� ����
        -- ���� ���̺��� ����, ����, �߰��ϴ� ���� ������, ���� ���̺��� ����� �����Ͱ� ���� �����Ϳ��� �ﰢ �ݿ���
        
        -- VIEW�� ������ �� WITH READ ONLY�� �־��� ������ VIEW�� ������ �� ���� �б� �������θ� ��� ������
        -- ���� ���̺��� ����, ����, �߰��ϴ� ���� ������, ���� ���̺��� ����� �����Ͱ� ���� �����Ϳ��� �ﰢ �ݿ���

  ** ȸ�� ���̺��� ������ ȸ��('e001')�� ���ϸ����� 1500�� �����Ͻÿ�.
       UPDATE MEMBER
          SET MEM_MILEAGE = 6500
        WHERE MEM_ID = 'e001';
        
       SELECT * FROM VIEW_MEM_MILEAGE;
       
       COMMIT;