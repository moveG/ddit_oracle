2021-0708-01)
 1)SELECT �� ����
   SELECT [DISTINCT] �÷���|����|������ [AS]["][��Ī]["]
   -- []: ���ȣ ���� ������ ������ ������
   . 'DISTINCT' : �ߺ��� ���� ����
   . '[AS]["][��Ī]["]' : �÷��� �ο��� �Ǵٸ� �̸����� Ư������ ���� ""(�ֵ���ǥ)�� ���� ���
    - ��½� �÷��� ����
    -- ""(ū����ǥ): �÷��� ���
    -- ''(����ǥ): ���ڿ��� ���
   
��뿹) ȸ�����̺�(MEMBER)�� �ֹι�ȣ(MEM_REG01)�� ����Ͽ� ȸ���� ���̸� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �ֹι�ȣ, ����
       SELECT MEM_ID AS "FROM",
              MEM_NAME AS ȸ����,
              MEM_REGNO1||'-'||MEM_REGNO2 AS "�ֹ� ��ȣ",
              EXTRACT(YEAR FROM SYSDATE)-(TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))+1900) AS ����
         FROM MEMBER;
       -- EXTRACT(YEAR FROM SYSDATE) ~ AS ����: �� ���� ��� ����, ����(��Ī)�� �÷����� ��
       -- FROM�� ���� ����Ŭ���� �����ϴ� ��ɹ��� �÷������� ������ ""(�ֵ���ǥ)�� ����ؾ���
       -- ||: ���ڿ��� ������ �� ���
       
  (1) ������(OPERATOR)
    - ���������
      . +, -, *, /
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
       -- ���ʽ��� NULL�̶� ���޾׵� NULL�� ��
       -- NVL + ,0�� ���̸� NULL���� 0���� �����
        
    - ���迬���� : ��� ��, TRUE/FALSE�� ����� ��ȯ
      . >, <, >=, <=, =, !=(<>)
      -- <> : ><�� ����� �ȵ�
      
��뿹) ȸ�����̺��� ���ϸ����� 4000�̻��� ȸ���� ȸ����ȣ, ȸ����, ����, ���ϸ����� ��ȸ�Ͻÿ�.
       ���ϸ����� ���� ȸ������ ��ȸ�Ͻÿ�.
       -- LGU: �з��ڵ�
       -- JOIN: �� �� �̻��� ���̺��� ���� �����Ͽ� �����͸� �˻��� �� ����ϴ� ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_MILEAGE >= 200
        ORDER BY MEM_MILEAGE, MEM_ID DESC; -- ���� �������� ����, ���� �����Ͱ� ������ ����� ���� �������� ����
     -- ORDER BY 4(�÷��ε���) DESC; -- �÷��� ��� �÷��ε��� ��� ������
                                   -- �÷��� ��� �Լ��� �����ڰ� ���ԵǾ� ���� ���� �����Ƿ� �÷��ε����� ���
                                   -- �÷��ε���: SELECT������ ���������� ���ʴ�� 1, 2, 3, 4, ...
                                   -- ORDER BY: ũ�� ������ ���� ASC�� ��������, DESC�� ��������, DEFAULT���� ASC(��������)
                                   -- ���������� ��->ū / �������� ū->��
      
**��������: UPDATE��
  UPDATE ���̺��
     SET �÷���=��[, 
         �÷���=��, 
           :
         �÷���=��]
  [WHERE ����];
 
**ȸ�����̺� ���� ����
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
    
   SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
     FROM MEMBER
    WHERE MEM_ID = 'd001';

2) UPDATE MEMBER
      SET MEM_REGNO1 = '000323',
          MEM_REGNO2 = '3011014',
          MEM_BIR = TO_DATE('20000323')
    WHERE MEM_ID = 'n001';
    
   SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
     FROM MEMBER
    WHERE MEM_ID='n001';

3) UPDATE MEMBER
      SET MEM_REGNO1 = '020131',
          MEM_REGNO2 = '4402712',
          MEM_BIR = TO_DATE('2002/01/31') -- /�� ���� ������Ʈ ����
    WHERE MEM_ID = 'v001';
    
   SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
     FROM MEMBER
    WHERE MEM_ID='v001';
    
   -- �ѹ��� ������ ��ȸ�ϱ� (��Ÿ ������)
   SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
     FROM MEMBER
    WHERE MEM_ID IN('d001', 'n001', 'v001');

��뿹) ȸ�����̺��� ����ȸ�������� ��ȸ�Ͻÿ�.
       Alias ȸ����ȣ, ȸ����, �������, ���ϸ���, ���
-- ������ ����ȸ��, ����ȸ���� �����ϴ� ��� CASE~
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_BIR AS �������,
              MEM_MILEAGE AS ���ϸ���,
              CASE WHEN SUBSTR(MEM_REGNO2,1,1)='2' OR
                        SUBSTR(MEM_REGNO2,1,1)='4' THEN
                              '����ȸ��'
                   ELSE            
                              '����ȸ��'
              END AS ���                
         FROM MEMBER
        WHERE SUBSTR(MEM_REGNO2,1,1)= ANY('2', '4'); -- 1,1 : 1��°���� 1����
     -- WHERE SUBSTR(MEM_REGNO2,1,1)= '2'
     --    OR
     --       SUBSTR(MEM_REGNO2,1,1)= '4';

    - ��������
      . NOT, AND, OR
      -- ���迬���� ������ ������ �� ���
      -- AND�� ����(���� �� �ϳ��� FALSE��� ��� FALSE), OR�� ����(���� �� �ϳ��� TRUE��� ��� TRUE)
      -- NOT, AND, OR ������ �켱������ ������
      . NOT: ������
      -------------------------------
         �Է�      ���
       A     B    (OR) (AND) (EX-OR)
      -------------------------------
       0     0     0     0     0
       0     1     1     0     1
       1     0     1     0     1
       1     1     1     1     0
      -------------------------------
      -- 0: FALSE / 1: TRUE
      -- EX-OR: ��Ÿ�� ����, ���ʿ� ���� ���� ������ 0, �ٸ� ���� ������ 1
               A                     B
      MEM_MILEAGE >= 2000 OR EXTRACT(YEAR FROM MEM_BIR) <= 2000

��뿹) ������̺��� ��ձ޿� �̻� �޿��� �޴� ����� ��ȸ�Ͻÿ�.
       Alias�� �����ȣ, �����, �޿�, �μ���ȣ
       SELECT EMPLOYEE_ID AS �����ȣ,
              FIRST_NAME AS �����,
              SALARY AS �޿�,
              DEPARTMENT_ID AS �μ���ȣ,
              ROUND((SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES),0) AS ��ձ޿�
         FROM HR.EMPLOYEES
        WHERE NOT SALARY < (SELECT AVG(SALARY)
                              FROM HR.EMPLOYEES) -- NOT(��ձ޿����� ����) -> ��ձ޿����� ũ�ų� ����
        ORDER BY 4;            
     
    - ��Ÿ������
      . IN, ANY, SOME, ALL, EXISTS, BETWEEN, LIKE �� ����
      -- IN, ANY, SOME, ALL, EXISTS: �����Ͱ� �ϳ� �̻� ������ �� ���
      -- BETWEEN: ������ �ش��ϴ� �����ͺ� A AND B
      -- LIKE: ������ �˻��� �� ���
      
      
    SELECT * FROM JOBS;
    -- ������ �߻���
    -- LDG89���������� HR������ �� �� ����
    SELECT * FROM HR.JOBS;
    -- �ٸ� ������ TABLE�� ���� ������ TABLE�� �տ� "������."�� �ٿ��ش�
   

  COMMIT;