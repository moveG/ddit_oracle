2021-0708-01)
 1)SELECT 절 구성
   SELECT [DISTINCT] 컬럼명|수식|데이터 [AS]["][별칭]["]
   -- []: 대괄호 안의 내용은 생략이 가능함
   . 'DISTINCT' : 중복된 값을 배제
   . '[AS]["][별칭]["]' : 컬럼에 부여된 또다른 이름으로 특수문자 사용시 ""(쌍따옴표)로 묶어 사용
    - 출력시 컬럼의 제목
    -- ""(큰따옴표): 컬럼명에 사용
    -- ''(따옴표): 문자열에 사용
   
사용예) 회원테이블(MEMBER)의 주민번호(MEM_REG01)을 사용하여 회원의 나이를 조회하시오.
       Alias는 회원번호, 회원명, 주민번호, 나이
       SELECT MEM_ID AS "FROM",
              MEM_NAME AS 회원명,
              MEM_REGNO1||'-'||MEM_REGNO2 AS "주민 번호",
              EXTRACT(YEAR FROM SYSDATE)-(TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))+1900) AS 나이
         FROM MEMBER;
       -- EXTRACT(YEAR FROM SYSDATE) ~ AS 나이: 만 나이 계상 공식, 나이(별칭)이 컬럼명이 됨
       -- FROM과 같이 오라클에서 지원하는 명령문을 컬럼명으로 쓰려면 ""(쌍따옴표)를 사용해야함
       -- ||: 문자열을 연결할 때 사용
       
  (1) 연산자(OPERATOR)
    - 산술연산자
      . +, -, *, /
        -- 자바는 문자열이 최우선 EX) "75" + 20 -> "75" + "20" -> 7520
        -- 오라클은 숫자가 최우선 EX) "75" + 20 ->   75 + 20   -> 95
        
사용예) HR계정의 사원테이블에서 보너스를 계산하여 급여의 지급액을 조회하시오.
       보너스 = 급여 * 영업실적코드(COMMISSION_PCT)의 35%
       지급액 = 급여 + 보너스
       출력 : 사원번호, 사원명, 급여, 보너스, 지급액
       SELECT EMPLOYEE_ID AS 사원번호,
              FIRST_NAME||' '||LAST_NAME AS 사원명,
              SALARY AS 급여,
              NVL(SALARY * COMMISSION_PCT * 0.35, 0) AS 보너스,
              SALARY + NVL(SALARY * COMMISSION_PCT * 0.35, 0) AS 지급액
         FROM HR.EMPLOYEES;
       -- 보너스가 NULL이라서 지급액도 NULL이 됨
       -- NVL + ,0을 붙이면 NULL값을 0으로 출력함
        
    - 관계연산자 : 대소 비교, TRUE/FALSE를 결과로 반환
      . >, <, >=, <=, =, !=(<>)
      -- <> : ><는 사용이 안됨
      
사용예) 회원테이블에서 마일리지가 4000이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오.
       마일리지가 많은 회원부터 조회하시오.
       -- LGU: 분류코드
       -- JOIN: 두 개 이상의 테이블을 서로 연결하여 데이터를 검색할 때 사용하는 방법
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_JOB AS 직업,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 200
        ORDER BY MEM_MILEAGE, MEM_ID DESC; -- 앞의 조건으로 정렬, 앞의 데이터가 동일한 사람은 뒤의 조건으로 정렬
     -- ORDER BY 4(컬럼인덱스) DESC; -- 컬럼명 대신 컬럼인덱스 사용 가능함
                                   -- 컬럼명 대신 함수나 연산자가 포함되어 있을 수도 있으므로 컬럼인덱스를 사용
                                   -- 컬럼인덱스: SELECT절에서 위에서부터 차례대로 1, 2, 3, 4, ...
                                   -- ORDER BY: 크기 순으로 정렬 ASC는 오름차순, DESC는 내림차순, DEFAULT값은 ASC(오름차순)
                                   -- 오름차순은 작->큰 / 내림차순 큰->작
      
**정보변경: UPDATE문
  UPDATE 테이블명
     SET 컬럼명=값[, 
         컬럼명=값, 
           :
         컬럼명=값]
  [WHERE 조건];
 
**회원테이블 정보 변경
 1) d001 회원의 주민번호 460409-2000000, 생년월일이 1946/04/09 ->
               주민번호 010409-4234765, 생년월일이 2001/04/09
 2) n001 회원의 주민번호 750323-1011014, 생년월일이 1975/03/23 ->
               주민번호 000323-3011014, 생년월일이 2000/03/23
 3) v001 회원의 주민번호 520131-2402712, 생년월일이 1952/01/31 ->
               주민번호 020131-4402712, 생년월일이 2002/01/31

