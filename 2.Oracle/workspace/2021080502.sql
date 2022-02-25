2021-0805-02) 트리거(Trigger)
    - 특정 이벤트의 발생 이전 또는 이후에 자동으로 실행되어야할 프로시져
    - 트리거는 문장단위 트리거와 행단위 트리거로 구분됨
    - 문장단위 트리거의 수행시 트리거가 완료되지 않은 상태에서 또다른 트리거를 호출하면
      테이블의 일관성 유지를 위해 해당 테이블의 접근이 금지됨
    -- 잘못 사용하면 락이 걸려 테이블에 대한 접근이 금지될 수 있으므로, 사용에 주의가 필요함  
    -- 문장단위 트리거는 특정 이벤트가 발생하면 오직 한번만 실행됨
    -- 행단위 트리거는 여러개의 행이 업데이트 삭제 수정될때마다 각 행마다 트리거가 각각 발생함
    -- 트리거 함수(COLUMN NEW, COLUMN OLD)가 존재함
    (사용형식)
      CREATE [OR REPLACE] TRIGGER 트리거명
        timming[BEFORE|AFTER] event[INSERT|UPDATE|DELETE]
        ON 테이블명
        [FOR EACH ROW]
        [WHEN 조건]
     [DECLARE
        선언부
     ]
      BEGIN
        실행부 -- 트리거의 내용, 트리거로 처리해야할 쿼리
      END;
      . 'BEFORE|AFTER' : '실행부'(트리거의 본문)가 실행될 시점
      -- 제품을 입고(BUYPROD UPDATE)한 뒤(AFTER), 재고 테이블(REMAIN UPDATE)에 입력
      . 'INSERT|UPDATE|DELETE' : 트리거를 발생시키는 이벤트로 OR 연산자로 복수개 사용 가능
        ex) INSERT OR DELETE, INSERT OR UPDATE OR DELETE etc...
      . 'FOR EACH ROW' : 행단위 트리거시 기술(생략하면 문장단위 트리거)
      . 'WHEN 조건' : 행단위 트리거에서만 사용이 가능하며, 이벤트 발생에 대한 구체적인 조건을 기술함
      -- COMMIT하지 않으면 홀딩이 되어 다른 사람은 이용할 수 없으므로, INSERT, UPDATE, DELETE 뒤에는 항상 COMMIT을 해주는 것이 좋음
      -- TRIGGER의 트리거명은 일반적으로 'TR_'로 시작함
      -- TRIGGER의 본문은 BEGIN 실행부에 존재함
      
사용예) 분류 테이블에 새로운 분류코드를 삽입하고, 삽입 후 '새로운 분류가 추가되었습니다.'를 출력하는 트리거를 작성하시오.
       [분류코드 : 'P502', 분류명 : '임산물', 순번 : 11]
       (문장단위 트리거)
       CREATE OR REPLACE TRIGGER TG_LPROD_INSERT -- TRIGGER의 트리거명은 일반적으로 'TR_'로 시작함
         AFTER INSERT ON LPROD
       BEGIN
         DBMS_OUTPUT.PUT_LINE('새로운 분류가 추가되었습니다.');
       END;
       
       INSERT INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)
         VALUES (13, 'P504', '농축산물');
       
       COMMIT;
       
       SELECT * FROM LPROD;
       -- 트리거의 출력을 보려면 새로운 내용을 검색해줘야함
       -- 트리거 내부에서는 DML명령어를 사용할 수 없음
       
       CREATE OR REPLACE TRIGGER TG_LPROD_INSERT
         AFTER DELETE ON LPROD
       BEGIN
         DBMS_OUTPUT.PUT_LINE('분류가 삭제되었습니다.');
       END;      
      
       DELETE LPROD
        WHERE LPROD_ID = 13;
       
       COMMIT;
       
       SELECT * FROM LPROD;
       
