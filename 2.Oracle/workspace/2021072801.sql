2021-0728-01) 집합연산자
  - 집합연산자는 SELECT문의 결과를 대상으로 연산을 수행
  - 복잡한 서브쿼리나 조인을 줄일 수 있음
  - 여러개의 SELECT문을 하나로 묶는 역할 수행
  - UNION ALL, UNION, INTERSECT, MINUS 제공
  ** 주의사항
    - 각 SELECT문의 같은 개수, 같은 타입의 컬럼을 조회해야함
    - 각 SELECT문들이 여러개의 컬럼을 조회하는 경우 모든 컬럼에 대한 집합연산을 수행
    - ORDER BY는 사용할 수 있으나 가장 마지막 SELECT문에서만 사용이 가능
    - 출력은 첫번째 SELECT문에 의해 결정됨

  1) UNION
    . 합집합의 결과를 반환
    . 교집합 부분(공통부분)의 중복은 배제됨
    
사용예) 사원 테이블에서 'Seattle'에 근무하는 사원과 'IT'부서에 근무하는 사원을 조회하시오.
       1) 'Seattle'에 근무하는 사원
       Alias는 사원번호, 사원명, 소재지, 직무명
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        ORDER BY 1;
              
       2) 'IT'부서에 근무하는 사원
       Alias는 사원번호, 사원명, 소재지, 직무명       
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'IT'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;
              
       3) 결합 : UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'IT'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;
     -- UNION을 할 때 ORDER BY절은 마지막에만 나올 수 있음        
              
       4) 'Administration'부서에 근무하는 사원
       Alias는 사원번호, 사원명, 소재지, 직무명       
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Administration'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;  
  
       5) 결합 : UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 부서명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Administration'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;  
  
       6) 결합 : UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Accounting'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;
  
       7) 결합 : UNION ALL -- 두 테이블에서 중복 값을 중복 출력함
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION ALL
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Accounting'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;  
  
사용예) 회원 테이블에서 마일리지가 3000이상인 회원과 직업이 공무원인 회원을 조회하시오.
       1) 마일리지가 3000이상인 회원
       Alias는 회원번호, 회원명, 주소, 마일리지
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
        
       2) 직업이 공무원인 회원
       Alias는 회원번호, 회원명, 주소, 마일리지  
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '공무원';
        
       3) 결합 : UNION -- 마일리지가 3000이상인 회원 7명, 직업이 공무원인 4명을 합쳐 두조건을 모두 만족하는 1명의 중복을 제외해서 10명이 출력됨
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000
        UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '공무원';

       4) 결합 : UNION -- 타입이 달라서 출력이 불가능함
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000
        UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_JOB AS 직업 -- 타입이 달라서 출력이 불가능함
         FROM MEMBER
        WHERE MEM_JOB = '공무원';

       5) 결합 : UNION -- 마일리지와 주민번호1은 타입은 동일하지만 값이 달라서 중복으로 판단하지 않고 각각을 모두 출력함
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000
        UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              TO_NUMBER(MEM_REGNO1) AS 주민번호1
         FROM MEMBER
        WHERE MEM_JOB = '공무원';
        -- 될 수 있으면 값을 맞춰주는 것이 좋음

  2) UNION ALL
    . 합집합의 결과를 반환
    . 교집합 부분(공통부분)이 중복되어 출력됨

사용예) 회원 테이블에서 마일리지가 2000이상인 회원과 직업이 주부인 회원을 조회하시오.
       1) 마일리지가 2000이상인 회원
       Alias는 회원번호, 회원명, 주소, 마일리지
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 2000;
        
       2) 직업이 주부인 회원
       Alias는 회원번호, 회원명, 주소, 마일리지  
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '주부';
        
       3) 결합 : UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 2000
        UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '주부';

       4) 결합 : UNION ALL -- f001 같은 경우 마일리지가 2000이상이어서 출력되고, 직업이 주부라서 출력됨, 중복을 제거하지 않음
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 2000
        UNION ALL
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '주부';

