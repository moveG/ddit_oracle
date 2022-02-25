2021-0730-01)
  2. SEQUENCE ��ü
    - ���������� �����ϴ� ���� ��ȯ�ϴ� ��ü
    - ���̺�� ������ -- ���� ���̺��� ���ÿ� ����� �� �ִٴ� �ǹ�
    - ������ ���̺��� �⺻Ű�� ������ ������ �÷��� ���� ���, �ڵ����� �ο��Ǵ� �������� ���ڰ��� �ʿ��� ��� ����
    (�������)
      CREATE SEQUENCE ��������    -- �� �κи� �ۼ��ص� ������ ��� ����
        [START WITH n]          -- ���۰�, �����ϸ� �ּҰ�(MINVALUE)
        [INCREMENT BY n]        -- ������, �����ϸ� 1, ������ +����, ���Ҵ� -���� ����ϸ��
        [MAXVALUE n|NOMAXVALUE] -- �ִ밪, �⺻�� NOMAXVALUE�̸� ���� 10^27
        [MINVALUE n|NOMINVALUE] -- �ּҰ�, �⺻�� NOMINVALUE�̸� ���� 1
        [CYCLE|NOCYCLE]         -- �ּ�[�ִ�]�� ������ ���������� �ٽ� �������� ����, �⺻�� NOCYCLE
        [CACHE n|NOCACHE]       -- ������ ���� ĳ�ÿ� �̸� �����ϰ� ������� ����, �⺻�� CACHE 20
        [ORDER|NOORDER]         -- ������ ���Ǵ�� ������ ������ ����, �⺻�� NOORDER
      
    ** �ǻ��÷�
       ��������.CURRVAL : '������'�� ������ �ִ� ���簪 ��ȯ
       ��������.NEXTVAL : '������'�� ������ ��ȯ
       ** ������ ��ü�� ������ �� �� ó�� ����� �ݵ�� '��������.NEXTVAL'�̾�� �� -- ������� �������� ������ �ǹ�
       ** ��������.NEXTVAL�� ����Ͽ� ������ ���� �ٽ� ������� �� ����
       -- �������� ���̺� �����Ǿ� �ֱ� ������(���� ���̺� ���ÿ� ���Ǳ� ������) �����ϰ� ������� ������ ���ϴ� ���� ���� �� ����  
       -- �߸� ����ϸ� �����ϰ� ���� �ο����� �ʰ� �뼺�뼺�ϰ� ���� �ο��� �� �����Ƿ� ������ ����ؾ���

��뿹) LPROD ���̺��� LPROD_ID�� ����� �������� �����Ͻÿ�.
       SELECT MAX(LPROD_ID) FROM LPROD; -- �ִ밪 9�� ��µ�
       
       CREATE SEQUENCE SEQ_LPROD
         START WITH 10; -- 9�� �̹� �����ϴ� ���̹Ƿ� 10���� �����ϴ� ���� ����
       
       SELECT SEQ_LPROD.CURRVAL FROM DUAL; -- SEQ_LPROD ���������� ���� CURRVAL�� ���ǵ��� �ʾ����Ƿ� NEXTVAL���� ����ؾ���
       
       INSERT INTO LPROD
         VALUES(SEQ_LPROD.NEXTVAL, 'P501', '��깰');
         
       SELECT * FROM LPROD;  
         
��뿹) ������ 2005�� 4�� 18���̶� �����ϰ�, CART_NO�� �����Ͻÿ�.
       SELECT TO_CHAR(TO_DATE('2005/04/18'), 'YYYYMMDD')||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(MAX(CART_NO), 9))+1, '00000'))
         FROM CART
        WHERE CART_NO LIKE '20050418%' 
        -- SEQUENCE�� ������� ������ �Լ��� �Ἥ �����ϰ� ����ؾ���
        -- NEXTVAL�̸� �����ϰ� 2005041800003�� ����� �� ����
        -- ������������ ����ϹǷ� �̸� ������ �����ϱ� ���� �˰����� ����Ⱑ ����
        -- SEQUENCE�� ������� �ʰ� ���� ������ ����� ����ϴ� ��쵵 ����
        
    ** �������� ����� ���ѵǴ� ���
      - SELECT, DELETE, UPDATE���� ���Ǵ� �������� --INSERT�������� ��� ����
      - VIEW�� ������� �ϴ� ����
      - DISTINCT�� ���Ǵ� SELECT��
      - GROUP BY, ORDER BY���� ���Ǵ� SELECT��
      - ���տ�����(UNION, UNION ALL, INTERSECT, MINUS)�� ���Ǵ� SELECT��
      - WHERE��
      -- �ַ� �ڷḦ ������ �� ����(�ַ� INSERT�� �Ǵ� INSERT������ ���Ǵ� ������������ ����)

  3. SYNONYM ��ü
    - ���Ǿ�(��Ī)�� �ǹ�
    - ����Ŭ���� ���Ǵ� ��ü�� ������ �̸��� �ο��Ͽ� ���� -- ���ʿ� �����ִ� ��� ��(���̺�, ��,...)
    - �ַ� �̸� �� ��ü���� ����ϱ� ���� ��ü������ ��ü�� �� ���
    (�������)
      CREATE [OR REPLACE] SYNONYM �ó봽�� FOR ��ü��
        . '��ü��'�� ������ �̸��� '�ó봽��'�� �ο�
        . �÷��� ��Ī�� ���̺��� ��Ī���� ������
          - '�ó봽��'�� �ش� ���̺� �����̽� ��ü���� ���
          - '�÷��� ��Ī'�� '���̺��� ��Ī'�� �ش� ���������� ��� ����
          
��뿹) HR������ EMPLOYEES, DEPARTMENTS, JOB_HISTORY ���̺� ��Ī('�ó봽��') EMP, DEPT, JOBH �� �ο��Ͻÿ�.
       CREATE OR REPLACE SYNONYM EMP FOR HR.EMPLOYEES;
       CREATE OR REPLACE SYNONYM DEPT FOR HR.DEPARTMENTS;
       CREATE OR REPLACE SYNONYM JOBH FOR HR.JOB_HISTORY;
       
       SELECT * FROM EMP;
       SELECT * FROM DEPT; -- ���̺��(HR.DEPARTMENTS) ��� �ó봽��(DEPT)�� �����ϰ� ����� �� ����
       SELECT * FROM JOBH;
       -- ���̺��(HR.EMPLOYEES, HR.DEPARTMENTS, HR.JOB_HISTORY) ��� �ó봽��(EMP, DEPT, JOBH)�� �����ϰ� ����� �� ����
       