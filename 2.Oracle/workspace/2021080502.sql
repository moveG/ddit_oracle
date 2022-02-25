2021-0805-02) Ʈ����(Trigger)
    - Ư�� �̺�Ʈ�� �߻� ���� �Ǵ� ���Ŀ� �ڵ����� ����Ǿ���� ���ν���
    - Ʈ���Ŵ� ������� Ʈ���ſ� ����� Ʈ���ŷ� ���е�
    - ������� Ʈ������ ����� Ʈ���Ű� �Ϸ���� ���� ���¿��� �Ǵٸ� Ʈ���Ÿ� ȣ���ϸ�
      ���̺��� �ϰ��� ������ ���� �ش� ���̺��� ������ ������
    -- �߸� ����ϸ� ���� �ɷ� ���̺� ���� ������ ������ �� �����Ƿ�, ��뿡 ���ǰ� �ʿ���  
    -- ������� Ʈ���Ŵ� Ư�� �̺�Ʈ�� �߻��ϸ� ���� �ѹ��� �����
    -- ����� Ʈ���Ŵ� �������� ���� ������Ʈ ���� �����ɶ����� �� �ึ�� Ʈ���Ű� ���� �߻���
    -- Ʈ���� �Լ�(COLUMN NEW, COLUMN OLD)�� ������
    (�������)
      CREATE [OR REPLACE] TRIGGER Ʈ���Ÿ�
        timming[BEFORE|AFTER] event[INSERT|UPDATE|DELETE]
        ON ���̺��
        [FOR EACH ROW]
        [WHEN ����]
     [DECLARE
        �����
     ]
      BEGIN
        ����� -- Ʈ������ ����, Ʈ���ŷ� ó���ؾ��� ����
      END;
      . 'BEFORE|AFTER' : '�����'(Ʈ������ ����)�� ����� ����
      -- ��ǰ�� �԰�(BUYPROD UPDATE)�� ��(AFTER), ��� ���̺�(REMAIN UPDATE)�� �Է�
      . 'INSERT|UPDATE|DELETE' : Ʈ���Ÿ� �߻���Ű�� �̺�Ʈ�� OR �����ڷ� ������ ��� ����
        ex) INSERT OR DELETE, INSERT OR UPDATE OR DELETE etc...
      . 'FOR EACH ROW' : ����� Ʈ���Ž� ���(�����ϸ� ������� Ʈ����)
      . 'WHEN ����' : ����� Ʈ���ſ����� ����� �����ϸ�, �̺�Ʈ �߻��� ���� ��ü���� ������ �����
      -- COMMIT���� ������ Ȧ���� �Ǿ� �ٸ� ����� �̿��� �� �����Ƿ�, INSERT, UPDATE, DELETE �ڿ��� �׻� COMMIT�� ���ִ� ���� ����
      -- TRIGGER�� Ʈ���Ÿ��� �Ϲ������� 'TR_'�� ������
      -- TRIGGER�� ������ BEGIN ����ο� ������
      
��뿹) �з� ���̺� ���ο� �з��ڵ带 �����ϰ�, ���� �� '���ο� �з��� �߰��Ǿ����ϴ�.'�� ����ϴ� Ʈ���Ÿ� �ۼ��Ͻÿ�.
       [�з��ڵ� : 'P502', �з��� : '�ӻ깰', ���� : 11]
       (������� Ʈ����)
       CREATE OR REPLACE TRIGGER TG_LPROD_INSERT -- TRIGGER�� Ʈ���Ÿ��� �Ϲ������� 'TR_'�� ������
         AFTER INSERT ON LPROD
       BEGIN
         DBMS_OUTPUT.PUT_LINE('���ο� �з��� �߰��Ǿ����ϴ�.');
       END;
       
       INSERT INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)
         VALUES (13, 'P504', '����깰');
       
       COMMIT;
       
       SELECT * FROM LPROD;
       -- Ʈ������ ����� ������ ���ο� ������ �˻��������
       -- Ʈ���� ���ο����� DML��ɾ ����� �� ����
       
       CREATE OR REPLACE TRIGGER TG_LPROD_INSERT
         AFTER DELETE ON LPROD
       BEGIN
         DBMS_OUTPUT.PUT_LINE('�з��� �����Ǿ����ϴ�.');
       END;      
      
       DELETE LPROD
        WHERE LPROD_ID = 13;
       
       COMMIT;
       
       SELECT * FROM LPROD;
       
