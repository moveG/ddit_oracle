2021-0730-01)
  2. SEQUENCE 객체
    - 순차적으로 증감하는 값을 반환하는 객체
    - 테이블과 독립적 -- 여러 테이블에서 동시에 사용할 수 있다는 의미
    - 임의의 테이블에서 기본키로 설정할 마땅한 컬럼이 없는 경우, 자동으로 부여되는 순차적인 숫자값이 필요한 경우 사용됨
    (사용형식)
      CREATE SEQUENCE 시퀀스명    -- 이 부분만 작성해도 시퀀스 사용 가능
        [START WITH n]          -- 시작값, 생략하면 최소값(MINVALUE)
        [INCREMENT BY n]        -- 증감값, 생략하면 1, 증가는 +값을, 감소는 -값을 기술하면됨
        [MAXVALUE n|NOMAXVALUE] -- 최대값, 기본은 NOMAXVALUE이며 값은 10^27
        [MINVALUE n|NOMINVALUE] -- 최소값, 기본은 NOMINVALUE이며 값은 1
        [CYCLE|NOCYCLE]         -- 최소[최대]값 도달후 시퀀스값을 다시 생성할지 여부, 기본은 NOCYCLE
        [CACHE n|NOCACHE]       -- 시퀀스 값을 캐시에 미리 생성하고 사용할지 여부, 기본은 CACHE 20
        [ORDER|NOORDER]         -- 제시한 조건대로 시퀀스 생성을 보증, 기본은 NOORDER
      
    ** 의사컬럼
       시퀀스명.CURRVAL : '시퀀스'가 가지고 있는 현재값 반환
       시퀀스명.NEXTVAL : '시퀀스'의 다음값 반환
       ** 시퀀스 객체가 생성된 후 맨 처음 명령은 반드시 '시퀀스명.NEXTVAL'이어야 함 -- 만들어진 시퀀스의 시작을 의미
       ** 시퀀스명.NEXTVAL을 사용하여 생성된 값은 다시 재생성할 수 없음
       -- 시퀀스는 테이블에 독립되어 있기 때문에(여러 테이블에 동시에 사용되기 때문에) 정교하게 사용하지 않으면 원하는 값을 얻을 수 없음  
       -- 잘못 사용하면 일정하게 값이 부여되지 않고 듬성듬성하게 값이 부여될 수 있으므로 조심히 사용해야함

사용예) LPROD 테이블의 LPROD_ID에 사용할 시퀀스를 생성하시오.
       SELECT MAX(LPROD_ID) FROM LPROD; -- 최대값 9가 출력됨
       
       CREATE SEQUENCE SEQ_LPROD
         START WITH 10; -- 9는 이미 존재하는 값이므로 10으로 시작하는 것이 편리함
       
       SELECT SEQ_LPROD.CURRVAL FROM DUAL; -- SEQ_LPROD 시퀀스에는 아직 CURRVAL이 정의되지 않았으므로 NEXTVAL부터 사용해야함
       
       INSERT INTO LPROD
         VALUES(SEQ_LPROD.NEXTVAL, 'P501', '농산물');
         
       SELECT * FROM LPROD;  
         
사용예) 오늘이 2005년 4월 18일이라 가정하고, CART_NO를 생성하시오.
       SELECT TO_CHAR(TO_DATE('2005/04/18'), 'YYYYMMDD')||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(MAX(CART_NO), 9))+1, '00000'))
         FROM CART
        WHERE CART_NO LIKE '20050418%' 
        -- SEQUENCE를 사용하지 않으면 함수를 써서 복잡하게 출력해야함
        -- NEXTVAL이면 간단하게 2005041800003을 출력할 수 있음
        -- 여러군데에서 사용하므로 이를 적절히 제어하기 위한 알고리즘을 만들기가 힘들어서
        -- SEQUENCE를 사용하지 않고 위의 복잡한 방식을 사용하는 경우도 있음
        
    ** 시퀀스의 사용이 제한되는 경우
      - SELECT, DELETE, UPDATE문에 사용되는 서브쿼리 --INSERT문에서는 사용 가능
      - VIEW를 대상으로 하는 쿼리
      - DISTINCT가 사용되는 SELECT문
      - GROUP BY, ORDER BY절이 사용되는 SELECT문
      - 집합연산자(UNION, UNION ALL, INTERSECT, MINUS)에 사용되는 SELECT문
      - WHERE절
      -- 주로 자료를 삽입할 때 사용됨(주로 INSERT문 또는 INSERT문에서 사용되는 서브쿼리에서 사용됨)

  3. SYNONYM 객체
    - 동의어(별칭)를 의미
    - 오라클에서 사용되는 객체에 별도의 이름을 부여하여 참조 -- 왼쪽에 나와있는 모든 것(테이블, 뷰,...)
    - 주로 이름 긴 객체명을 사용하기 쉬운 객체명으로 대체할 때 사용
    (사용형식)
      CREATE [OR REPLACE] SYNONYM 시노늄명 FOR 객체명
        . '객체명'에 별도의 이름인 '시노늄명'을 부여
        . 컬럼의 별칭과 테이블의 별칭과의 차이점
          - '시노늄명'은 해당 테이블 스페이스 전체에서 사용
          - '컬럼의 별칭'과 '테이블의 별칭'은 해당 쿼리에서만 사용 가능
          
사용예) HR계정의 EMPLOYEES, DEPARTMENTS, JOB_HISTORY 테이블에 별칭('시노늄명') EMP, DEPT, JOBH 을 부여하시오.
       CREATE OR REPLACE SYNONYM EMP FOR HR.EMPLOYEES;
       CREATE OR REPLACE SYNONYM DEPT FOR HR.DEPARTMENTS;
       CREATE OR REPLACE SYNONYM JOBH FOR HR.JOB_HISTORY;
       
       SELECT * FROM EMP;
       SELECT * FROM DEPT; -- 테이블명(HR.DEPARTMENTS) 대신 시노늄명(DEPT)만 간단하게 사용할 수 있음
       SELECT * FROM JOBH;
       -- 테이블명(HR.EMPLOYEES, HR.DEPARTMENTS, HR.JOB_HISTORY) 대신 시노늄명(EMP, DEPT, JOBH)만 간단하게 사용할 수 있음
       