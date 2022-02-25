2021-0715-01)
  3. 날짜함수
   1) SYSDATE
    - 시스템에서 제공하는 날짜정보(년, 월, 일, 시, 분, 초)를 반환
    - '+', '-' 연산의 대상
    - 날짜 - 날짜 : 두 날짜 사이의 날수(DAYS)를 반환
    -- 날짜정보를 사용자가 직접 입력할 경우 컴퓨터 지정형식을 위반해서는 안됨
    -- 시, 분, 초 중 일부가 누락되면 날짜로 인식하지 못함
    -- 가장 많이 사용됨
    
사용예)
       SELECT SYSDATE - 10,
              TO_CHAR(SYSDATE, 'YYYY MM DD HH24:MI:SS'),
              TRUNC(SYSDATE - TO_DATE('19900715'))
         FROM DUAL;

   2) ADD_MONTHS(d, n)
    - 날짜형식의 자료 d에 n만큼의 월을 더한 날짜로 변환
    
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
        -- 전체인원은 107명인데, 106명만 출력됨
        -- 소속부서 값이 없는(NULL) 사장은 출력에서 제외됨, 조건에 부합되지 않은 값은 출력에서 제외됨

   3) NEXT_DAY(d, expr)
    - 주어진 날짜 d에서 다가올 가장 빠른 'expr'요일의 날짜를 반환
    - expr : 월, 화, ..., 일, 월요일, 화요일, ..., 일요일
    -- 가장 빠른 요일에서 오늘은 제외함
    -- 사용 빈도는 낮음
    
사용예) 
       SELECT NEXT_DAY(SYSDATE, '월'),
              NEXT_DAY(SYSDATE, '목'),
              NEXT_DAY(SYSDATE, '일요일')
         FROM DUAL;
         
   4) LAST_DAY(d)
    - 날짜자료 d에 포함된 월의 마지막 일을 반환
    -- 주로 윤년 때문에 2월(28일, 29일 구분)에 많이 사용됨
    
사용예) 매입 테이블(BUYPROD)에서 2월에 매입된 매입건수를 조회하시오.
       --매입건수는 BUY_QTY의 행수(줄수)
       SELECT COUNT(*) AS 매입건수
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050201') AND LAST_DAY(TO_DATE('20050201'));
         
   5) MONTHS_BETWEEN(d1, d2)
    - 두 날짜자료 사이의 월수 변환
    -- 정수가 아닌, 실수로 반환됨
    -- 사용 빈도는 낮음
    
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

   6) EXTRACT(fmt FROM d)
    - 날짜자료 d에서 'fmt'로 기술된 자료를 추출함
    - 반환값의 형식은 숫자형식임
    - 'fmt' : YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
    -- SYSDATE 다음으로 많이 사용됨
    -- 동시에 여러개를 추출하지는 못함
    
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
    
    COMMIT;
