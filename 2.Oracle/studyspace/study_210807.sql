사용예) 키보드로 10~110사이의 부서번호를 입력받아 해당부서 직원 중 가장 입사일이 빠른 사원 정보를 출력하시오.
       Alias는 사원번호, 사원명, 입사일, 직책
       ACCEPT P_DID PROMPT '부서코드(10~100)'
       DECLARE
         V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE;
         V_NAME HR.EMPLOYEES.EMP_NAME%TYPE;
         V_HIRE HR.EMPLOYEES.HIRE_DATE%TYPE;
         V_JOBID HR.EMPLOYEES.JOB_ID%TYPE;
       BEGIN
         SELECT A.EMPLOYEE_ID, A.EMP_NAME, A.HIRE_DATE, A.JOB_ID
           INTO V_EID, V_NAME, V_HIRE, V_JOBID
           FROM (SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, JOB_ID
                   FROM HR.EMPLOYEES
                  WHERE DEPARTMENT_ID = TO_NUMBER(&P_DID)
                  ORDER BY 3) A
          WHERE  ROWNUM = 1;
          
          DBMS_OUTPUT.PUT_LINE('사원번호 : '||V_EID);
          DBMS_OUTPUT.PUT_LINE('사원명 : '||V_NAME);
          DBMS_OUTPUT.PUT_LINE('입사일 : '||V_HIRE);
          DBMS_OUTPUT.PUT_LINE('직책코드 : '||V_JOBID);
          
          EXCEPTION WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('예외발생 : '||SQLERRM);
       END;

사용예) 임의의 수를 입력받아 짝수인지 홀수인 판별하시오.
       ACCEPT P_NUM PROMPT '수 입력';
       DECLARE
         V_NUM NUMBER := TO_NUMBER(&P_NUM);
         V_RES VARCHAR2(200);
       BEGIN
         IF MOD(V_NUM, 2) = 0 THEN
           V_RES := TO_CHAR(V_NUM)||'은/는 짝수입니다.';
         ELSE
           V_RES := TO_CHAR(V_NUM)||'은/는 홀수입니다.';
         END IF;
         
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;
       
       DECLARE
         V_FLAG BOOLEAN := TRUE;
         V_RES VARCHAR2(200);
       BEGIN
         IF V_FLAG THEN
            V_RES := 'TRUE';
         ELSIF V_FLAG IS NULL THEN
            V_RES := 'NULL';
         ELSE
            V_RES := 'FALSE';
         END IF;
         
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;
       
사용예) 회원 테이블에서 회원들의 마일리지를 조회하여,
       그 값이 5000이상이면 'VIP회원',
       그 값이 3000이상이면 '정회원',
       그 이하이면 '준회원'을 출력하시오.
       Alias는 회원번호, 회원명, 마일리지       
       DECLARE
         V_MID MEMBER.MEM_ID%TYPE;
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_MILE MEMBER.MEM_MILEAGE%TYPE;
         V_RES VARCHAR2(200);
         
         CURSOR CUR_MEM01 IS
           SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
             FROM MEMBER;
       BEGIN
         OPEN CUR_MEM01;
         LOOP
           FETCH CUR_MEM01 INTO V_MID, V_NAME, V_MILE;
           EXIT WHEN CUR_MEM01%NOTFOUND;
           IF V_MILE >= 5000 THEN
             V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'VIP회원';
           ELSIF V_MILE >= 3000 THEN
             V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'정회원';
           ELSE  
             V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'준회원';
           END IF;
           DBMS_OUTPUT.PUT_LINE(V_RES);
           DBMS_OUTPUT.PUT_LINE('================================');
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('회원수 : '||CUR_MEM01%ROWCOUNT||'명');
         CLOSE CUR_MEM01;
       END;
       