1) UPDATE MEMBER
      SET MEM_REGNO1 = '010409',
          MEM_REGNO2 = '4234765',
          MEM_BIR = TO_DATE('20010409')
    WHERE MEM_ID = 'd001';
    
   SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
     FROM MEMBER
    WHERE MEM_ID = 'd001';

2) UPDATE MEMBER
      SET MEM_REGNO1 = '000323',
          MEM_REGNO2 = '3011014',
          MEM_BIR = TO_DATE('20000323')
    WHERE MEM_ID = 'n001';
    
   SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
     FROM MEMBER
    WHERE MEM_ID='n001';

3) UPDATE MEMBER
      SET MEM_REGNO1 = '020131',
          MEM_REGNO2 = '4402712',
          MEM_BIR = TO_DATE('2002/01/31') -- /가 들어가도 업데이트 가능
    WHERE MEM_ID = 'v001';
    
   SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
     FROM MEMBER
    WHERE MEM_ID='v001';
    
   -- 한번에 여러명 조회하기 (기타 연산자)
   SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
     FROM MEMBER
    WHERE MEM_ID IN('d001', 'n001', 'v001');

사용예) 회원테이블에서 여성회원정보를 조회하시오.
       Alias 회원번호, 회원명, 생년월일, 마일리지, 비고
-- 비고란에 남성회원, 여성회원을 삽입하는 방법 CASE~
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_BIR AS 생년월일,
              MEM_MILEAGE AS 마일리지,
              CASE WHEN SUBSTR(MEM_REGNO2,1,1)='2' OR
                        SUBSTR(MEM_REGNO2,1,1)='4' THEN
                              '여성회원'
                   ELSE            
                              '남성회원'
              END AS 비고                
         FROM MEMBER
        WHERE SUBSTR(MEM_REGNO2,1,1)= ANY('2', '4'); -- 1,1 : 1번째부터 1글자
     -- WHERE SUBSTR(MEM_REGNO2,1,1)= '2'
     --    OR
     --       SUBSTR(MEM_REGNO2,1,1)= '4';

    - 논리연산자
      . NOT, AND, OR
      -- 관계연산을 여러개 연결할 때 사용
      -- AND는 직렬(조건 중 하나라도 FALSE라면 모두 FALSE), OR은 병렬(조건 중 하나라도 TRUE라면 모두 TRUE)
      -- NOT, AND, OR 순서로 우선순위가 결정됨
      . NOT: 논리부정
      -------------------------------
         입력      출력
       A     B    (OR) (AND) (EX-OR)
      -------------------------------
       0     0     0     0     0
       0     1     1     0     1
       1     0     1     0     1
       1     1     1     1     0
      -------------------------------
      -- 0: FALSE / 1: TRUE
      -- EX-OR: 배타적 논리합, 양쪽에 같은 값이 들어오면 0, 다른 값이 들어오면 1
               A                     B
      MEM_MILEAGE >= 2000 OR EXTRACT(YEAR FROM MEM_BIR) <= 2000

사용예) 사원테이블에서 평균급여 이상 급여를 받는 사원을 조회하시오.
       Alias는 사원번호, 사원명, 급여, 부서번호
       SELECT EMPLOYEE_ID AS 사원번호,
              FIRST_NAME AS 사원명,
              SALARY AS 급여,
              DEPARTMENT_ID AS 부서번호,
              ROUND((SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES),0) AS 평균급여
         FROM HR.EMPLOYEES
        WHERE NOT SALARY < (SELECT AVG(SALARY)
                              FROM HR.EMPLOYEES) -- NOT(평균급여보다 작음) -> 평균급여보다 크거나 같음
        ORDER BY 4;            
     
    - 기타연산자
      . IN, ANY, SOME, ALL, EXISTS, BETWEEN, LIKE 등 제공
      -- IN, ANY, SOME, ALL, EXISTS: 데이터가 하나 이상 존재할 때 사용
      -- BETWEEN: 범위에 해당하는 데이터비교 A AND B
      -- LIKE: 패턴을 검색할 때 사용
      
      
    SELECT * FROM JOBS;
    -- 오류가 발생함
    -- LDG89계정에서는 HR계정을 볼 수 없다
    SELECT * FROM HR.JOBS;
    -- 다른 계정의 TABLE을 보고 싶으면 TABLE명 앞에 "계정명."을 붙여준다
   

  COMMIT;