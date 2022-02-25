2021-0803-01)
      (2) CASE 문
        - 표준 SQL의 SELECT 절에 사용되는 CASE 표현식과 동일함
        - 다중 분기 기능 제공
        -- 모든 CASE문을 IF문으로 변환이 가능하지만, IF문을 모두 CASE문으로 변환하는 것은 불가능함
        -- JAVA의 Switch-Case와 달리 break가 필요없음
        (사용형식 - 01)
          CASE 변수|수식 WHEN 값1 THEN
                            명령1;
                       WHEN 값2 THEN
                            명령2;
                             :
                       ELSE 명령n;
          END CASE;
          
        (사용형식 - 02)
          CASE WHEN 조건1 THEN
                    명령1;
               WHEN 조건2 THEN
                    명령2;
                     :
               ELSE 명령n;
          END CASE;
          
사용예) 10-100 사이의 난수를 발생시켜 난수에 해당하는 부서에 속한 사원 중 첫번째 사원의 급여를 조회하여
       5000이하이면 '저임금 사원', 10000이하이면 '평균임금 사원', 그 이상이면 '고임금 사원'을 출력하시오.
       Alias는 사원번호, 사원명, 부서명
       DECLARE
         V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE; -- 사원번호
         V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE; -- 사원이름
         V_DNAME HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE; -- 부서명
         V_SAL HR.EMPLOYEES.SALARY%TYPE; -- 급여
         V_MESSAGE VARCHAR2(20); -- 비고란(저임금 사원, 평균임금 사원, 고임금 사원)
         V_DID HR.EMPLOYEES.DEPARTMENT_ID%TYPE; -- 난수로 발생시킨 부서코드
       BEGIN
         V_DID := TRUNC(SYS.DBMS_RANDOM.VALUE(10, 110), -1); -- 정수형 난수 발생, TRUNC(~, -1)로 1의 자리를 버림
         SELECT A.EMPLOYEE_ID, A.EMP_NAME, B.DEPARTMENT_NAME, A.SALARY
           INTO V_EID, V_ENAME, V_DNAME, V_SAL -- INTO를 사용하지 않으면 오류 발생, PL/SQL에서는 반드시 INTO를 사용해야함
           FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
          WHERE A.DEPARTMENT_ID = V_DID
            AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
            AND ROWNUM = 1; -- 첫번째 사원을 조회
         CASE WHEN V_SAL < 5000 THEN
                   V_MESSAGE := '저임금 사원';
              WHEN V_SAL < 10000 THEN
                   V_MESSAGE := '평균임금 사원';
              ELSE 
                   V_MESSAGE := '고임금 사원';
         END CASE;     
 
         DBMS_OUTPUT.PUT_LINE('부서명 : '||V_DNAME);
         DBMS_OUTPUT.PUT_LINE('사원번호 : '||V_EID);
         DBMS_OUTPUT.PUT_LINE('사원명 : '||V_ENAME);
         DBMS_OUTPUT.PUT_LINE('비고 : '||V_MESSAGE);
       END;
          
    3) 반복문
      . 오라클의 반복문은 LOOP, WHILE, FOR 문이 제공됨
      (1) LOOP 문
        - 반복문의 기본 구조
        (사용형식)
          LOOP
            반복처리명령문(들);
            [EXIT WHEN 조건;]
          END LOOP;
          . 기본적으로 무한루프
          . 'EXIT WHEN 조건' : 조건이 참(true)이면 반복을 벗어남(END LOOP 다음으로 제어 이동)
          -- FOR문, WHILE문 내부에 LOOP문이 존재함
          -- EXIT는 JAVA의 Break와 유사함
          
사용예) 구구단의 7단을 출력하는 블록을 작성하시오.
       DECLARE
         V_CNT NUMBER := 1; -- 숫자변수는 반드시 초기값을 설정해줘야함, 그렇지 않으면 참조될때 NULL값이 참조되므로 오류가 발생함
         V_RES NUMBER := 0;
       BEGIN
         LOOP
           V_RES := V_CNT * 7;
           EXIT WHEN V_CNT > 9;
           DBMS_OUTPUT.PUT_LINE(7||' * '||V_CNT||' = '||V_RES);
           V_CNT := V_CNT + 1;
         END LOOP;
       END;

사용예) 구구단의 모든 단을 출력하는 블록을 작성하시오.
       DECLARE
         V_NUM NUMBER := 2;
         V_CNT NUMBER := 1;
         V_RES NUMBER := 0;
       BEGIN
         LOOP
           EXIT WHEN V_NUM > 9;
           LOOP
             V_RES := V_NUM * V_CNT;
             EXIT WHEN V_CNT > 9;
             DBMS_OUTPUT.PUT_LINE(V_NUM||' * '||V_CNT||' = '||V_RES);
             V_CNT := V_CNT + 1;
           END LOOP;
           V_CNT := 1;
           V_NUM := V_NUM + 1;
           DBMS_OUTPUT.PUT_LINE('');
         END LOOP;  
       END;

      (2) WHILE 문
        - 개발언어의 WHILE문과 동일 기능 및 구조
        (사용형식)
          WHILE 조건 LOOP
            반복처리명령문(들);
            [EXIT WHEN 조건;]
          END LOOP;
          . '조건'이 참이면 반복 수행
          
사용예) 구구단의 7단을 출력하는 블록을 작성하시오.
       DECLARE
         V_CNT NUMBER := 0;
         V_RES NUMBER := 0;
       BEGIN
         WHILE V_CNT < 9 LOOP
           V_CNT := V_CNT + 1;
           V_RES := V_CNT * 7;
           DBMS_OUTPUT.PUT_LINE(7||' * '||V_CNT||' = '||V_RES);
         END LOOP;
       END;
       
       COMMIT;