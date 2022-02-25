2021-0726-02) 서브쿼리
  - SQL구문 안에 또다른 SQL구문이 포함된 형태
  - 바깥쪽 쿼리를 메인쿼리, 안쪽 쿼리를 서브쿼리라고 함
  - 서브쿼리는 메인쿼리의 결과를 반환하기 위해 중간 결과로 사용
  - 서브쿼리는 '( )'로 묶어 사용함(예외 INSERT문에 사용되는 서브쿼리는 '( )'를 사용하지 않음)
  - 서브쿼리는 사용되는 위치에 따라 일반 서브쿼리(SELECT 절), 인라인 서브쿼리(FROM 절), 중첩 서브쿼리(WHERE 절)로 구분
  - 반환하는 결과의 행/열의 개수에 따라 단일행/단일열, 단일행/다중열, 다중행/다중열로 구분
  - 메인쿼리와 서브쿼리에 사용되는 테이블 간의 조인 여부에 따라 관련성 없는 서브쿼리/연관서브쿼리로 구분
  - 알려지지 않은 조건에 근거하여 데이터를 검색하는 경우 유용

    1) 단일행 서브쿼리
      . 하나의 행만 결과로 반환
      . 단일행 연산자는 관계연산자(=, !=, >, <, >=, <=)임
      
사용예) 
       SELECT EMPLOYEE_ID, EMP_NAME
         FROM HR.EMPLOYEES
        WHERE (DEPARTMENT_ID, MANAGER_ID) = (SELECT DEPARTMENT_ID, MANAGER_ID -- 비교될 데이터의 수가 같아야함
                                               FROM HR.DEPARTMENTS
                                              WHERE MANAGER_ID = 121);

    2) 다중행 서브쿼리
      . 하나 이상의의 행을 반환하는 서브쿼리
      . 복수행 연산자 : IN, ANY, SOME, ALL, EXISTS
      
사용예) 사원 테이블에서 직원의 수가 10명 이상인 부서를 출력하시오.
       Alias는 부서코드, 부서명
       (메인쿼리 : 부서코드, 부서명 출력)
       SELECT A.DEPARTMENT_ID AS 부서코드,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID = (서브쿼리)
        
       (서브쿼리 : 직원의 수가 10명 이상이 되는 부서의 부서코드)
       SELECT B.DID
         FROM (SELECT DEPARTMENT_ID AS DID,
                      COUNT(*)
                 FROM HR.EMPLOYEES
                GROUP BY DEPARTMENT_ID
               HAVING COUNT(*) >= 10) B;
       -- 집계합수인 COUNT는 WHERE절에 올 수 없고, HAVING절에 넣어서 조건을 만들어줘야함

       (결합 : ANY(=SOME) 연산자 사용)
       SELECT A.DEPARTMENT_ID AS 부서코드,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID = ANY (SELECT B.DID
                                       FROM (SELECT DEPARTMENT_ID AS DID,
                                                    COUNT(*)
                                               FROM HR.EMPLOYEES
                                              GROUP BY DEPARTMENT_ID
                                             HAVING COUNT(*) >= 10) B);
                                            
       (결합 : IN 연산자 사용)
       SELECT A.DEPARTMENT_ID AS 부서코드,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID IN (SELECT B.DID
                                    FROM (SELECT DEPARTMENT_ID AS DID,
                                                 COUNT(*)
                                            FROM HR.EMPLOYEES
                                           GROUP BY DEPARTMENT_ID
                                          HAVING COUNT(*) >= 10) B);                                            

       (결합: EXISTS 연산자 사용)
         - EXISTS 연산자 왼쪽의 표현식(식 OR 컬럼명)이 없음
         - EXISTS 연산자 오른쪽은 반드시 서브쿼리
       SELECT A.DEPARTMENT_ID AS 부서코드,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE EXISTS (SELECT 1 -- C.DID보다는 1을 많이 사용함
                        FROM (SELECT B.DEPARTMENT_ID AS DID,
                                     COUNT(*)
                                FROM HR.EMPLOYEES B
                               GROUP BY B.DEPARTMENT_ID
                              HAVING COUNT(*) >= 10) C
                       WHERE C.DID = 50 OR C.DID = 80); --A.DEPARTMENT_ID);

    3) 다중열 서브쿼리
      . 하나 이상의의 열을 반환하는 서브쿼리
      . PAIRWISE(쌍비교) 서브쿼리 또는 Nonpairwise(비쌍비교) 서브쿼리로 구현
      
사용예) 80번 부서에서 급여가 평균 이상인 사원을 조회하시오.
       Alias는 사원번호, 급여, 부서코드
       (PARWISE 방식 설명용)
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.SALARY 급여,
              A.DEPARTMENT_ID AS 부서코드
         FROM HR.EMPLOYEES A
        WHERE (A.EMPLOYEE_ID, A.DEPARTMENT_ID) IN (SELECT B.EMPLOYEE_ID, B.DEPARTMENT_ID
                                                     FROM HR.EMPLOYEES B
                                                    WHERE B.SALARY >= (SELECT AVG(C.SALARY)
                                                                         FROM HR.EMPLOYEES C
                                                                        WHERE C.DEPARTMENT_ID = B.DEPARTMENT_ID)
                                                      AND B.DEPARTMENT_ID = 80)
        ORDER BY 3, 2;

       (간단한 방식)
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.SALARY 급여,
              A.DEPARTMENT_ID AS 부서코드
         FROM HR.EMPLOYEES A
        WHERE A.DEPARTMENT_ID = 80
          AND A.SALARY >= (SELECT AVG(SALARY)
                             FROM HR.EMPLOYEES
                            WHERE DEPARTMENT_ID = 80)
        ORDER BY 3, 2;
        
        COMMIT;
        