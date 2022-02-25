사용예) 공유폴더의 강의자료 97쪽 논리 ERD를 참조하여 사원, 사업장, 사업장자재, 근무 테이블을 생성하시오.
       [사원 테이블]
       1)테이블명 : EMPLOYEE
       2)컬럼
       ---------------------------------------------
       컬럼명      데이터타입(크기)      N.N      PK/FK
       ---------------------------------------------
       EMP_ID     CHAR(4)            N.N        PK
       EMP_NAME   VARCHAR2(30)       N.N
       E_ADDR     VARCHAR2(80)
       E_TEL      VARCHAR2(20)
       E_POSITION VARCHAR2(30)
       E_DEPT     VARCHAR2(50)
       ---------------------------------------------
       CREATE TABLE EMPLOYEE (
         EMP_ID     CHAR(4)      NOT NULL,
         EMP_NAMEE  VARCHAR2(30) NOT NULL,
         E_ADDR     VARCHAR2(80),
         E_TEL      VARCHAR2(20),
         E_POSITION VARCHAR2(30),
         E_DEPT     VARCHAR2(50),
         CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EMP_ID));
  
사용예) 
       [사업장 테이블]
       1)테이블명 : SITE
       2)컬럼
       ---------------------------------------------
       컬럼명      데이터타입(크기)      N.N      PK/FK
       ---------------------------------------------
       SITE_ID    CHAR(4)                      PK
       SITE_NAME  VARCHAR2(30)       N.N
       SITE_ADDR  VARCHAR2(80)
       REMARKS    VARCHAR2(255)
       ---------------------------------------------
       -- PK(기본키)는 중복배제를 위해 자동으로 NOT NULL이 부여됨       
       CREATE TABLE SITE (
         SITE_ID   CHAR(4),
         SITE_NAME VARCHAR(30) NOT NULL,
         SITE_ADDR VARCHAR(80),
         REMARKS   VARCHAR2(255),
         CONSTRAINT PK_SITE PRIMARY KEY (SITE_ID));
       
사용예) 
       [근무 테이블]
       1)테이블명 : WORK
       2)컬럼
       ---------------------------------------------
       컬럼명      데이터타입(크기)      N.N      PK/FK
       ---------------------------------------------
       EMP_ID     CHAR(4)            N.N     PK % FK
       SITE_ID    CHAR(4)            N.N     PK % FK
       INPUT_DATE DATE
       ---------------------------------------------       
       CREATE TABLE WORK (
         EMP_ID     CHAR(4) NOT NULL,
         SITE_ID    CHAR(4) NOT NULL,
         INPUT_DATE DATE,
         CONSTRAINT PK_WORK PRIMARY KEY (EMP_ID, SITE_ID),
         CONSTRAINT FK_WORK_EMP FOREIGN KEY(EMP_ID)
           REFERENCES EMPLOYEE(EMP_ID),
         CONSTRAINT FK_WORK_SITE FOREIGN KEY(SITE_ID)
           REFERENCES SITE(SITE_ID));
       
사용예) 사원 테이블(EMPLOYEE)에 다음 자료를 입력하시오.
       -----------------------------------------------------------------------------------
       사원번호    이름       주소                   전화번호          직위        부서
       -----------------------------------------------------------------------------------
       A101      홍길동      대전시 중구 대흥동      042-222-8202      사원      공공 개발부
       A104      강감찬                                             대리      기술영업부
       A105      이순신                                             부장
       -----------------------------------------------------------------------------------
       INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, E_ADDR, E_TEL, E_POSITION, E_DEPT)
         VALUES ('A101', '홍길동', '대전시 중구 대흥동', '042-222-8202', '사원', '공공 개발부');
       INSERT INTO EMPLOYEE
         VALUES ('A104', '강감찬', '', '', '대리', '기술영업부');
       INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, E_POSITION)
         VALUES ('A105', '이순신', '부장');
         
