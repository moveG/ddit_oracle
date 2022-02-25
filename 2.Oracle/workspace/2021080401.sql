2021-0804-01)
      (3) FOR 문
        - 개발언어의 FOR문과 유사한 구조
        - 일반 반복처리를 위한 FOR문과 CURSOR처리를 위한 FOR문이 제공됨
        -- 반복회수를 정확하게 알거나 반복회수가 중요하면 FOR문을 사용
        -- 반복회수를 정확하게 알지 못하거나 반복회수가 중요하지 않으며, 마지막으로 처리해야할 조건을 알고 있으면 WHILE문을 사용
        (일반 FOR문 사용형식)
          FOR 인덱스 IN [REVERSE] 초기값..최대값 LOOP -- 초기값~최대값까지 1씩 증감함, '..'은 생략할 수 없음
            반복처리명령문(들);
          END LOOP;
          . '인덱스' : 제어변수로 사용될 인덱스로 시스템에서 자동으로 설정해줌, 변수를 선언할 필요가 없음
          . 'REVERSE' : 역순으로 반복처리시 사용함

사용예) 구구단의 7단을 출력하는 블록을 작성하시오.
       DECLARE
         -- 선언부가 없어도 작성 가능
       BEGIN
         FOR I IN 1..9 LOOP
           DBMS_OUTPUT.PUT_LINE(7||' * '||I||' = '||7 * I);
         END LOOP;
       END;
       
사용예) 구구단의 모든 단을 출력하는 블록을 작성하시오.
       DECLARE
         -- 선언부가 없어도 작성 가능
       BEGIN
         FOR J IN 2..9 LOOP
           FOR I IN 1..9 LOOP
             DBMS_OUTPUT.PUT_LINE(J||' * '||I||' = '||J * I);
           END LOOP;
           DBMS_OUTPUT.PUT_LINE('');
         END LOOP; 
       END;
       
사용예) 첫날에 100원을 저축하고, 그 다음날부터 전날의 2배씩 저축할 때, 최초로 200만원을 넘는 날의 저축금액을 구하시오.
       -- 정확한 날을 모르므로 아주 긴 주기의 FOR문을 작성하고 200만원이 넘을때 FOR문을 빠져나가게 하면 됨
       DECLARE
         V_SUM NUMBER := 0; -- 저축합계 금액
         V_DSUM NUMBER := 100; -- 일별 저축액수
         V_DAYS NUMBER := 0; -- 날짜, 날짜는 I로 알 수 있는데, I는 FOR문 밖에서 사용할 수 없으므로 I를 저장할 변수를 설정해줌
       BEGIN
         FOR I IN 1..1000 LOOP
           V_SUM := V_SUM + V_DSUM;
           V_DAYS := I;
           IF V_SUM >= 2000000 THEN
             EXIT;
           END IF;
           V_DSUM := V_DSUM * 2;
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('일수 : '||V_DAYS||'일');
         DBMS_OUTPUT.PUT_LINE('저축금액 : '||V_SUM||'원');
       END;
       
        (CURSOR를 위한 FOR문 사용형식) -- FOR문과 CURSOR를 함께 사용하는 것이 가장 안정적인 사용방식
          FOR 레코드명 IN 커서명|커서선언문 LOOP
            반복처리명령문(들);
          END LOOP;
          . '레코드명' : 커서가 가르키는 행의 값을 가지고 있는 변수로 시스템에서 자동으로 설정해줌, 변수를 선언할 필요가 없음
          . 커서 내의 값들(컬럼)의 참조는 '레코드명.커서의 컬럼명' 형식으로 기술함
          . 커서의 OPEN, FETCH, CLOSE 명령 생략
          . 커서선언문 : 선언영역에서 선언해야할 커서선언문 중 'SELECT'문을 서브쿼리 형식으로 기술
          -- DECLARE절의 변수선언을 하지 않아도 됨

사용예) 2005년도 상품별 입고수량합계를 출력하는 블록을 작성하시오.
       Alias는 상품코드, 상품명, 입고수량
       DECLARE
         V_NUM NUMBER := 1;
         -- DECLARE절의 변수선언을 하지 않아도 됨
         CURSOR CUR_BUY02 IS
           SELECT B.BUY_PROD AS BID,
                  A.PROD_NAME AS PNAME,
                  SUM(B.BUY_QTY) AS AMT
             FROM PROD A, BUYPROD B
            WHERE A.PROD_ID = B.BUY_PROD
              AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
            GROUP BY B.BUY_PROD, A.PROD_NAME;
       BEGIN
         FOR REC1 IN CUR_BUY02 LOOP -- 커서의 한 행이 한 레코드(REC1), 자동으로 커서의 한 행씩 읽음
           DBMS_OUTPUT.PUT_LINE('상품코드 : '||REC1.BID);
           DBMS_OUTPUT.PUT_LINE('상품명 : '||REC1.PNAME);
           DBMS_OUTPUT.PUT_LINE('판매수량 : '||REC1.AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------'||V_NUM);
           V_NUM := V_NUM + 1;
         END LOOP;
       END;

사용예) 2005년도 상품별 입고수량합계를 출력하는 블록을 작성하시오.
       Alias는 상품코드, 상품명, 입고수량
       DECLARE
       BEGIN
         FOR REC1 IN (SELECT B.BUY_PROD AS BID, A.PROD_NAME AS PNAME, SUM(B.BUY_QTY) AS AMT
                        FROM PROD A, BUYPROD B
                       WHERE A.PROD_ID = B.BUY_PROD
                         AND EXTRACT(YEAR FROM B.BUY_DATE) = 2005
                       GROUP BY B.BUY_PROD, A.PROD_NAME)
         LOOP
           DBMS_OUTPUT.PUT_LINE('상품코드 : '||REC1.BID);
           DBMS_OUTPUT.PUT_LINE('상품명 : '||REC1.PNAME);
           DBMS_OUTPUT.PUT_LINE('판매수량 : '||REC1.AMT);
           DBMS_OUTPUT.PUT_LINE('---------------------------');
         END LOOP;
       END;
       
       COMMIT;