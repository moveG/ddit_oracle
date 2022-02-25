2021-0804-02) 저장 프로시져(Stored Procedure)
    - 서버에 저장된 특정목정을 위한 컴파일된 모듈
    - 처리속도의 향상 : 프로시져 내의 모든 구문을 하나의 Batch로 인식하여 한번에 분석 및 최적화를 시키고 실행시킴
    - 네트워크의 Traffic 감소 : Client에서 Server로 전송할 SQL구문을 서버가 미리 저장하고 있어,
      Client에서 다량의 SQL구문 대신 프로시져 이름과 매개변수만 전송
    - 반환값이 없음
    -- 자바의 VOID 타입 메서드라고 생각하면됨, SELECT 절에 사용할 수 없음
    -- 매개변수 : 값을 전달하는 통로
    (사용형식)
      CREATE [OR REPLACE] PROCEDURE 프로시져명[( -- 프로시져 이름은 보통 'PROC_'로 시작함
        매개변수 [MODE] 타입 [:=값][,
          :
        매개변수 [MODE] 타입 [:=값]])]
      IS|AS -- 이 부분을 DECLARE라고 생각하면됨
        선언영역
      BEGIN
        실행영역
      END;
      . 'OR REPLACE' : 같은 이름의 프로시져가 존재하면 OVERWRITE, 없으면 새롭게 생성
      . 'MODE' : 매개변수의 성격을 나타내며 IN(입력용), OUT(출력용), INOUT(입출력 공용)을 사용할 수 있으며 생략하면 IN으로 간주
      . '타입' : 매개변수의 데이터 타입으로 크기를 지정하지 않음

    (사용형식 - 실행)
      EXEC|EXECUTE 프로시져명[(매개변수)list];
      
      OR
      
      프로시져명[(매개변수)list]; -- 익명블록이나 다른 PL/SQL객체 내에서 실행됨

사용예) 년도와 월과 제품코드를 입력받아 해당제품의 입고수량을 집계하여 재고수불테이블에서 해당제품의 재고를 갱신하는 프로시져를 작성하시오.
       (사용형식)
       CREATE OR REPLACE PROCEDURE PROC_BUY_REMAIN(
         P_YEAR  IN CHAR, -- 입력이니 IN(외부에서 가져오니 IN, 외부로 내보내면 OUT)
         P_MONTH IN VARCHAR2, -- 입력이니 IN
         P_PID   IN VARCHAR2) -- 입력이니 IN
       IS
         V_IAMT NUMBER(5) := 0; -- 매입수량
         V_FLAG NUMBER := 0; -- 매입자료 존재유무
         V_DATE DATE := TO_DATE(P_YEAR||P_MONTH||'01'); -- 매입발생 월의 시작날짜
       BEGIN
         SELECT COUNT(*), SUM(BUY_QTY) INTO V_FLAG, V_IAMT
           FROM BUYPROD
          WHERE BUY_PROD = P_PID
            AND BUY_DATE BETWEEN V_DATE AND LAST_DAY(V_DATE);
            
         IF V_FLAG != 0 THEN
           UPDATE REMAIN
              SET REMAIN_I = REMAIN_I + V_IAMT,
                  REMAIN_J_99 = REMAIN_J_99 + V_IAMT,
                  REMAIN_DATE = LAST_DAY(V_DATE)
            WHERE REMAIN_YEAR = P_YEAR
              AND PROD_ID = P_PID;
         END IF;
       END;
       (사용형식 - 실행)
       EXECUTE PROC_BUY_REMAIN('2005', '03', 'P201000017');
       
       ROLLBACK;
       
사용예) 사원번호를 입력받아 해당사원이 소속된 부서의 부서명, 인원수, 평균급여를 받환받는 프로시져를 작성하시오.
       -- 프로시져는 반환값이 없음, '반환받는'이라는 뜻은 OUT 매개변수를 사용해 출력하라는 뜻임
       (사용형식) -- HR계정에서 사용가능
       CREATE OR REPLACE PROCEDURE PROC_EMP01(
         P_EID  IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE, -- 'HR.EMPLOYEES.EMPLOYEE_ID'와 같은 타입으로 매개변수 선언
         P_DNAME OUT HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE, -- 부서명
         P_CNT OUT NUMBER, -- 인원수
         P_SAL OUT NUMBER) -- 평균급여
       IS
         -- 선언할 내용이 없으면 비워둠
       BEGIN
         SELECT B.DEPARTMENT_NAME, COUNT(*), ROUND(AVG(SALARY))
           INTO P_DNAME, P_CNT, P_SAL
           FROM (SELECT DEPARTMENT_ID AS DID
                   FROM HR.EMPLOYEES
                  WHERE EMPLOYEE_ID = P_EID) A, DEPARTMENTS B, EMPLOYEES C
          WHERE A.DID = B.DEPARTMENT_ID
            AND C.DEPARTMENT_ID = B.DEPARTMENT_ID
          GROUP BY B.DEPARTMENT_NAME;
       END;
       (사용형식 - 실행) -- HR계정에서 사용가능
       -- 실행을 하려면 반환받을 매개변수를 선언해야함
       DECLARE
         V_DNAME HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE;
         V_CNT NUMBER := 0;
         V_SAL NUMBER := 0;
       BEGIN
         PROC_EMP01(109, V_DNAME, V_CNT, V_SAL); -- EXECUTE가 있으면 안됨
         DBMS_OUTPUT.PUT_LINE('부서명 : '||V_DNAME);
         DBMS_OUTPUT.PUT_LINE('직원수 : '||V_CNT);
         DBMS_OUTPUT.PUT_LINE('평균급여 : '||V_SAL);
       END;