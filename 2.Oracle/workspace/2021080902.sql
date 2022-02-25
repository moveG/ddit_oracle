2021-0809-02) PACKAGE
    - 논리적 연관성이 있는 PL/SQL의 변수, 상수커서, 서브프로그램(함수, 프로시져)들의 항목을 묶어놓은 객체
    - 다른 객체에서 패키지 항목들을 공유하고 실행함
    - 모듈화 기능을 제공함
    - 프로그램 설계의 용이성을 제공함
    - 캡슐화 기능을 제공함
    - 선언부와 본문부로 구성됨
    
  1. 패키지 선언부
    - 패키지에서 사용할 변수, 상수 함수 등의 선언영역(명세)
    (사용형식)
      CREATE [OR REPLACE] PACKAGE 패키지명 IS
        변수, 상수, 커서 선언;
        FUNCTION 함수명[(매개변수 list)]
          RETURN 반환타입;
                    :
       PROCEDURE 프로시져명(매개변수 list);
                    :
      END 패키지명;
      
  2. 패키지 본문부
    - 선언부에서 선언된 PL/SQL객체들의 구현내용을 기술함
    (사용형식)
      CREATE [OR REPLACE] PACKAGE BODY 패키지명 IS
        변수명 타입;
        상수명 CONSTANT 타입;
        커서 정의;
        
        FUNCTION 함수명[(매개변수 list)]
          RETURN 타입
        IS
          선언부;
        BEGIN
          실행부;
          RETURN expr;
        END 함수명; -- 함수명은 생략이 가능하지만, END가 여러개 나오므로 구분을 위해 함수명을 기술해주는 것이 좋음
                     :
        PROCEDURE 프로시져명[(매개변수 list)]
        IS
          선언부;
        BEGIN
          실행부;
        END 프로시져명; -- 프로시져명은 생략이 가능하지만, 구분을 위해 함수명을 기술해주는 것이 좋음
      END 패키지명;
      
  ** 사원 테이블에 퇴직일자 컬럼을 추가하시오.
     -- HR계정에서 작동함
     컬럼명           타입           NULL 여부
     RETIRE_DATE     DATE -- 입사하면서 퇴직일자를 정해놓지는 않기 때문에 NULL을 허용해야함(NULL 상태이면 근무중)
     
     ALTER TABLE EMPLOYEES
       ADD RETIRE_DATE DATE ;
     
     COMMIT;

사용예) 사원관리에 필요한 함수 등을 관리
       - 패키지명 : PKG_EMP
       - FN_GET_NAME : 사원번호를 입력받아 이름을 반환하는 함수
       - PROC_NEW_EMP : 신규사원정보 입력 프로시져(사원번호, LAST_NAME, 이메일, 입사일, JOB_ID)
                                              -- NOT NULL항목이라 반드시 입력해야함
       - PROC_RETIRE_EMP : 퇴직자처리 프로시져
       (패키지 선언부)
       CREATE OR REPLACE PACKAGE PKG_EMP
       IS
         -- 사원번호를 입력받아 이름을 반환하는 함수
         FUNCTION FN_GET_NAME( -- 함수를 선언하는 선언부
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE) -- 사원번호를 입력받을 변수
           RETURN VARCHAR2;
         
         -- 신규사원정보 입력 프로시져
         PROCEDURE PROC_NEW_EMP(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
           P_LNAME IN EMPLOYEES.LAST_NAME%TYPE,
           P_EMAIL IN EMPLOYEES.EMAIL%TYPE,
           -- 입사일은 오늘날짜이라서 굳이 여기에 입력할 이유가 없어서 생략함
           P_JOB_ID IN JOBS.JOB_ID%TYPE);
           
         -- 퇴직자처리 프로시져
         PROCEDURE PROC_RETIRE_EM(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE);
       END PKG_EMP;
       -- 본문부 없이 선언부 만으로도 컴파일이 가능함
       
       (패키지 본문부)
       CREATE OR REPLACE PACKAGE BODY PKG_EMP -- 본문부에는 BODY를 붙여줘야함
       IS
         FUNCTION FN_GET_NAME(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE)
           RETURN VARCHAR2
         IS
           V_ENAME EMPLOYEES.EMP_NAME%TYPE;
         BEGIN
           SELECT EMP_NAME INTO V_ENAME
             FROM EMPLOYEES
            WHERE EMPLOYEE_ID = P_EID;
           RETURN V_ENAME;
         END FN_GET_NAME;
       
         PROCEDURE PROC_NEW_EMP(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
           P_LNAME IN EMPLOYEES.LAST_NAME%TYPE,
           P_EMAIL IN EMPLOYEES.EMAIL%TYPE,
           P_JOB_ID IN JOBS.JOB_ID%TYPE)
         IS
         BEGIN
           INSERT INTO EMPLOYEES(EMPLOYEE_ID, LAST_NAME, EMAIL, JOB_ID, HIRE_DATE, EMP_NAME)
             VALUES(P_EID, P_LNAME, P_EMAIL, P_JOB_ID, SYSDATE - 1, P_LNAME||'길동');
           COMMIT; -- 트리거에서는 COMMIT을 사용하지 못하지만, 프로시져나 함수에서는 사용할 수 있음
         END PROC_NEW_EMP;
         
         PROCEDURE PROC_RETIRE_EM(
           P_EID IN EMPLOYEES.EMPLOYEE_ID%TYPE)
         IS
         BEGIN
           UPDATE EMPLOYEES
              SET RETIRE_DATE = SYSDATE
            WHERE EMPLOYEE_ID = P_EID;
           COMMIT;
         END PROC_RETIRE_EM;
       END PKG_EMP;
       
       (패키지 실행)
       SELECT PKG_EMP.FN_GET_NAME(EMPLOYEE_ID)
         FROM EMPLOYEES
        WHERE DEPARTMENT_ID = 60; 
       
       EXECUTE PKG_EMP.PROC_NEW_EMP(250, '홍', 'gdhong@gmail.com', 'FI_ACCOUNT');
       
       EXEC PKG_EMP.PROC_RETIRE_EM(150);