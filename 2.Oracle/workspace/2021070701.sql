2021-0707-01)
 1)자료 삽입 명령(INSERT)
  - 생성된 테이블에 새로운 자료를 삽입함
  (사용형식)
  INSET INTO 테이블명[(컬럼명1[,컬럼명2,...])]
   VALUES('값1'[,'값2',...]);
   -- VALUE"S"
   . '테이블명' : 자료 삽입 대상 테이블명
   . '컬럼명1,..' : 이 옵션을 생략하면 테이블에 기술된 모든 컬럼에 기술된 순서에 맞도록 VALUES절에 값을 기술해야함
   . '컬럼명1,..' : 이 옵션이 사용되면 필요한 컬럼에만 값(데이터)을 지정하여 자료를 삽입할 수 있음,
                   기술된 '컬럼명'의 개수 및 순서와 VALUES절의 값의 개수 및 순서가 일치해야 하고,
                   NOT NULL항목은 반드시 기술해야 함(생략될 수 없음)
   -- 컬럼명과 값은 반드시 대응, 매칭되어야 함(컬럼명1-값1, 컬럼명2-값2,...)
   -- NULL은 편리하지만, 부정확한 데이터를 만들어낼 수도 있음 (EX-수도요금은 기본요금이 있지만, 사용량이 NULL이면 요금이 기본요금이 아니라 0이 됨)
   -- NULL 오류 예방법: DEFAULT값을 설정하면 사용자가 값을 입력하지 않아도 NULL이 아닌, DEFAULT값이 자동으로 저장됨
   -- NOT NULL로 설정된 컬럼은 컬럼명을 생략할 수 없음
   -- CHAR(고정길이)타입은 거의 PK를 설정할 때만 사용됨
   -- 한글은 3 BYTE
   -- 문자열은 ''(따옴표)를 사용함
   -- INSERT에 기술된 컬럼명에 맞도록 VALUES의 값을 순서에 맞게 넣어줘야 함
   
사용예) 사원 테이블(EMPLOYEE)에 다음 자료를 입력하시오.
       -----------------------------------------------------------------------------------
       사원번호    이름       주소                   전화번호          직위        부서
       -----------------------------------------------------------------------------------
       A101      홍길동      대전시 중구 대흥동      042-222-8202      사원      공공 개발부
       A104      강감찬                                             대리      기술영업부
       A105      이순신                                             부장
       -----------------------------------------------------------------------------------
       
       INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, E_ADDR, E_TEL, E_POSITION, E_DEPT) -- 여기에 기술된 순서가 왼쪽창의 순서보다 우선됨
        VALUES('A101', '홍길동', '대전시 중구 대흥동', '042-222-8202', '사원', '공공 개발부');
        
       INSERT INTO EMPLOYEE -- 컬럼명을 생략하면 왼쪽창의 순서대로 자료를 입력해야함
        VALUES('A104', '강감찬', '', '', '대리', '기술영업부');
       
       INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, E_POSITION)
        VALUES('A105', '이순신', '부장');
        
       SELECT * FROM EMPLOYEE; -- 자료가 제대로 입력되었는지 확인
     
사용예) 사업장 테이블(SITE)에 다음 자료를 입력하시오.
       -----------------------------------------------------------------------------------
       사업장번호       사업장명                주소                   비고
       -----------------------------------------------------------------------------------
       S100      대흥초등학교보수공사      대전시 중구 대흥동
       S200      건물 신축
       -----------------------------------------------------------------------------------
       
       INSERT INTO SITE VALUES('S200', '건물 신축', NULL, '');
       INSERT INTO SITE(SITE_ID, SITE_NAME, SITE_ADDR)
        VALUES('S100', '대흥초등학교보수공사', '대전시 중구 대흥동');
       
       SELECT * FROM SITE; -- 자료가 제대로 입력되었는지 확인
       
사용예) 근무 테이블(WORK)에 다음 자료를 입력하시오.
       (1) 홍길동 사원이 오늘부로 'S200' 사업장에서 근무
        INSERT INTO WORK VALUES('A101', 'S200', SYSDATE); -- 오늘 날짜는 SYSDATE를 입력
        
       (2) 이순신 부장이 2020년 10월 01일부터 'S200' 사업장에서 근무
        INSERT INTO WORK VALUES('A105', 'S200', TO_DATE('20201001')); -- 날짜를 입력할 때는 TO_DATE('YYYYMMDD')
        
       (3) 강감찬 대리가 'S100' 사업장에서 근무
        INSERT INTO WORK(EMP_ID, SITE_ID) VALUES('A104', 'S100');
       
        SELECT * FROM WORK; -- 자료가 제대로 입력되었는지 확인
        -- SELECT 열에 관련된 동작
        -- WHERE 행에 관련된 동작
       
        SELECT MOD((TRUNC(SYSDATE) -TO_DATE('00010101'))-1, 7) FROM DUAL; -- 0001년 1월 1일부터 오늘까지 경과된 날짜
        -- 오라클은 퍼센트를 사용하지 못함
       
       ** S200에 근무하는 사원정보를 조회하시오.
          Alias는 사업장명, 사원번호, 사원명, 직위, 전화번호이다.
          
          SELECT A.SITE_NAME AS 사업장명,
                 B.EMP_ID AS 사원번호,
                 B.EMP_NAME AS 사원명,
                 B.E_POSITION AS 직위,
                 B.E_TEL AS 전화번호
            FROM SITE A, EMPLOYEE B, WORK C
           WHERE A.SITE_ID=C.SITE_ID
             AND B.EMP_ID=C.EMP_ID
             AND A.SITE_ID=UPPER('S200');

 2)자료 삭제 명령(DELETE)
  - 존재하는 자료를 삭제함
  (사용형식)
  DELETE 테이블명  
   [WHERE 조건];
   . '테이블명' : 삭제할 자료가 저장된 테이블
   . 'WHERE 조건': 삭제할 조건을 기술하며 생락하면 모든 자료를 삭제
   . ROLLBACK의 대상 -- 다시 복구할 수 있는 ROLLBACK의 대상
   . 관계가 설정(부모 테이블)된 자료는 삭제할 수 없다
   -- SELECT 열에 관련된 동작
   -- WHERE 행에 관련된 동작
   
사용예) 사원 테이블에서 'A101' 사원정보를 삭제하시오.
       DELETE EMPLOYEE
        WHERE UPPER(EMP_ID)='A101';
        -- 대소문자 구분이 필요함 (''(따옴표)안에는 대소문자를 구분함)
        -- UPPER 모든 글자를 대문자로 변경
        -- LOWER 모든 글자를 소문자로 변경
        -- 자식 테이블이 존재하므로 삭제가 불가능함
        
       DELETE WORK;
        -- 자식테이블부터 삭제해야 부모테이블 삭제가 가능함
       
       COMMIT;
       
** 객체 삭제
   DROP 객체타입 객체명;
   -- 객체타입:  USER, VIEW, INDEX, SYNONYM, TABLE... etc
   
   EMPLOYEE 테이블 삭제
    DROP TABLE WORK;
    DROP TABLE EMPLOYEE;
    DROP TABLE SITE;
    -- 외래키로 인해 참조되는 테이블이 존재하므로 삭제가 불가능함
    -- 자식 테이블부터 삭제해야함
    -- 테이블 내부에 데이터가 존재해도 전체를 삭제함
    
    ROLLBACK;
    -- DROP으로 삭제한 것은 ROLLBACK이 불가능함