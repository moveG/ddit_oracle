사용예) 모든 회원들의 평균 마일리지를 조회하시오.
       SELECT ROUND(AVG(MEM_MILEAGE), 2) AS "평균 마일리지"
         FROM MEMBER;
         
사용예) 모든 여성 회원들의 평균 마일리지를 조회하시오.   
       SELECT ROUND(AVG(MEM_MILEAGE), 2) AS "평균 마일리지"
         FROM MEMBER
        WHERE SUBSTR(MEM_REGNO2, 1, 1) IN('2', '4');
        
사용예) 회원들의 성별 평균 마일리지를 조회하시오.
       SELECT CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '2'
                     OR SUBSTR(MEM_REGNO2, 1, 1) = '4' THEN
                        '여성회원'
                   ELSE 
                        '남성회원' END AS 구분,
              ROUND(AVG(MEM_MILEAGE)) AS "평균 마일리지"
         FROM MEMBER
        GROUP BY CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '2'
                        OR SUBSTR(MEM_REGNO2, 1, 1) = '4' THEN
                           '여성회원'
                      ELSE 
                           '남성회원' END;

사용예) 사원 테이블에서 각 부서별 평균급여를 구하시오.
       Alias는 부서코드, 부서명, 평균급여
       SELECT A.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명,
              '$'||TO_CHAR(ROUND(AVG(SALARY)), '99,999') AS 평균급여
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        GROUP BY A.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
        -- DEPARTMENT_ID처럼 여러 테이블에서 사용되는 컬럼은 전부 별칭을 붙여, 확실하게 구분해줘야함
        -- B.DEPARTMENT_NAME처럼 한 테이블에서만 사용하는 컬럼은 별칭(B)은 빼도 무방하지만, 될 수 있으면 전부 별칭을 붙여주는게 좋음
        
사용예) 2005년 1~6월 월별 평균 매입액을 조회하시오.
       -- 매입액 BUYPROD, 매출자료 CART, 상품자료 PROD, 회원자료 MEMBER, 거래처자료 BUYER
       SELECT EXTRACT(MONTH FROM BUY_DATE)||'월' AS 월,
              TO_CHAR(ROUND(AVG(BUY_QTY * BUY_COST)), '99,999,999')||' 원' AS "평균 매입액"
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050630')
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
        ORDER BY 1;
        
사용예) 2005년 1~6월 월별 평균 매입액과 매입액 합계를 조회하되, 평균 매입액이 400만원 이상인 월만 조회하시오.
       SELECT EXTRACT(MONTH FROM BUY_DATE)||'월' AS 월,
              TO_CHAR(ROUND(AVG(BUY_QTY * BUY_COST)), '99,999,999')||' 원' AS "평균 매입액",
              TO_CHAR(SUM(BUY_QTY * BUY_COST), '999,999,999')||' 원' AS "매입액 합계"
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050630')
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
       HAVING AVG(BUY_QTY * BUY_COST) >= 4000000
        ORDER BY 1;        
        
사용예) 2005년 1~6월 월별 평균 매입액과 매입액 합계와 매입건수를 조회하되, 평균 매입액이 400만원 이상인 월만 조회하시오.
       SELECT EXTRACT(MONTH FROM BUY_DATE)||'월' AS 월,
              COUNT(*)||' 건' AS 매입건수,
              TO_CHAR(ROUND(AVG(BUY_QTY * BUY_COST)), '99,999,999')||' 원' AS "평균 매입액",
              TO_CHAR(SUM(BUY_QTY * BUY_COST), '999,999,999')||' 원' AS "매입액 합계"
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050630')
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
       HAVING AVG(BUY_QTY * BUY_COST) >= 4000000
        ORDER BY 1;
        
사용예) 2005년 분류별 평균 판매금액을 조회하시오.
       SELECT B.LPROD_GU AS 분류코드,
              B.LPROD_NM AS 분류명,
              TO_CHAR(ROUND(AVG(A.CART_QTY * C.PROD_PRICE)), '9,999,999')||' 원' AS "평균 판매금액"
         FROM CART A, LPROD B, PROD C
        WHERE A.CART_PROD = C.PROD_ID
          AND C.PROD_LGU = B.LPROD_GU
          AND SUBSTR(A.CART_NO, 1, 4) = '2005'
        GROUP BY B.LPROD_GU, B.LPROD_NM
        ORDER BY 1;

