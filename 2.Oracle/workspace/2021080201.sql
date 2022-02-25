2021-0802-01) PL/SQL(Procedual Language SQL)
    - 표준 SQL의 기능을 확장한 SQL
    - 서버에 실행가능한 형태의 모듈화된 서브 프로그램
    - Block 구조로 구성
    - 모듈화, 캡슐화(정보의 은닉화, 하나의 모듈이 실행될 때 외부에 영향을 받으면 안됨, 다른 모듈에 간섭을 해서는 안됨)
    - Anonymous Block, User Defined Function(Function), Stored Procedure(Procedure), Package, Trigger 등이 제공됨
    -- Function과 Procedure이 가장 빈번하게 사용됨
    -- 반환값이 있으면 Function, 반환값이 없으면 Procedure
    -- Package는 PL/SQL의 객체들을 묶어서 사용할 수 있는 기능, 한꺼번에 혹은 필요한 기능만 사용 가능
    -- Trigger는 발생된 이벤트의 전후에 처리되어야할 함수가 있으면 사용하는 기능
    
  1. 익명블록(Anoymous Block)
    - PL/SQL의 기본구조
    - 단순 스크립트에서 실행되는 블록
    -- 이름이 없는 블록이라서 저장할 수 없고, 그래서 재사용이 안됨
    -- 익명블록 위에 오는 것에 따라 Function, Procedure, Package, Trigger 등이 될 수 있음
    -- 일반변수는 'V_'로 시작되고, 매개변수는 'P_'로 시작됨
    (기술형식)
      DECLARE
        선언부(변수, 상수, 커서 선언);
      BEGIN
        실행부(비즈니스 로직을 처리하기 위한 SQL문)
        [EXCEPTION -- 선택사항
          예외처리부; -- WHEN OTHERS THEN?: 모든 경우의 예외를 처리할 수 있음
        ]
      END;
      -- 이제부터는 스크립트 출력창이 아닌, DBMS출력창으로 출력되어야함
      -- DBMS출력창은 자동으로 삭제되지 않음
      -- 지우개 버튼을 통해 기존에 출력된 내용을 삭제할 수 있음

