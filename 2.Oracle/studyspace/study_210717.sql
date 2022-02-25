사용예) 회원 테이블에서 충남에 거주하는 회원정보를 조회하시오.
       Alias는 회원번호, 회원명, 주민번호, 주소이며, 주민번호는 'XXXXXX-XXXXXXX'형식으로 출력
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_REGNO1||'-'||MEM_REGNO2 AS 주민번호,
              MEM_ADD1||' '||MEM_ADD2 AS 주소
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '충남%'
        ORDER BY 1;

사용예) 회원 테이블에서 충남에 거주하는 회원정보를 조회하시오.
       Alias는 회원번호, 회원명, 주민번호, 주소이며, 주민번호는 'XXXXXX-XXXXXXX'형식으로 출력
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              CONCAT(CONCAT(MEM_REGNO1, '-'), MEM_REGNO2) AS 주민번호,
              CONCAT(CONCAT(MEM_ADD1, ' '), MEM_ADD2) AS 주소
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '충남%'
        ORDER BY 1;

사용예) 오늘이 2005년 4월 1일인 경우 CART_NO를 자동 생성하시오.
       SELECT TO_CHAR(SYSDATE, 'YYYYMMDD')||TRIM(TO_CHAR(TO_NUMBER(SUBSTR((CART_NO), 9)) + 1, '00000'))
         FROM CART
        WHERE CART_NO LIKE '20050401%';
        
       SELECT MAX(CART_NO) + 1
         FROM CART
        WHERE CART_NO LIKE '20050401%';

사용예) 
       SELECT REPLACE('대전광역시 중구 대흥동', '전광역시', '전시'),
              REPLACE('대전광역시 중구 대흥동', '광역'),
              REPLACE('대전광역시 중구 대흥동', ' '),
              REPLACE('대전광역시 중구 대흥동', '대')
         FROM DUAL;
         
사용예) 
       SELECT INSTR('APPLE PERSIMON PEAR BEAR', 'E'),
              INSTR('APPLE PERSIMON PEAR BEAR', 'P', 5),
              INSTR('APPLE PERSIMON PEAR BEAR', 'P', 5, 2),
              INSTR('APPLE PERSIMON PEAR BEAR', 'P', 5, 3)
         FROM DUAL;
         
사용예) 
       SELECT GREATEST(50, 70, 90),
              LEAST(50, 70, 90)
         FROM DUAL;
         
사용예) 회원 테이블에서 마일리지가 1000 미만인 모든 회원의 마일리지를 1000으로 수정 출력하시오.
       Alias는 회원번호, 회원명, 원본 마일리지, 수정마일리지
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS "원본 마일리지",
              GREATEST(MEM_MILEAGE, 1000) AS "수정 마일리지"
         FROM MEMBER;
         
       SELECT MAX(MEM_NAME) FROM MEMBER;


         
사용예) 회원 테이블에서 마일리지가 1000 미만인 모든 회원의 마일리지를 1000으로 수정 출력하시오.
       Alias는 회원번호, 회원명, 원본 마일리지, 수정마일리지
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS "원본 마일리지",
              GREATEST(MEM_MILEAGE, 1000) AS "수정 마일리지"
         FROM MEMBER;
         
       SELECT GRREATEST(MEM_NAME) FROM MEMBER; -- 오류
       SELECT MAX(MEM_NAME) FROM MEMBER; -- 정상

사용예) 사원 테이블에서 급여의 지급액을 계산하여 출력하시오.
       Alias는 사원번호, 사원명, 급여, 세금, 지급액
       세금 = 급여액의 17%
       지급액은 급여 - 세금
       소수점 1자리까지 출력
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              SALARY AS 급여,
              TRUNC(SALARY * 0.17, 1) AS 세금,
              SALARY - TRUNC(SALARY * 0.17, 1) AS 지급액
         FROM HR.EMPLOYEES;
       