사용예) 2005년 회원의 연령대별 평균 판매금액을 조회하시오.
       SELECT TRUNC((EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM C.MEM_BIR)) / 10) * 10||'대' AS 연령대,
              TO_CHAR(ROUND(AVG(A.CART_QTY * B.PROD_PRICE)), '9,999,999')||' 원' AS "평균 판매금액"
         FROM CART A, PROD B, MEMBER C
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_MEMBER = C.MEM_ID
          AND A.CART_NO LIKE '2005%'
        GROUP BY TRUNC((EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM C.MEM_BIR)) / 10) * 10
        ORDER BY 1;

문제) 사원들 중 자기가 속한 부서의 평균급여보다 적은 급여를 받는 직원정보를 조회하시오.
     Alias는 사원번호, 사원명, 부서번호, 부서명, 급여, 부서평균급여
     제출일자 : 2021년 7월 31일까지
     제출방법 : 교사용 PC 공유폴더에 전송(SEM-PC D:\공유폴더\oracle\homework)
     문서타입 : 메모장에 저장된 TEXT문서
     문서이름 : 본인이름_0731.TXT
     SELECT TBLB.EMPLOYEE_ID AS 사원번호,
            TBLB.EMP_NAME AS 사원명,
            TBLA.DEPT_ID AS 부서번호,
            TBLA.DEPT_NAME AS 부서명,
            TBLB.SALARY AS 급여,
            TBLA.DEPT_AVG AS 부서평균급여
       FROM (SELECT A.DEPARTMENT_ID AS DEPT_ID,
                    A.DEPARTMENT_NAME AS DEPT_NAME,
                    ROUND(AVG(B.SALARY)) AS DEPT_AVG
               FROM HR.DEPARTMENTS A, HR.EMPLOYEES B
              WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
              GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME) TBLA,
            HR.EMPLOYEES TBLB
      WHERE TBLA.DEPT_ID = TBLB.DEPARTMENT_ID
        AND TBLB.SALARY < TBLA.DEPT_AVG
      ORDER BY 3;
      
사용예) 사원 테이블에서 각 부서별 사원수를 조회하시오.
       SELECT DEPARTMENT_ID AS 부서코드,
              COUNT(*) AS 사원수1,
              COUNT(LAST_NAME) AS 사원수2
         FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID
        ORDER BY 1;
        
       SELECT DEPARTMENT_ID AS 부서코드,
              COUNT(*) AS 사원수1,
              COUNT(LAST_NAME) AS 사원수2
         FROM HR.EMPLOYEES
        GROUP BY ROLLUP(DEPARTMENT_ID)
        ORDER BY 1;        
        
사용예) 2005년 5월 분류코드별 판매건수를 조회하시오.
       SELECT B.PROD_LGU AS 분류코드,
              COUNT(*) AS 판매건수
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY B.PROD_LGU
        ORDER BY 1;
        
사용예) 2005년 5~6월 회원별 매입횟수를 조회하시오.
       Alias는 회원번호, 매입횟수
       SELECT A.CID AS 회원번호,
              COUNT(*) AS 매입건수
         FROM (SELECT DISTINCT CART_NO AS CNO,
                      CART_MEMBER AS CID
                 FROM CART
                WHERE SUBSTR(CART_NO, 1, 6) IN('200505', '200506')
                ORDER BY 2)A
        GROUP BY A.CID
        ORDER BY 1;
       
-- DB는 미래 확장성이 있는 형태로 설계되어야함

