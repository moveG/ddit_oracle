2021-0712-01) 데이터 타입
 - 오라클에서 사용되는 데이터 타입은 문자열, 숫자, 날짜, 2진자료형이 제공
  1. 문자열 자료
   - 오라클의 문자열은 ''(따옴표)로 묶어 표현
   - 고정길이(CHAR) 타입과, 가변길이(VARCHAR, VARCHAR2, LONG, NVARCHAR2, CLOB) 타입으로 구분
   - 영문, 숫자, 특수문자(공백, 물음표 등)는 1BYTE로 한글(초성, 중성, 종성)은 3BYTE로 표현
   -- 오라클SQL에서는 문자열('')을 제외하고 대소문자 구분을 하지 않음
   -- 가변길이 타입 : 사용된 길이를 제외하고 반납함
   -- 오라클에서는 VARCHAR보다 VARCHAR2 사용을 권장함
   -- LONG : 사용은 가능하지만 서비스는 중단됨 (자바의 LONG: 정수 타입 / 오라클의 LONG: 문자열 타입)
   -- 'N'VARCHAR2 : 길이의 단위가 BYTE가 아니라, 글자의 개수
   -- 가변길이 타입에도 길이를 설정하는 이유: 과거 고정길이를 사용할 때의 습관
   1) CHAR
    . 정의된 크기의 기억공간에 자료를 저장하고 남는 공간은 공백으로 채움
    . 데이터는 MSB에서 LSB쪽으로 저장 (왼쪽부터 채움)
    -- MSB : 가장 변화크기가 큰 BIT (+ , -)
    -- LSB : 가장 변화크기가 작은 BIT (2^0자리)
   (사용형식)
    컬럼명 CHAR(크기 [BYTE|CHAR]);
     - 최대 2000BYTE 까지 저장 가능
     - 'BYTE|CHAR' : 생략하면 BYTE로 취급되며, 'CHAR'가 사용되면 '크기'는 글자수를 나타냄. 다만, CHAR을 사용해도 2000BYTE를 초과할 수 없음
     - 주로 길이가 고정된 컬럼이나 기본키 컬럼의 데이터 타입으로 사용 (EX)주민번호)
     
사용예) 
       CREATE TABLE T_CHAR(
        COL1 CHAR(20),
        COL2 CHAR(20 CHAR),
        COL3 CHAR(20 BYTE));
       
       INSERT INTO T_CHAR(COL1, COL2, COL3)
        VALUES('무궁화 꽃이 피', '무궁화 꽃이 피', '무궁화');
       
       SELECT * FROM T_CHAR;
       
       SELECT LENGTHB(COL1), LENGTHB(COL2), LENGTHB(COL3)
         FROM T_CHAR;
       
       INSERT INTO T_CHAR(COL1, COL2, COL3)
        VALUES('무궁화 꽃이 피', '무궁화 꽃이 피었습니다', '무궁화');
       
       -- LENGTHB : 컬럼의 길이를 BYTE로 표시하는 함수
       -- COL2 : '무궁화 꽃이 피'는 8글자 사용(20 BYTE) + 12글자 남음(12BYTE - 영문자 기준) = 32BYTE
       
    2) VARCHAR2
     . 가변길이 자료 저장에 이용
    (사용형식)
     컬럼명 VARCHAR2(크기[BYTE|CHAR])
      - 최대 4000BYTE까지 저장 가능
      - 사용자가 정의한 데이터만큼 사용하고 남은 공간은 SYSTEM에 반환
       
사용예) 
       CREATE TABLE T_VARCHAR2(
         COL1 VARCHAR(500),
         COL2 VARCHAR(50 CHAR),
         COL3 VARCHAR(50 BYTE));
         
       INSERT INTO T_VARCHAR2
        VALUES('IL POSTONO', '필립 느와레', '마시모 트로이시');
        
       INSERT INTO T_VARCHAR2
        VALUES('PERSIMON BANNA APPLE', 'PERSIMON BANNA', 'PERSIMON');   
       
       SELECT * FROM T_VARCHAR2;
       
       SELECT LENGTHB(COL1), LENGTHB(COL2), LENGTHB(COL3)
         FROM T_VARCHAR2;
         
    3) VARCHAR, NVARCHAR, NVARCHAR2
     . 기본적으로 NVARCHAR2와 저장방법은 동일함
     . NVARCHAR, NVARCHAR2는 UTF-8(가변길이), UTP-16(고정길이) 방식의 코드로 변환하여 자료를 저장함(국제표준코드 적용)
    
    4) LONG
     . 가변길이 자료를 저장
    (사용형식)
     컬럼명 LONG
      - 최대 2GB까지 저장 가능
      - 한 테이블에 하나의 칼럼만 사용가능(제약사항)
      - CLOB로 대체됨
      - 문자열 함수(LENGTH, LENGTHB, SUBSTR 등) 사용이 제한됨
       
