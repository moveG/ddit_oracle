2021-0804-01)
      (3) FOR ��
        - ���߾���� FOR���� ������ ����
        - �Ϲ� �ݺ�ó���� ���� FOR���� CURSORó���� ���� FOR���� ������
        -- �ݺ�ȸ���� ��Ȯ�ϰ� �˰ų� �ݺ�ȸ���� �߿��ϸ� FOR���� ���
        -- �ݺ�ȸ���� ��Ȯ�ϰ� ���� ���ϰų� �ݺ�ȸ���� �߿����� ������, ���������� ó���ؾ��� ������ �˰� ������ WHILE���� ���
        (�Ϲ� FOR�� �������)
          FOR �ε��� IN [REVERSE] �ʱⰪ..�ִ밪 LOOP -- �ʱⰪ~�ִ밪���� 1�� ������, '..'�� ������ �� ����
            �ݺ�ó����ɹ�(��);
          END LOOP;
          . '�ε���' : ������� ���� �ε����� �ý��ۿ��� �ڵ����� ��������, ������ ������ �ʿ䰡 ����
          . 'REVERSE' : �������� �ݺ�ó���� �����

��뿹) �������� 7���� ����ϴ� ����� �ۼ��Ͻÿ�.
       DECLARE
         -- ����ΰ� ��� �ۼ� ����
       BEGIN
         FOR I IN 1..9 LOOP
           DBMS_OUTPUT.PUT_LINE(7||' * '||I||' = '||7 * I);
         END LOOP;
       END;
       
��뿹) �������� ��� ���� ����ϴ� ����� �ۼ��Ͻÿ�.
       DECLARE
         -- ����ΰ� ��� �ۼ� ����
       BEGIN
         FOR J IN 2..9 LOOP
           FOR I IN 1..9 LOOP
             DBMS_OUTPUT.PUT_LINE(J||' * '||I||' = '||J * I);
           END LOOP;
           DBMS_OUTPUT.PUT_LINE('');
         END LOOP; 
       END;
       
��뿹) ù���� 100���� �����ϰ�, �� ���������� ������ 2�辿 ������ ��, ���ʷ� 200������ �Ѵ� ���� ����ݾ��� ���Ͻÿ�.
       -- ��Ȯ�� ���� �𸣹Ƿ� ���� �� �ֱ��� FOR���� �ۼ��ϰ� 200������ ������ FOR���� ���������� �ϸ� ��
       DECLARE
         V_SUM NUMBER := 0; -- �����հ� �ݾ�
         V_DSUM NUMBER := 100; -- �Ϻ� ����׼�
         V_DAYS NUMBER := 0; -- ��¥, ��¥�� I�� �� �� �ִµ�, I�� FOR�� �ۿ��� ����� �� �����Ƿ� I�� ������ ������ ��������
       BEGIN
         FOR I IN 1..1000 LOOP
           V_SUM := V_SUM + V_DSUM;
           V_DAYS := I;
           IF V_SUM >= 2000000 THEN
             EXIT;
           END IF;
           V_DSUM := V_DSUM * 2;
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('�ϼ� : '||V_DAYS||'��');
         DBMS_OUTPUT.PUT_LINE('����ݾ� : '||V_SUM||'��');
       END;
       
        (CURSOR�� ���� FOR�� �������) -- FOR���� CURSOR�� �Բ� ����ϴ� ���� ���� �������� �����
          FOR ���ڵ�� IN Ŀ����|Ŀ������ LOOP
            �ݺ�ó����ɹ�(��);
          END LOOP;
          . '���ڵ��' : Ŀ���� ����Ű�� ���� ���� ������ �ִ� ������ �ý��ۿ��� �ڵ����� ��������, ������ ������ �ʿ䰡 ����
          . Ŀ�� ���� ����(�÷�)�� ������ '���ڵ��.Ŀ���� �÷���' �������� �����
          . Ŀ���� OPEN, FETCH, CLOSE ��� ����
          . Ŀ������ : ���𿵿����� �����ؾ��� Ŀ������ �� 'SELECT'���� �������� �������� ���
          -- DECLARE���� ���������� ���� �ʾƵ� ��

��뿹) 2005�⵵ ��ǰ�� �԰�����հ踦 ����ϴ� ����� �ۼ��Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �԰����
       DECLARE
         V_NUM NUMBER := 1;
         -- DECLARE���� ���������� ���� �ʾƵ� ��
         CURSOR CUR_BUY02 IS
           SELECT B.BUY_PROD AS BID,
                  A.PROD_NAME AS PNAME,
                  SUM(B.BUY_QTY) AS AMT
             FROM PROD A, BUYPROD B
            WHERE A.PROD_ID = B.BUY_PROD
              AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
            GROUP BY B.BUY_PROD, A.PROD_NAME;
       BEGIN
         FOR REC1 IN CUR_BUY02 LOOP -- Ŀ���� �� ���� �� ���ڵ�(REC1), �ڵ����� Ŀ���� �� �྿ ����
           DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '||REC1.BID);
           DBMS_OUTPUT.PUT_LINE('��ǰ�� : '||REC1.PNAME);
           DBMS_OUTPUT.PUT_LINE('�Ǹż��� : '||REC1.AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------'||V_NUM);
           V_NUM := V_NUM + 1;
         END LOOP;
       END;

��뿹) 2005�⵵ ��ǰ�� �԰�����հ踦 ����ϴ� ����� �ۼ��Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �԰����
       DECLARE
       BEGIN
         FOR REC1 IN (SELECT B.BUY_PROD AS BID, A.PROD_NAME AS PNAME, SUM(B.BUY_QTY) AS AMT
                        FROM PROD A, BUYPROD B
                       WHERE A.PROD_ID = B.BUY_PROD
                         AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
                       GROUP BY B.BUY_PROD, A.PROD_NAME)
         LOOP
           DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '||REC1.BID);
           DBMS_OUTPUT.PUT_LINE('��ǰ�� : '||REC1.PNAME);
           DBMS_OUTPUT.PUT_LINE('�Ǹż��� : '||REC1.AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------');
         END LOOP;
       END;
       
       COMMIT;