사용예) 키보드로 10~110사이의 부서번호를 입력받아 해당부서 직원 중 가장 입사일이 빠른 사원 정보를 출력하시오.
       Alias는 사원번호, 사원명, 입사일, 직책
       ACCEPT P_DID PROMPT '부서코드(10~110)' -- 입력창을 띄우는 기능, P_DID는 VARCHAR2타입 문자열
       DECLARE
         V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE; -- 참조타입을 사용하는 방법, 해당컬럼의 해당타입과 동일하게 설정해줌
         V_NAME HR.EMPLOYEES.EMP_NAME%TYPE;
         V_HIRE HR.EMPLOYEES.HIRE_DATE%TYPE;
         V_JOBID HR.EMPLOYEES.JOB_ID%TYPE;
       BEGIN
         SELECT A.EMPLOYEE_ID, A.EMP_NAME, A.HIRE_DATE, A.JOB_ID
           INTO V_EID, V_NAME, V_HIRE, V_JOBID
           FROM (SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, JOB_ID
                   FROM HR.EMPLOYEES
                  WHERE DEPARTMENT_ID = TO_NUMBER('&P_DID')
                  ORDER BY 3) A
          WHERE ROWNUM = 1; -- 변수에는 하나의 데이터만 저장할 수 있음
          
          DBMS_OUTPUT.PUT_LINE('사원번호 : '||V_EID); -- 자바의 PACKAGE명과 유사, 제공하는 API를 사용하겠다는 의미
          DBMS_OUTPUT.PUT_LINE('사원명 : '||V_NAME); -- PUT_LINE은 출력하고 줄을 바꿔줌
          DBMS_OUTPUT.PUT_LINE('입사일 : '||V_HIRE); -- 자바의 SYSTEM.OUT.PRINTLN과 거의 동일한 기능
          DBMS_OUTPUT.PUT_LINE('직책코드 : '||V_JOBID); -- ()안은 인쇄하고자 하는 내용을 넣음
          
          EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('예외발생 : '||SQLERRM);
       END;
       
    1) 변수와 상수 -- 상수는 선언할 때 단 한번 변수의 역할을 수행하고, 다음부터 변수로의 역할을 상실함, 왼쪽(Left-Value자리)에 올 수 없음
      . 실행부에서 사용할 변수와 상수
      . SCLAR 변수 : 하나의 데이터를 저장하는 변수 -- 한 순간에 하나의 데이터만 저장 가능
        - REFERENCE 변수(참조형 변수) : 임의의 테이블에 존재하는 컬럼의 타입과 크기를 참조하는 변수
        - COMPOISTE 변수(배열 변수) : PL/SQL에서 사용하는 배열 변수(RECORD TYPE - 한 행을 다룸, TABLE TYPE - 한 테이블을 다룸)
        - BIND 변수 : 파라미터로 넘겨지는 IN(자료를 밖에서 넘겨받을때 사용), OUT(내 모듈에서 처리된 결과를 밖으로 내보낼때 사용)에서 사용되는 변수,
                     리턴값을 전달하기 위해 사용되는 변수
      (사용형식)
        변수명[CONSTANT] 데이터타입[(크기)]|테이블명.컬럼명%TYPE|테이블명%ROWTYPE[:=초기값];
        - 'CONSTANT' : 상수 선언
        - '테이블명.컬럼명%TYPE|테이블명%ROWTYPE' : 참조타입, ROWTYPE은 한 줄 전체를 출력
        - 숫자형 변수인 경우에는 반드시 초기화를 해야함, 초기화하지 않으면 런타임 오류 발생
        - 데이터타입 : SQL에서 사용하는 데이터 타입
          . BINARY_INTEGER, PLS_INTEGER : -2147483648 ~ 2147483647 사이의 정수로 취급
          . BOOLEAN : true, false, null을 취급하는 논리형 변수(자바와는 달리 null도 취급함),
                      표준SQL에서는 사용할 수 없었지만, PL/SQL에서는 사용가능,
                      변수에서만 사용가능
                      
    2) 분기명령
      . 프로그램의 실행 순서를 변경하는 명령
      . IF, CASE WHEN 등이 제공됨
      (1) IF 문
        - 개발언어의 IF 문과 동일한 기능을 제공함
        -- {}로 범위를 지정할 수 없기 때문에 IF문이 끝나면 END IF;를 붙여줘야함
        -- 조건은 ()로 묶어도, 묶지 않아도 됨
        -- ELSIF에서는 E가 없지만, ELSE에서는 E가 존재함
        (사용형식 - 01)
          IF 조건 THEN
             명령1;
         [ELSE
             명령2;]
          END IF;
          
        (사용형식 - 02)
          IF 조건 THEN
             명령1;
          ELSIF 조건 THEN
             명령2;]
               :
          ELSE
             명령n;
          END IF;          
          
        (사용형식 - 03) -- 구분을 위해 들여쓰기와 내어쓰기를 철저히 해야함
          IF 조건 THEN
             명령1;
             IF 조건 THEN
                명령2;
             ELSE
                명령3;
             END IF; -- 내부의 IF문의 종료를 위해 END IF;를 반드시 붙여줘야함
          ELSE
             명령n;
          END IF;

사용예) 임의의 수를 입력받아 짝수인지 홀수인 판별하시오.
       ACCEPT P_NUM PROMPT '수 입력 : '
       DECLARE
         V_NUM NUMBER := TO_NUMBER('&P_NUM'); -- ':='은 대입연산자, '&'는 주소가 아닌 내용을 참조하라는 뜻
         V_RES VARCHAR2(100);
       BEGIN
         IF MOD(V_NUM, 2) = 0 THEN
            V_RES := TO_CHAR(V_NUM)||'은/는 짝수입니다.';
         ELSE
            V_RES := TO_CHAR(V_NUM)||'은/는 홀수입니다.';
         END IF;
         
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;
       
       DECLARE
         V_FLAG BOOLEAN := TRUE;
         V_RES VARCHAR2(100);
       BEGIN
         IF V_FLAG THEN
            V_RES := 'TRUE';
         ELSIF V_FLAG IS NULL THEN
            V_RES := 'NULL';
         ELSE
            V_RES := 'FALSE';
         END IF;
         
         DBMS_OUTPUT.PUT_LINE(V_RES);
       END;
       