사용예) 모든 부서별 사원수를 조회하시오. (NULL 부서코드는 무시)
       SELECT B.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명,
              COUNT(JOB_ID) AS 사원수
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID (+)= B.DEPARTMENT_ID
        GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
        -- 외부조인을 할 때는 값이 많은 쪽을 사용해야함
        -- 값이 적을 쪽을 사용하면 NULL이 삽입됨
        -- 외부조인 연산자(+)는 값이 적은 쪽에 넣어줌
        -- 사원이 없는 부서에 사원수가 1이 조회된 이유는 NULL값이 들어가서, NULL들어간 COUNT(*)가 줄 수를 카운트해서 사원수가 1이 됨
        -- COUNT(*) 대신 COUNT(컬럼명)을 쓰면 사원이 없는 부서에 정상적으로 사원수가 0으로 조회됨
        -- B.DEPARTMENT_ID가 A.DEPARTMENT_ID보다 값이 많으므로 A.DEPARTMENT_ID에 (+)를 붙여줘서 B.DEPARTMENT_ID만큼 확장시켜줌

사용예) 2005년 월별 매입액 중 최대매입제품과 최소매입제품의 최대매입액, 최소매입액을 조회하시오.
       Alias는 월, 최대매입액, 최소매입액
       SELECT EXTRACT(MONTH FROM BUY_DATE) AS 월,
              MAX(BUY_QTY * BUY_COST) AS 최대매입액,
              MIN(BUY_QTY * BUY_COST) AS 최소매입액
         FROM BUYPROD
        WHERE EXTRACT(YEAR FROM BUY_DATE) = 2005
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
        ORDER BY 1;
            
사용예) 2005년 5월 최대구매 고객정보를 조회하시오.
       Alias는 회원번호, 회원명, 구매금액
       -- 데이터베이스는 1촌(부모-자식)만 인식
       SELECT A.CART_MEMBER AS 회원번호,
              B.MEM_NAME AS 회원명,
              SUM(A.CART_QTY * C.PROD_PRICE) AS 구매금액
         FROM CART A, MEMBER B, PROD C
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_PROD = C.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER, B.MEM_NAME
        ORDER BY 3 DESC;
        -- 모든 회원의 구매금액을 내림차순으로 출력함
        -- 최대구매 회원만 출력할 수는 없음
        -- 최대구매 회원 한명만 출력하려면 서브쿼리를 사용해야함
        
       SELECT A.CART_MEMBER AS 회원번호,
              B.MEM_NAME AS 회원명,
              MAX(SUM(A.CART_QTY * C.PROD_PRICE)) AS 구매금액
         FROM CART A, MEMBER B, PROD C
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_PROD = C.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER, B.MEM_NAME;
        -- MAX(SUM()): 집계함수 안에 집계함수를 사용할 수 없음, 오류가 발생함
        
       SELECT A.CART_MEMBER AS 회원번호,
              B.MEM_NAME AS 회원명,
              SUM(A.CART_QTY * C.PROD_PRICE) AS 구매금액
         FROM CART A, MEMBER B, PROD C
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_PROD = C.PROD_ID
          AND A.CART_NO LIKE '200505%'
          AND ROWNUM = 1
        GROUP BY A.CART_MEMBER, B.MEM_NAME
        ORDER BY 3 DESC;
        -- ROWNUM은 회원번호 옆의 숫자를 의미한다, 이것은 오라클에서 임의로 부여한 의사코드임
        -- ROWNUM 1을 해도 최대구매 고객인 신영남이 아니라, 다른 사람이 출력됨
        -- 데이터가 SORT되기 전에 개수부터 카운트해서 다른 사람이 출력됨
        
