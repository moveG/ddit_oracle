2021-0805-01) User Defined Function(함수)
    - 프로시져와 장점 등이 유사함
    - 반환값이 있음 -- 프로시져는 반환값이 없음
    - 자주 사용되는 서브쿼리 또는 복잡한 산술식 등을 함수로 구현
    - SELECT 문의 SELECT절, WHERE절에 사용이 가능함 -- 프로시져는 일반쿼리 문에서 사용이 불가능, 독립적으로 실행함
    -- 메서드, 프로시저, 함수 등은 하나의 값만 반환하도록 설계하는 것이 좋음
    (사용형식)
      CREATE [OR REPLACE] FUNCTION 함수명[(
        매개변수 [MODE] 타입 [:=값][,
          :
        매개변수 [MODE] 타입 [:=값]])]
        RETURN 데이터 타입 -- 기본형 데이터 타입만 사용가능함, 참조형 데이터 타입은 사용 불가능함
      IS|AS -- 이 부분을 DECLARE라고 생각하면됨
        선언영역
      BEGIN
        실행영역
        RETURN 값|expr; -- 실제 반환되는 값, 하나만 반환가능
      END;
      . 'RETURN 데이터 타입' : 반환할 데이터 타입
      . 'RETURN 값|expr' : 반환해야하는 값 또는 값을 산출하는 수식 등으로 반드시 1개 이상 존재해야함
      -- CREATE의 RETURN 데이터 타입과 BEGIN의 RETURN 값의 데이터 타입은 동일해야함
      
사용예) '대전'에 거주하는 회원의 회원번호를 입력받아 해당 해원의 2005년 6월 구매금액을 출력하는 함수를 작성하시오.
       (사용형식)
       CREATE OR REPLACE FUNCTION FN_SUM01 (
         P_MID MEMBER.MEM_ID%TYPE)
         RETURN NUMBER
       IS
         V_SUM NUMBER := 0; -- 구매금액합계
         V_CNT NUMBER := 0; -- 2005년 6월에 해당 회원 자료(CART)의 존재유무 확인
       BEGIN
         SELECT COUNT(*) INTO V_CNT
           FROM CART
          WHERE CART_NO LIKE '200506%'
            AND CART_MEMBER = P_MID;
         IF V_CNT != 0 THEN
           SELECT SUM(A.CART_QTY * B.PROD_PRICE) INTO V_SUM
             FROM CART A, PROD B
            WHERE CART_NO LIKE '200506%'
              AND CART_MEMBER = P_MID
              AND A.CART_PROD = B.PROD_ID;
         ELSE
           V_SUM := 0;
         END IF;
         RETURN V_SUM;
       END;

       (사용형식 - 실행)
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              FN_SUM01 (MEM_ID) AS 구매금액
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '대전%'
        ORDER BY 1;
       
사용예) 상품코드와 년도 및 월을 입력받아 해당 상품의 구매수량과 구매금액을 출력하는 함수를 작성하시오.
       (사용형식 - 함수) : FN_BUY01 -- 함수 내부에서 구매사실 여부 판단
       CREATE OR REPLACE FUNCTION FN_BUY01 (
         P_PID IN PROD.PROD_ID%TYPE, -- IN을 생략해도 무방, 생략하면 IN으로 간주, OUT은 무조건 기술해야함
         P_YEAR CHAR,
         P_MONTH CHAR)
         RETURN VARCHAR2 -- 두 개를 반환받을 수 없으므로 묶어서 반환
       IS
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- '01'을 붙여서 시작일이 됨
         V_AMT NUMBER := 0; -- 매입수량을 집계함
         V_SUM NUMBER := 0; -- 매입금액 합계를 저장함
         V_CNT NUMBER := 0; -- 자료수 유무를 판단함
         V_RES VARCHAR2(100);
       BEGIN
         SELECT COUNT(*) INTO V_CNT -- 매입수량 존재 유무를 판다
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
            AND BUY_PROD = P_PID; -- BUY_PROD가 넘겨받은 상품코드와 동일한지 판단
            
         IF V_CNT != 0 THEN
           SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_AMT, V_SUM -- 구매수량과 구매금액을 각각 V_AMT와 V_SUM에 넣음
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
              AND BUY_PROD = P_PID;
         ELSE
           V_SUM := 0;
           V_AMT := 0;
         END IF;
         V_RES := '구매수량 : '||V_AMT||', '||'구매금액 :'||V_SUM; -- 두 개를 반환할 수 없으므로 묶어서 반환
         RETURN V_RES;
       END;
       
       (사용형식 - 실행)       
       SELECT '2005-05', PROD_ID, PROD_NAME, FN_BUY01(PROD_ID, '2005', '05')
         FROM PROD;
       
       (사용형식 - 함수) : FN_BUY02 -- 함수 내부에서 구매사실 여부 판단
       CREATE OR REPLACE FUNCTION FN_BUY02 (
         P_PID IN PROD.PROD_ID%TYPE, -- IN을 생략해도 무방, 생략하면 IN으로 간주, OUT은 무조건 기술해야함
         P_YEAR CHAR,
         P_MONTH CHAR,
         P_AMT OUT NUMBER) -- 출력용 매개변수, 매입수량 합계가 매개변수를 통해 밖으로 출력됨
         RETURN NUMBER
       IS
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- '01'을 붙여서 시작일이 됨
         V_AMT NUMBER := 0; -- 매입수량을 집계함
         V_SUM NUMBER := 0; -- 매입금액 합계를 저장함
         V_CNT NUMBER := 0; -- 자료수 유무를 판단함
       BEGIN
         SELECT COUNT(*) INTO V_CNT -- 매입수량 존재 유무를 판다
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
            AND BUY_PROD = P_PID; -- BUY_PROD가 넘겨받은 상품코드와 동일한지 판단
            
         IF V_CNT != 0 THEN
           SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_AMT, V_SUM -- 구매수량과 구매금액을 각각 V_AMT와 V_SUM에 넣음
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
              AND BUY_PROD = P_PID;
         ELSE
           V_SUM := 0;
           V_AMT := 0;
         END IF;
         P_AMT := V_AMT;
         RETURN V_SUM;
       END;
       
       (사용형식 - 실행) -- SELECT문을 사용하면 한꺼번에 처리되므로 하나하나 처리가 불가능함, 그래서 커서를 사용해 실행함
       DECLARE
         V_AMT NUMBER := 0;
         V_SUM NUMBER := 0;
         CURSOR CUR_PROD IS
           SELECT PROD_ID, PROD_NAME
             FROM PROD;
       BEGIN
         FOR REC IN CUR_PROD LOOP
           V_SUM := FN_BUY02(REC.PROD_ID, '2005', '05', V_AMT);
           DBMS_OUTPUT.PUT_LINE('상품코드 : '||REC.PROD_ID);
           DBMS_OUTPUT.PUT_LINE('상품명 : '||REC.PROD_NAME);
           DBMS_OUTPUT.PUT_LINE('매입수량 : '||V_AMT);
           DBMS_OUTPUT.PUT_LINE('매입금액 : '||V_SUM);
           DBMS_OUTPUT.PUT_LINE('============================');
         END LOOP;  
       END;
       