사용예) 2005년 1월 ~ 3월 제품분류별 평균매입액을 조회하시오.
       Alias는 분류코드, 분류명, 평균매입금액
       평균매입금액은 정수로(소수점 없이) 표현, 1의 자리에서 반올림
       SELECT C.PROD_LGU AS 분류코드,
              B.LPROD_NM AS 분류명,
              ROUND(AVG(A.BUY_QTY * C.PROD_COST), -1) AS 평균매입금액
         FROM BUYPROD A, LPROD B, PROD C
        WHERE A.BUY_PROD = C.PROD_ID
          AND C.PROD_LGU = B.LPROD_GU
          AND A.BUY_DATE BETWEEN '20050101' AND '20050331'
        GROUP BY C.PROD_LGU, B.LPROD_NM
        ORDER BY 1;
       
사용예) 
       SELECT FLOOR(12.5), CEIL(12.5),
              FLOOR(12), CEIL(12),
              FLOOR(-12.5), CEIL(-12.5)
         FROM DUAL;

사용예) 임의의 년도를 입력받아 윤년과 평년을 구별하시오.
       윤년: (4의 배수이면서 100의 배수가 아니거나),
            (400의 배수가 되는 해)
       ACCEPT P_YEAR  PROMPT '년도 입력'
       DECLARE
         V_YEAR NUMBER(4) := TO_NUMBER('&P_YEAR');
         V_RES VARCHAR(100);
       BEGIN
         IF (MOD(V_YEAR, 4) = 0 AND MOD(V_YEAR, 100) != 0) OR MOD(V_YEAR, 400) = 0 THEN
            V_RES := TO_CHAR(V_YEAR)||'년은 윤년입니다.';
         ELSE
            V_RES := TO_CHAR(V_YEAR)||'년은 평년입니다.';
         END IF;
         
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;
       
사용예) 
       SELECT WIDTH_BUCKET(90, 0, 100, 10) FROM DUAL;       
       
사용예) 회원 테이블에서 회원들의 마일리지를 3개의 그룹으로 나누고 각 회원들의 마일리지가 속한 그룹을 조회하여
       1그룹에 속한 회원은 '새싹 회원',
       2그룹에 속한 회원은 '정규 회원',
       3그룹에 속한 회원은 'VIP 회원'을 비고란에 출력하시오.
       Alias는 회원번호, 회원명, 직업, 마일리지, 비고
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_JOB AS 직업,
              MEM_MILEAGE AS 마일리지,
              CASE WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 3) = 1 THEN
                        '새싹 회원'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 3) = 2 THEN
                        '정규 회원'
                   ELSE
                        'VIP 회원'
              END AS 비고
         FROM MEMBER;

사용예)         
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_JOB AS 직업,
              MEM_MILEAGE AS 마일리지,
              CASE WHEN WIDTH_BUCKET(MEM_MILEAGE, (SELECT MIN(MEM_MILEAGE)
                                                     FROM MEMBER),
                                                  (SELECT MAX(MEM_MILEAGE) + 1
                                                     FROM MEMBER), 3) = 1 THEN
                        '새싹 회원'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, (SELECT MIN(MEM_MILEAGE)
                                                     FROM MEMBER),
                                                  (SELECT MAX(MEM_MILEAGE) + 1
                                                     FROM MEMBER), 3) = 2 THEN
                        '정규 회원'
                   ELSE
                        'VIP 회원'
              END AS 비고
         FROM MEMBER;

사용예) 회원 테이블에서 회원들의 마일리지를 5개의 그룹으로 나누고 등급을 비고란에 출력하시오.
       등급은 마일리지가 많은 회원이 1등급이고, 제일 작은 회원이 5등급이다.
       Alias는 회원번호, 회원명, 직업, 마일리지, 비고
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_JOB AS 직업,
              MEM_MILEAGE AS 마일리지,
              CASE WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 1 THEN
                        '5등급'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 2 THEN
                        '4등급'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 3 THEN
                        '3등급'
                   WHEN WIDTH_BUCKET(MEM_MILEAGE, 500, 9000, 5) = 4 THEN
                        '2등급'
                   ELSE
                        '1등급'
              END AS 비고
         FROM MEMBER
        ORDER BY 5;
       
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS 마일리지,
              WIDTH_BUCKET(MEM_MILEAGE, 9000, 500, 5)||'등급' AS 비고
         FROM MEMBER
        ORDER BY 4;
       