사용예) 2005년 5월 최대구매 고객정보를 조회하시오.
       Alias는 회원번호, 회원명, 구매금액
       (SUBQUERY)
       SELECT A.MID AS 회원번호,
              A.MNAME AS 회원명,
              A.AMT AS 구매금액
         FROM (SELECT A.CART_MEMBER AS MID,
                      B.MEM_NAME AS MNAME,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS AMT
                 FROM CART A, MEMBER B, PROD C
                WHERE A.CART_MEMBER = B.MEM_ID
                  AND A.CART_PROD = C.PROD_ID
                  AND A.CART_NO LIKE '200505%'
                GROUP BY A.CART_MEMBER, B.MEM_NAME
                ORDER BY 3 DESC) A
        WHERE ROWNUM = 1;
        
       (SUBQUERY)
       SELECT D.MID AS 회원번호,
              D.MNAME AS 회원명,
              E.MEM_ADD1||' '||MEM_ADD2 AS 주소,
              E.MEM_HP AS 연락처,
              D.AMT AS 구매금액
         FROM (SELECT A.CART_MEMBER AS MID,
                      B.MEM_NAME AS MNAME,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS AMT
                 FROM CART A, MEMBER B, PROD C
                WHERE A.CART_MEMBER = B.MEM_ID
                  AND A.CART_PROD = C.PROD_ID
                  AND A.CART_NO LIKE '200505%'
                GROUP BY A.CART_MEMBER, B.MEM_NAME
                ORDER BY 3 DESC) D, MEMBER E
        WHERE D.MID = E.MEM_ID
          AND ROWNUM = 1;
        -- MEMBER가 서브쿼리 안밖으로 중복 사용됨, 안쪽의 MEMBER를 바깥에서 사용할 수 없음
        -- 서브쿼리 안쪽의 별칭과 바깥의 별칭은 중복되어도 상관이 없음

사용예) 사원 테이블에서 영업실적코드(COMMISSION_PCT)가 NULL이 아닌 사원을 조회하시오.
       Alias는 사원번호, 사원명, 입사일, 부서코드, 급여
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              HIRE_DATE AS 입사일,
              DEPARTMENT_ID AS 부서코드,
              SALARY AS 급여
         FROM HR.EMPLOYEES
        WHERE COMMISSION_PCT != NULL -- <> NULL
        ORDER BY 1;
        -- != NULL / <> NULL: NULL을 판별하지 못해, 조건에 맞는 값이 없어서 출력되지 않음
   
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              HIRE_DATE AS 입사일,
              DEPARTMENT_ID AS 부서코드,
              SALARY AS 급여
         FROM HR.EMPLOYEES
        WHERE COMMISSION_PCT IS NOT NULL
        ORDER BY 1;
        -- IS NOT NULL: 정상출력됨

사용예) 상품 테이블에서 PROD_SIZE 값이 NULL이면 '상품크기정보 없음' 문자열을 출력하시오.
       Alias는 상품코드, 상품명, 크기, 매입단가
       SELECT PROD_ID AS 상품코드,
              PROD_NAME AS 상품명,
              NVL(PROD_SIZE, '상품크기정보 없음') AS 크기,
              PROD_COST AS 매입단가
         FROM PROD;
   
사용예) 사원 테이블에서 사원번호, 사원명, 부서코드, 직무코드를 출력하시오. 단, 부서코드가 NULL이면 'CEO'를 출력하시오.
       Alias는 사원번호, 사원명, 부서코드, 직무코드
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              NVL(TO_CHAR(DEPARTMENT_ID), 'CEO') AS 부서코드,
              JOB_ID AS 직무코드
         FROM HR.EMPLOYEES
        ORDER BY 3 DESC;
        -- DEPARTMENT_ID는 NUMBER 타입이고, CEO는 문자열이므로 타입이 달라 오류가 발생함
        -- DEPARTMENT_ID를 TO_CHAR 함수로 문자열로 바꿔야 NVL이 정상작동함
        
** 상품 테이블에서 분류코드가 P301인 상품의 판매가를 매입가의 90%로 UPDATE하시오.
   UPDATE PROD
      SET PROD_PRICE = PROD_COST
    WHERE LOWER(PROD_LGU) = 'p301';
    -- 분류코드의 대소문자를 정확히 맞춰줘야하므로, LOWER를 이용해 PROD_LGU 전체를 소문자로 바꾼 다음, p301을 인식시킴.
    COMMIT;

