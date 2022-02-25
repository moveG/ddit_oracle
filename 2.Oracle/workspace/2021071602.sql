2021-0716-02) 집계함수
  - 주어진 자료를 특정 컬럼을 기준으로 그룹으로 나누고, 그룹 별로 자료에 대한 집계를 반환하는 함수
  - SUM, AVG, COUNT, MIN, MAX
  -- 같은 형식끼리 모으는 것
  -- SELECT문을 주의해야함, SELECT문을 잘못 구성하면 원하는 자료를 얻기 어려움
  -- 일반컬럼과 집계함수가 함께 나오면, 일반컬럼을 기준으로 그룹을 이루어서 집계함수의 결과를 출력함
  -- 부서코드, 인원수, 평균임금이 나오면, 일반컬럼인 부서코드를 기준으로 그룹을 이루어서 집계함수를 이용해 인원수와 평균임금을 출력하면 됨
  -- 집계함수가 사용되지 않은 일반컬럼은 GROUP BY에 모두 기술해서 묶어줘야함
  -- 왼쪽에서 오른쪽으로 갈수록 그룹 크기가 작아짐(대그룹 => 소그룹)
  -- 그룹 안에, 그룹 안에, 그룹 안에... 중첩된 그룹이 됨
  
  (사용형식)
   SELECT [컬럼list],
          SUM|AVG|MIN|MAX(expr)|COUNT(column|*),
                      :
     FROM 테이블명
   [WHERE 조건]
   [GROUP BY 컬럼명[, 컬럼명,...]]
  [HAVING 조건]
   [ORDER BY 컬럼명|컬럼인덱스[ASC|DESC][, 컬럼명|컬럼인덱스[ASC|DESC],...]];
   -- []안의 것은 생략이 가능한 부분임
   -- HAVING, WHERE절 다음에 조건이 나옴
   -- WHERE에는 일반적인 조건이 기술됨
   -- HAVING에는 집계함수에(SUM, AVG, MIN MAX, COUNT) 부여된 조건이 기술됨
   -- WHERE, GROUP BY, HAVING, ORDER BY 순서를 맞춰 쓰는게 좋음
 
  1. SUM(expr)
   - 'expr'로 표현되는 수식 또는 컬럼의 값에 대한 합계를 반환

사용예) 사원 테이블에서 모든 사원의 급여 총액을 구하시오.
       SELECT SUM(SALARY)
         FROM HR.EMPLOYEES;
         -- 일반컬럼이 존재하면 GROUP BY가 필수 이지만, 일반컬럼이 없으면 GROUP BY는 불필요함
        
사용예) 사원 테이블에서 부서별 급여 합계를 구하시오.
       -- **별: **가 기본컬럼이 되어야함
       SELECT DEPARTMENT_ID AS 부서코드,
              SUM(SALARY) AS 급여합계
         FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID
        ORDER BY 1;
        -- 일반컬럼을 GROUP BY를 이용해 묶어줘야함
   
사용예) 사원 테이블에서 부서별 급여 합계를 구하되, 합계가 10000이상인 부서만 조회하시오.
       조건 : 합계가 10000이상
       SELECT DEPARTMENT_ID AS 부서코드,
              SUM(SALARY) AS 급여합계
         FROM HR.EMPLOYEES
     -- WHERE SUM(SALARY) >= 10000
        WHERE DEPARTMENT_ID IS NOT NULL -- 부서코드가 없는 사장은 제외, 오라클SQL은 '!=' 기호를 인식하지 못함
        GROUP BY DEPARTMENT_ID
       HAVING SUM(SALARY) >= 10000 -- 집계함수에 대한 조건은 HAVING 부분에 기술해야함
        ORDER BY 1;
   
사용예) 2005년 5월 회원별 구매현황(회원번호, 구매수량합계, 구매금액합계)을 조회하시오.
       SELECT A.CART_MEMBER AS 회원번호,
              SUM(A.CART_QTY) AS 구매수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 구매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER;

사용예) 2005년 월별 회원별 구매현황(구매월, 회원번호, 구매수량합계, 구매금액합계)을 조회하시오.
       SELECT SUBSTR(A.CART_NO, 5, 2) AS 구매월,            -- 일반컬럼
              A.CART_MEMBER AS 회원번호,                    -- 일반컬럼
              SUM(A.CART_QTY) AS 구매수량합계,               -- 집계함수
              SUM(A.CART_QTY * B.PROD_PRICE) AS 구매금액합계 -- 집계함수
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID            
          AND SUBSTR(A.CART_NO, 1, 4) = '2005'          -- 2005년
        GROUP BY SUBSTR(A.CART_NO, 5, 2), A.CART_MEMBER -- 월별, 회원별 / 일반컬럼 묶어줌
        ORDER BY 1, 2;
   
사용예) 회원 테이블에서 직업별 마일리지 합계를 구하시오.
       SELECT MEM_JOB AS 직업,                  -- 일반컬럼
              SUM(MEM_MILEAGE) AS "마일리지 합계" -- 집계함수
         FROM MEMBER
        GROUP BY MEM_JOB                       -- 직업별 / 일반컬럼을 묶어줌
        ORDER BY 1;
        -- 직업별로 묶어서 합계를 구하는 것은 오라클이 해야할 일이므로, WHERE절에 이를 구하기 위한 공식을 기술할 필요가 없음
   
문제) 사원 테이블에서 근무국가별 급여합계를 구하시오.
     SELECT D.COUNTRY_ID AS 국가코드,
            D.COUNTRY_NAME AS 국가명,
            COUNT(*) AS 사원수,
            TO_CHAR(SUM(A.SALARY), '999,990') AS 급여합계
       FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C, HR.COUNTRIES D
      WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        AND B.LOCATION_ID = C.LOCATION_ID
        AND C.COUNTRY_ID = D.COUNTRY_ID
      GROUP BY D.COUNTRY_ID, D.COUNTRY_NAME -- D.COUNTRY_NAME은 적을 의미가 없지만, GROUP BY 절의 형식을 맞추기 위해 적어줘야함
      ORDER BY 1;
      
사용예) 사원 테이블에서 각 부서별 보너스 합계를 구하시오.
       Alias는 부서코드, 부서명, 보너스 합계이고, 보너스는 영업실적(COMMISSION_PCT)과 급여를 곱한 결과의 30%
       UPDATE HR.EMPLOYEES
          SET COMMISSION_PCT = 0.2
        WHERE EMPLOYEE_ID = 107;
        
        COMMIT;
     
       SELECT A.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명,
              NVL(SUM(A.COMMISSION_PCT * A.SALARY) * 0.3, 0) AS "보너스 합계"
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        GROUP BY A.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
        -- 내부 JOIN은 JOIN 조건이 맞지 않으면, 그 값은 버려짐
        
        COMMIT;