사용예)
       SELECT SYSDATE - 10,
              TO_CHAR(SYSDATE, 'YYYY MM DD HH24:MI:SS'),
              TRUNC(SYSDATE - TO_DATE('19900715'))
         FROM DUAL;
       
사용예) 사원의 정식 입사일은 수습기간 3개월이 지난 날짜이다. 각 사원이 이 회사에 처음 입사한 날짜를 구하시오.
       Alias는 사원번호, 사원명, 입사일, 수습입사일, 소속부서
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              A.HIRE_DATE AS 입사일,
              ADD_MONTHS(A.HIRE_DATE, -3) AS 수습입사일,
              B.DEPARTMENT_NAME AS 소속부서
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        ORDER BY 5;
        
사용예)
       SELECT NEXT_DAY(SYSDATE, '월'),
              NEXT_DAY(SYSDATE, '목'),
              NEXT_DAY(SYSDATE, '일요일')
         FROM DUAL;
       
사용예) 매입 테이블(BUYPROD)에서 2월에 매입된 매입건수를 조회하시오.
       --매입건수는 BUY_QTY의 행수(줄수)
       SELECT COUNT(*) AS 매입건수
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050201') AND LAST_DAY(TO_DATE('20050201'));

사용예)
       SELECT MONTHS_BETWEEN(SYSDATE, HIRE_DATE) AS 근속개월수
         FROM HR.EMPLOYEES;
         
       SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS 근속개월수
         FROM HR.EMPLOYEES;
 
       SELECT EMP_NAME,
              HIRE_DATE,
              TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) ||'년 '||
              MOD(TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), 12) ||'개월' AS 근속기간
         FROM HR.EMPLOYEES;

사용예) 이번 달에 생일이 있는 회원의 정보를 조회하시오.
       Alias는 회원번호, 회원명, 생년월일
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_BIR AS 생년월일
         FROM MEMBER
        WHERE EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM MEM_BIR);
        -- 7월달 생일이 없어서 출력은 없음
       
       SELECT EXTRACT(HOUR FROM SYSTIMESTAMP),
              EXTRACT(MINUTE FROM SYSTIMESTAMP),
              EXTRACT(SECOND FROM SYSTIMESTAMP)
         FROM DUAL;

사용예) 
       SELECT MEM_NAME AS 회원명,
              CAST(SUBSTR(MEM_REGNO1, 1, 2) AS NUMBER) + 1900 AS 출생년도,
              EXTRACT(YEAR FROM SYSDATE) - (CAST(SUBSTR(MEM_REGNO1, 1, 2) AS NUMBER) + 1900) AS 나이
         FROM MEMBER
        WHERE NOT MEM_REGNO1 LIKE '0%'
    
사용예) 
       SELECT SYSDATE FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'CC') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'CC BC YYYY"년"') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'CC BC YY"년"') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'CC BC YYYY"년" Q"분기"') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'YYYY MON MONTH') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'YYYY MON DD DDD J') FROM DUAL;
       SELECT TO_CHAR(SYSDATE, 'YYYY DAY DY D') FROM DUAL;

사용예) 
       SELECT TO_CHAR(2345, '99,999') FROM DUAL;
       SELECT TO_CHAR(2345, '00,000') FROM DUAL;
       SELECT TO_CHAR(12345, 'L99,999') FROM DUAL;
       SELECT TO_CHAR(12345, '99,999L') FROM DUAL;
       SELECT TO_CHAR(12345, '$99,999') FROM DUAL;
       SELECT TO_CHAR(-12345, '99,999PR') FROM DUAL;
       SELECT TO_CHAR(12345, '99,999PR') FROM DUAL;
       SELECT TO_CHAR(255, 'XXXX') FROM DUAL;
       SELECT TO_CHAR(255, 'XX') FROM DUAL;
    