사용예) 2005년 7월 모든 상품에 대한 판매정보를 조회하시오.
       Alias는 상품코드, 판매수량합계, 판매금액합계
       SELECT A.CART_PROD AS 상품코드,
              SUM(A.CART_QTY) AS 판매수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD (+)= B.PROD_ID
        GROUP BY A.CART_PROD
        ORDER BY 1;
        -- 상품코드는 CART보다 PROD 테이블에 더 많으므로 B 테이블의 컬럼명을 사용하는 것이 좋음
        -- B.RPOD_ID보다 A.CART_PROD가 더 적으므로 A.CART_PROD쪽에 (+)를 붙여줘야함
        -- 팔린 적이 없는 것은 NULL값으로 출력함
       
       SELECT B.PROD_ID AS 상품코드,
              SUM(A.CART_QTY) AS 판매수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD (+)= B.PROD_ID
        GROUP BY B.PROD_ID
        ORDER BY 1;
        -- A.CART_PROD 상품코드 값이 더 많은 B.PROD_ID를 사용하면 NULL대신 상품코드가 제대로 출력됨.
        
       SELECT B.PROD_ID AS 상품코드,
              SUM(A.CART_QTY) AS 판매수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD (+)= B.PROD_ID
          AND A.CART_NO LIKE '200507%'
        GROUP BY B.PROD_ID
        ORDER BY 1;
        -- 외부조인 대신 내부조인이 되어서 정확한 값이 출력되지 않고 20개의 값만 출력됨
        -- 외부조인에서 정확한 출력을 위해서는 서브쿼리 또는 ANSI JOIN을 사용해야함
       
       (ANSI JOIN 사용) 
       SELECT B.PROD_ID AS 상품코드,
              SUM(A.CART_QTY) AS 판매수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A
        RIGHT OUTER JOIN PROD B ON(A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200507%')
        GROUP BY B.PROD_ID
        ORDER BY 1;
        
       SELECT B.PROD_ID AS 상품코드,
              NVL(SUM(A.CART_QTY), 0) AS 판매수량합계,
              NVL(SUM(A.CART_QTY * B.PROD_PRICE), 0) AS 판매금액합계
         FROM CART A
        RIGHT OUTER JOIN PROD B ON(A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200507%')
        GROUP BY B.PROD_ID
        ORDER BY 1;
        -- NVL을 사용하여 NULL값 대신 0을 출력함

사용예) 사원 테이블에서 사원번호, 사원명, 부서코드, 직무코드를 출력하시오. 단, 부서코드가 NULL이면 'CEO'를 출력하시오.
       Alias는 사원번호, 사원명, 부서코드, 직무코드
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              NVL2(TO_CHAR(DEPARTMENT_ID), TO_CHAR(DEPARTMENT_ID), 'CEO') AS 부서코드,
              JOB_ID AS 직무코드
         FROM HR.EMPLOYEES
        ORDER BY 3 DESC;
              
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              NVL2(DEPARTMENT_ID, TO_CHAR(DEPARTMENT_ID), 'CEO') AS 부서코드,
              JOB_ID AS 직무코드
         FROM HR.EMPLOYEES
        ORDER BY 3 DESC;
        -- 'c'값은 'val1', 'val2'와의 데이터 타입을 맞추지 않아도 됨
              
사용예) 상품 테이블에서 상품의 색상정보(PROD_COLOR)의 값이 NULL이면 '색상정보 없는 상품'을, NULL이 아니면 '색상정보 보유 상품'을 출력하시오.
       Alias는 PROD_ID, PROD_NAME, PROD_COLOR
       SELECT PROD_ID,
              PROD_NAME,
              NVL(PROD_COLOR, '없음') AS 색상정보,
              NVL2(PROD_COLOR, '색상정보 보유 상품', '색상정보 없는 상품') AS 색상정보
         FROM PROD;