사용예) 사업장 테이블(SITE)에 다음 자료를 입력하시오.
       -----------------------------------------------------------------------------------
       사업장번호       사업장명                주소                   비고
       -----------------------------------------------------------------------------------
       S100      대흥초등학교보수공사      대전시 중구 대흥동
       S200      건물 신축
       -----------------------------------------------------------------------------------         
       INSERT INTO WORK (SITE_ID, SITE_NAME, SITE_ADDR)
         VALUES ('S100', '대흥초등학교보수공사', '대전시 중구 대흥동');
       INSERT INTO
         VALUES ('S200', '건물신축', NULL, '');
       
사용예) 근무 테이블(WORK)에 다음 자료를 입력하시오.
       (1) 홍길동 사원이 오늘부로 'S200' 사업장에서 근무       
       INSERT INTO WORK VALUES ('A101', 'S200', SYSDATE);
       (2) 이순신 부장이 2020년 10월 01일부터 'S200' 사업장에서 근무
       INSERT INTO WORK VALUES ('A105', 'S200', TO_DATE('20201001');
       (3) 강감찬 대리가 'S100' 사업장에서 근무
       INSERT INTO WORK (EMP_ID, SITE_ID) VALUES ('A104', 'S100');
       
사용예) S200에 근무하는 사원정보를 조회하시오.
       Alias는 사업장명, 사원번호, 사원명, 직위, 전화번호이다.      
       SELECT A.SITE_NAME AS 사업장명,
              B.EMP_ID AS 사원번호,
              B.EMP_NAME AS 사원명,
              B.E_POSITION AS 직위,
              B.E_TEL AS 전화번호
         FROM SITE A, EMPLOYEE B, WORK C
        WHERE A.SITE_ID=C.SITE_ID
          AND A.EMP_ID=C.EMP_ID
          AND A.SITE_ID=UPPER('S200');
       
사용예) 사원 테이블에서 'A101' 사원정보를 삭제하시오.
       DELETE EMPLOYEE
        WHERE UPPER(EMP_ID)='A101'
       -- ROLLBACK 가능

사용예) EMPLOYEE 테이블 삭제
       DROP TABLE WORK;
       DROP TABLE EMPLOYEE;
       DROP TABLE SITE;
       -- ROLLBACK 불가능
       
사용예) 회원테이블(MEMBER)의 주민번호(MEM_REG01)을 사용하여 회원의 나이를 조회하시오.
       Alias는 회원번호, 회원명, 주민번호, 나이
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_REGNO1||'-'||MEM_REGNO2 AS 주민번호,
              EXTRACT(YEAR FROM SYSDATE)-(TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))+1900) AS 나이
         FROM MEMBER;

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
       
사용예) 회원테이블에서 마일리지가 4000이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오.
       마일리지가 많은 회원부터 조회하시오.
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_JOB AS 직업,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 200
        ORDER BY MEM_MILEAGE, 1 DESC;

사용예) 회원테이블 정보 변경
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
       
    SELECT MEM_ID AS 회원번호,
           MEM_REGNO1||'-'||MEM_REGNO2 AS 주민번호,
           MEM_BIR AS 생년월일
      FROM MEMBER
     WHERE MEM_ID = 'd001'
     
 2) UPDATE MEMBER
       SET MEM_REGNO1 = '000323',
           MEM_REGNO2 = '3011014',
           MEM_BIR = TO_DATE('20000323')
     WHERE MEM_ID = 'n001';
     
     SELECT MEM_ID AS 회원번호,
            MEM_REGNO1||'-'||MEM_REGNO2 AS 주민번호,
            MEM_BIR AS 생년월일
       FROM MEMBER
      WHERE MEM_ID = 'n001';
      
 3) UPDATE MEMBER
       SET MEM_REGNO1 = '020131',
           MEM_REGNO2 = '4402712',
           MEM_BIR = TO_DATE('2002/01/31') -- /가 들어가도 업데이트 가능
     WHERE MEM_ID = 'v001';
    
    SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
      FROM MEMBER
     WHERE MEM_ID='v001';
     
 4) SELECT MEM_ID, MEM_REGNO1, MEM_REGNO2, MEM_BIR
      FROM MEMBER
     WHERE MEM_ID IN('d001', 'n001', 'v001');   

