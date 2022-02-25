2021-0726-02) ��������
  - SQL���� �ȿ� �Ǵٸ� SQL������ ���Ե� ����
  - �ٱ��� ������ ��������, ���� ������ ����������� ��
  - ���������� ���������� ����� ��ȯ�ϱ� ���� �߰� ����� ���
  - ���������� '( )'�� ���� �����(���� INSERT���� ���Ǵ� ���������� '( )'�� ������� ����)
  - ���������� ���Ǵ� ��ġ�� ���� �Ϲ� ��������(SELECT ��), �ζ��� ��������(FROM ��), ��ø ��������(WHERE ��)�� ����
  - ��ȯ�ϴ� ����� ��/���� ������ ���� ������/���Ͽ�, ������/���߿�, ������/���߿��� ����
  - ���������� ���������� ���Ǵ� ���̺� ���� ���� ���ο� ���� ���ü� ���� ��������/�������������� ����
  - �˷����� ���� ���ǿ� �ٰ��Ͽ� �����͸� �˻��ϴ� ��� ����

    1) ������ ��������
      . �ϳ��� �ุ ����� ��ȯ
      . ������ �����ڴ� ���迬����(=, !=, >, <, >=, <=)��
      
��뿹) 
       SELECT EMPLOYEE_ID, EMP_NAME
         FROM HR.EMPLOYEES
        WHERE (DEPARTMENT_ID, MANAGER_ID) = (SELECT DEPARTMENT_ID, MANAGER_ID -- �񱳵� �������� ���� ���ƾ���
                                               FROM HR.DEPARTMENTS
                                              WHERE MANAGER_ID = 121);

    2) ������ ��������
      . �ϳ� �̻����� ���� ��ȯ�ϴ� ��������
      . ������ ������ : IN, ANY, SOME, ALL, EXISTS
      
��뿹) ��� ���̺��� ������ ���� 10�� �̻��� �μ��� ����Ͻÿ�.
       Alias�� �μ��ڵ�, �μ���
       (�������� : �μ��ڵ�, �μ��� ���)
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID = (��������)
        
       (�������� : ������ ���� 10�� �̻��� �Ǵ� �μ��� �μ��ڵ�)
       SELECT B.DID
         FROM (SELECT DEPARTMENT_ID AS DID,
                      COUNT(*)
                 FROM HR.EMPLOYEES
                GROUP BY DEPARTMENT_ID
               HAVING COUNT(*) >= 10) B;
       -- �����ռ��� COUNT�� WHERE���� �� �� ����, HAVING���� �־ ������ ����������

       (���� : ANY(=SOME) ������ ���)
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID = ANY (SELECT B.DID
                                       FROM (SELECT DEPARTMENT_ID AS DID,
                                                    COUNT(*)
                                               FROM HR.EMPLOYEES
                                              GROUP BY DEPARTMENT_ID
                                             HAVING COUNT(*) >= 10) B);
                                            
       (���� : IN ������ ���)
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID IN (SELECT B.DID
                                    FROM (SELECT DEPARTMENT_ID AS DID,
                                                 COUNT(*)
                                            FROM HR.EMPLOYEES
                                           GROUP BY DEPARTMENT_ID
                                          HAVING COUNT(*) >= 10) B);                                            

       (����: EXISTS ������ ���)
         - EXISTS ������ ������ ǥ����(�� OR �÷���)�� ����
         - EXISTS ������ �������� �ݵ�� ��������
       SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.DEPARTMENTS A
        WHERE EXISTS (SELECT 1 -- C.DID���ٴ� 1�� ���� �����
                        FROM (SELECT B.DEPARTMENT_ID AS DID,
                                     COUNT(*)
                                FROM HR.EMPLOYEES B
                               GROUP BY B.DEPARTMENT_ID
                              HAVING COUNT(*) >= 10) C
                       WHERE C.DID = 50 OR C.DID = 80); --A.DEPARTMENT_ID);

    3) ���߿� ��������
      . �ϳ� �̻����� ���� ��ȯ�ϴ� ��������
      . PAIRWISE(�ֺ�) �������� �Ǵ� Nonpairwise(��ֺ�) ���������� ����
      
��뿹) 80�� �μ����� �޿��� ��� �̻��� ����� ��ȸ�Ͻÿ�.
       Alias�� �����ȣ, �޿�, �μ��ڵ�
       (PARWISE ��� �����)
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.SALARY �޿�,
              A.DEPARTMENT_ID AS �μ��ڵ�
         FROM HR.EMPLOYEES A
        WHERE (A.EMPLOYEE_ID, A.DEPARTMENT_ID) IN (SELECT B.EMPLOYEE_ID, B.DEPARTMENT_ID
                                                     FROM HR.EMPLOYEES B
                                                    WHERE B.SALARY >= (SELECT AVG(C.SALARY)
                                                                         FROM HR.EMPLOYEES C
                                                                        WHERE C.DEPARTMENT_ID = B.DEPARTMENT_ID)
                                                      AND B.DEPARTMENT_ID = 80)
        ORDER BY 3, 2;

       (������ ���)
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.SALARY �޿�,
              A.DEPARTMENT_ID AS �μ��ڵ�
         FROM HR.EMPLOYEES A
        WHERE A.DEPARTMENT_ID = 80
          AND A.SALARY >= (SELECT AVG(SALARY)
                             FROM HR.EMPLOYEES
                            WHERE DEPARTMENT_ID = 80)
        ORDER BY 3, 2;
        
        COMMIT;
        