사용예) 오늘 날짜가 2005년 6월 11일이며 제품코드가 'P102000005'인 상품을 처음 10개 매입했다 가정하고,
       이 정보를 매입 테이블에 저장하고 재고수불 테이블을 변경하는 트리거를 작성하시오.
       (행단위 트리거)
       CREATE OR REPLACE TRIGGER TG_BUYPROD_INSERT -- 트리거는 자동으로 호출되어 실행됨
         AFTER INSERT ON BUYPROD -- TRIGGER의 실행시점을 설정함, BUYPROD 테이블에서 INSERT 동작 다음에 실행됨, BEGIN 블록의 내용이 실행됨
         FOR EACH ROW
       DECLARE
         V_QTY NUMBER := :NEW.BUY_QTY;
         V_PROD PROD.PROD_ID%TYPE := :NEW.BUY_PROD; -- :NEW는 참조 후의 열의 값
       BEGIN -- 트리거의 내용, 트리거 실행시 BEGIN 블록의 내용이 실행됨
         UPDATE REMAIN
            SET REMAIN_I = REMAIN_I + V_QTY, -- V_QTY 대신 :NEW.BUY_QTY 사용 가능
                REMAIN_J_99 = REMAIN_J_99 + V_QTY,
                REMAIN_DATE = TO_DATE('20050611')
          WHERE REMAIN_YEAR = '2005'
            AND PROD_ID = :NEW.BUY_PROD; -- :NEW.BUY_PROD 대신 V_PROD 사용 가능
         DBMS_OUTPUT.PUT_LINE(:NEW.BUY_PROD||'상품이 '||V_QTY||'개 입고되었습니다.');
       END;
       
       (실행)
       INSERT INTO BUYPROD
         SELECT TO_DATE('20050611'), PROD_ID, 10, PROD_COST
           FROM PROD
          WHERE PROD_ID = 'P102000005';
       
       COMMIT;
       
  1. 트리거 의사레코드 - 행단위 트리거에서만 사용이 가능함
    1) :NEW - INSERT, UPDATE 이벤트시 사용
              데이터가 삽입(갱신)되는 경우 새롭게 들어온 값
              DELETE 시에는 모두 NULL임
    2) :OLD - DELETE, UPDATE 이벤트시 사용
              데이터가 삭제(갱신)되는 경우 이미 존재하고 있던 값
              INSERT 시에는 모두 NULL임
              
  2. 트리거 함수
    - 트리거의 이벤트를 구별하기 위한 함수
    1) INSERTING : 트리거의 이벤트가 INSERT이면 참
    2) UPDATING : 트리거의 이벤트가 UPDATE이면 참
    3) DELETING : 트리거의 이벤트가 DELETE이면 참
       
사용예) 오늘(2005년 08월 06일) 'h001'회원(라준호)이 상품 'P202000019'을 5개 구입했을 때,
       CART 테이블과 재고수불 테이블에 자료를 삽입 및 갱신하시오.
       -- REMAIN_YEAR : 재고년도
       -- PROD_ID : 재고 제품코드
       -- REMAIN DATE : 최신날짜
       -- REMAIN_J_00 : 기초재고
       -- REMAIN_J_99 : 기말재고(현재재고)
       -- REMAIN_I : 입고
       -- REMAIN_O : 출고
       -- 자동정렬 : 원하는 범위 블록 + Ctrl + F7
       (행단위 트리거)
       CREATE OR REPLACE TRIGGER TG_CART_CHANGE
         AFTER INSERT OR UPDATE OR DELETE ON CART
         FOR EACH ROW -- 각 행마다 처리됨
       DECLARE
         V_QTY NUMBER := 0; -- 구입수량
         V_PID PROD.PROD_ID%TYPE; -- 상품코드
         V_DATE DATE; -- 날짜
       BEGIN
         IF INSERTING THEN -- 제품을 구입함, 출고량(REMAIN_O) 증가, 재고(REMAIN_J_99) 감소
           V_QTY := NVL(:NEW.CART_QTY, 0);
           V_PID := :NEW.CART_PROD;
           V_DATE := TO_DATE(SUBSTR(:NEW.CART_NO, 1, 8));
         ELSIF UPDATING THEN -- 제품 구입수량을 변경함(5 -> 2), 5가 OLD, 2가 NEW, 출고량 감소, 재고 증가
           V_QTY := NVL(:NEW.CART_QTY, 0) - NVL(:OLD.CART_QTY, 0);
           V_PID := :NEW.CART_PROD;
           V_DATE := TO_DATE(SUBSTR(:NEW.CART_NO, 1, 8));
         ELSIF DELETING THEN -- 구입을 취소함, 출고량 감소, 재고 증가
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
         DBMS_OUTPUT.PUT_LINE('오류발생 : '||SQLERRM);
       END;
       
       (실행)
       ACCEPT P_AMT PROMPT '수량 : '
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
         ELSE -- 교수님 수정이 필요함
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