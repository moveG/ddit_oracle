2021-0714-01)
  2. �����Լ�
   1) GREATEST(n1, n2[, n3, ...]), LEAST(n1, n2[, n3, ...])
    - GREATEST : �־��� ��(n1, ~ ..) �� ���� ū ���� ��ȯ
    - LEAST : �־��� ��(n1, ~ ..) �� ���� ���� ���� ��ȯ
    -- MAX, MIN���� ����: GREATEST, LEAST�� ���� �����ؾ� �ϰ�, MAX, MIN�� �÷����� ���� ã��
    -- MAX, MIN : ���� ��
    -- GREATEST, LEAST : Ⱦ�� ��, ���� �÷����� ���� �� ���
  
��뿹)
       SELECT GREATEST(50, 70, 90),
              LEAST(50, 70, 90)
         FROM DUAL;
         
��뿹) ȸ�� ���̺��� ���ϸ����� 1000 �̸��� ��� ȸ���� ���ϸ����� 1000���� ���� ����Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���� ���ϸ���, ���� ���ϸ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS "���� ���ϸ���",
              GREATEST(MEM_MILEAGE, 1000) AS "���� ���ϸ���"
         FROM MEMBER;
         
       SELECT GREATEST(MEM_NAME) FROM MEMBER; -- ����
       SELECT MAX(MEM_NAME) FROM MEMBER; -- ����
       
   2) ROUND(n[, i]), TRUNC(n[, i])
    - ROUND : �־��� �� n�� �Ҽ��� ���� i + 1��° �ڸ����� �ݿø��Ͽ� i��° ���� ���
              i�� �����̸� �����κ� i ��°���� �ݿø�
              i�� �����Ǹ� 0���� ���ֵ�
    - TRUNC : ROUND�� ���� ����ǳ� �ݿø��� �ƴ϶� ����ó��
    -- ���ݰ��� ������ ���� TRUNC�� ����ؼ� �����ؼ� �����
  
��뿹) ��� ���̺��� �޿��� ���޾��� ����Ͽ� ����Ͻÿ�.
       Alias�� �����ȣ, �����, �޿�, ����, ���޾�
       ���� = �޿����� 17%
       ���޾��� �޿� - ����
       �Ҽ��� 1�ڸ����� ���
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              SALARY AS �޿�,
              TRUNC(SALARY * 0.17, 1) AS ����, 
              SALARY - TRUNC(SALARY * 0.17, 1) AS ���޾�
         FROM HR.EMPLOYEES;

��뿹) 2005�� 1�� ~ 3�� ��ǰ�з��� ��ո��Ծ��� ��ȸ�Ͻÿ�.
       Alias�� �з��ڵ�, �з���, ��ո��Աݾ�
       ��ո��Աݾ��� ������(�Ҽ��� ����) ǥ��, 1�� �ڸ����� �ݿø�
       SELECT C.PROD_LGU AS �з��ڵ�,
              B.LPROD_NM AS �з���,
              ROUND(AVG(A.BUY_QTY * C.PROD_COST), -1) AS ��ո��Աݾ�
         FROM BUYPROD A, LPROD B, PROD C
        WHERE A.BUY_PROD = C.PROD_ID
          AND C.PROD_LGU = B.LPROD_GU
          AND A.BUY_DATE BETWEEN '20050101' AND '20050331'
        GROUP BY C.PROD_LGU, B.LPROD_NM
        ORDER BY 1;
        -- ���̺��� ��Ī�� FROM ���� ���
        -- �÷� ��Ī�� SELECT ���� ���(AS + ��Ī)
        -- ���̺��� 2�� �̻� ������ JOIN�� �߻���
        
   3) FLOOR(n), CEIL(n)
    - n�� ����� ������ ��ȯ
    - FLOOR : n�� ���ų� ũ�� ���� ���� �� ���� ū ����
    - CEIL : n�� ���ų� ū ���� �� ���� ���� ����
    - ����, �޿� ó�� �ݾװ� ���õ� ���Ŀ� �ַ� ���
    -- �����͸� ����ȭ ��ų�� ���
    -- ���� �Ǽ�: EX) +11.2 : FLOOR +11 CEIL +12
    -- ���� �Ǽ�: EX) -11.2 : FLOOR -12 CEIL -11 (����)
    -- ROUND ��� ����� ����(��(����)�� �� ���� �ʰ��ϴ� CEIL��, ��(����)�� ���� ���� FLOOR�� ���)
   