사용예) 2005년 4월과 7월에 팔린 상품정보를 조회하시오.
       1) 2005년 4월에 팔린 상품정보 -- 67개 출력
       Alias는 상품코드, 상품명, 판매가격, 거래처명
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        ORDER BY 1;

       2) 2005년 7월에 팔린 상품정보
       Alias는 상품코드, 상품명, 판매가격, 거래처명 -- 20개 출력
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;

       3) 결합 : UNION -- 68개 출력
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        UNION
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;

       3) 결합 : UNION ALL -- 87개 출력
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        UNION ALL
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;

  3) INTERSECT
    . 교집합(공통부분)의 결과를 반환

사용예) 2005년 4월에 판매된 상품 중, 7월에도 판매된 상품정보를 조회하시오.
       Alias는 상품코드, 상품명, 판매가격, 거래처명
       1) 결합 : INTERSECT
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        INTERSECT
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;
  
사용예) 부서명이 'Shipping'에 속한 사원 중 'Matthew Weiss' 사원의 팀에 소속된 직원을 조회하시오.
       1) 부서명이 'Shipping'에 속한 사원 -- 45명 출력
       Alias는 사원번호, 사원명, 부서명, 입사일, 급여
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              A.HIRE_DATE AS 입사일,
              A.SALARY AS 급여
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE B.DEPARTMENT_NAME = 'Shipping'
          AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
        ORDER BY 1;

       2) 'Mattew Weiss' 사원의 팀에 소속된 직원 -- 8명 출력
       Alias는 사원번호, 사원명, 부서명, 입사일, 급여
       SELECT C.EMPLOYEE_ID AS 사원번호,
              C.EMP_NAME AS 사원명,
              D.DEPARTMENT_NAME AS 부서명,
              C.HIRE_DATE AS 입사일,
              C.SALARY AS 급여
         FROM (SELECT A.EMPLOYEE_ID AS EID
                 FROM HR.EMPLOYEES A
                WHERE A.EMP_NAME = 'Matthew Weiss') B,
              HR.EMPLOYEES C, HR.DEPARTMENTS D
        WHERE C.MANAGER_ID = B.EID
          AND C.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY 1;
        
       3) 결합 : INTERSECT -- 8명 출력
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              A.HIRE_DATE AS 입사일,
              A.SALARY AS 급여
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND B.DEPARTMENT_NAME = 'Shipping'
        INTERSECT
       SELECT C.EMPLOYEE_ID AS 사원번호,
              C.EMP_NAME AS 사원명,
              D.DEPARTMENT_NAME AS 부서명,
              C.HIRE_DATE AS 입사일,
              C.SALARY AS 급여
         FROM (SELECT A.EMPLOYEE_ID AS EID
                 FROM HR.EMPLOYEES A
                WHERE A.EMP_NAME = 'Matthew Weiss') B,
              HR.EMPLOYEES C, HR.DEPARTMENTS D
        WHERE C.MANAGER_ID = B.EID
          AND C.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY 1;

  4) MINUS
    . MINUS 연산자 앞에 위치한 쿼리의 결과에서 MINUS 뒤에 기술된 쿼리의 결과를 차감한 결과를 반환

사용예) 장바구니 테이블에서 4월과 6월에 판매된 상품 중 4월에만 판매된 상품을 조회하시오.
       1) 4월에 판매된 상품 -- 67명 출력
       Alias는 상품번호, 상품명, 수량합계, 판매금액합계
       SELECT DISTINCT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명,
              SUM(A.CART_QTY) AS 수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200504%'
        GROUP BY A.CART_PROD, B.PROD_NAME
        ORDER BY 1;
        
       2) 6월에 판매된 상품 -- 15명 출력
       Alias는 상품번호, 상품명, 수량합계, 판매금액합계
       SELECT DISTINCT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명,
              SUM(A.CART_QTY) AS 수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200506%'
        GROUP BY A.CART_PROD, B.PROD_NAME
        ORDER BY 1;
        
       3) 결합 : MINUS -- 53명 출력
       SELECT DISTINCT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명
--            SUM(A.CART_QTY) AS 수량합계,
--            SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200504%'
--      GROUP BY A.CART_PROD, B.PROD_NAME
        MINUS
       SELECT DISTINCT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명
--            SUM(A.CART_QTY) AS 수량합계,
--            SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200506%'
--      GROUP BY A.CART_PROD, B.PROD_NAME
        ORDER BY 1;
        
        COMMIT;