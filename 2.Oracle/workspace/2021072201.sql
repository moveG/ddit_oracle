2021-0722-01)

사용예) 2005년 5월 회원별 판매액을 조회하여 계산하고 상위 5명의 자료를 출력하시오.
       Alias는 회원번호, 회원명, 구매금액합계
       -- ORDER BY절은 WHERE절보다 늦게 실행되므로 5명을 자르고, 그 5명의 순서를 정렬함
       -- 서브쿼리를 사용해야, 구매금액합계별로 정렬한 뒤 ROWNUM으로 자를 수 있음
       -- FROM절의 서브쿼리는 실행하면 반드시 결과가 출력되어야함
       SELECT TBLA.CID AS 회원번호,
              TBLB.MEM_NAME AS 회원명,
              TBLA.AMT AS 구매금액합계
         FROM (SELECT A.CART_MEMBER AS CID,
                      SUM(A.CART_QTY * B.PROD_PRICE) AS AMT
                 FROM CART A, PROD B
                WHERE A.CART_PROD = B.PROD_ID
                  AND A.CART_NO LIKE '200505%'
                GROUP BY A.CART_MEMBER
                ORDER BY 2 DESC) TBLA,
              MEMBER TBLB
        WHERE TBLA.CID = TBLB.MEM_ID
          AND ROWNUM <= 5;
       
사용예) 회원의 마일리지를 조회하여 상위 20%에 속한 회원들이 2005년 4~6월 구매한 정보를 조회하시오.
       Alias는 회원번호, 회원명, 금액
       DECLARE
         V_ID MEMBER.MEM_ID%TYPE;
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_AMT NUMBER := 0;
         -- % 참조타입
         CURSOR CUR_MEM01 IS -- 커서를 생성함
           SELECT A.MID
             FROM (SELECT MEM_ID AS MID
                     FROM MEMBER
                    ORDER BY MEM_MILEAGE DESC) A
            WHERE ROWNUM <= ROUND((SELECT COUNT(*)
                                     FROM MEMBER) * 0.2);
       BEGIN
         OPEN CUR_MEM01; -- 커서를 열음
         LOOP -- LOOP ~ END LOOP까지 반복
           FETCH CUR_MEM01 INTO V_ID; -- 커서를 처음부터 차례대로 읽어와라
           EXIT WHEN CUR_MEM01%NOTFOUND; -- 커서에 더 이상 읽어올 자료가 없을 때 참이되어 밖으로 빠져나옴
           
           SELECT C.MEM_NAME, SUM(A.CART_QTY * B.PROD_PRICE)
             INTO V_NAME, V_AMT
             FROM CART A, PROD B, MEMBER C
            WHERE A.CART_MEMBER = C.MEM_ID
              AND A.CART_PROD = B.PROD_ID
              AND A.CART_MEMBER = V_ID
              AND SUBSTR(A.CART_NO, 1, 6) BETWEEN '200504' AND '200506'
            GROUP BY C.MEM_NAME;
              
           DBMS_OUTPUT.PUT_LINE('회원번호 : '||V_ID);
           DBMS_OUTPUT.PUT_LINE('회원명 : '||V_NAME);
           DBMS_OUTPUT.PUT_LINE('구매금액 : '||V_AMT);
           DBMS_OUTPUT.PUT_LINE('------------------------');
         END LOOP;
         
         CLOSE CUR_MEM01; --커서를 닫음
       END;
       
사용예) 2005년 5월 매입액과 매출액을 조회하시오.
       Alias는 상품코드, 상품명, 매입합계, 매출합계
       (5월 매입집계)
       SELECT A.BUY_PROD AS 상품코드,
              SUM(A.BUY_QTY * B.PROD_COST) AS 매입합계
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD = B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050501') AND TO_DATE('20050531')
        GROUP BY A.BUY_PROD
        ORDER BY 1;
        
       (5월 매출집계)
       SELECT A.CART_PROD AS 상품코드,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 매입합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_PROD
        ORDER BY 1;
       
       (5월 매출입 종합집계 - 일반조인 사용형식)
       SELECT PROD_ID AS 상품코드,
              PROD_NAME AS 상품명,
              NVL(TBLA.BAMT, 0) AS 매입합계,
              NVL(TBLB.CAMT, 0) AS 매출합계
         FROM (SELECT A.BUY_PROD AS BID,
                      SUM(A.BUY_QTY * B.PROD_COST) AS BAMT
                 FROM BUYPROD A, PROD B
                WHERE A.BUY_PROD = B.PROD_ID
                  AND A.BUY_DATE BETWEEN TO_DATE('20050501') AND TO_DATE('20050531')
                GROUP BY A.BUY_PROD) TBLA,
                         (SELECT A.CART_PROD AS CID,
                                 SUM(A.CART_QTY * B.PROD_PRICE) AS CAMT
                            FROM CART A, PROD B
                           WHERE A.CART_PROD = B.PROD_ID
                             AND A.CART_NO LIKE '200505%'
                           GROUP BY A.CART_PROD) TBLB,
              PROD
        WHERE TBLA.BID (+)= PROD_ID
          AND TBLB.CID (+)= PROD_ID
        ORDER BY 1;
        
       (5월 매출입 종합집계 - ANSI INNER JOIN 사용형식)
       SELECT A.PROD_ID AS 상품코드,
              A.PROD_NAME AS 상품명,
              NVL(SUM(A.PROD_COST * B.BUY_QTY), 0) AS 매입합계,
              NVL(SUM(A.PROD_PRICE * C.CART_QTY), 0) AS 매출합계
         FROM PROD A
         LEFT OUTER JOIN BUYPROD B ON (B.BUY_PROD = A.PROD_ID
              AND B.BUY_DATE BETWEEN TO_DATE('20050501') AND TO_DATE('20050531'))
         LEFT OUTER JOIN CART C ON (C.CART_PROD = A.PROD_ID
              AND C.CART_NO LIKE '200505%')
        GROUP BY A.PROD_ID, A.PROD_NAME
        ORDER BY 1;
        -- LEFT 쪽에 더 다양하게 기술된 컬럼을 넣음

    3. Non-Equi Join
      - 조인조건문이 '=' 이외의 연산자가 사용된 경우
      - IN, ANY, SOME, ALL, EXISTS 등의 복수행 연산자 사용
      -- 자주 발생하지는 않음
      
사용예) 사원 테이블에서 사원들의 평균임금보다 더 많은 임금을 받는 사원을 출력하시오.
       Alias는 사원번호, 사원명, 부서명, 급여, 평균급여
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              A.SALARY AS 급여,
              C.ASAL AS 평균급여
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B,
              (SELECT ROUND(AVG(SALARY)) AS ASAL
                 FROM HR.EMPLOYEES) C -- 서브쿼리가 한번만 실행되어 결과를 ASAL에 넣음, 실행 효율측면에서 효율적임
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND A.SALARY >= C.ASAL
        ORDER BY 4;
      
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              A.SALARY AS 급여,
              (SELECT ROUND(AVG(SALARY))
                 FROM HR.EMPLOYEES) AS 평균급여
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND A.SALARY > (SELECT ROUND(AVG(SALARY))
                            FROM HR.EMPLOYEES) -- 서브쿼리가 직원수만큼 실행됨, 비효율적임
        ORDER BY 4;
        
사용예) 2005년 6월 구매가 가장 많은 고객의 주소지 이외의 주소지에 거주하는 회원을 조회하시오.
       Alias는 회원번호, 회원명, 주소
       SELECT AS 회원번호,
              AS 회원명,
              AS 주소
              
        COMMIT;
        