사용예) 회원테이블에서 여성회원정보를 조회하시오.
       Alias 회원번호, 회원명, 생년월일, 마일리지, 비고
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_BIR AS 생년월일,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE SUBSTR(MEM_REGNO2,1,1) = '2'
           OR SUBSTR(MEM_REGNO2,1,1) = '4';

사용예) 사원테이블에서 평균급여 이상 급여를 받는 사원을 조회하시오.
       Alias 는 사원번호, 사원명, 급여, 부서번호
       SELECT EMPLOYEE_ID AS 사원번호,
              FIRST_NAME AS 사원명,
              SALARY AS 급여,
              DEPARTMENT_ID AS 부서번호,
              ROUND((SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES), 0) AS 평균급여
         FROM HR.EMPLOYEES
        WHERE NOT SALARY < (SELECT AVG(SALARY)
                              FROM HR.EMPLOYEES)
        ORDER BY DEPARTMENT_ID;
     
       SELECT * FROM HR.JOBS;
       
       -- 컬럼
       -- ALTER TABLE
       --   ADD, DROP COLUMN, RENAME COLUMN, MODIFY
       
사용예) 사원테이블에서 FIRST_NAME과 LAST_NAME을 합쳐 EMP_NAME항목을 만들어보시오.      
 1) 사원테이블에서 EMP_NAME VARCHAR2(80) 컬럼을 추가하시오.
    ALTER TABLE HR.EMPLOYEES
      ADD(EMP_NAME VARCHAR2(80));
       
 3) FIRST_NAME과 LAST_NAME값을 EMP_NAME에 저장하시오.
    UPDATE HR.EMPLOYEES
       SET EMP_NAME = FIRST_NAME||' '||LAST_NAME;
       
사용예) 사원테이블(HR계정)에서 10, 30, 40, 60번 부서에 속한 사원들의 사원번호, 사원명, 부서코드, 입사일을 조회하시오.
       (OR 연산자 사용)       
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              DEPARTMENT_ID AS 부서코드,
              HIRE_DATE AS 입사일
         FROM HR.EMPLOYEES
        WHERE DEPARTMENT_ID=10
           OR DEPARTMENT_ID=30
           OR DEPARTMENT_ID=40
           OR DEPARTMENT_ID=60
        ORDER BY 3;
        
       (IN 연산자 사용)       
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              DEPARTMENT_ID AS 부서코드,
              HIRE_DATE AS 입사일
         FROM HR.EMPLOYEES
        WHERE DEPARTMENT_ID IN(10, 30, 40, 60)
        ORDER BY 3;
       
       (ANY(SOME) 연산자 사용)
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              DEPARTMENT_ID AS 부서코드,
              HIRE_DATE AS 입사일
         FROM HR.EMPLOYEES
     -- WHERE DEPARTMENT_ID = ANY(10, 30, 40, 60)
        WHERE DEPARTMENT_ID = SOME(10, 30, 40, 60)
        ORDER BY 3;       
       
사용예) 사원테이블(HR계정)에서 20, 40, 70번 부서에 속한 사원들의 급여보다 급여가 많은 사원의 사원번호, 사원명, 급여, 부서번호를 조회하시오.
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              SALARY AS 급여,
              DEPARTMENT_ID AS 부서번호
         FROM HR.EMPLOYEES
        WHERE SALARY > ALL (SELECT SALARY
                              FROM HR.EMPLOYEES
                             WHERE DEPARTMENT_ID IN(20, 40, 70));
     -- WHERE SALARY > (SELECT MAX(SALARY)
     --                       FROM HR.EMPLOYEES
     --                      WHERE DEPARTMENT_ID IN(20, 40, 70));                                
       
