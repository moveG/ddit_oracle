2021-0730-01)
  4. INDEX ��ü
    - �������� �˻�ȿ������ �����ϱ� ���� ��ü
    - WHERE �������� ���Ǵ� �÷��̳� SORT�� GROUP�� �����÷� ���� �������� INDEX�� �����ϸ� DBMS�� ���ϸ� �ٿ� ��ü ������ ����
    - ������ ������ �ҿ�(INDEX FILE), �ε��� ������ ���������� ���� �ý��� �ڿ��� �ʿ���, ������ ���� � ���� �ð��� �ҿ��
    -- �⺻Ű�� �ڵ����� �ε����� ��(ex PK_BUYER, PK_CART,...)
    - �ε��� ����
      . Unique Index : �ߺ����� ������� �ʴ� �ε���(�⺻Ű �ε��� ��)
      . Non-Unique Index : �ߺ����� ����ϴ� �ε����� Null���� ���������, �ϳ��� Null���� �����
      . Single Index : �ε��� ������ �ϳ��� �÷��� ����
      . Composite Index : �ε��� ������ �������� �÷��� ���Ǹ�, WHERE������ ���� ��� �׸�(�ε��� ���� �׸�)�� ������ ȿ������ �����Ŵ
      . Normal Index : �⺻ �ε���(Ʈ������ ��� - ��� ����� ��� �˻� Ƚ���� ������)��
                       ROWID(�� ���� ������ �ּҰ�)�� �÷������� �ּҸ� ������
      . Function-Based Normal Index : �ε��� ���� �÷��� �Լ��� ���� ����, WHERE ���������� ���� ���� �Լ� ����� ȿ���� ���� �����
      . Bitmap Index : ROWID�� �÷����� ����(Binary)���� �������� �ּҸ� ������, -- Normal Index�� ��������� ���������� �����ؼ� �ּҸ� ������
                       Cardinality�� ���� ��쿡 ȿ�����̸�, �߰�, ����, ������ ���� ��� ��ȿ������
    (�������)
      CREATE [UNIQUE|BITMAP] INDEX �ε�����
        ON ���̺��(�÷���1[, �÷���2,...][ASC|DESC]);

��뿹) ȸ�� ���̺��� �ֹι�ȣ �������� �ε����� �����Ͻÿ�.
       CREATE INDEX IDX_MEM_REGNO
         ON MEMBER(MEM_REGNO1, MEM_REGNO2);
       
       CREATE INDEX IDX_MEM_NAME
         ON MEMBER(MEM_NAME);
       
       DROP INDEX IDX_MEM_NAME;
         
       SELECT * FROM MEMBER
        WHERE MEM_ADD1 LIKE '����%';
       
       SELECT * FROM MEMBER
         WHERE MEM_NAME = '�ſ�ȯ';
         
��뿹) ȸ�� ���̺��� MEM_REGNO2�� �ֹι�ȣ �� 2~5��° ���ڷ� ������ �ε����� �����Ͻÿ�.
       CREATE INDEX IDX_MEM_REGNO_SUBSTR
         ON MEMBER(SUBSTR(MEM_REGNO2, 2, 4));
         
       SELECT * FROM MEMBER
         WHERE SUBSTR(MEM_REGNO2, 2, 4) = '4489';
         
    ** �ε����� �籸�� -- �ε����� �籸����Ű�� ����
      - �ش� ���̺��� �ڷᰡ ���� ������ ��� -- ���� �������� �ʾƵ� �����ð��� ������ �ڵ����� �籸����
      - �ε����� �ٸ� ���̺� �����̽��� �̵���Ų ��
    (�������)      
      ALTER INDEX �ε����� REBUILD
         
      COMMIT;