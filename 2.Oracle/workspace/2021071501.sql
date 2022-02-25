2021-0715-01)
  3. ��¥�Լ�
   1) SYSDATE
    - �ý��ۿ��� �����ϴ� ��¥����(��, ��, ��, ��, ��, ��)�� ��ȯ
    - '+', '-' ������ ���
    - ��¥ - ��¥ : �� ��¥ ������ ����(DAYS)�� ��ȯ
    -- ��¥������ ����ڰ� ���� �Է��� ��� ��ǻ�� ���������� �����ؼ��� �ȵ�
    -- ��, ��, �� �� �Ϻΰ� �����Ǹ� ��¥�� �ν����� ����
    -- ���� ���� ����
    
��뿹)
       SELECT SYSDATE - 10,
              TO_CHAR(SYSDATE, 'YYYY MM DD HH24:MI:SS'),
              TRUNC(SYSDATE - TO_DATE('19900715'))
         FROM DUAL;

   2) ADD_MONTHS(d, n)
    - ��¥������ �ڷ� d�� n��ŭ�� ���� ���� ��¥�� ��ȯ
    
��뿹) ����� ���� �Ի����� �����Ⱓ 3������ ���� ��¥�̴�. �� ����� �� ȸ�翡 ó�� �Ի��� ��¥�� ���Ͻÿ�.
       Alias�� �����ȣ, �����, �Ի���, �����Ի���, �ҼӺμ�
       SELECT A.EMPLOYEE_ID AS �����ȣ,
              A.EMP_NAME AS �����,
              A.HIRE_DATE AS �Ի���,
              ADD_MONTHS(A.HIRE_DATE, -3) AS �����Ի���,
              B.DEPARTMENT_NAME AS �ҼӺμ�              
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        ORDER BY 5;
        -- ��ü�ο��� 107���ε�, 106�� ��µ�
        -- �ҼӺμ� ���� ����(NULL) ������ ��¿��� ���ܵ�, ���ǿ� ���յ��� ���� ���� ��¿��� ���ܵ�

   3) NEXT_DAY(d, expr)
    - �־��� ��¥ d���� �ٰ��� ���� ���� 'expr'������ ��¥�� ��ȯ
    - expr : ��, ȭ, ..., ��, ������, ȭ����, ..., �Ͽ���
    -- ���� ���� ���Ͽ��� ������ ������
    -- ��� �󵵴� ����
    
��뿹) 
       SELECT NEXT_DAY(SYSDATE, '��'),
              NEXT_DAY(SYSDATE, '��'),
              NEXT_DAY(SYSDATE, '�Ͽ���')
         FROM DUAL;
         
   4) LAST_DAY(d)
    - ��¥�ڷ� d�� ���Ե� ���� ������ ���� ��ȯ
    -- �ַ� ���� ������ 2��(28��, 29�� ����)�� ���� ����
    
��뿹) ���� ���̺�(BUYPROD)���� 2���� ���Ե� ���԰Ǽ��� ��ȸ�Ͻÿ�.
       --���԰Ǽ��� BUY_QTY�� ���(�ټ�)
       SELECT COUNT(*) AS ���԰Ǽ�
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050201') AND LAST_DAY(TO_DATE('20050201'));
         
   5) MONTHS_BETWEEN(d1, d2)
    - �� ��¥�ڷ� ������ ���� ��ȯ
    -- ������ �ƴ�, �Ǽ��� ��ȯ��
    -- ��� �󵵴� ����
    
��뿹) 
       SELECT MONTHS_BETWEEN(SYSDATE, HIRE_DATE) AS �ټӰ�����
         FROM HR.EMPLOYEES;

       SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS �ټӰ�����
         FROM HR.EMPLOYEES;

       SELECT EMP_NAME,
              HIRE_DATE,
              TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) ||'�� '|| 
              MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), 12) ||'����' AS �ټӱⰣ
         FROM HR.EMPLOYEES;

   6) EXTRACT(fmt FROM d)
    - ��¥�ڷ� d���� 'fmt'�� ����� �ڷḦ ������
    - ��ȯ���� ������ ����������
    - 'fmt' : YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
    -- SYSDATE �������� ���� ����
    -- ���ÿ� �������� ���������� ����
    
��뿹) �̹� �޿� ������ �ִ� ȸ���� ������ ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �������       
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_BIR AS �������
         FROM MEMBER
        WHERE EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM MEM_BIR);
        -- 7���� ������ ��� ����� ����
        
       SELECT EXTRACT(HOUR FROM SYSTIMESTAMP),
              EXTRACT(MINUTE FROM SYSTIMESTAMP),
              EXTRACT(SECOND FROM SYSTIMESTAMP)
         FROM DUAL;
    
    COMMIT;
