2021-0803-02) 커서(CURSOR)
    - 오라클 SQL명령어에 의하여 영향을 받은 행들의 집합
    - SELECT문에 의해 반환된 결과 집합의 행들을 차례대로 접근해야 하는 경우 사용함
    - 개발자가 결과를 수동적으로 제어할 필요가 있는 경우 사용
    - IMPLICITE, EXPLICITE CURSOR
    - 커서의 사용은 FOR문을 제외하고 생성(선언) -> OPEN -> FETCH -> CLOSE 단계를 차례대로 실행
    
  1. 익명커서(IMPLICITE CURSOR)
    - 이름이 없는 커서
    - SELECT문이 실행되면 결과(커서)가 자동으로 OPEN이 되고, 결과 출력이 완료된 직후에 자동으로 CLOSE 됨(참조 불가능)
    - 커서속성
      . SQL%ISOPEN : 커서가 OPEN 상태이면 참(true) 반환 - 항상 거짓(false)
      . SQL%NOTFOUND : 커서에 자료가 남아있지 않으면 참(true) 반환
      . SQL%FOUND : 커서에 자료가 남아있으면 참(true) 반환 -- WHILE문의 조건문에 사용할 수 있음
      . SQL%ROWCOUNT : 커서에 존재하는 자료의 개수
      -- 이름이 존재하는 커서는 SQL자리에 커서의 이름을 기술함

  2. 커서(EXPLICITE CURSOR)
    - 이름이 부여된 커서
    - 선언부에서 선언
    (선언형식 - 선언부)
      CURSOR 커서명[(변수명 타입명[,변수명 타입명,...])] -- 필요없으면 기술하지 않아도 됨, 변수명과 타입명만 기술함(크기 제외)
      IS
        SELECT 문;
        
    (선언형식 - 실행부)
      OPEN 커서명[(매개변수[,매개변수,...])]; -- 위의 커서와 같은 타입이어야함

      FETCH 커서명 INTO 변수list;
      
      CLOSE 커서명;

사용예) 2005년 5월 입고상품별 출고현황을 조회하는 블록을 커서를 이용하여 작성하시오.
       Alias는 상품코드, 상품명, 수량
       -- 입고상품을 하나씩 꺼내서 CART TABLE에서 비교함
       DECLARE -- 출력하고자 하는 부분을 반드시 기술해야함
         V_PID PROD.PROD_ID%TYPE; -- 상품코드
         V_PNAME PROD.PROD_NAME%TYPE; -- 상품명
         V_AMT NUMBER := 0; -- 판매수량
         V_CNT NUMBER := 0; -- 매입은 되었지만 매출이 없는 경우를 위해 설정
         
         CURSOR CUR_BUY01(PDATE DATE) IS -- 매입상품별 커서, 상품코드 36개가 커서가 됨, 이것을 하나씩 읽어옴, PDATE는 시작일
           SELECT DISTINCT BUY_PROD --INTO는 BEGIN절에서만 사용
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN PDATE AND LAST_DAY(PDATE); -- TO_DATE('20050501') AND TO_DATE('20050531') 대신 사용됨
       BEGIN
         OPEN CUR_BUY01(TO_DATE('20050501')); -- CUR_BUY01 커서를 오픈함, TO_DATE('20050501')는 PDATE와 대응, 실제값을 넣어줌
         LOOP
           FETCH CUR_BUY01 INTO V_PID; -- CUR_BUY01의 열을 끌고와서 V_PID에 넣어줌
           EXIT WHEN CUR_BUY01%NOTFOUND;
           SELECT COUNT(*) INTO V_CNT
             FROM CART
            WHERE CART_PROD = V_PID
              AND CART_NO LIKE '200505%';
           
           IF V_CNT !=0 THEN
             SELECT PROD_NAME, SUM(CART_QTY) INTO V_PNAME, V_AMT
               FROM CART, PROD
              WHERE CART_PROD = V_PID
                AND CART_PROD = PROD_ID
                AND CART_NO LIKE '200505%'
              GROUP BY PROD_NAME;
           
             DBMS_OUTPUT.PUT_LINE('상품코드 : '||V_PID);
             DBMS_OUTPUT.PUT_LINE('상품명 : '||V_PNAME);
             DBMS_OUTPUT.PUT_LINE('판매수량 : '||V_AMT);
             DBMS_OUTPUT.PUT_LINE('---------------------------');
           END IF;  
         END LOOP;
         CLOSE CUR_BUY01;
       END;

