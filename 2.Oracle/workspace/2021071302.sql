2021-0713-02) �Լ�(FUNCTION)
  - Ư�� ����� ��ȯ�ϱ� ���Ͽ� �̸� �ۼ��Ͽ� �����ϵ� ���
  - ��ȯ���� ����
  - ������ ��Ʈ��ũ ���� ������ �⿩
  - ������ �Լ��� ������ �Լ�(�����Լ� : SUM, AVG, COUNT, MAX, MIN)�� ����
  - ���ڿ�, ����, ��¥, ����ȯ, NULLó��, �����Լ� ���� ����
  - ��ø ����� ������
  -- ������ �Լ��� ������ �Լ��� ���Ǵ� �����ڰ� �ٸ�
  
  SELECT EMP_NAME, SALARY
    FROM HR.EMPLOYEES
   WHERE DEPARTMENT_ID = (SELECT A.DID
                            FROM (SELECT DEPARTMENT_ID AS DID,
                                         COUNT(*)
                                    FROM HR.EMPLOYEES
                                   GROUP BY DEPARTMENT_ID
                                  HAVING COUNT(*) >= 5) A);
  -- ���� �߻�
  
  SELECT EMP_NAME, SALARY
    FROM HR.EMPLOYEES
   WHERE DEPARTMENT_ID IN(SELECT A.DID
                            FROM (SELECT DEPARTMENT_ID AS DID,
                                         COUNT(*)
                                    FROM HR.EMPLOYEES
                                   GROUP BY DEPARTMENT_ID
                                  HAVING COUNT(*) >= 5) A);  
  -- �� �۵���
  
  1. ���ڿ� �Լ�
   1) || (���ڿ� ���� ������)
    - �ڹٿ��� ���ڿ� ���տ� ���Ǵ� '+'�� ����
    - �� ���ڿ��� �����Ͽ� ���ο� ���ڿ��� ��ȯ
  
��뿹) ȸ�� ���̺��� �泲�� �����ϴ� ȸ�������� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �ֹι�ȣ, �ּ��̸�, �ֹι�ȣ�� 'XXXXXX-XXXXXXX'�������� ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '�泲%'
        ORDER BY 1; -- MEM_ID
        
   2) CONCAT(c1, c2)
    - �־��� ���ڿ� �ڷ� c1�� c2�� �����Ͽ� ��ȯ
    -- ���� ���ڿ��� ���ս�Ű���� CONCAT �ȿ� CONCAT �ȿ� CONCAT�� �ݺ������� ���� ������ ������ �ǹǷ�, �� ������ �ʴ´�
        
��뿹) ȸ�� ���̺��� �泲�� �����ϴ� ȸ�������� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �ֹι�ȣ, �ּ��̸�, �ֹι�ȣ�� 'XXXXXX-XXXXXXX'�������� ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              CONCAT (CONCAT (MEM_REGNO1, '-'), MEM_REGNO2) AS �ֹι�ȣ,
              CONCAT (MEM_ADD1, CONCAT (' ', MEM_ADD2)) AS �ּ�
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '�泲%'
        ORDER BY 1; -- MEM_ID
        
   3) ASCII (c1), CHR(n1)
    - ASCII (c1) : c1�� �ش��ϴ� ASCII �ڵ尪�� ��ȯ
    - CHR (n1) : ���� n1�� �ش��ϴ� ���ڸ� ��ȯ
    
��뿹) 
       SELECT ASCII (MEM_NAME), CHR(65) FROM MEMBER;
       SELECT ASCII (PROD_ID), CHR(65) FROM PROD;
       
��뿹)
DECLARE
BEGIN
  FOR I IN 1..255 LOOP
    DBMS_OUTPUT.PUT_LINE(I||'='||CHR(I));
  END LOOP;
END;

   4) RPAD(c1, n[, c2]), LPAD(c1, n[, c2])
    - RPAD : ������ ���� n�� c1�� �����ϰ� ���� ������ ������ c2�� �����Ѵ�.
    - LPAD : ������ ���� n�� c1�� �����ϰ� ���� ���� ������ c2�� �����Ѵ�.
    - c2�� �����Ǹ� ������ ä��
    -- ���ſ� ���� ���󵵰� ������
    -- ���ڿ��� ����ó�� ������ �����Ϸ��� LPAD�� ����ϸ� ��
    
��뿹) 
       SELECT LPAD ('12345', 7, '*') AS COL1,
              RPAD ('9876', 6) AS COL2
         FROM DUAL;
    
       SELECT TO_CHAR(PROD_COST) AS COL1,
              LPAD (PROD_NAME, 30) AS COL2,
              LPAD (TO_CHAR(PROD_COST), 10) AS COL3,
              LPAD (TO_CHAR(PROD_COST), 10, '#') AS "COST"
         FROM PROD;
    
   5) RTRIM(c1[, c2]), LTRIM(c1[, c2])
    - RTRIM : �־��� ���ڿ� c1 ���ο� c2 ���ڿ��� �����ʿ��� ã�� ����
    - LTRIM : �־��� ���ڿ� c1 ���ο� c2 ���ڿ��� ���ʿ��� ã�� ����
    - c2�� �����Ǹ� ������ ����(�ܾ� ������ ������ ���� �Ұ���)