사용예) 회원 테이블에서 회원들의 마일리지를 조회하여,
       그 값이 5000이상이면 'VIP회원',
       그 값이 3000이상이면 '정회원',
       그 이하이면 '준회원'을 출력하시오.
       Alias는 회원번호, 회원명, 마일리지
       DECLARE
         V_MID MEMBER.MEM_ID%TYPE;
         V_NAME MEMBER.MEM_NAME%TYPE;
         V_MILE MEMBER.MEM_MILEAGE%TYPE;
         V_RES VARCHAR2(100);
         
         CURSOR CUR_MEM01 IS -- 테이블의 자료를 한 행씩 읽음
           SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
             FROM MEMBER;
       BEGIN
         OPEN CUR_MEM01;
         LOOP
           FETCH CUR_MEM01 INTO V_MID, V_NAME, V_MILE; -- FETCH : 커서에 있는 자료를 읽어와서 각각 사용함
           EXIT WHEN CUR_MEM01%NOTFOUND; -- CURSOR에 들어있는 자료가 하나도 없으면 탈출함
           IF V_MILE >= 5000 THEN
              V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'VIP회원';
           ELSIF V_MILE >= 3000 THEN
              V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'정회원';
           ELSE
              V_RES := V_MID||', '||V_NAME||', '||TO_CHAR(V_MILE)||', '||'준회원';
           END IF;
           DBMS_OUTPUT.PUT_LINE(V_RES);
           DBMS_OUTPUT.PUT_LINE('===========================');
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('회원수 : '||CUR_MEM01%ROWCOUNT||'명');
         CLOSE CUR_MEM01;
       END;
       
사용예) 사용자로부터 수도사용량(톤 단위)을 입력받아 수도요금을 계산하여 출력하시오.
       사용량(톤)   수도단가(원)
        01-10        275
        11-20        305
        21-30        350
        31-40        415
        41톤 이상     500원
        
       하수도 사용요금 : 사용량 * 120원
       ---------------------------------
       ex) 27톤을 사용한 경우
       ---------------------------------
       01-10톤 : 275 * 10 = 2,750원
       11-20톤 : 305 * 10 = 3,050원
       21-27톤 : 350 * 7  = 2,450원
       ---------------------------------
       하수도 사용요금 : 27 * 120 = 3,240원
       ---------------------------------
                       수도요금 : 11,490원
       ---------------------------------
       ACCEPT P_NUM PROMPT '사용량(톤)'
       DECLARE
         V_NUM NUMBER := TO_NUMBER('&P_NUM');
         V_RES VARCHAR2(100);
       BEGIN
         IF V_NUM <= 10 THEN
           V_RES := TO_CHAR((V_NUM * 275) + (V_NUM * 120));
         ELSIF V_NUM BETWEEN 11 AND 20 THEN
           V_RES := TO_CHAR((10 * 275) + ((V_NUM - 10) * 305) + (V_NUM * 120));
         ELSIF V_NUM BETWEEN 21 AND 30 THEN
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + ((V_NUM - 20) * 350) + (V_NUM * 120));
         ELSIF V_NUM BETWEEN 31 AND 40 THEN
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (10 * 350) + ((V_NUM - 30) * 415) + (V_NUM * 120));
         ELSE
           V_RES := TO_CHAR((10 * 275) + (10 * 305) + (10 * 350) + (10 * 415) + ((V_NUM - 40) * 500) + (V_NUM * 120));
         END IF;
         
         DBMS_OUTPUT.PUT_LINE('사용량 : '||V_NUM||'톤');
         DBMS_OUTPUT.PUT_LINE('수도요금 : '||V_RES||'원');
       END;
       
       ACCEPT P_NUM PROMPT '사용량(톤)'
       DECLARE
         V_NUM NUMBER := TO_NUMBER('&P_NUM');
         V_RES NUMBER(30);
       BEGIN
         IF V_NUM <= 10 THEN
           V_RES := V_NUM * 275;
         ELSIF V_NUM <= 20 THEN
           V_RES := (10 * 275) + ((V_NUM - 10) * 305);
         ELSIF V_NUM <= 30 THEN
           V_RES := (10 * 275) + (10 * 305) + ((V_NUM - 20) * 350);
         ELSIF V_NUM <= 40 THEN
           V_RES := (10 * 275) + (10 * 305) + (10 * 350) + ((V_NUM - 30) * 415);
         ELSE
           V_RES := (10 * 275) + (10 * 305) + (10 * 350) + (10 * 415) + ((V_NUM - 40) * 500);
         END IF;
         V_RES := V_RES + (V_NUM * 120);
         
         DBMS_OUTPUT.PUT_LINE('사용량 : '||V_NUM||'톤');
         DBMS_OUTPUT.PUT_LINE('수도요금 : '||V_RES||'원');
       END;
       
       COMMIT;