사용예) 
       SELECT TO_NUMBER('12345', '99999'),
              TO_NUMBER('12345', '9999999'),
              TO_NUMBER('12345', '9000000'),
              TO_NUMBER('12345', '9900000'),
           -- TO_NUMBER('12345', '0000009'),
           -- TO_NUMBER('12345', '99,999'),
           -- TO_NUMBER('-12345', '99999PR'),
              TO_NUMBER('12345', '99999PR'),
              TO_NUMBER('12345')
         FROM DUAL;

사용예) 
       SELECT TO_DATE('20200320'),
              TO_DATE('20200320', 'YYYYMMDD'),
              TO_DATE('20200320', 'YYYY/MM/DD'),
              TO_DATE('20200320', 'YYYY MM DD')
           -- TO_DATE('20200332', 'YYYY MM DD')
           -- TO_DATE('20200320', 'AM YYYYMMDD')
           -- TO_DATE('20200320', 'YYYY MONTH DD')
         FROM DUAL;

사용예) 사원 테이블에서 모든 사원의 급여 총액을 구하시오.
       SELECT SUM(SALARY)
         FROM HR.EMPLOYEES;
           
사용예) 사원 테이블에서 부서별 급여 합계를 구하시오.
       -- **별: **가 기본컬럼이 되어야함
       SELECT DEPARTMENT_ID AS 부서코드,
              SUM(SALARY) AS 급여합계
         FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID
        ORDER BY 1;

사용예) 사원 테이블에서 부서별 급여 합계를 구하되, 합계가 10000이상인 부서만 조회하시오.
       조건 : 합계가 10000이상
       SELECT DEPARTMENT_ID AS 부서코드,
              SUM(SALARY) AS 급여합계
         FROM HR.EMPLOYEES
        WHERE DEPARTMENT_ID IS NOT NULL
        GROUP BY DEPARTMENT_ID
       HAVING SUM(SALARY) >= 10000
        ORDER BY 1;

사용예) 2005년 5월 회원별 구매현황(회원번호, 구매수량합계, 구매금액합계)을 조회하시오.
       SELECT A.CART_MEMBER AS 회원번호,
              SUM(A.CART_QTY) AS 구매수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 구매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY CART_MEMBER
        ORDER BY 1;
        
사용예) 2005년 월별 회원별 구매현황(구매월, 회원번호, 구매수량합계, 구매금액합계)을 조회하시오.
       SELECT SUBSTR(A.CART_NO, 5, 2) AS 구매월,
              A.CART_MEMBER AS 회원번호,
              SUM(A.CART_QTY) AS 구매수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 구매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO, 1, 4) = '2005'
        GROUP BY SUBSTR(A.CART_NO, 5, 2), A.CART_MEMBER
        ORDER BY 1, 2;

사용예) 회원 테이블에서 직업별 마일리지 합계를 구하시오.
       SELECT MEM_JOB AS 직업,
              SUM(MEM_MILEAGE) AS "마일리지 합계"
         FROM MEMBER
        GROUP BY MEM_JOB
        ORDER BY 2;
       
사용예) 사원 테이블에서 근무국가별 급여합계를 구하시오
       SELECT A.COUNTRY_NAME AS 근무국가,
              SUM(B.SALARY) AS 급여합계
         FROM HR.COUNTRIES A, HR.EMPLOYEES B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE A.COUNTRY_ID = D.COUNTRY_ID
          AND D.LOCATION_ID = C.LOCATION_ID
          AND C.DEPARTMENT_ID = B.DEPARTMENT_ID
        GROUP BY A.COUNTRY_NAME
        ORDER BY 1;
    
        COMMIT;