사용예) 상품 테이블에서 판매가와 매입가를 비교하여 판매가가 같지 않으면 '정상상품'을 같으면 '단종상품'을 비고란에 출력하시오.
       Alias는 상품코드, 상품명, 매입가, 판매가, 비고
       SELECT PROD_ID AS 상품코드,
              PROD_NAME AS 상품명,
              PROD_COST AS 매입가,
              PROD_PRICE AS 판매가,
              NULLIF(PROD_PRICE, PROD_COST) AS 비고
         FROM PROD;
         -- NULLIF에서 PROD_PRICE 혹은 NULL이 출력됨

       SELECT PROD_ID AS 상품코드,
              PROD_NAME AS 상품명,
              PROD_COST AS 매입가,
              PROD_PRICE AS 판매가,
              NVL2(NULLIF(PROD_PRICE, PROD_COST), '정상상품', '단종상품') AS 비고
         FROM PROD;
         -- NULLIF에서 반환된 PROD_PRICE 또는 NULL을, NVL2로 '정상상품'과 '단종상품'을 출력함

사용예) 상품 테이블에서 판매가와 매입가를 비교하여 판매가와 매입가가 같지 않으면 판매가를, 같으면 '단종상품'을 판매가란에 출력하시오.
       Alias는 상품코드, 상품명, 매입가, 판매가, 비고
       SELECT PROD_ID AS 상품코드,
              PROD_NAME AS 상품명,
              PROD_COST AS 매입가,
              NVL2(NULLIF(PROD_PRICE, PROD_COST), TO_CHAR(PROD_PRICE), '단종상품') AS 판매가
         FROM PROD;
         
       SELECT PROD_ID AS 상품코드,
              PROD_NAME AS 상품명,
              PROD_COST AS 매입가,
              NVL(LPAD(TO_CHAR(NULLIF(PROD_PRICE, PROD_COST)), 10), LPAD(TRIM('단종상품'), 12)) AS 판매가
         FROM PROD;

사용예) 
       SELECT COUNT(*)
         FROM CART, BUYPROD;
       -- 30636행 (207행 * 148행)
       SELECT COUNT(*)
         FROM BUYPROD;
       -- 207행
       SELECT COUNT(*)
         FROM CART;
       -- 148행  
       SELECT 207 * 148 FROM DUAL;
         
사용예) 
       SELECT COUNT(*)
         FROM CART, BUYPROD, PROD;
         
       SELECT COUNT(*)
         FROM CART
        CROSS JOIN BUYPROD
        CROSS JOIN PROD;

사용예) 매입 테이블에서 2005년 1월 상품별 매입현황을 조회하시오.
       Alias는 상품코드, 상품명, 매입수량합계, 매입금액합계
       (일반조인 사용형식)
       SELECT A.BUY_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              SUM(A.BUY_QTY) AS 매입수량합계,
              SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액합계
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD = B.PROD_ID -- 조인조건
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY A.BUY_PROD, B.PROD_NAME
        ORDER BY 1;
        
       (ANSI INNER JOIN 사용형식)
       SELECT A.BUY_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              SUM(A.BUY_QTY) AS 매입수량합계,
              SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액합계
         FROM BUYPROD A
        INNER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID)
        WHERE A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY A.BUY_PROD, B.PROD_NAME
        ORDER BY 1;
         
        SELECT A.BUY_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              SUM(A.BUY_QTY) AS 매입수량합계,
              SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액합계
         FROM BUYPROD A
        INNER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'))
        GROUP BY A.BUY_PROD, B.PROD_NAME
        ORDER BY 1;
        -- 테이블이 두개 밖에 없어서 AND, WHERE 둘 중 무엇을 사용해도 무방함

사용예) 사원 테이블에서 관리자 사원번호가 121번인 부서에 속한 사원 정보를 조회하시오.
       Alias는 사원번호, 사원명, 부서명, 직무명
       (일반조인 사용형식)
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID -- 조인조건
          AND A.JOB_ID = C.JOB_ID -- 조인조건
          AND B.MANAGER_ID = 121
        ORDER BY 1;
        -- 관리자 사원번호가 121번인 "부서"에 속한 사원 정보: DEPARTMENTS 테이블의 MANAGER_ID를 사용해야함
        
       (ANSI INNER JOIN 사용형식) 
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A
        INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND B.MANAGER_ID = 121)
        INNER JOIN HR.JOBS C ON (A.JOB_ID = C.JOB_ID)
        ORDER BY 1;

       (ANSI INNER JOIN 사용형식) 
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A
        INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
        INNER JOIN HR.JOBS C ON (A.JOB_ID = C.JOB_ID)
        WHERE B.MANAGER_ID = 121
        ORDER BY 1;