사용예) 매입정보테이블(BUYPROD)에서 2005년 3월 매입현황을 출력하시오.
       Alias는 날짜, 제품코드, 매입수량, 매입금액이다.       
       (AND 연산자 사용)       
       SELECT BUY_DATE AS 날짜,
              BUY_PROD AS 제품코드,
              BUY_QTY AS 매입수량,
              BUY_QTY * BUY_COST AS 매입금액
         FROM BUYPROD
        WHERE BUY_DATE >= TO_DATE('20050301')
          AND BUY_DATE <= LAST_DAY(TO_DATE('20050301'));
          
       (BETWEEN 연산자 사용)
       SELECT BUY_DATE AS 날짜,
              BUY_PROD AS 제품코드,
              BUY_QTY AS 매입수량,
              BUY_QTY * BUY_COST AS 매입금액
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050301') AND LAST_DAY(TO_DATE('20050301'));
       
사용예) 회원테이블에서 40대 회원의 회원번호, 회원명, 마일리지를 조회하시오.
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR) BETWEEN 40 AND 49;
       
사용예) 회원의 생년월일 컬럼에서 월을 추출하시오.
       SELECT EXTRACT(MONTH FROM MEM_BIR),
              SUBSTR(MEM_BIR,6,2)
         FROM MEMBER;
         
사용예) 회원테이블에서 이번달의 생일이 있는 회원번호, 회원명을 조회하시오.
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명
         FROM MEMBER
        WHERE EXTRACT(MONTH FROM SYSDATE) = EXTRACT(MONTH FROM MEM_BIR);
    --  WHERE EXTRACT(MONTH FROM SYSDATE) = SUBSTR(MEM_BIR,6,2); 
       
사용예) 분류코드가 P2로 시작하는 상품에 대하여 2005년 5월 매출실적(CART TABLE)을 조회하시오.
       Alias는 상품코드, 상품명, 분류코드, 분류명, 판매수량, 금액이다.
       SELECT A.PID AS 상품코드,
              A.PNAME AS 상품명,
              LPROD_GU AS 분류코드,
              LPROD_NM AS 분류명,
              A.QAMT AS 판매수량,
              A.MAMT AS 금액       
         FROM LPROD,(SELECT CART_PROD AS PID,
                            PROD_NAME AS PNAME,
                            SUM(CART_QTY) AS QAMT,
                            SUM(CART_QTY * PROD_PRICE) AS MAMT
                       FROM CART, PROD
                      WHERE CART_PROD = PROD_ID
                        AND CART_NO LIKE '200505%'
                        AND PROD_LGU BETWEEN 'P200' AND 'P299' -- 문자열도 BETWEEN 가능
                      GROUP BY CART_PROD, PROD_NAME) A,
              PROD
        WHERE PROD_ID = A.PID
          AND PROD_LGU = LPROD_GU
        ORDER BY 1;
       
사용예) 회원테이블에서 대전에 거주하는 회원들을 조회하시오.
       Alias는 회원번호, 회원명, 주소, 직업, 마일리지이다.
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_JOB AS 직업,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '대전%';   
        
사용예) 장바구니테이블에서 2005년 7월 판매현황을 조회하시오.
       Alias는 일자, 상품코드, 판매수량이다.
       (LIKE 연산자 사용)
       SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS 일자,
              CART_PROD AS 상품코드,
              CART_QTY AS 판매수량
         FROM CART
        WHERE CART_NO LIKE '200507%';
       
       (BETWEEN 연산자 사용)
       SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS 일자,
              CART_PROD AS 상품코드,
              CART_QTY AS 판매수량
         FROM CART
        WHERE SUBSTR(CART_NO, 1, 6) BETWEEN TO_NUMBER('200506') AND TO_NUMBER('200507');
       
 commit;       