2021-0709-02)
  (4) LIKE ������
    . ������ ���� �� ���
    . ���ڿ��� ���� �� ���
    . ���ϵ�ī��� '%'�� '_'�� ���Ǿ� ���� ���ڿ��� ����
    . '%' : '%'�� ���� ��ġ ������ ��� ���ڿ��� ����
      EX) '����%' : '����'���� ���۵Ǵ� ��� �ܾ�� ����
          '��%��' : ù ���ڰ� '��'�̰� ������ ���ڰ� '��'�� ��� �ܾ�� ����
          '%��'   : �� ���ڰ� '��'�� ��� �ܾ�� ����
          
��뿹) ȸ�����̺��� ������ �����ϴ� ȸ������ ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, �ּ�, ����, ���ϸ����̴�.
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
              MEM_JOB AS ����,
              MEM_MILEAGE AS ���ϸ���
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '����%';
        
����) ��ٱ������̺��� 2005�� 7�� �Ǹ���Ȳ�� ��ȸ�Ͻÿ�.
      Alias�� ����, ��ǰ�ڵ�, �Ǹż����̴�.
      (LIKE ������ ���)
      SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS ����,
             CART_PROD AS ��ǰ�ڵ�,
             CART_QTY AS �Ǹż���
        FROM CART
       WHERE CART_NO LIKE '200507%';
      -- TO_DATE() �Լ�: ���ڿ��� ��¥�� ��ȯ��
      -- SUBSTR �Լ�: ���ڿ��� ������
      -- 6��, 7�� �Ǹ���Ȳ�� LIKE �Լ��δ� ���� �� ����
      -- �����;��� ���� ��� LIKE �Լ��� ����ϸ� ��µǴ� ���� �ʹ� ���� �������� ��찡 �����Ƿ� ����� �����ϴ� ���� ����
      
      (BETWEEN ������ ���)
      SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS ����,
             CART_PROD AS ��ǰ�ڵ�,
             CART_QTY AS �Ǹż���
        FROM CART
       WHERE SUBSTR(CART_NO,1,6) BETWEEN TO_NUMBER('200506') AND TO_NUMBER('200507');
      -- SUBSTR�� BETWEEN�� ����������� BETWEEN�� %�� ��� �ȵ� EX) BETWEEN TO_NUMBER('200506%') AND ~ (X)
       
 COMMIT;     