사용예) 2005년 거래처별 매출현황을 조회하시오.
       Alias는 거래처코드, 거래처명, 매출금액합계
       (일반조인 사용형식) 거래처에서 납품하는 제품들이 얼마나 많이 팔렸나?
       -- 컬럼명에 '_ID'가 붙은 것은 대부분 기본키
       -- 컬럼명에 '_LGU'가 붙은 것은 대부분 분류코드
       -- 날짜는 대부분 일반조건이므로 WHERE절에 작성함
       -- EXTRACT는 날짜 타입에 사용함
       SELECT B.BUYER_ID AS 거래처코드,
              B.BUYER_NAME AS 거래처명,
              SUM(A.CART_QTY * C.PROD_PRICE) AS 매출금액합계
         FROM CART A, BUYER B, PROD C
        WHERE A.CART_PROD = C.PROD_ID
          AND C.PROD_BUYER = B.BUYER_ID
          AND A.CART_NO LIKE '2005%'
       -- AND SUBSTR(A.CART_NO, 1, 4) = '2005'
        GROUP BY B.BUYER_ID, B.BUYER_NAME
        ORDER BY 1;

       (ANSI INNER JOIN 사용형식)
       SELECT B.BUYER_ID AS 거래처코드,
              B.BUYER_NAME AS 거래처명,
              SUM(A.CART_QTY * C.PROD_PRICE) AS 매출금액합계
         FROM BUYER B
        INNER JOIN PROD C ON (B.BUYER_ID = C.PROD_BUYER)
        INNER JOIN CART A ON (C.PROD_ID = A.CART_PROD
       -- AND A.CART_NO LIKE '2005%')
          AND SUBSTR(A.CART_NO, 1, 4) = '2005')
        GROUP BY B.BUYER_ID, B.BUYER_NAME
        ORDER BY 1;

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

사용예) 거래처 '마르죠'와 동일한 지역(광역시도)에 소재하고 있는 거래처 정보를 조회하시오.
       Alias는 거래처코드, 거래처명, 주소, 담당자
       -- B 테이블이 마르죠와 동일한 지역의 거래처를 찾기 위한 테이블임
       SELECT B.BUYER_ID AS 거래처코드,
              B.BUYER_NAME AS 거래처명,
              B.BUYER_ADD1||' '||B.BUYER_ADD2 AS 주소,
              B.BUYER_CHARGER AS 담당자
         FROM BUYER A, BUYER B
        WHERE A.BUYER_NAME = '마르죠' -- 일반조건
          AND SUBSTR(A.BUYER_ADD1, 1, 2) = SUBSTR(B.BUYER_ADD1, 1, 2);
          
사용예) 사원번호 108번 사원과 같은 부서에 속한 사원들을 조회하시오.
       Alias는 사원번호, 사원명, 부서명, 직무코드
       SELECT B.EMPLOYEE_ID AS 사원번호,
              B.EMP_NAME AS 사원명,
              C.DEPARTMENT_NAME AS 부서명,
              B.JOB_ID AS 직무코드
         FROM HR.EMPLOYEES A, HR.EMPLOYEES B, HR.DEPARTMENTS C
        WHERE A.EMPLOYEE_ID = 108
          AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
        ORDER BY 1;

사용예) 모든 상품별 매입현황을 조회화시오.
       -- 모든: OUTER JOIN, 상품별: GROUP BY
       -- 양쪽에 동시에 존재하는 컬럼의 경우 SELECT절에 많은 쪽을 사용해야함
       Alias는 상품코드, 상품명, 매입수량, 매입금액
       (일반외부조인 사용형식)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD (+)= B.PROD_ID
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
       
       (ANSI외부조인 사용형식)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID)
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;  
        