사용예) 
       CREATE TABLE T_LONG(
         COL1 VARCHAR(100),
         COL2 LONG,
         COL3 CHAR(100));
         
       INSERT INTO T_LONG
        VALUES('PERSIMON BANNA APPLE', 'PERSIMON BANNA', 'PERSIMON');
      
       SELECT * FROM T_LONG;
         
       SELECT COL1, COL2, TRIM(COL3) FROM T_LONG;
       
       SELECT LENGTHB(COL1), LENGTHB(TRIM(COL2, 1, 3)), LENGTHB(COL3)
         FROM T_LONG;
       -- 오류 발생  

    5) CLOB(Char Large OBject)
     . 가변길이 자료를 저장
    (사용형식)
     컬럼명 CLOB
      - 최대 4GB까지 저장 가능
      - 여러 컬럼을 하나의 테이블에 선언 가능
      - 일부 기능은 DBMS_LOB API의 지원을 받아야 사용 가능(LENGTH, SUBSTR 등)
     
사용예) 
       CREATE TABLE T_CLOB(
         COL1 CLOB,
         COL2 CLOB,
         COL3 VARCHAR2(4000),
         COL4 LONG);
       
       INSERT INTO T_CLOB(COL1, COL2, COL4)
        VALUES('대전시 중구 대흥동 영민빌딩', '대전시 중구 대흥동 영민빌딩', '대전시 중구 대흥동 영민빌딩');
       
       SELECT * FROM T_CLOB;
       
       SELECT DBMS_LOB.GETLENGTH(COL1),
           -- DBMS_LOB.GETLENGTHB(COL2), -- LENGTH'B'는 지원하지 않음(워낙 공간을 많이 차지하는 형식이므로)
              SUBSTR(COL1, 5, 6),
              DBMS_LOB.SUBSTR(COL1, 5, 6)
           -- LOB에서는 매개변수 위치가 바뀜(EX) 5번째부터 6글자가, 6번째부터 5글자로 바뀜)
         FROM T_CLOB;
       
       -- SUBSTR 자바 오라클 차이
       -- ABCDEFG라는 문자열을 자를 때
       -- 자바 : SUBSTRING(2, 4)를 하면 "CD"의 결과가 나옴.
       -- 오라클SQL : SUBSTR(2, 4)를 하면 'CDEF'의 결과가 나옴.

  2. 숫자 자료
   - NUMBER 타입이 제공
   (사용형식)
    컬럼명 NUMBER[(정밀도|*[, 스케일])]
     . 저장범위 : 1.0 * 10^-130 ~ 9.999...9 * 10^125
     . 정밀도 : 전체 자리수(1 ~ 30)
     . 스케일(양수) : 소수점 이하의 자리수
       스케일(음수) : 정수 부분의 자리수
     . 20 BYTE로 표현
      
     EX) NUMBER, NUMBER(10), NUMBER(10, 2), NUMBER(*, 2), ...
     -----------------------------------------------
         입력값         선언              기억되는 값
     -----------------------------------------------
      123456.6789    NUMBER            123456.6789
      123456.6789    NUMBER(10)        123457
      123456.6789    NUMBER(7, 2)      오류       -- 7은 전체 자리수 / 2는 소수점 아래 자리수 / 정수에 5자리가 할당되지만 6자리라서 오류 발생
      123456.6789    NUMBER(*, 2)      123456.68 -- *은 AUTO / 2는 소수점 아래 자리수
      123456.6789    NUMBER(10, -2)    123500    -- 10은 전체 자리수 / -2는 정수 부분의 자리수 / 10의 자리에서 반올림 발생
     -----------------------------------------------  
       
사용예) 
       CREATE TABLE T_NUMBER(
         COL1 NUMBER,
         COL2 NUMBER(10), -- 자동 변환되어 (10, 0)으로 저장된다.
         COL3 NUMBER(7, 2),
         COL4 NUMBER(*, 2), -- *의 최대값은 38
         COL5 NUMBER(10, -2));
         
       INSERT INTO T_NUMBER VALUES(123456.6789, 123456.6789, 123456.6789, 123456.6789, 123456.6789); -- 오류 발생
       
       INSERT INTO T_NUMBER(COL1) VALUES(123456.6789);
       INSERT INTO T_NUMBER(COL2) VALUES(123456.6789);
    -- INSERT INTO T_NUMBER(COL3) VALUES(123456.6789); 오류 발생
       INSERT INTO T_NUMBER(COL3) VALUES(12345.6789);
       INSERT INTO T_NUMBER(COL4) VALUES(123456.6789);
       INSERT INTO T_NUMBER(COL5) VALUES(123456.6789);
       
       SELECT * FROM T_NUMBER;
       
    ** 스케일 > 정밀도 -- 매우 희귀한 경우
       . 스케일 : 소수점 이하의 데이터 수
       . 스케일 - 정밀도 : 소수점 이하에 존재해야할 0의 개수
       . 정밀도 : 소수점 이하의 0이 아닌 자료수
       
       EX)
       -----------------------------------------------------------
           입력값      선언           기억되는 값
       -----------------------------------------------------------       
        1.234       NUMBER(4, 5)    오류(정수 부분에 0이 아닌 값 존재)
        0.23        NUMBER(3, 5)    오류(0.00으로 시작)
        0.0023      NUMBER(3, 5)    오류(유효 숫자가 부족)
        0.0023      NUMBER(2, 4)    0.0023
        0.012345    NUMBER(3, 4)    0.0123
        0.012356    NUMBER(3, 4)    0.0124
       ----------------------------------------------------------- 
       
       COMMIT;