사용예) 사용자로부터 수도사용량(톤 단위)을 입력받아 수도요금을 계산하여 출력하시오.
       사용량(톤)   수도단가(원)
        01-10        275
        11-20        305
        21-30        350
        31-40        415
        41톤 이상     500원
        
       하수도 사용요금 : 사용량 * 120원
       ---------------------------------
       ex) 27톤을 사용한 경우
       ---------------------------------
       01-10톤 : 275 * 10 = 2,750원
       11-20톤 : 305 * 10 = 3,050원
       21-27톤 : 350 * 7  = 2,450원
       ---------------------------------
       하수도 사용요금 : 27 * 120 = 3,240원
       ---------------------------------
                       수도요금 : 11,490원
       ---------------------------------       
       ACCEPT P_NUM PROMPT '사용량(톤)';
       DECLARE
         V_NUM NUMBER := TO_NUMBER(&P_NUM);
         V_RES VARCHAR2(100);
       BEGIN
         IF V_NUM <= 10 THEN
           V_RES := TO_CHAR(V_NUM * 275);
         ELSIF V_NUM <= 20 THEN
           V_RES := TO_CHAR((10 * 275) + (MOD(V_NUM, 10) * 305));
         ELSIF V_NUM <= 30 THEN
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (MOD(V_NUM, 10) * 350));
         ELSIF V_NUM <= 40 THEN
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (10 * 350) + (MOD(V_NUM, 10) * 415));
         ELSE
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (10 * 350) + (10 * 415) + ((V_NUM - 40) * 500));
         END IF;
           V_RES := V_RES + (V_NUM * 120);
         
         DBMS_OUTPUT.PUT_LINE('사용량 : '||V_NUM||'톤');
         DBMS_OUTPUT.PUT_LINE('수도요금 : '||V_RES||'원');
       END;
       
       ACCEPT P_NUM PROMPT '사용량(톤)'
       DECLARE
         V_NUM NUMBER := TO_NUMBER('&P_NUM');
         V_RES NUMBER(30);
       BEGIN
         IF V_NUM <= 10 THEN
           V_RES := V_NUM * 275;
         ELSIF V_NUM <= 20 THEN
           V_RES := (10 * 275) + ((V_NUM - 10) * 305);
         ELSIF V_NUM <= 30 THEN
           V_RES := (10 * 275) + (10 * 305) + ((V_NUM - 20) * 350);
         ELSIF V_NUM <= 40 THEN
           V_RES := (10 * 275) + (10 * 305) + (10 * 350) + ((V_NUM - 30) * 415);
         ELSE
           V_RES := (10 * 275) + (10 * 305) + (10 * 350) + (10 * 415) + ((V_NUM - 40) * 500);
         END IF;
         V_RES := V_RES + (V_NUM * 120);
         
         DBMS_OUTPUT.PUT_LINE('사용량 : '||V_NUM||'톤');
         DBMS_OUTPUT.PUT_LINE('수도요금 : '||V_RES||'원');
       END;       
       
사용예) 10-100 사이의 난수를 발생시켜 난수에 해당하는 부서에 속한 사원 중 첫번째 사원의 급여를 조회하여
       5000이하이면 '저임금 사원', 10000이하이면 '평균임금 사원', 그 이상이면 '고임금 사원'을 출력하시오.
       Alias는 사원번호, 사원명, 부서명       
       DECLARE
         V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE; -- 사원번호
         V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE; -- 사원이름
         V_DNAME HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE; -- 부서명
         V_SAL HR.EMPLOYEES.SALARY%TYPE; -- 급여
         V_MESSAGE VARCHAR2(20); -- 비고란(저임금 사원, 평균임금 사원, 고임금 사원)
         V_DID HR.EMPLOYEES.DEPARTMENT_ID%TYPE; -- 난수로 발생시킨 부서코드
       BEGIN
         V_DID := TRUNC(SYS.DBMS_RANDOM.VALUE(10, 110), -1); -- 정수형 난수 발생, TRUNC(~, -1)로 1의 자리를 버림
         SELECT A.EMPLOYEE_ID, A.EMP_NAME, B.DEPARTMENT_NAME, A.SALARY
           INTO V_EID, V_ENAME, V_DNAME, V_SAL -- INTO를 사용하지 않으면 오류 발생, PL/SQL에서는 반드시 INTO를 사용해야함
           FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
          WHERE A.DEPARTMENT_ID = V_DID
            AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
            AND ROWNUM = 1; -- 첫번째 사원을 조회
         CASE WHEN V_SAL < 5000 THEN
                   V_MESSAGE := '저임금 사원';
              WHEN V_SAL < 10000 THEN
                   V_MESSAGE := '평균임금 사원';
              ELSE
                   V_MESSAGE := '고임금 사원';
         END CASE;
         
         DBMS_OUTPUT.PUT_LINE('부서명 : '||V_DNAME);
         DBMS_OUTPUT.PUT_LINE('사원번호 : '||V_EID);
         DBMS_OUTPUT.PUT_LINE('사원명 : '||V_ENAME);
         DBMS_OUTPUT.PUT_LINE('비고 : '||V_MESSAGE);
       END;
       