사용예) 년도와 월을 6자리 문자열로 입력받아 해당월에 가장 많은 상품을 구매(금액기준)한 회원의 이름과 구매금액을 출력하는 함수를 작성하시오.
       (사용형식 - 함수) : FN_MAXMEM
       CREATE OR REPLACE FUNCTION FN_MAXMEM (
         P_DATE VARCHAR2)
         RETURN VARCHAR2
       IS
         V_DATE VARCHAR2(20) := P_DATE; -- 날짜
         V_CNT NUMBER := 0; --구매여부?
         V_SUM NUMBER := 0; --구매금액
         V_NAME MEMBER.MEM_NAME%TYPE; --이름
         V_RES VARCHAR2(100); -- RETURN에는 자동형변환이 있기 때문에 타입이 약간 달라도 무방함
       BEGIN
         SELECT COUNT(CART_NO) INTO V_CNT
           FROM CART
          WHERE CART_NO LIKE V_DATE||'%';
         
         IF V_CNT > 0 THEN
           SELECT A.MNAME, A.MSUM INTO V_NAME, V_SUM
             FROM (SELECT B.MEM_NAME AS MNAME,
                          SUM(A.CART_QTY * C.PROD_PRICE) AS MSUM
                     FROM CART A, MEMBER B, PROD C
                    WHERE A.CART_MEMBER = B.MEM_ID
                      AND A.CART_PROD = C.PROD_ID
                      AND SUBSTR(A.CART_NO, 1, 6) = V_DATE
                    GROUP BY B.MEM_NAME
                    ORDER BY 2 DESC) A
            WHERE ROWNUM = 1;  
         ELSE
           V_NAME := '';
         END IF;
         V_RES := '회원명 : '||V_NAME||', 구매금액 : '||V_SUM;
         RETURN V_RES;
       END;
       
       (사용형식 - 실행)
       SELECT FN_MAXMEM('200506') FROM DUAL;
       
       (사용형식 - 함수) : FN_MAXMEM
       CREATE OR REPLACE FUNCTION FN_MAXMEM (
         P_PERIOD IN CHAR)
         RETURN VARCHAR2
       IS
         V_RES VARCHAR2(100);
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_SUM NUMBER := 0;
         V_DATE CHAR(7) := P_PERIOD||'%';
       BEGIN
         SELECT A.MEM_NAME, A.AMT INTO V_NAME, V_SUM -- 출력용 쿼리
           FROM (SELECT MEM_NAME, -- 참조용 서브쿼리
                        SUM(CART_QTY * PROD_PRICE) AS AMT
                   FROM CART, PROD, MEMBER
                  WHERE CART_PROD = PROD_ID
                    AND MEM_ID = CART_MEMBER
                    AND CART_NO LIKE V_DATE
                  GROUP BY MEM_NAME
                  ORDER BY 2 DESC) A
          WHERE ROWNUM = 1;
         V_RES := '회원명 : '||V_NAME||', 구매금액 : '||V_SUM;
         RETURN V_RES;
       END;
       
       (사용형식 - 실행)
       SELECT FN_MAXMEM('200506') FROM DUAL;
       
       (사용형식 - 입력)
       ACCEPT P_DATE PROMPT '년월(YYYYMM) : '
       DECLARE
         V_RES VARCHAR2(100);
       BEGIN
         V_RES := FN_MAXMEM('&P_DATE');
         DBMS_OUTPUT.PUT_LINE(SUBSTR('&P_DATE', 1, 4)||'년 '||SUBSTR('&P_DATE', 5)||'월');
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;