사용예) 2005년도 상품별 입고수량합계를 출력하는 블록을 커서를 이용하여 작성하시오.
       Alias는 상품코드, 상품명, 입고수량
      (2005년도 상품별 입고수량합계 쿼리) -- 커서로 사용하면됨
       SELECT B.BUY_PROD, A.PROD_NAME, SUM(B.BUY_QTY)
         FROM PROD A, BUYPROD B
        WHERE A.PROD_ID = B.BUY_PROD
          AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
        GROUP BY B.BUY_PROD, A.PROD_NAME;
        
       DECLARE
         V_PID PROD.PROD_ID%TYPE;
         V_PNAME PROD.PROD_NAME%TYPE;
         V_AMT NUMBER := 0; -- 수량집계를 위한 변수
                  
         CURSOR CUR_BUY02 IS
           SELECT B.BUY_PROD AS BID,
                  A.PROD_NAME AS PNAME,
                  SUM(B.BUY_QTY) AS AMT
             FROM PROD A, BUYPROD B
            WHERE A.PROD_ID = B.BUY_PROD
              AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
            GROUP BY B.BUY_PROD, A.PROD_NAME;
       BEGIN
         OPEN CUR_BUY02; -- 커서 오픈
         LOOP
           FETCH CUR_BUY02 INTO V_PID, V_PNAME, V_AMT; -- BID, PNAME, AMT와 순서대로 연결됨
           EXIT WHEN CUR_BUY02%NOTFOUND; -- 차례대로 자료를 읽다가 자료가 없으면 탈출함
           
           DBMS_OUTPUT.PUT_LINE('상품코드 : '||V_PID); -- 출력
           DBMS_OUTPUT.PUT_LINE('상품명 : '||V_PNAME);
           DBMS_OUTPUT.PUT_LINE('판매수량 : '||V_AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------');
         END LOOP; -- 루프 닫음
         DBMS_OUTPUT.PUT_LINE('자료수 : '||CUR_BUY02%ROWCOUNT);
         CLOSE CUR_BUY02; -- 커서 닫음
       END;
       
숙제) WHILE문을 사용하여 작성하시오.
사용예) 2005년 5월 입고상품별 출고현황을 조회하는 블록을 작성하시오.
       Alias는 상품코드, 상품명, 수량
       DECLARE
         V_PID PROD.PROD_ID%TYPE;
         V_PNAME PROD.PROD_NAME%TYPE;
         V_AMT NUMBER := 0;
         V_CNT NUMBER := 0;
         
         CURSOR CUR_BUY01(PDATE DATE) IS
           SELECT DISTINCT BUY_PROD
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN PDATE AND LAST_DAY(PDATE);
       BEGIN
         OPEN CUR_BUY01(TO_DATE('20050501'));
         FETCH CUR_BUY01 INTO V_PID;
         WHILE CUR_BUY01%FOUND LOOP
           SELECT COUNT(*) INTO V_CNT
             FROM CART
            WHERE CART_PROD = V_PID
              AND CART_NO LIKE '200505%';
           
           IF V_CNT !=0 THEN
             SELECT PROD_NAME, SUM(CART_QTY) INTO V_PNAME, V_AMT
               FROM CART, PROD
              WHERE CART_PROD = V_PID
                AND CART_PROD = PROD_ID
                AND CART_NO LIKE '200505%'
              GROUP BY PROD_NAME;
           
             DBMS_OUTPUT.PUT_LINE('상품코드 : '||V_PID);
             DBMS_OUTPUT.PUT_LINE('상품명 : '||V_PNAME);
             DBMS_OUTPUT.PUT_LINE('판매수량 : '||V_AMT);
             DBMS_OUTPUT.PUT_LINE('---------------------------');
           END IF;
           FETCH CUR_BUY01 INTO V_PID;
         END LOOP;
         CLOSE CUR_BUY01;
       END;

사용예) 2005년도 상품별 입고수량합계를 출력하는 블록을 작성하시오.
       Alias는 상품코드, 상품명, 입고수량
       DECLARE
         V_PID PROD.PROD_ID%TYPE;
         V_PNAME PROD.PROD_NAME%TYPE;
         V_AMT NUMBER := 0;
                  
         CURSOR CUR_BUY02 IS
           SELECT B.BUY_PROD AS BID,
                  A.PROD_NAME AS PNAME,
                  SUM(B.BUY_QTY) AS AMT
             FROM PROD A, BUYPROD B
            WHERE A.PROD_ID = B.BUY_PROD
              AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
            GROUP BY B.BUY_PROD, A.PROD_NAME;
       BEGIN
         OPEN CUR_BUY02;
        FETCH CUR_BUY02 INTO V_PID, V_PNAME, V_AMT;
        WHILE CUR_BUY02%FOUND LOOP
           DBMS_OUTPUT.PUT_LINE('상품코드 : '||V_PID);
           DBMS_OUTPUT.PUT_LINE('상품명 : '||V_PNAME);
           DBMS_OUTPUT.PUT_LINE('판매수량 : '||V_AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------');
           FETCH CUR_BUY02 INTO V_PID, V_PNAME, V_AMT;
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('자료수 : '||CUR_BUY02%ROWCOUNT);
         CLOSE CUR_BUY02;
       END;
       
       COMMIT;