사용예) 구구단의 7단을 출력하는 블록을 작성하시오.
       DECLARE
         V_CNT NUMBER := 1; -- 숫자변수는 반드시 초기값을 설정해줘야함, 그렇지 않으면 참조될때 NULL값이 참조되므로 오류가 발생함
         V_RES NUMBER := 0;
       BEGIN
         LOOP
           V_RES := 7 * V_CNT;
           EXIT WHEN V_CNT > 9;
           DBMS_OUTPUT.PUT_LINE(7||' * '||V_CNT||' = '||V_RES);
           V_CNT := V_CNT + 1;
         END LOOP;  
       END;
       
사용예) 구구단의 모든 단을 출력하는 블록을 작성하시오.
       DECLARE
         V_NUM NUMBER := 2;
         V_CNT NUMBER := 1;
         V_RES NUMBER := 0;
       BEGIN
         LOOP
         EXIT WHEN V_NUM > 9;
           LOOP
           V_RES := V_NUM * V_CNT;
           EXIT WHEN V_CNT > 9;
           DBMS_OUTPUT.PUT_LINE(V_NUM||' * '||V_CNT||' = '||V_RES);
           V_CNT := V_CNT + 1;
           END LOOP;
           V_CNT := 1;
           V_NUM := V_NUM + 1;
           DBMS_OUTPUT.PUT_LINE('');
         END LOOP;
       END;
       
사용예) 구구단의 7단을 출력하는 블록을 작성하시오.
       DECLARE
         V_CNT NUMBER := 0;
         V_RES NUMBER := 0;
       BEGIN
         WHILE V_CNT < 9 LOOP
           V_CNT := V_CNT + 1;
           V_RES := V_CNT * 7;
           DBMS_OUTPUT.PUT_LINE(7||' * '||V_CNT||' = '||V_RES);
         END LOOP;
       END;       
       
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
       
사용예) 년도와 월과 제품코드를 입력받아 해당제품의 입고수량을 집계하여 재고수불테이블에서 해당제품의 재고를 갱신하는 프로시져를 작성하시오.
       (사용형식)
       CREATE OR REPLACE PROCEDURE PROC_BUY_REMAIN(
         P_YEAR  IN CHAR, -- 입력이니 IN(외부에서 가져오니 IN, 외부로 내보내면 OUT)
         P_MONTH IN VARCHAR2, -- 입력이니 IN
         P_PID   IN VARCHAR2) -- 입력이니 IN
       IS
         V_IAMT NUMBER(5) := 0; -- 매입수량
         V_FLAG NUMBER := 0; -- 매입자료 존재유무
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- 매입발생 월의 시작날짜
       BEGIN
         SELECT COUNT(*), SUM(BUY_QTY) INTO V_FLAG, V_IAMT
           FROM BUYPROD
          WHERE BUY_PROD = P_PID
            AND BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE);
            
         IF V_FLAG != 0 THEN
           UPDATE REMAIN
              SET REMAIN_I = REMAIN_I + V_IAMT,
                  REMAIN_J_99 = REMAIN_J_99 + V_IAMT,
                  REMAIN_DATE = LAST_DAY(V_DATE)
            WHERE REMAIN_YEAR = P_YEAR
              AND PROD_ID = P_PID;
         END IF;
       END;
       (사용형식 - 실행)
       EXECUTE PROC_BUY_REMAIN('2005', '03', 'P201000017');
       
       ROLLBACK;
       
사용예) 사원번호를 입력받아 해당사원이 소속된 부서의 부서명, 인원수, 평균급여를 받환받는 프로시져를 작성하시오.
       -- 프로시져는 반환값이 없음, '반환받는'이라는 뜻은 OUT 매개변수를 사용해 출력하라는 뜻임
       (사용형식) -- HR계정에서 사용가능
       CREATE OR REPLACE PROCEDURE PROC_EMP01(
         P_EID  IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE, -- 'HR.EMPLOYEES.EMPLOYEE_ID'와 같은 타입으로 매개변수 선언
         P_DNAME OUT HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE, -- 부서명
         P_CNT OUT NUMBER, -- 인원수
         P_SAL OUT NUMBER) -- 평균급여
       IS
         -- 선언할 내용이 없으면 비워둠
       BEGIN
         SELECT B.DEPARTMENT_NAME, COUNT(*), ROUND(AVG(SALARY))
           INTO P_DNAME, P_CNT, P_SAL
           FROM (SELECT DEPARTMENT_ID AS DID
                   FROM HR.EMPLOYEES
                  WHERE EMPLOYEE_ID = P_EID) A, DEPARTMENTS B, EMPLOYEES C
          WHERE A.DID = B.DEPARTMENT_ID
            AND C.DEPARTMENT_ID = B.DEPARTMENT_ID
          GROUP BY B.DEPARTMENT_NAME;
       END;
       (사용형식 - 실행) -- HR계정에서 사용가능
       -- 실행을 하려면 반환받을 매개변수를 선언해야함
       DECLARE
         V_DNAME HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE;
         V_CNT NUMBER := 0;
         V_SAL NUMBER := 0;
       BEGIN
         PROC_EMP01(109, V_DNAME, V_CNT, V_SAL); -- EXECUTE가 있으면 안됨
         DBMS_OUTPUT.PUT_LINE('부서명 : '||V_DNAME);
         DBMS_OUTPUT.PUT_LINE('직원수 : '||V_CNT);
         DBMS_OUTPUT.PUT_LINE('평균급여 : '||V_SAL);
       END;       
       
