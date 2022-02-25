2021-0709-01)
 1)��Ÿ������
  (1) IN
    . �־��� �� �� ��� �ϳ��� ��ġ�ϸ� TRUE�� ��ȯ
    . OR �����ڷ� ġȯ ����
    . NOT �����ڿ� �Բ� ��� ������
    (�������)
     expr IN(��1[,��2,...])
     -- ���� ������ ���� �˻�: AND �Ǵ� BETWEEN ������ ���
     -- �ұ�Ģ�ϰ� ���õǴ� ���� �˻�: OR, IN, ANY, SOME ������ �Ǵ� EXIST�����ڸ� ���
     
 (�÷��� �߰�)
  ALTER TABLE ���̺��
    ADD(�÷��� ������ Ÿ��[(ũ��)] [DEFAULT �ʱⰪ]);

 (�÷��� ����)    
  ALTER TABLE ���̺�� DROP COLUMN �÷���;
  
 (�÷��̸��� ����)
  ALTER TABLE ���̺�� RENAME COLUMN �����÷��� TO ���ο��÷���;
  
 (�÷�Ÿ���� ����)
  ALTER TABLE ���̺��
 MODIFY(�÷��� ������ Ÿ��[(ũ��)] [DEFAULT �ʱⰪ]);

**������̺��� FIRST_NAME�� LAST_NAME�� ���� EMP_NAME�׸��� �����ÿ�.

**������̺��� EMP_NAME VARCHAR2(80) �÷��� �߰��Ͻÿ�.
  ALTER TABLE HR.EMPLOYEES
    ADD(EMP_NAME VARCHAR2(80));

  COMMIT;

**FIRST_NAME�� LAST_NAME���� EMP_NAME�� �����Ͻÿ�.
  UPDATE HR.EMPLOYEES
     SET EMP_NAME=FIRST_NAME||' '||LAST_NAME;

  COMMIT;

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
     -- WHERE DEPARTMENT_ID =ANY(10, 30, 40, 60)
        WHERE DEPARTMENT_ID =SOME(10, 30, 40, 60)
        ORDER BY 3;

  (2) ALL
    . ( )�ȿ� �־��� ������ ��� �����ؾ� ����� ��(TRUE)�� ��
    . AND �����ڷ� ġȯ ����
    (�������)
     �÷��� ���迬����ALL [��1[,��2,...])

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
     --                   FROM HR.EMPLOYEES
     --                  WHERE DEPARTMENT_ID IN(20, 40, 70));                            

  (3) BETWEEN ~ AND
    . ������ �����Ͽ� ���� ��ȸ�ϴ� ���ǹ� ������ ���
    . �� ������ 'AND'�� ġȯ ����
    -- ��� ������ ��(����, ���� ��)�� ���� ������ �����ؼ� ��� ����
    -- ��¥ ��ȸ�� �� LIKE���� BETWEEN�� ������

��뿹) �����������̺�(BUYPROD)���� 2005�� 3�� ������Ȳ�� ����Ͻÿ�.
       Alias�� ��¥, ��ǰ�ڵ�, ���Լ���, ���Աݾ��̴�.
       (AND ������ ���)
       SELECT BUY_DATE AS ��¥,
              BUY_PROD AS ��ǰ�ڵ�,
              BUY_QTY AS ���Լ���,
              BUY_QTY * BUY_COST AS ���Աݾ�
         FROM BUYPROD
        WHERE BUY_DATE >=TO_DATE('20050301')
          AND BUY_DATE <=LAST_DAY(TO_DATE('20050301'));
        -- AUTO CAST: �ڵ� ����ȯ, JAVA���� ���� ���
        -- ����ŬSQL������ ����, ��¥, ���ڿ� ������ �߿��ϰ� �����                 
        -- TO_DATE() �Լ�: ���ڿ��� ��¥�� ��ȯ��
        -- LAST_DAY(): ���� ���� ������ ��¥�� ��ȯ��(2�� ���� ������ ��¥(28�� OR 29��) ��꿡 ����)

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
        WHERE EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR) BETWEEN 40 AND 49;
        
     **ȸ���� ������� �÷����� ���� �����Ͻÿ�.
       SELECT EXTRACT(MONTH FROM MEM_BIR),
              SUBSTR(MEM_BIR,5,2)
         FROM MEMBER;
       -- SUBSTR�� ����� ��¥�� �ƴ�, ���ڿ��̴�

     **ȸ�����̺��� �̹����� ������ �ִ� ȸ����ȣ, ȸ������ ��ȸ�Ͻÿ�.
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����
         FROM MEMBER
        WHERE EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM MEM_BIR);
     -- WHERE EXTRACT(MONTH FROM SYSDATE) = SUBSTR(MEM_BIR,6,2); 
     -- ��¥�� SUBSTR�� �� ��� ���м�(EX.2000/01/01)�� ����ؾ��Ѵ�.

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
       
 COMMIT;