사용예) 2005년 1월 모든 상품별 매입현황을 조회화시오.
       Alias는 상품코드, 상품명, 매입수량, 매입금액
       (일반외부조인 사용형식)        
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD (+)= B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131') -- 내부조인되어 39개의 결과만 출력함
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
       
       -- 해결방법1 : ANSI외부조인 사용
       (ANSI외부조인 사용형식)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'))
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
        
       -- 해결방법2 : 해결안됨
       (ANSI외부조인 사용형식)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID)
        WHERE A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131') -- 내부조인되어 39개의 결과만 출력함
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
        
       -- 해결방법3 : 결합 
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM PROD B, (--2005년도 1월 매입정보(내부조인)) A
        WHERE B.컬럼명 = A.컬럼명 (+)
        ORDER BY 1;
       -- 2005년도 1월 매입정보(내부조인) 
       SELECT BUY_PROD AS BID,
              SUM(BUY_QTY) AS QAMT,
              SUM(BUY_QTY * BUY_COST) AS MAMT
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY BUY_PROD;        
       
       (SUBQUERY + 일반외부조인)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(A.QAMT, 0) AS 매입수량,
              NVL(A.MAMT, 0) AS 매입금액
         FROM PROD B, (SELECT BUY_PROD AS BID,
                              SUM(BUY_QTY) AS QAMT,
                              SUM(BUY_QTY * BUY_COST) AS MAMT
                         FROM BUYPROD
                        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
                        GROUP BY BUY_PROD) A
        WHERE B.PROD_ID = A.BID (+)
        ORDER BY 1;
        
사용예) 모든 부서별 사원수를 출력하시오.
       Alias는 부서코드, 부서명, 사원수
       (일반외부조인 사용형식)
       SELECT B.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명,
              COUNT(A.EMPLOYEE_ID) AS 사원수
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID (+)
        GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
       -- COUNT(*): NULL 값이 계산되어 사원이 없는 부서에 사원수가 1명으로 출력됨
       -- COUNT(A.EMPLOYEE_ID): 부서코드가 없는 CEO가 존재하기에 107명이 아닌, 106명만 출력됨
       
       (ANSI외부조인 사용형식)
       SELECT LPAD(NVL(TO_CHAR(B.DEPARTMENT_ID), '없음'), 4) AS 부서코드, -- 양쪽 타입을 맞추기 위해 TO_CHAR를 이용해 형변환 해줌
              NVL(B.DEPARTMENT_NAME, '없음') AS 부서명, -- 양쪽 타입이 동일하므로 TO_CHAR을 이용한 형변환이 필요없음
              COUNT(A.EMPLOYEE_ID) AS 사원수
         FROM HR.EMPLOYEES A
         FULL OUTER JOIN HR.DEPARTMENTS B ON (B.DEPARTMENT_ID = A.DEPARTMENT_ID)
        GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
       
사용예) 2005년 4월 모든 상품에 대한 판매현황을 조회하시오.
       Alias는 상품코드, 상품명, 판매수량, 판매금액
       (SUBQUERY + 일반외부조인)
       SELECT BBB.PROD_ID AS 상품코드,
              BBB.PROD_NAME AS 상품명,
              NVL(AAA.CQTY, 0) AS 판매수량,
              NVL(AAA.CPRI, 0) AS 판매금액
         FROM PROD BBB, (SELECT A.CART_PROD AS CID,
                                SUM(A.CART_QTY) AS CQTY,
                                SUM(A.CART_QTY * B.PROD_PRICE) AS CPRI
                           FROM CART A, PROD B
                          WHERE A.CART_PROD = B.PROD_ID
                            AND A.CART_NO LIKE '200504%'
                          GROUP BY A.CART_PROD) AAA
        WHERE BBB.PROD_ID = AAA.CID (+)
        ORDER BY 1;
        
       (ANSI외부조인 사용형식)       
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.CART_QTY), 0) AS 판매수량,
              NVL(SUM(A.CART_QTY * B.PROD_PRICE), 0) AS 판매금액
         FROM CART A
        RIGHT OUTER JOIN PROD B ON (A.CART_PROD = B.PROD_ID AND
              A.CART_NO LIKE '200504%')
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
        
        COMMIT;