사용예) '대전'에 거주하는 회원의 회원번호를 입력받아 해당 해원의 2005년 6월 구매금액을 출력하는 함수를 작성하시오.
       (사용형식)       
       CREATE OR REPLACE FUNCTION FN_SUM01 (
         P_MID MEMBER.MEM_ID%TYPE)
         RETURN NUMBER
       IS
         V_SUM NUMBER := 0; -- 구매금액 합계
         V_CNT NUMBER := 0; -- 2005년 6월에 해당 회원의 자료(CART)의 존재유무 확인
       BEGIN
         SELECT COUNT(*) INTO V_CNT
           FROM CART
          WHERE CART_NO LIKE '200506%'
            AND CART_MEMBER = P_MID;
            
         IF V_CNT != 0 THEN
           SELECT SUM(CART_QTY * PROD_PRICE) INTO V_SUM
             FROM CART, PROD
            WHERE CART_NO LIKE '200506%'
              AND CART_MEMBER = P_MID
              AND CART_PROD = PROD_ID;
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
         P_PID IN PROD.PROD_ID%TYPE, -- IN은 생략해도 무방, OUT은 무조건 기술, 생략하면 IN으로 간주함
         P_YEAR CHAR,
         P_MONTH CHAR)
         RETURN VARCHAR2 -- 2개를 반환받을 수 없으므로 묶어서 반환함
       IS
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- '01'을 붙여서 시작일이 됨
         V_AMT NUMBER := 0; -- 매입수량 집계
         V_SUM NUMBER := 0; -- 매입금액합계 저장
         V_CNT NUMBER := 0; -- 자료 존재유무 판단
         V_RES VARCHAR2(100);
       BEGIN
         SELECT COUNT(*) INTO V_CNT -- 매입수량 존재유무 판단
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
            AND BUY_PROD = P_PID; -- BUY_PROD가 넘겨받은 상품코드와 동일한지 판단
            
         IF V_CNT != 0 THEN
           SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_AMT, V_SUM
           -- 구매수량과 구매금액을 각각 V_AMT, V_SUM에 넣음
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
              AND BUY_PROD = P_PID;
         END IF;
         
         V_RES := '구매수량 : '||V_AMT||', '||'구매금액 :'||V_SUM;
         -- 두 개를 반환할 수 없으므로 묶어서 반환
         RETURN V_RES;
       END;

       (사용형식 - 실행)
       SELECT PROD_ID, PROD_NAME, FN_BUY01(PROD_ID, '2005', '05')
         FROM PROD;

       (사용형식 - 함수) : FN_BUY02 -- 함수 내부에서 구매사실 여부 판단       
       CREATE OR REPLACE FUNCTION FN_BUY02 (
         P_PID IN PROD.PROD_ID%TYPE, -- IN은 생략해도 무방, OUT은 무조건 기술, 생략하면 IN으로 간주함
         P_YEAR CHAR,
         P_MONTH CHAR,
         P_AMT OUT NUMBER) -- 출력용 매개변수, 매입수량 합계가 매개변수를 통해 밖으로 출력됨
         RETURN NUMBER
       IS
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- '01'을 붙여서 시작일이 됨
         V_AMT NUMBER := 0; -- 매입수량 집계
         V_SUM NUMBER := 0; -- 매입금액합계 저장
         V_CNT NUMBER := 0; -- 자료 존재유무 판단
       BEGIN
         SELECT COUNT(*) INTO V_CNT -- 매입수량 존재유무 판단
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
            AND BUY_PROD = P_PID; -- BUY_PROD가 넘겨받은 상품코드와 동일한지 판단
            
         IF V_CNT != 0 THEN
           SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_AMT, V_SUM
           -- 구매수량과 구매금액을 각각 V_AMT, V_SUM에 넣음
             FROM BUYPROD
            WHERE BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE)
              AND BUY_PROD = P_PID;
         END IF;
         
         P_AMT := V_AMT;
         RETURN V_SUM;
       END;
       
       (사용형식 - 실행) -- SELECT문을 사용하면 한번에 처리되기 때문에, 하나씩 처리하기 위해 커서를 사용함
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
         V_DATE VARCHAR2(20) := P_DATE;
         V_CNT NUMBER := 0;
         V_SUM NUMBER := 0;
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_RES VARCHAR2(100);
       BEGIN
         SELECT COUNT(*) INTO V_CNT
           FROM CART
          WHERE CART_NO LIKE V_DATE||'%';
         
         IF V_CNT != 0 THEN
           SELECT A.MNAME, A.MSUM INTO V_NAME, V_SUM
             FROM (SELECT MEM_NAME AS MNAME,
                          SUM(CART_QTY * PROD_PRICE) AS MSUM
                     FROM CART, MEMBER, PROD
                    WHERE CART_MEMBER = MEM_ID
                      AND CART_PROD = PROD_ID
                      AND CART_NO LIKE V_DATE||'%'
                    GROUP BY MEM_NAME
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

사용예) 년도와 월을 6자리 문자열로 입력받아 해당월에 가장 많은 상품을 구매(금액기준)한 회원의 이름과 구매금액을 출력하는 함수를 작성하시오.
       (사용형식 - 함수) : FN_MAXMEM       
       CREATE OR REPLACE FUNCTION FN_MAXMEM (
         P_DATE IN VARCHAR2)
         RETURN VARCHAR2
       IS
         V_RES VARCHAR2(100);
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_SUM NUMBER := 0;
         V_DATE VARCHAR2(10) := P_DATE||'%';
       BEGIN
         SELECT A.MEM_NAME, A.AMT INTO V_NAME, V_SUM
           FROM (SELECT MEM_NAME,
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

사용예) 분류 테이블에 새로운 분류코드를 삽입하고, 삽입 후 '새로운 분류가 추가되었습니다.'를 출력하는 트리거를 작성하시오.
       [분류코드 : 'P502', 분류명 : '임산물', 순번 : 11]
       (문장단위 트리거)
       CREATE OR REPLACE TRIGGER TG_LPROD_INSERT
         AFTER INSERT ON LPROD
       BEGIN
         DBMS_OUTPUT.PUT_LINE('새로운 분류가 추가되었습니다.');
       END;
       
       INSERT INTO LPROD(LPROD_ID, LPROD_GU, LPROD_NM)
         VALUES (13, 'P504', '농축산물');
         
       COMMIT;  
       
       SELECT * FROM LPROD;
       
       CREATE OR REPLACE TRIGGER TG_LPROD_INSERT
         AFTER DELETE ON LPROD
       BEGIN
         DBMS_OUTPUT.PUT_LINE('새로운 분류가 삭제되었습니다.');
       END;
       
       DELETE LPROD
        WHERE LPROD_ID = 13;
        
       COMMIT;
       
       SELECT * FROM LPROD;       
       