��뿹) ���� ��¥�� 2005�� 6�� 11���̸� ��ǰ�ڵ尡 'P102000005'�� ��ǰ�� ó�� 10�� �����ߴ� �����ϰ�,
       �� ������ ���� ���̺� �����ϰ� ������ ���̺��� �����ϴ� Ʈ���Ÿ� �ۼ��Ͻÿ�.
       (����� Ʈ����)
       CREATE OR REPLACE TRIGGER TG_BUYPROD_INSERT -- Ʈ���Ŵ� �ڵ����� ȣ��Ǿ� �����
         AFTER INSERT ON BUYPROD -- TRIGGER�� ��������� ������, BUYPROD ���̺��� INSERT ���� ������ �����, BEGIN ����� ������ �����
         FOR EACH ROW
       DECLARE
         V_QTY NUMBER := :NEW.BUY_QTY;
         V_PROD PROD.PROD_ID%TYPE := :NEW.BUY_PROD; -- :NEW�� ���� ���� ���� ��
       BEGIN -- Ʈ������ ����, Ʈ���� ����� BEGIN ����� ������ �����
         UPDATE REMAIN
            SET REMAIN_I = REMAIN_I + V_QTY, -- V_QTY ��� :NEW.BUY_QTY ��� ����
                REMAIN_J_99 = REMAIN_J_99 + V_QTY,
                REMAIN_DATE = TO_DATE('20050611')
          WHERE REMAIN_YEAR = '2005'
            AND PROD_ID = :NEW.BUY_PROD; -- :NEW.BUY_PROD ��� V_PROD ��� ����
         DBMS_OUTPUT.PUT_LINE(:NEW.BUY_PROD||'��ǰ�� '||V_QTY||'�� �԰�Ǿ����ϴ�.');
       END;
       
       (����)
       INSERT INTO BUYPROD
         SELECT TO_DATE('20050611'), PROD_ID, 10, PROD_COST
           FROM PROD
          WHERE PROD_ID = 'P102000005';
       
       COMMIT;
       
  1. Ʈ���� �ǻ緹�ڵ� - ����� Ʈ���ſ����� ����� ������
    1) :NEW - INSERT, UPDATE �̺�Ʈ�� ���
              �����Ͱ� ����(����)�Ǵ� ��� ���Ӱ� ���� ��
              DELETE �ÿ��� ��� NULL��
    2) :OLD - DELETE, UPDATE �̺�Ʈ�� ���
              �����Ͱ� ����(����)�Ǵ� ��� �̹� �����ϰ� �ִ� ��
              INSERT �ÿ��� ��� NULL��
              
  2. Ʈ���� �Լ�
    - Ʈ������ �̺�Ʈ�� �����ϱ� ���� �Լ�
    1) INSERTING : Ʈ������ �̺�Ʈ�� INSERT�̸� ��
    2) UPDATING : Ʈ������ �̺�Ʈ�� UPDATE�̸� ��
    3) DELETING : Ʈ������ �̺�Ʈ�� DELETE�̸� ��
       
��뿹) ����(2005�� 08�� 06��) 'h001'ȸ��(����ȣ)�� ��ǰ 'P202000019'�� 5�� �������� ��,
       CART ���̺�� ������ ���̺� �ڷḦ ���� �� �����Ͻÿ�.
       -- REMAIN_YEAR : ���⵵
       -- PROD_ID : ��� ��ǰ�ڵ�
       -- REMAIN DATE : �ֽų�¥
       -- REMAIN_J_00 : �������
       -- REMAIN_J_99 : �⸻���(�������)
       -- REMAIN_I : �԰�
       -- REMAIN_O : ���
       -- �ڵ����� : ���ϴ� ���� ��� + Ctrl + F7
       (����� Ʈ����)
       CREATE OR REPLACE TRIGGER TG_CART_CHANGE
         AFTER INSERT OR UPDATE OR DELETE ON CART
         FOR EACH ROW -- �� �ึ�� ó����
       DECLARE
         V_QTY NUMBER := 0; -- ���Լ���
         V_PID PROD.PROD_ID%TYPE; -- ��ǰ�ڵ�
         V_DATE DATE; -- ��¥
       BEGIN
         IF INSERTING THEN -- ��ǰ�� ������, ���(REMAIN_O) ����, ���(REMAIN_J_99) ����
           V_QTY := NVL(:NEW.CART_QTY, 0);
           V_PID := :NEW.CART_PROD;
           V_DATE := TO_DATE(SUBSTR(:NEW.CART_NO, 1, 8));
         ELSIF UPDATING THEN -- ��ǰ ���Լ����� ������(5 -> 2), 5�� OLD, 2�� NEW, ��� ����, ��� ����
           V_QTY := NVL(:NEW.CART_QTY, 0) - NVL(:OLD.CART_QTY, 0);
           V_PID := :NEW.CART_PROD;
           V_DATE := TO_DATE(SUBSTR(:NEW.CART_NO, 1, 8));
         ELSIF DELETING THEN -- ������ �����, ��� ����, ��� ����
           V_QTY := -(NVL(:OLD.CART_QTY, 0));
           V_PID := :OLD.CART_PROD;
           V_DATE := TO_DATE(SUBSTR(:OLD.CART_NO, 1, 8));
         END IF;
         
         UPDATE REMAIN
            SET REMAIN_O = REMAIN_O + V_QTY,
                REMAIN_J_99 = REMAIN_J_99 - V_QTY,
                REMAIN_DATE = V_DATE
          WHERE REMAIN_YEAR = '2005'
            AND PROD_ID = V_PID;
         
         EXCEPTION WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('�����߻� : '||SQLERRM);
       END;
       
       (����)
       ACCEPT P_AMT PROMPT '���� : '
       DECLARE
         V_CNT NUMBER := 0;
         V_CARTNO CHAR(13);
         V_AMT NUMBER := TO_NUMBER('&P_AMT');
       BEGIN
         SELECT COUNT(*) INTO V_CNT
           FROM CART
          WHERE CART_NO LIKE '20050806%';
         
         IF V_CNT = 0 THEN
           V_CARTNO := '2005080600001';
           INSERT INTO CART(CART_MEMBER, CART_NO, CART_PROD, CART_QTY)
             VALUES('h001', V_CARTNO, 'P202000019', V_AMT);
         ELSE -- ������ ������ �ʿ���
           IF V_AMT != 0 THEN
             UPDATE CART 
                SET CART_QTY = V_AMT
              WHERE CART_NO = '2005080600001'
                AND CART_PROD = 'P202000019';
           ELSE
             DELETE CART
              WHERE CART_NO = '2005080600001'
                AND CART_PROD = 'P202000019';
           END IF;
         END IF;
         COMMIT;
       END;