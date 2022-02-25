2021-0706-02)SQL 명령의 구분
 1)Query
  . 질의 및 조회
  . SELECT 문
  --SELECT * FROM 테이블명;
 2)DML(Data Manipulation Language:데이터 조작어)
  . INSERT, UPDATE, DELETE 문
  --UPDATE, DELETE: 기존 데이터가 존재해야 사용 가능
 3)DCL(Data Control Language:데이터 제어어)
  . COMMIT, ROLLBACK, SAVEPOINT, GRANT
  --COMMIT: 저장
  --ROLLBACK: 맨 마지막 커밋한 상태로 되돌리기
  --SAVEPOINT: 위치 지정해서 저장
  --GRANT: 권한 부여
 4)DDL(Data Definition Language:데이터 정의어)
  . CREATE, DROP, ALTER
  --CREATE: 생성
  --DROP: 제거
  --ALTER: 변경

 (1) CREATE
  . 오라클 객체를 생성
  (사용형식)
  CREATE 객체타입 객체명;
   - 객체타입 : 생성하려 하는 객체의 종류로 USER, VIEW, INDEX, SYNONYM, TABLE... etc
   
  **테이블 생성명령
  CREATE TABLE 테이블명(
    컬럼명 데이터타입[(크기)] [NOT NULL] [DEFAULT 값][,]
    -- 테이블명은 내용을 짐작할 수 있도록 명명, 적당한 단어가 없다면 TBL_를 붙여 만듦
    -- NOT NULL: NULL을 허용하지 않음, 데이터를 입력해줘야 함
    -- DEFAULT 값: NULL 대신 DEFAULT로 들어가기를 원하는 값
    -- , (콤마): 하나 이상의 컬럼을 만들 경우 반드시 삽입한다
                     :
    컬럼명 데이터타입[(크기)] [NOT NULL] [DEFAULT 값][,]
    
   [CONSTRAINT 기본키설정명 PRIMARY KEY(컬럼명[,컬럼명,...])][,]
   --CONSTRAINT: TABLE에 적용되는 제약조건
   --기본키설정명: 일반적으로 PK_테이블명으로 사용
   --외래키설정명: 일반적으로 FK_테이블명_테이블명으로 사용
   --복합키: 컬럼명[,컬럼명]으로 추가
   [CONSTRAINT 외래키설정명 FOREIGN KEY(컬럼명[,컬럼명,...])
     REFERENCES 테이블명(컬럼명)][,]
     --REFERENCE"S" 원본테이블에서 사용된 컬럼명
                         :
   [CONSTRAINT 외래키설정명 FOREIGN KEY(컬럼명[,컬럼명,...])
     REFERENCES 테이블명(컬럼명)]);
      
     . '데이터타입' : CHAR, VARCHAR2, DATE, NUMBER, CLOB, BLOB 등 사용
     -- CLOB: 대용량, 가변길이
     -- BLOB: 2진 타입
     -- 오라클에서는 모든 문자를 문자열로 인식, 다만 고정길이와 가변길이를 구분함
     -- 고정길이는 정해진 길이를 모두 사용, 정해진 크기보다 큰 수를 입력하면 오류로 취급
     -- 가변길이는 사용한 길이 외에는 반납함
     . 'DEFAULT 값' : 사용자가 데이터 입력시(INSERT문) 데이터를 기술하지 않은 경우 저장되는 값
     . '기본키설정명', '외래키설정명' : 기본키 및 외래키 설정을 구별하기 위해 부여된 인덱스명으로 고유한 식별자 이어야 함
     . 'REFERENCES 테이블명(컬럼명)' : 원본테이블명(부모테이블명)과 그곳에서 사용된 컬럼명
     -- 식별관계: 부모의 기본키
     -- 비식별관계: 부모의 비기본키
     -- *: 애스트릭, ALL 전부다
     -- &: 앰퍼샌드, 그리고
     -- @: 앳, 장소 표시
     -- |: 파이프 기호

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
       
       CREATE TABLE EMPLOYEE(
         EMP_ID     CHAR(4) NOT NULL,
         EMP_NAME   VARCHAR2(30) NOT NULL,
         E_ADDR     VARCHAR2(80),
         E_TEL      VARCHAR2(20),
         E_POSITION VARCHAR2(30),
         E_DEPT     VARCHAR2(50),
         CONSTRAINT PK_EMPLOYEE PRIMARY KEY(EMP_ID));

--실행방법: Block + Ctrl + Enter

COMMIT;

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
       
       CREATE TABLE SITE(
         SITE_ID   CHAR(4),
         SITE_NAME VARCHAR2(30) NOT NULL,
         SITE_ADDR VARCHAR2(80),
         REMARKS   VARCHAR2(255),
         CONSTRAINT PK_SITE PRIMARY KEY(SITE_ID));

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
     
       CREATE TABLE WORK(
         EMP_ID     CHAR(4) NOT NULL,
         SITE_ID    CHAR(4) NOT NULL,
         INPUT_DATE DATE,
         CONSTRAINT PK_WORK PRIMARY KEY(EMP_ID, SITE_ID),
         CONSTRAINT FK_WORK_EMP FOREIGN KEY(EMP_ID)
          REFERENCES EMPLOYEE(EMP_ID),
         CONSTRAINT FK_WORK_SITE FOREIGN KEY(SITE_ID)
          REFERENCES SITE(SITE_ID));
          