사용예) 오늘 날짜가 2005년 6월 11일이며 제품코드가 'P102000005'인 상품을 처음 10개 매입했다 가정하고,
       이 정보를 매입 테이블에 저장하고 재고수불 테이블을 변경하는 트리거를 작성하시오.
       (행단위 트리거)       
       CREATE OR REPLACE TRIGGER TG_BUYPROD_INSERT
         AFTER INSERT ON BUYPROD
         FOR EACH ROW
       DECLARE
         V_QTY NUMBER := :NEW.BUY_QTY;
         V_PROD PROD.PROD_ID%TYPE := :NEW.BUY_PROD;
       BEGIN
         UPDATE REMAIN
            SET REMAIN_I = REMAIN_J + V_QTY,
                REMAIN_J_PP = REMAIN_J_99 + V_QTY,
                REMAIN_DATE = TO_DATE(20050611)
          WHERE REMAIN_YEAR = '2005'
            AND PROD_ID = :NEW.BUY_PROD;
         DBMS_OUTPUT.PUT_LINE(:NEW.BUY_PROD||'상품이 '||V_QTY||'개 입고되었습니다.');
       END;
       
       (실행)
       INSERT INTO BUYPROD
         SELECT TO_DATE('20050611'), PROD_ID, 10, PROD_COST
           FROM PROD
          WHERE PROD_ID = 'P102000005';
       
       COMMIT;
       
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
       
       
       
       
       
       