��뿹)
       SELECT FLOOR(12.5), CEIL(12.5),
              FLOOR(12), CEIL(12),
              FLOOR(-12.5), CEIL(-12.5)
         FROM DUAL;

   4) MOD(n, i), REMAINDER(n, i)
    - �������� ��ȯ
    - MOD : n�� i�� ���� �������� ��ȯ
    -- MOD : JAVA�� %�� ���� ����� ����    
            ������ = ������ - ���� * (FLOOR(������/����))
    EX) 15 / 6 �� ������ = 15 - 6 * (FLOOR(15/6))
                        = 15 - 6 * (FLOOR(2.5))
                        = 15 - 12
                        = 3
    - REMAINDER : n�� i�� ���� �������� i�� ���� ������ ���̸� MOD�� ���� �������� ��ȯ�ϰ�,
                  �������� �� �̻��� ���̸� ���� ���� �Ǳ� ���� �������� �� ���� ��ȯ
                  ������ = ������ - ���� * (ROUND(������/����))
    EX) 15 / 6 �� ������ = 15 - 6 * (ROUND(15/6))
                        = 15 - 6 * (ROUND(2.5))
                        = 15 - 18
                        = -3
��뿹)
       SELECT MOD(17, 6), REMAINDER(17, 6),
              MOD(17, 7), REMAINDER(17, 7)
         FROM DUAL;
         -- ���� �̻��ؼ� �������� �ٽ� ���캸�Ŵٰ� ��
         
��뿹) ������ �⵵�� �Է¹޾� ����� ����� �����Ͻÿ�.
       ����: (4�� ����̸鼭 100�� ����� �ƴϰų�),
            (400�� ����� �Ǵ� ��)
       ACCEPT P_YEAR  PROMPT '�⵵ �Է�'
       DECLARE
         V_YEAR NUMBER := TO_NUMBER('&P_YEAR');
         V_RES VARCHAR2(100);
       BEGIN
         IF (MOD(V_YEAR, 4) = 0 AND MOD(V_YEAR, 100) != 0) OR MOD(V_YEAR, 400) = 0 THEN
           V_RES := TO_CHAR(V_YEAR)||'���� �����Դϴ�.';
         ELSE
           V_RES := TO_CHAR(V_YEAR)||'���� ����Դϴ�.';
         END IF;
         
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;
        
   5) WIDTH_BUCKET(n, min, max, b)
    - min���� max �� ������ b�� �������� ������, �־��� �� n�� �� ���� �� ��� ������ ���ϴ����� �Ǻ��Ͽ� ������ �ε����� ��ȯ��

��뿹)
       SELECT WIDTH_BUCKET(90, 0, 100, 10) FROM DUAL;
       -- �ּҹ��� �� 0�� ������ ���ԵǾ� 1������ ��������, �ִ���� �� 100�� ������ ��� 11������ ���ϰ� ��
       -- ������ �Ʒ��� �����(EX) -10) 0������ ���ϰ�, ������ ���� �����(EX) 120) 11������ ����
      
��뿹) ȸ�� ���̺��� ȸ������ ���ϸ����� 3���� �׷����� ������ �� ȸ������ ���ϸ����� ���� �׷��� ��ȸ�Ͽ�
       1�׷쿡 ���� ȸ���� '���� ȸ��',
       2�׷쿡 ���� ȸ���� '���� ȸ��',
       3�׷쿡 ���� ȸ���� 'VIP ȸ��'�� ������ ����Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ����, ���ϸ���, ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���,
              CASE WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 3) = 1 THEN
                        '���� ȸ��'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 3) = 2 THEN
                        '���� ȸ��'
                   ELSE 
                        'VIP ȸ��'
              END AS ���          
         FROM MEMBER;
         -- CASE WHEN�� SELECT�������� ��� ����
         
         SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���,
              CASE WHEN WIDTH_BUCKET(MEM_MILEAGE, (SELECT MIN(MEM_MILEAGE)
                                                     FROM MEMBER),
                                                  (SELECT MAX(MEM_MILEAGE) + 1
                                                     FROM MEMBER), 3) = 1 THEN
                        '���� ȸ��'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, (SELECT MIN(MEM_MILEAGE)
                                                     FROM MEMBER),
                                                  (SELECT MAX(MEM_MILEAGE) + 1
                                                     FROM MEMBER), 3) = 2 THEN
                        '���� ȸ��'
                   ELSE 
                        'VIP ȸ��'
              END AS ���          
         FROM MEMBER;
         
��뿹) ȸ�� ���̺��� ȸ������ ���ϸ����� 5���� �׷����� ������ ����� ������ ����Ͻÿ�.
       ����� ���ϸ����� ���� ȸ���� 1����̰�, ���� ���� ȸ���� 5����̴�.
       Alias�� ȸ����ȣ, ȸ����, ����, ���ϸ���, ���
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���,
              CASE WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 1 THEN
                        '5���'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 2 THEN
                        '4���'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 3 THEN
                        '3���'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 4 THEN
                        '2���'     
                   ELSE 
                        '1���'
              END AS ���          
         FROM MEMBER;
         
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���,
              WIDTH_BUCKET(MEM_MILEAGE, 9000, 500, 5)||'���' AS ���          
         FROM MEMBER;
         -- ����� ����(EX)�ִ밪�� 1���, �ּҰ��� 5���)���� �Ϸ��� max�� min���� ���� �ٲپ��ָ� ��
         
         -- �����Լ��� ROUND, MOD�� �ַ� �����
         -- �����Լ��� SUBSTR, REPLACE, TRIM�� �ַ� �����
         
         COMMIT;
         