��뿹) HR�������� ���.
       ALTER TABLE EMPLOYEES
         MODIFY (EMP_NAME VARCHAR2(80));
  
      SELECT EMPLOYEE_ID, EMP_NAME
        FROM EMPLOYEES;

      UPDATE EMPLOYEES
         SET EMP_NAME = RTRIM(EMP_NAME);

      COMMIT;
  
   6) TRIM(c1)
    - �ܾ� ���� �Ǵ� �����ʿ� �߻��� ������ ��� ����
    - �ܾ� ������ ������ ���� �Ұ���
    
��뿹) 
       SELECT MEM_NAME, MEM_HP, MEM_JOB, MEM_MILEAGE
         FROM MEMBER
        WHERE MEM_NAME = '������     ';
        -- ��ã��
        -- ������ ���ڿ��� ���, ��ȿ�� �������� ���
    
       SELECT MEM_NAME, MEM_HP, MEM_JOB, MEM_MILEAGE
         FROM MEMBER
        WHERE MEM_NAME = TRIM('    ������     ');
        -- ã��
    
       SELECT MEM_NAME, MEM_HP, MEM_JOB, MEM_MILEAGE
         FROM MEMBER
        WHERE MEM_NAME = TRIM('    ��   ����     ');
        -- ��ã��
        -- �ܾ� ������ ������ ���� �Ұ���

   7) SUBSTR(c, n1[, n2])
    - �־��� ���ڿ� c���� n1��°���� n2 ������ŭ ���ڸ� �����Ͽ� �κ� ���ڿ��� ��ȯ
    - ����� ���ڿ���
    - n1, n2�� 1���� ���۵�
    - n2�� �����ǰų� ������ ������ ū n2�� ����ϸ� n1 ���� ��� ���ڿ��� ������
    - n1�� �����̸� �������� �������� ó����
    -- �� �� ����� �׻� Ÿ���� ��ġ���Ѿ���
    -- ���� ���� ���Ǵ� �Լ�
    
��뿹) 
       SELECT SUBSTR('������ �߱� ���ﵿ', 2, 5),
              SUBSTR('������ �߱� ���ﵿ', 2),
              SUBSTR('������ �߱� ���ﵿ', 2, 20),
              SUBSTR('������ �߱� ���ﵿ', -7, 5) AS c1
         FROM DUAL;
         
��뿹) ������ 2005�� 4�� 1���� ��� CART_NO�� �ڵ� �����Ͻÿ�.
       SELECT TO_CHAR(SYSDATE, 'YYYYMMDD')||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(MAX(CART_NO), 9)) + 1, '00000'))
         FROM CART
        WHERE CART_NO LIKE '20050401%';
        -- '00000' 4�� 00004�� �ٲ��ش�
        
       SELECT MAX(CART_NO) + 1
         FROM CART
        WHERE CART_NO LIKE '20050401%';
        -- MAX(CART_NO) : ���ڿ� �߿��� ���� ū ���� ã��
        -- MAX(CART_NO) : ���ڿ������� ���ڷθ� �̷���� ���ڷ� ������ ������
        -- + 1: ���� ���ڿ��� �ڵ����� ���ڷ� �ٲ���
        
   8) REPLACE(c1, c2[, c3])
    - �־��� ���ڿ� c1�� ���Ե� c2�� ã�� c3�� ġȯ��Ŵ
    - c3�� �����Ǹ� ã�� c2�� ������Ŵ
    - �ܾ� ������ ���� ���ſ� ���� �� ����
    -- �Ű������� 3�� ���� �� �� ����
    -- c1: ���� ������
    -- c2: ���������Ϳ��� ã���� �ϴ� ���ڿ�
    -- c3: c2�� ��ü�ϰ��� �ϴ� ���ڿ�
    -- �������Ŵ� �μ����� ���������, ������ �ָ����� �Ǿ� �ܾ�ġȯ���� �������Ÿ� �� ���� �����
    
��뿹) 
       SELECT REPLACE('���������� �߱� ���ﵿ', '��������', '����'),
              REPLACE('���������� �߱� ���ﵿ', '����'),
              REPLACE('���������� �߱� ���ﵿ', ' '), -- �ܾ� ������ �������� ���
              REPLACE('���������� �߱� ���ﵿ', '��') -- ���ڿ����� ��ġ�ϴ� ��� �ܾ ã�� ��� ������
         FROM DUAL;
         
   9) INSTR(c1, c2[, m[, n]])
    - �־��� ���ڿ� c1���� c2 ���ڿ��� ó�� ���� ��ġ���� ��ȯ
    - m�� �˻� ������ġ�� ���� ������ �� ���
    - n�� c2 ���ڿ��� �ݺ� Ƚ���� ���Ͽ� �˻��ϴ� ��� ���
    -- ��� �󵵰� ����
    
��뿹) 
       SELECT INSTR('APPLE PERSIMON PEAR BEAR', 'E'), -- ó������ �����ؼ� E�� ó�� ���� ��ġ�� ǥ��
              INSTR('APPLE PERSIMON PEAR BEAR', 'P', 5), -- 5��°���� �����ؼ� P�� ó�� ���� ��ġ�� ǥ��
                                                         -- (ã�°� 5��°����, ��ġ�� ó������ ī��Ʈ)
              INSTR('APPLE PERSIMON PEAR BEAR', 'P', 5, 2), -- 5��°���� �����ؼ� P�� 2��°�� ���� ��ġ�� ǥ��
              INSTR('APPLE PERSIMON PEAR BEAR', 'P', 5, 3) -- 0��: ���ٴ� ǥ��
         FROM DUAL;
         
       COMMIT;
       