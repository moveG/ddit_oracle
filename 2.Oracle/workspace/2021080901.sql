2021-0809-01)

사용예) 사원테이블에서 사원번호 125번(Julia Nayer) 사원의 직무가 'ST_CLERK'에서 'ST_MAN'으로 승진되었다.
       이 정보를 사원테이블에 반영하고 난 후 직무변동 테이블을 갱신하시오.
       -- 직무코드, 월급, 이력 테이블 갱신
       -- HR계정에서 작동함
       (행단위 트리거)
       CREATE OR REPLACE TRIGGER TG_JOB_CHANGE
         AFTER UPDATE ON EMPLOYEES
         FOR EACH ROW
       DECLARE
         V_EID EMPLOYEES.EMPLOYEE_ID%TYPE := :OLD.EMPLOYEE_ID; -- OLD.EMPLOYEE_ID 대신 125번 사원번호를 입력해도 됨
         V_CNT NUMBER := 0; -- JOB_HISTORY에 사원번호 125번이 존재하나 판단
         V_SDATE DATE;
         V_EDATE DATE;
       BEGIN
         SELECT COUNT(*) INTO V_CNT
           FROM JOB_HISTORY
          WHERE EMPLOYEE_ID = 125;
         
         IF V_CNT = 0 THEN -- JOB_HISTORY에 이전 기록이 없는 경우
           V_SDATE := :OLD.HIRE_DATE; -- 입사일이 현 직무 시작일
           V_EDATE := SYSDATE - 1; -- 현재일 하루전이 현 직무 종료일
         ELSE -- JOB_HISTORY에 이전 기록이 있는 경우
           SELECT A.END_DATE INTO V_SDATE
             FROM (SELECT START_DATE, END_DATE
                     FROM JOB_HISTORY
                    WHERE EMPLOYEE_ID = 125
                    ORDER BY 2 DESC) A
            WHERE ROWNUM = 1;
           V_SDATE := V_SDATE + 1;
           V_EDATE := SYSDATE - 1;
         END IF;
         INSERT INTO JOB_HISTORY
           VALUES(V_EID, V_SDATE, V_EDATE, :OLD.JOB_ID, :OLD.DEPARTMENT_ID);
       END;
       
       (실행)
       DECLARE
       BEGIN
         UPDATE EMPLOYEES
            SET (SALARY, JOB_ID) = (SELECT A.MIN_SALARY, 'ST_MAN'
                                      FROM (SELECT MIN_SALARY
                                              FROM JOBS
                                             WHERE JOB_ID = 'ST_MAN') A)
          WHERE EMPLOYEE_ID = 125;
       END;