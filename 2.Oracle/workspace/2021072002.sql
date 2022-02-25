2021-0720-02) NULL처리 함수
  - 오라클에서 각 컬럼의 기본 초기값은 모두 NULL임
  - NULL자료에 대한 사칙연산 결과는 모두 NULL임
  - NULL자료에 대한 연산자 및 함수로 IS NULL, IS NOT NULL, NVL, NVL2, NULLIF 등이 사용됨
  -- NULL값은 존재 자체는 문제없지만 연산에 참여하게 되면 문제가 됨
  -- 어떤 연산을 해도 NULL값을 출력하므로 원하는 결과값을 얻을 수 없음
  -- 그러므로 NULL값에 대한 처리가 필요함

  1. IS NULL, IS NOT NULL
   - 특정 컬럼이나 계산된 값이 NULL인지 판별하기 위해 사용
   - '=' 연산자로 NULL값 여부를 판별하지 못함
   
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
   
  2. NVL(c, val)
   - 'c'의 값을 판단하여 그 값이 NULL이면 'val' 값을 반환하고, NULL이 아니면 'c'의 값을 반환함
   - 'c'와 'val'의 데이터 타입이 동일해야함
   -- 문자열과 숫자형이라면 오류가 발생하지만, 문자열이 숫자로 변환될 수 있는 문자열이라면 자동으로 형변환되어 오류가 발생하지 않음
   
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
        
  3. NVL2(c, val1, val2)
   - 'c'의 값을 판단하여 그 값이 NULL이면 'val2' 값을 반환하고, NULL이 아니면 'val1'의 값을 반환함
   - 'val1'과 'val2'의 데이터 타입이 동일해야함
   - 'c'값은 데이터 타입을 맞추지 않아도 됨
   -- 문자열과 숫자형이라면 오류가 발생하지만, 문자열이 숫자로 변환될 수 있는 문자열이라면 자동으로 형변환되어 오류가 발생하지 않음
   -- NVL(c, val1)을 NVL2(c, c, val2)형식으로 쓸 수도 있음
   
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
        
  4. NULLIF(c1, c2)
   - 'c1'과 'c2'를 비교하여 같으면 NULL을 반환하고, 같지 않으면 'c1'을 반환함

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
      
         COMMIT;
         