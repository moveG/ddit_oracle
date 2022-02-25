STUDY_SUMMARY
  (사용형식)
    SYSTEM계정에서
    CREATE USER 계정명 IDENTIFIED BY java(비밀번호);

    GRANT RESOURCE, DBA, CONNECT TO 계정명;

  (사용형식)
    CREATE USER 계정명 IDENTIFIED BY 암호;
  
  (권한부여)
    GRANT 권한명[,권한명,..] TO 계정명;
  
  (사용형식)
    CREATE 객체타입 객체명;
  
  (사용형식)
    CREATE TABLE 테이블명(
    컬럼명 데이터타입[(크기)] [NOT NULL] [DEFAULT 값][,]
                     :
    컬럼명 데이터타입[(크기)] [NOT NULL] [DEFAULT 값][,]
   [CONSTRAINT 기본키설정명 PRIMARY KEY(컬럼명[,컬럼명,...])][,]
   [CONSTRAINT 외래키설정명 FOREIGN KEY(컬럼명[,컬럼명,...])
     REFERENCES 테이블명(컬럼명)][,]
   [CONSTRAINT 외래키설정명 FOREIGN KEY(컬럼명[,컬럼명,...])
     REFERENCES 테이블명(컬럼명)]);
  
  (사용형식)
    INSERT INTO 테이블명[(컬럼명1[,컬럼명2,...])]
     VALUES('값1'[,'값2',...]);

  (사용형식)
    DELETE 테이블명
      [WHERE 조건];

  (사용형식)
    DROP 객체타입 객체명;
    DROP TABLE 테이블명;
    
  (사용형식)    
    ROLLBACK;

  (사용형식)
    SELECT [DISTINCT] 컬럼명 [AS]["][별칭]["][,]
                            :
                      컬럼명 [AS]["][별칭]["]
      FROM 테이블명 [별칭]
    [WHERE 조건]
    [GROUP BY 컬럼명[,컬럼명,...]]
   [HAVING 조건]
    [ORDER BY 컬럼명|컬럼인덱스[ASC|DESC]][]]
            [,컬럼명|컬럼인덱스[ASC|DESC],...]];

  (사용형식)
    UPDATE 테이블명
       SET 컬럼명=값[, 
           컬럼명=값, 
             :
           컬럼명=값]
    [WHERE 조건];

  (사용형식)    
   (컬럼을 추가)
    ALTER TABLE 테이블명
      ADD(컬럼명 데이터 타입[(크기)] [DEFAULT 초기값]);
   (컬럼을 삭제)    
    ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
   (컬럼이름을 변경)
    ALTER TABLE 테이블명 RENAME COLUMN 원래컬럼명 TO 새로운컬럼명;
   (컬럼타입을 변경)
    ALTER TABLE 테이블명
   MODIFY(컬럼명 데이터 타입[(크기)] [DEFAULT 초기값]);    
-------------------------------------------------------------------------------------------------------------------------------
  ** 연산자(OPERATOR)
    - 산술연산자
      . +, -, *, /
    - 관계연산자 : 대소 비교, TRUE/FALSE를 결과로 반환
      . >, <, >=, <=, =, !=(<>)
    - 논리연산자
      . NOT, AND, OR
    - 기타연산자
      . IN, ANY, SOME, ALL, EXISTS, BETWEEN, LIKE 등 제공

    1. 기타연산자
      1) IN
        . 주어진 값 중 어느 하나와 일치하면 TRUE를 반환
        . OR 연산자로 치환 가능
        . NOT 연산자와 함께 사용 가능함
        (사용형식)
          expr IN(값1[,값2,...])
      
      2) ALL
        . ( )안에 주어진 값들을 모두 만족해야 결과가 참(TRUE)이 됨
        . AND 연산자로 치환 가능
        (사용형식)
          컬럼명 관계연산자ALL [값1[,값2,...])      
      
      3) BETWEEN ~ AND
        . 범위를 지정하여 값을 조회하는 조건문 구성에 사용
        . 논리 연산자 'AND'로 치환 가능
        
      4) LIKE 연산자
        . 패턴을 비교할 때 사용
        . 문자열만 비교할 때 사용
        . 와일드카드로 '%'와 '_'가 사용되어 패턴 문자열을 구성
        . '%' : '%'이 사용된 위치 이후의 모든 문자열과 대응
          EX) '대전%' : '대전'으로 시작되는 모든 단어와 대응
              '대%시' : 첫 글자가 '대'이고 마지막 글자가 '시'인 모든 단어와 대응
              '%다'   : 끝 글자가 '다'인 모든 단어와 대응
-------------------------------------------------------------------------------------------------------------------------------
  ** 데이터 타입
    - 오라클에서 사용되는 데이터 타입은 문자열, 숫자, 날짜, 2진자료형이 제공
    
    1. 문자열 자료
      - 오라클의 문자열은 ''(따옴표)로 묶어 표현
      - 고정길이(CHAR) 타입과, 가변길이(VARCHAR, VARCHAR2, LONG, NVARCHAR2, CLOB) 타입으로 구분
      - 영문, 숫자, 특수문자(공백, 물음표 등)는 1BYTE로 한글(초성, 중성, 종성)은 3BYTE로 표현
      
      1) CHAR
        . 정의된 크기의 기억공간에 자료를 저장하고 남는 공간은 공백으로 채움
        . 데이터는 MSB에서 LSB쪽으로 저장 (왼쪽부터 채움)
        -- MSB : 가장 변화 크기가 큰 BIT (+ , -)
        -- LSB : 가장 변화 크기가 작은 BIT (2^0자리)
        (사용형식)
          컬럼명 CHAR(크기 [BYTE|CHAR]);
          - 최대 2000BYTE 까지 저장 가능
          - 'BYTE|CHAR' : 생략하면 BYTE로 취급되며, 'CHAR'가 사용되면 '크기'는 글자수를 나타냄
                          다만, CHAR을 사용해도 2000BYTE를 초과할 수 없음
          - 주로 길이가 고정된 컬럼이나 기본키 컬럼의 데이터 타입으로 사용 (EX)주민번호)
      
      2) VARCHAR2
        . 가변길이 자료 저장에 이용
        (사용형식)
          컬럼명 VARCHAR2(크기[BYTE|CHAR])
          - 최대 4000BYTE까지 저장 가능
          - 사용자가 정의한 데이터만큼 사용하고 남은 공간은 SYSTEM에 반환
     
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

      5) CLOB(Char Large OBject)
        . 가변길이 자료를 저장
        (사용형식)
          컬럼명 CLOB
          - 최대 4GB까지 저장 가능
          - 여러 컬럼을 하나의 테이블에 선언 가능
          - 일부 기능은 DBMS_LOB API의 지원을 받아야 사용 가능(LENGTH, SUBSTR 등)

    2. 숫자 자료
      - NUMBER 타입이 제공
      (사용형식)
        컬럼명 NUMBER[(정밀도|*[, 스케일])]
          - 저장범위 : 1.0 * 10^-130 ~ 9.999...9 * 10^125
          - 정밀도 : 전체 자리수(1 ~ 30)
          - 스케일(양수) : 소수점 이하의 자리수
          - 스케일(음수) : 정수 부분의 자리수
          - 20 BYTE로 표현
          - 스케일 > 정밀도 -- 매우 희귀한 경우
            . 스케일 : 소수점 이하의 데이터 수
            . 스케일 - 정밀도 : 소수점 이하에 존재해야할 0의 개수
            . 정밀도 : 소수점 이하의 0이 아닌 자료수
            
    3. 날짜 자료 -- 날짜 비교는 LIKE(문자열)보다는 BETWEEN을 사용해라
      - DATE, TIMESTAMP 타입 제공
      - 덧셈과 뺄셈의 대상
      
      1) DATE
        . 기본 날짜형
        (사용형식)
          컬럼명 DATE; -- 정의가 되지 않으면 0으로 초기화
            - 년, 월, 일, 시, 분, 초 정보를 저장 및 관리
            - 날짜형 자료의 뺄셈 : 두 날짜 사이의 일수 변환 -- NUMBER형으로 반환
            - 날짜형 + 정수 : '날짜'에서 '정수'만큼 경과된 후의 날짜 변환 -- 날짜형으로 반환
            - 날짜형 - 정수 : '날짜'에서 '정수'만큼 과거의 날짜 변환 -- 날짜형으로 반환
     
      2) TIMESTAMP
        . 시간대 정보와 정교한 시간(10억분의 1초) 제공
        (사용형식)
          컬럼명 TIMESTAMP; -- 시간대 정보 없는 날짜 정보 
          컬럼명 TIMESTAMP WITH TIME ZONE; -- 시간대 정보(도시명/대륙명)와 날짜 정보
          컬럼명 TIMESTAMP WITH LOCAL TIME ZONE; -- 서버가 설치된 지역의 시간대 정보(도시명/대륙명)와 날짜 정보     
       
    4. 기타 자료
      - 2진 자료를 저장
      - RAW, LONG RAW, BLOB, BFILE

      1) BFILE
        . 2진 자료를 저장
        . 원본 자료를 데이터베이스 외부에 저장하고 데이터베이스에는 경로 정보만 저장
        . 4GB 까지 저장
        (사용형식)
          컬럼명 BEFILE;
            - 오라클에서는 원본 자료(2진 자료)에 대해서 해석하거나 변환하지 않음
            - 2진 자료 저장을 위해 DIRECTORY 객체가 필요
     
      2) BLOB
        . 2진 자료를 저장
        . 원본 자료를 데이터베이스 내부에 저장
        . 4GB 까지 저장
        (사용형식)
          컬럼명 BLOB;
            - BLOB 사용순서
              . 테이블 생성
              . 디렉토리 객체 생성
              . 익명블록 생성
-------------------------------------------------------------------------------------------------------------------------------
  ** 단일행 함수(FUNCTION)
    - 특정 결과를 반환하기 위하여 미리 작성하여 컴파일된 모듈
    - 반환값이 존재
    - 서버와 네트워크 성능 개선에 기여
    - 단일행 함수와 복수행 함수(집계함수 : SUM, AVG, COUNT, MAX, MIN)로 구분
    - 문자열, 숫자, 날짜, 형변환, NULL처리, 집계함수 등이 있음
    - 중첩 사용이 가능함
    -- 단일행 함수와 복수행 함수는 사용되는 연산자가 다름

  1. 문자열 함수
    1) || (문자열 결합 연산자)
      . 자바에서 문자열 결합에 사용되는 '+'와 같음
      . 두 문자열을 결합하여 새로운 문자열을 반환
    
    2) CONCAT(c1, c2)
      . 주어진 문자열 자료 c1과 c2를 결합하여 반환
      -- 여러 문자열을 결합시키려면 CONCAT 안에 CONCAT 안에 CONCAT이 반복적으로 들어가는 복잡한 구조가 되므로, 잘 사용되지 않음    
    
    3) ASCII (c1), CHR(n1)
      . ASCII (c1) : c1에 해당하는 ASCII 코드값을 반환
      . CHR (n1) : 숫자 n1에 해당하는 문자를 반환
    
    4) RPAD(c1, n[, c2]), LPAD(c1, n[, c2])
      . RPAD : 지정된 길이 n에 c1을 저장하고 남은 오른쪽 공간에 c2를 삽입한다.
      . LPAD : 지정된 길이 n에 c1을 저장하고 남은 왼쪽 공간에 c2를 삽입한다.
      . c2가 생략되면 공백을 채움
      -- 과거에 비해 사용빈도가 떨어짐
      -- 문자열을 숫자처럼 오른쪽 정렬하려면 LPAD를 사용하면 됨
    
    5) RTRIM(c1[, c2]), LTRIM(c1[, c2])
      . RTRIM : 주어진 문자열 c1 내부에 c2 문자열을 오른쪽에서 찾아 삭제
      . LTRIM : 주어진 문자열 c1 내부에 c2 문자열을 왼쪽에서 찾아 삭제
      . c2가 생략되면 공백을 제거(단어 내부의 공백은 제거 불가능)

    6) TRIM(c1)
      . 단어 왼쪽 또는 오른쪽에 발생된 공백을 모두 제거
      . 단어 내부의 공백은 제거 불가능
    
    7) SUBSTR(c, n1[, n2])
      . 주어진 문자열 c에서 n1번째부터 n2 개수만큼 글자를 추출하여 부분 문자열을 반환
      . 결과도 문자열임
      . n1, n2는 1부터 시작됨
      . n2가 생략되거나 문자의 수보다 큰 n2를 사용하면 n1 이후 모든 문자열을 추출함
      . n1이 음수이면 오른쪽을 기준으로 처리됨
      -- 비교 및 연산시 항상 타입을 일치시켜야함
      -- 가장 자주 사용되는 함수
    
    8) REPLACE(c1, c2[, c3])
      . 주어진 문자열 c1에 포함된 c2를 찾아 c3로 치환시킴
      . c3가 생략되면 찾은 c2를 삭제시킴
      . 단어 내부의 공백 제거에 사용될 수 있음
      -- 매개변수를 3개 까지 쓸 수 있음
      -- c1: 원본 데이터
      -- c2: 원본데이터에서 찾고자 하는 문자열
      -- c3: c2를 대체하고자 하는 문자열
      -- 공백제거는 부수적인 기능이지만, 지금은 주목적이 되어 단어치환보다 공백제거에 더 많이 사용됨
    
    9) INSTR(c1, c2[, m[, n]])
      . 주어진 문자열 c1에서 c2 문자열이 처음 나온 위치값을 반환
      . m은 검색 시작위치를 직접 지정할 때 사용
      . n은 c2 문자열의 반복 횟수를 정하여 검색하는 경우 사용
      -- 사용 빈도가 낮음

  2. 숫자함수
    1) GREATEST(n1, n2[, n3, ...]), LEAST(n1, n2[, n3, ...])
      . GREATEST : 주어진 수(n1, ~ ..) 중 가장 큰 값을 반환
      . LEAST : 주어진 수(n1, ~ ..) 중 가장 작은 값을 반환
      -- MAX, MIN과의 차이: GREATEST, LEAST는 값을 나열해야 하고, MAX, MIN은 컬럼에서 값을 찾음
      -- MAX, MIN : 종적 비교
      -- GREATEST, LEAST : 횡적 비교, 여러 컬럼값을 비교할 때 사용
      
    2) ROUND(n[, i]), TRUNC(n[, i])
      . ROUND : 주어진 수 n의 소수점 이하 i + 1번째 자리에서 반올림하여 i번째 까지 출력
                i가 음수이면 정수부분 i 번째에서 반올림
                i가 생략되면 0으로 간주됨
      . TRUNC : ROUND와 같이 수행되나 반올림이 아니라 절삭처리
      -- 세금같이 내야할 돈은 TRUNC를 사용해서 절삭해서 계산함
      
    3) FLOOR(n), CEIL(n)
      . n에 가까운 정수를 반환
      . FLOOR : n과 같거나 크지 않은 정수 중 가장 큰 정수
      . CEIL : n과 같거나 큰 정수 중 가장 작은 정수
      . 세금, 급여 처럼 금액과 관련된 수식에 주로 사용
      -- 데이터를 정수화 시킬때 사용
      -- 양의 실수: EX) +11.2 : FLOOR +11 CEIL +12
      -- 음의 실수: EX) -11.2 : FLOOR -12 CEIL -11 (주의)
      -- ROUND 대신 사용이 가능(돈(월급)을 줄 때는 초과하는 CEIL을, 돈(세금)을 받을 때는 FLOOR을 사용)
         
    4) MOD(n, i), REMAINDER(n, i)
      . 나머지를 반환
      . MOD : n을 i로 나눈 나머지를 반환, JAVA의 %와 같은 기능을 수행,
              나머지 = 피젯수 - 젯수 * (FLOOR(피젯수/젯수))
      . REMAINDER : n을 i로 나눈 나머지가 i의 절반 이하의 값이면 MOD와 같은 나머지를 반환하고,
                    나머지가 그 이상의 값이면 다음 몫이 되기 위해 더해져야 할 수를 반환,
                    나머지 = 피젯수 - 젯수 * (ROUND(피젯수/젯수))
    
    5) WIDTH_BUCKET(n, min, max, b)
      . min에서 max 값 까지를 b개 구간으로 나누고, 주어진 수 n이 그 구간 중 어느 구간에 속하는지를 판별하여 구간의 인덱스를 반환함     
      
  3. 날짜함수
    1) SYSDATE
      . 시스템에서 제공하는 날짜정보(년, 월, 일, 시, 분, 초)를 반환
      . '+', '-' 연산의 대상
      . 날짜 - 날짜 : 두 날짜 사이의 날수(DAYS)를 반환
      -- 날짜정보를 사용자가 직접 입력할 경우 컴퓨터 지정형식을 위반해서는 안됨
      -- 시, 분, 초 중 일부가 누락되면 날짜로 인식하지 못함
      -- 가장 많이 사용됨
      
    2) ADD_MONTHS(d, n)
      . 날짜형식의 자료 d에 n만큼의 월을 더한 날짜로 변환
      
    3) NEXT_DAY(d, expr)
      . 주어진 날짜 d에서 다가올 가장 빠른 'expr'요일의 날짜를 반환
      . expr : 월, 화, ..., 일, 월요일, 화요일, ..., 일요일
      -- 가장 빠른 요일에서 오늘은 제외함
      -- 사용 빈도는 낮음
      
    4) LAST_DAY(d)
      . 날짜자료 d에 포함된 월의 마지막 일을 반환
      -- 주로 윤년 때문에 2월(28일, 29일 구분)에 많이 사용됨
      
      
    5) MONTHS_BETWEEN(d1, d2)
      . 두 날짜자료 사이의 월수 변환
      -- 정수가 아닌, 실수로 반환됨
      -- 사용 빈도는 낮음
      
    6) EXTRACT(fmt FROM d)
      . 날짜자료 d에서 'fmt'로 기술된 자료를 추출함
      . 반환값의 형식은 숫자형식임
      . 'fmt' : YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
      -- SYSDATE 다음으로 많이 사용됨
      -- 동시에 여러개를 추출하지는 못함
      
  4. 변환함수
    - 특정시점에서 다른 타입으로 일시적으로 형변환 -- 그 특정시점이 지나면 다시 원래 타입으로 돌아감
    - TO_CHAR, TO_DATE, TO_NUMBER, CAST -- 뒤로 갈수록 사용 빈도수가 낮아짐
    
    1) CAST(expr AS 타입)
      . 'expr'로 정의된 자료를 '타입'형태로 일시적으로 형변환
      
    2) TO_CHAR(expr[, fmt])
      . 주어진 자료 'expr'을 형식 지정 문자열 'fmt'에 맞추어 문자열로 변형하여 반환
      . 'expr'은 숫자, 날짜, 문자열(CHAR, CLOB => VARCHAR2로) 타입의 자료
      . 영구적 형변환
      -- VARCHAR2를 VARCHAR2로 형변환하는 것은 허용되지 않음
      -- 함수는 그것이 호출된 위치에 반환값을 주기 때문에 SELECT절, WHERE절, 단독으로 사용 가능
      -- 프로시저는 반환값이 없어 SELECT절, WHERE절에 사용할 수 없고, 독립해서 호출하는 방식으로 사용 가능
      -- ""(쌍따옴표)는 컬럼의 별칭, 사용자가 직접 정의한 문자열에 사용함
      -- ''(따옴표) 안에 전부 넣어줘야함
      -- RM은 로마자 형식
      -- DD 오늘 일수, DDD는 1월 1일부터 기산된 일수, J는 기원전 4XXX년 전부터 기산된 일수
      -- D는 일요일부터 기산한 요일의 인덱스
      -- AM/PM은 오전/오후를 구분하는 용도 쓰임, AM/PM으로 고정하지 않음
      -- expr: EXPRESSION(표현), fmt: FORMAT(포맷)
      
    3) TO_NUMBER(expr[, fmt])
      . 주어진 자료 'expr'의 값을 'fmt' 형식에 맞추어 숫자로 변환
      . 'expr'은 문자열 타입의 자료
      . 'fmt'는 모두 적용되지는 않음(숫자로 형변환 가능한 형식만 적용 가능)
      . 영구적 형변환
      -- ,(COMMA, 자리수)는 대표적으로 적용 불가능한 예시
      -- .(DOT, 소수점)은 적용 가능
      
    4) TO_DATE(expr[, fmt])
      . 주어진 자료 'expr'의 값을 'fmt' 형식에 맞추어 날짜로 변환
      . 'expr'은 문자열 타입의 자료
      . 'fmt'는 모두 적용되지는 않음(날짜로 형변환 가능한 형식만 적용 가능)
      . 원본자료가 날짜형식에 맞도록 제공되어야 함
      . 영구적 형변환
-------------------------------------------------------------------------------------------------------------------------------      
  ** 집계함수
    - 주어진 자료를 특정 컬럼을 기준으로 그룹으로 나누고, 그룹 별로 자료에 대한 집계를 반환하는 함수
    - SUM, AVG, COUNT, MIN, MAX
    -- 같은 형식끼리 모으는 것
    -- SELECT문을 주의해야함, SELECT문을 잘못 구성하면 원하는 자료를 얻기 어려움
    -- 일반컬럼과 집계함수가 함께 나오면, 일반컬럼을 기준으로 그룹을 이루어서 집계함수의 결과를 출력함
    -- 부서코드, 인원수, 평균임금이 나오면, 일반컬럼인 부서코드를 기준으로 그룹을 이루어서 집계함수를 이용해 인원수와 평균임금을 출력하면 됨
    -- 집계함수가 사용되지 않은 일반컬럼은 GROUP BY에 모두 기술해서 묶어줘야함
    -- 왼쪽에서 오른쪽으로 갈수록 그룹 크기가 작아짐(대그룹 => 소그룹)
    -- 그룹 안에, 그룹 안에, 그룹 안에... 중첩된 그룹이 됨
    (사용형식)
      SELECT [컬럼list],
             SUM|AVG|MIN|MAX(expr)|COUNT(column|*),
                         :
        FROM 테이블명
      [WHERE 조건]
      [GROUP BY 컬럼명[, 컬럼명,...]]
     [HAVING 조건]
      [ORDER BY 컬럼명|컬럼인덱스[ASC|DESC][, 컬럼명|컬럼인덱스[ASC|DESC],...]];
      -- []안의 것은 생략이 가능한 부분임
      -- HAVING, WHERE절 다음에 조건이 나옴
      -- WHERE에는 일반적인 조건이 기술됨
      -- HAVING에는 집계함수에(SUM, AVG, MIN MAX, COUNT) 부여된 조건이 기술됨
      -- WHERE, GROUP BY, HAVING, ORDER BY 순서를 맞춰 쓰는게 좋음
 
  1. SUM(expr)
    - 'expr'로 표현되는 수식 또는 컬럼의 값에 대한 합계를 반환

  2. AVG(expr)
   - 'expr'로 정의된 컬럼이나 수식의 값에 대한 산술평균 값을 반환    

  3. COUNT(column명|*)
   - 그룹내의 행의 수(자료의 개수)를 반환
   - 외부조인연산에 사용되는 경우 '*'를 사용하면 부정확한 결과를 반환하기 때문에 해당 테이블의 컬럼명을 기술해야 함
   -- '*'만 사용하면 NULL인 컬럼도 1로 나오지만, 컬럼명을 쓰면 NULL인 컬럼은 나오지 않음
   
  4. MAX(column명), MIN(column명)
   - MAX : 주어진 컬럼명 중 최대값을 반환
   - MIN : 주어진 컬럼명 중 최소값을 반환
   - 집계함수는 다른 집계함수를 포함할 수 없다.
   -- 집계함수는 겹쳐 사용할 수 없음
   -- 중복사용이 필요할 때는 서브쿼리를 사용함
-------------------------------------------------------------------------------------------------------------------------------      
  ** NULL처리 함수
      - 오라클에서 각 컬럼의 기본 초기값은 모두 NULL임
      - NULL자료에 대한 사칙연산 결과는 모두 NULL임
      - NULL자료에 대한 연산자 및 함수로 IS NULL, IS NOT NULL, NVL, NVL2, NULLIF 등이 사용됨
      -- NULL값은 존재 자체는 문제없지만 연산에 참여하게 되면 문제가 됨
      -- 어떤 연산을 해도 NULL값을 출력하므로 원하는 결과값을 얻을 수 없음
      -- 그러므로 NULL값에 대한 처리가 필요함

  1. IS NULL, IS NOT NULL
   - 특정 컬럼이나 계산된 값이 NULL인지 판별하기 위해 사용
   - '=' 연산자로 NULL값 여부를 판별하지 못함
   
  2. NVL(c, val)
   - 'c'의 값을 판단하여 그 값이 NULL이면 'val' 값을 반환하고, NULL이 아니면 'c'의 값을 반환함
   - 'c'와 'val'의 데이터 타입이 동일해야함
   -- 문자열과 숫자형이라면 오류가 발생하지만, 문자열이 숫자로 변환될 수 있는 문자열이라면 자동으로 형변환되어 오류가 발생하지 않음
   
  3. NVL2(c, val1, val2)
   - 'c'의 값을 판단하여 그 값이 NULL이면 'val2' 값을 반환하고, NULL이 아니면 'val1'의 값을 반환함
   - 'val1'과 'val2'의 데이터 타입이 동일해야함
   - 'c'값은 데이터 타입을 맞추지 않아도 됨
   -- 문자열과 숫자형이라면 오류가 발생하지만, 문자열이 숫자로 변환될 수 있는 문자열이라면 자동으로 형변환되어 오류가 발생하지 않음
   -- NVL(c, val1)을 NVL2(c, c, val2)형식으로 쓸 수도 있음
      
  4. NULLIF(c1, c2)
   - 'c1'과 'c2'를 비교하여 같으면 NULL을 반환하고, 같지 않으면 'c1'을 반환함   
-------------------------------------------------------------------------------------------------------------------------------         
  ** 테이블 조인
    - 관계형 데이터베이스의 핵심 기능
    - 복수개의 테이블에 분산된 자료를 조회하기 위함
    - 테이블 사이에 관계(Relationship)가 맺어져 있어야 함
    - 구분
      . 일반조인 / ANSI JOIN
        - 일반조인 - CARTESIAN PRODUCT, EQUI JOIN, NON EQUI JOIN, SELF JOIN, OUTER JOIN
        -- <내부조인>
        -- NON EQUI JOIN: '=' 이외의 연산자를 사용한 조인
        -- SELF JOIN: 하나의 테이블을 두개로 간주해 자신을 조인
        -- <외부조인>
        -- OUTER JOIN: 조인조건이 맞지 않는 것은 버리고 조건이 맞는 것만 출력
        - ANSI JOIN - CROSS JOIN, NATURAL JOIN, INNER JOIN, OUTER JOIN
        -- <내부조인>
        -- NATURAL JOIN: 조인 조건을 기술하지 않아도 자동으로 조인, 사용 빈도가 낮음
        -- <외부조인>
        -- OUTER JOIN: 일반조인보다 훨씬 더 정확함
    . 내부조인 / 외부조인   
   
    (일반조인 사용형식)
      SELECT 컬럼list
        FROM 테이블명1 [별칭1], 테이블명2 [별칭2], [테이블명3 [별칭3],... ]
       WHERE 조인조건1
        [AND 조인조건2]
        [AND 일반조건]...
      - 조인에 사용된 테이블이 n개일 때, 조인조건의 개수는 n-1개 이상이어야함
      - 조인조건과 일반조건의 기술 순서는 의미없음
      
    (ANSI INNER JOIN 사용형식)
      SELECT 컬럼list
        FROM 테이블명1 [별칭1]
       INNER JOIN 테이블명2 [별칭2] ON(조인조건1 [AND 일반조건1])
      [INNER JOIN 테이블명3 [별칭3] ON(조인조건2 [AND 일반조건2])]
            :
      [WHERE 일반조건n]...
      - '테이블명1'과 '테이블명2'는 반드시 조인 가능한 테이블일 것
      - '테이블명3'부터는 '테이블명1'과 '테이블명2'의 결과와 조인
      - ON 절에 사용되는 일반조건1은 '테이블명1'과 '테이블명2'에만 해당되는 조인조건
      - WHERE 절의 조인조건은 모든 테이블에 적용되는 조인조건

  1. CARTESIAN PRODUCT
    - 모든 가능한 행들의 집합을 결과로 반환
    - ANSI에서는 CROSS JOIN이 이에 해당
    - 특별한 목적 이외에는 사용되지 않음
    - 조인조건이 없거나 잘못된 경우 발생   
   
  2. Equi-Join
    - 동등 조인
    - 조인 조건에 '=' 연산자가 사용된 조인
    - ANSI JOIN은 INNER JOIN이 이에 해당
    - 조인조건 또는 SELECT에 사용되는 컬럼 중 두 테이블에서 같은 컬럼명으로
      정의된 경우 '테이블명.컬럼명' 또는 '테이블 별칭.컬럼명' 형식으로 기술   
   
  3. Non-Equi Join
    - 조인조건문이 '=' 이외의 연산자가 사용된 경우
    - IN, ANY, SOME, ALL, EXISTS 등의 복수행 연산자 사용
    -- 자주 발생하지는 않음   
   
  4. SELF JOIN
    - 하나의 테이블에 서로 다른 별칭을 부여하여 수행하는 조인
    - 조인 조건에 '=' 연산자가 사용된 조인   
   
  5. 외부조인(OUTER JOIN)
    - 내부조인은 조인조건을 만족하는 데이터를 기준으로 결과를 반환
    - 외부조인은 조인조건을 만족하지 못하는 데이터를 기준으로 부족한 테이블에 NULL 값으로 채워진 행을 삽입하여 조인을 수행
    - 조인조건에서 부족한 데이터를 가지고 있는 테이블에 속한 열이름 다음에 '(+)' 연산자를 추가함
    -- 데이터의 행의 수가 기준이 아니라, 데이터의 종류의 수가 기준이됨
    -- 상품 테이블에 상품의 종류가 가장 많고, 직원 테이블에 직원의 종류가 가장 많고, 매입 테이블에 매입업체의 종류가 가장 많음
    - 여러 조인조건이 외부조인이 수행되어야 하는 경우 모두 '(+)' 연산자를 사용해야함
    - 동시에 한 테이블에 복수개의 '(+)' 연산자를 사용할 수 없음
      즉, A, B, C 테이블이 외부조인에 참여할 때, A를 기준으로 B를 확장함과 동시에 C를 기준으로 B를 확장할 수 없음
      (WHERE A = B (+) AND C = B (+) => 허용 안 됨)
    - 일반외부조인의 경우 일반조건이 사용되면 내부조인 결과를 반환(해결방법 : ANSI 외부조인 또는 서브쿼리 사용)
    - 외부조인의 사용은 처리속도의 저하 유발
    (일반외부조인 사용형식)
      SELECT 컬럼List
        FROM 테이블명1, 테이블명2[,테이블명3,...]
       WHERE 테이블명1.컬럼[(+)] = 테이블명2.컬럼[(+)]
       . 양쪽 모두 부족한 외부조인은 허용 안됨(WHERE A.COL(+) = B.COL(+)) -- (+)의 위치를 표시한 것, 양쪽 동시에 사용할 수는 없음
      
    (ANSI외부조인 사용형식)
      SELECT 컬럼List
        FROM 테이블명1
        LEFT|RIGHT|FULL OUTER JOIN 테이블명2 ON(조인조건1 [AND 일반조건1])
       [LEFT|RIGHT|FULL OUTER JOIN 테이블명3 ON(조인조건2 [AND 일반조건2])] --테이블1, 2의 조인의 결과가 테이블3보다 종류가 많으면 LEFT를 사용
                             :
      [WHERE 일반조건n]
       . 테이블명1과 테이블명2는 반드시 조인 가능할 것
       -- 공통의 컬럼이 존재해야함, 테이블3은 테이블1이나 테이블2 둘 중 아무 것이나 조인되어도됨
       . 일반조건1은 테이블명1 또는 테이블명2에 국한된 조건
       . 일반조건n은 전체 테이블에 적용되는 조건으로 조인이 모두 수행한 후 적용됨 -- 조인 이후 마지막으로 걸러내는 경우 사용
       . LEFT|RIGHT|FULL : 테이블명1의 데이터 종류가 더 많은 경우 LEFT, 반대의 경우 RIGHT, 양쪽 모두 부족한 경우 FULL 사용
-------------------------------------------------------------------------------------------------------------------------------                   
  ** 서브쿼리
    - SQL구문 안에 또다른 SQL구문이 포함된 형태
    - 바깥쪽 쿼리를 메인쿼리, 안쪽 쿼리를 서브쿼리라고 함
    - 서브쿼리는 메인쿼리의 결과를 반환하기 위해 중간 결과로 사용
    - 서브쿼리는 '( )'로 묶어 사용함(예외 INSERT문에 사용되는 서브쿼리는 '( )'를 사용하지 않음)
    - 서브쿼리는 사용되는 위치에 따라 일반 서브쿼리(SELECT 절), 인라인 서브쿼리(FROM 절), 중첩 서브쿼리(WHERE 절)로 구분
    - 반환하는 결과의 행/열의 개수에 따라 단일행/단일열, 단일행/다중열, 다중행/다중열로 구분
    - 메인쿼리와 서브쿼리에 사용되는 테이블 간의 조인 여부에 따라 관련성 없는 서브쿼리/연관서브쿼리로 구분
    - 알려지지 않은 조건에 근거하여 데이터를 검색하는 경우 유용

  1. 단일행 서브쿼리
    - 하나의 행만 결과로 반환
    - 단일행 연산자는 관계연산자(=, !=, >, <, >=, <=)임
  
  2. 다중행 서브쿼리
    - 하나 이상의의 행을 반환하는 서브쿼리
    - 복수행 연산자 : IN, ANY, SOME, ALL, EXISTS  
  
  3. 다중열 서브쿼리
    - 하나 이상의의 열을 반환하는 서브쿼리
    - PAIRWISE(쌍비교) 서브쿼리 또는 Nonpairwise(비쌍비교) 서브쿼리로 구현  
  
  4. DML 명령에 서브쿼리 사용
    1) INSERT 문에 서브쿼리 사용
      . '( )'를 사용하지 않고 서브쿼리 기술
      . INSERT 문의 VALUES절도 생략  
      
    2) UPDATE 문에 서브쿼리 사용
      . 복수개의 컬럼을 갱신하는 경우 '( )' 안에 변경할 컬럼을 기술하여 하나의 SET절로 처리
      
    3) DELECT 문에 서브쿼리 사용
      . WHERE 조건절에 IN 이나 EXISTS 연산자를 사용하여 삭제할 자료를 좀 더 세밀하게 선택할 수 있음
-------------------------------------------------------------------------------------------------------------------------------                      
  ** 집합연산자
    - 집합연산자는 SELECT문의 결과를 대상으로 연산을 수행
    - 복잡한 서브쿼리나 조인을 줄일 수 있음
    - 여러개의 SELECT문을 하나로 묶는 역할 수행
    - UNION ALL, UNION, INTERSECT, MINUS 제공
    ** 주의사항
      . 각 SELECT문의 같은 개수, 같은 타입의 컬럼을 조회해야함
      . 각 SELECT문들이 여러개의 컬럼을 조회하는 경우 모든 컬럼에 대한 집합연산을 수행
      . ORDER BY는 사용할 수 있으나 가장 마지막 SELECT문에서만 사용이 가능
      . 출력은 첫번째 SELECT문에 의해 결정됨

  1. UNION
    - 합집합의 결과를 반환
    - 교집합 부분(공통부분)의 중복은 배제됨
   
  2. UNION ALL
    - 합집합의 결과를 반환
    - 교집합 부분(공통부분)이 중복되어 출력됨   
   
  3. INTERSECT
    - 교집합(공통부분)의 결과를 반환   
   
  4. MINUS
    - MINUS 연산자 앞에 위치한 쿼리의 결과에서 MINUS 뒤에 기술된 쿼리의 결과를 차감한 결과를 반환
-------------------------------------------------------------------------------------------------------------------------------                      
  ** RANK 함수(집합등수계산)
    - 성적, 급여, 매출 등의 순위를 구할 때 사용
    - ORDER BY절과 ROWNUM의사 컬럼은 오라클의 WHERE절과 ORDER BY절의 실행 순서 때문에 정확한 결과 반환이 불가능함
    -- WHERE절이 ORDER BY보다 먼저 실행됨
    - 이를 해결하기 위해 RANK와 DENSE_RANK 함수를 제공
    - RANK와 DENSE_RANK 함수의 차이점
      . RANK : 중복 순위가 발생하면 중복 개수만큼 다음 순위값을 증가(ex 1, 1, 1, 4, 5,...)
      . DENSE_RANK : 중복 순위가 발생해도 다음 순위는 순차적인 값을 배정(ex 1, 1, 2, 3, 4,...)
      . ROW_NUMBER : 중복에 관계없이 순차 순위값 배정(ex 1, 2, 3, 4, 5,...) -- 행번호를 부여한 것
    - SELECT 절에서 사용
    (사용형식)
      SELECT 컬럼list,
             RANK() OVER(ORDER BY 기준컬럼명 DESE|ASC) AS 컬럼별칭,
                  :
        FROM 테이블명;
-------------------------------------------------------------------------------------------------------------------------------                      
  ** 기타
  1. VIEW 객체
    - 가상의 테이블
    - SELECT 문에 종속되지 않은 독립적 객체
    - 필요한 자료가 복수개의 테이블에 분포되어 있는 경우 사용
    - 특정 테이블의 접근을 차단하고 필요한 정보를 제공해야 하는 경우 사용
    (사용형식)
      CREATE [OR REPLACE] VIEW 뷰이름[(컬럼list)]
      AS
        SELECT 문
        [WITH CHECK OPTION]
        [WITH READ ONLY];
      . 'OR REPLACE' : 같은 이름의 뷰가 존재하면 이를 대체하고, 존재하지 않으면 새롭게 생성
      . '컬럼list' : 뷰에서 사용할 컬럼명, 생략하면 SELECT문에 사용된 컬럼별칭 또는 컬럼명이 뷰의 컬럼명으로 사용됨
      . 'WITH CHECK OPTION' : 뷰를 생성하는 SELECT문에 사용된 조건을 체크하여 이를 위배하는 DML명령을 뷰에 사용하지 못하게 함
      . 'WITH READ ONLY' : 읽기전용 뷰 생성
      -- 뷰이름은 일반적으로 뷰라는 것을 표시하기 위해 'VIEW_'로 시작함
      -- SELECT문의 결과가 VEIW가 됨
      -- 뷰와 원본테이블은 서로 연결되어있음
      -- 뷰의 데이터를 수정하면 원본테이블의 데이터도 수정되므로, 이를 방지하기 위해 'WITH READ ONLY'를 통해 뷰의 수정을 막음
      -- 원본의 WHERE절을 검사하여 이를 위반하는 DML명령을 뷰를 대상으로 사용하지 못하도록 함, 원본 테이블에서는 자유로운 사용이 가능
      -- 사용을 전제로 하는 'WITH CHECK OPTION'과 사용 자체를 막는 'WITH READ ONLY'는 서로 배타적이라서 동시 사용이 불가능함
      -- SELECT문을 사용했을때 이름이 부여되지 않은 뷰가 생성됨, 다시 SELECT문을 사용하면 새로운 뷰가 이전의 뷰를 덮어씀
    
    ** VIEW 사용시 주의사항
      . WITH 절이 사용된 경우 ORDER BY절 사용 금지
      . 집계함수, DISTINCT가 사용된 VIEW를 대상으로 DML명령 사용할 수 없음 -- DISTINCT : 중복 배제
      . 표현식(CASE WHEN ~ THEN, DECODE 등)이나 일반함수를 적용하여 뷰가 생성된 경우 해당 컬럼을 대상으로 수정, 삭제 등 사용 금지
      . CURRVAL, NEXTVAL 등 의사컬럼(Pseudo Column) 사용 금지
      . ROWNUM, ROWID 등 사용시 별칭을 사용해야함

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
      . 시퀀스명.CURRVAL : '시퀀스'가 가지고 있는 현재값 반환
      . 시퀀스명.NEXTVAL : '시퀀스'의 다음값 반환
      . ** 시퀀스 객체가 생성된 후 맨 처음 명령은 반드시 '시퀀스명.NEXTVAL'이어야 함 -- 만들어진 시퀀스의 시작을 의미
      . ** 시퀀스명.NEXTVAL을 사용하여 생성된 값은 다시 재생성할 수 없음
      -- 시퀀스는 테이블에 독립되어 있기 때문에(여러 테이블에 동시에 사용되기 때문에) 정교하게 사용하지 않으면 원하는 값을 얻을 수 없음  
      -- 잘못 사용하면 일정하게 값이 부여되지 않고 듬성듬성하게 값이 부여될 수 있으므로 조심히 사용해야함

    ** 시퀀스의 사용이 제한되는 경우
      . SELECT, DELETE, UPDATE문에 사용되는 서브쿼리 --INSERT문에서는 사용 가능
      . VIEW를 대상으로 하는 쿼리
      . DISTINCT가 사용되는 SELECT문
      . GROUP BY, ORDER BY절이 사용되는 SELECT문
      . 집합연산자(UNION, UNION ALL, INTERSECT, MINUS)에 사용되는 SELECT문
      . WHERE절
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

  4. INDEX 객체
    - 데이터의 검색효율성을 개선하기 위한 객체
    - WHERE 조건절에 사용되는 컬럼이나 SORT나 GROUP의 기준컬럼 등을 기준으로 INDEX를 구성하면 DBMS의 부하를 줄여 전체 성능이 향상됨
    - 별도의 공간이 소요(INDEX FILE), 인덱스 파일의 유지보수에 많은 시스템 자원이 필요함, 데이터 수정 등에 많은 시간이 소요됨
    -- 기본키는 자동으로 인덱스가 됨(ex PK_BUYER, PK_CART,...)
    - 인덱스 종류
      . Unique Index : 중복값을 허용하지 않는 인덱스(기본키 인덱스 등)
      . Non-Unique Index : 중복값을 허용하는 인덱스로 Null값을 허용하지만, 하나의 Null값만 허용함
      . Single Index : 인덱스 구성에 하나의 컬럼이 사용됨
      . Composite Index : 인덱스 구성에 복수개의 컬럼이 사용되며, WHERE절에서 사용시 모든 항목(인덱스 구성 항목)의 참여가 효율성을 증대시킴
      . Normal Index : 기본 인덱스(트리구조 사용 - 모든 노드의 평균 검색 횟수가 동일함)로
                       ROWID(각 행의 물리적 주소값)와 컬럼값으로 주소를 산출함
      . Function-Based Normal Index : 인덱스 구성 컬럼에 함수가 사용된 경우로, WHERE 조건절에서 사용시 동일 함수 적용시 효율이 가장 우수함
      . Bitmap Index : ROWID와 컬럼값의 이진(Binary)값의 조합으로 주소를 산출함, -- Normal Index와 비슷하지만 이진값으로 변경해서 주소를 산출함
                       Cardinality가 적은 경우에 효율적이며, 추가, 변경, 삭제가 많은 경우 비효율적임
    (사용형식)
      CREATE [UNIQUE|BITMAP] INDEX 인덱스명
        ON 테이블명(컬럼명1[, 컬럼명2,...][ASC|DESC]);   
   
    ** 인덱스의 재구성 -- 인덱스를 재구성시키는 이유
      . 해당 테이블의 자료가 많이 삭제된 경우 -- 직접 지시하지 않아도 일정시간이 지나면 자동으로 재구성됨
      . 인덱스를 다른 테이블 스페이스로 이동시킨 후
    (사용형식)      
      ALTER INDEX 인덱스명 REBUILD   
-------------------------------------------------------------------------------------------------------------------------------                         
  ** PL/SQL(Procedual Language SQL)
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

      (2) CASE 문
        - 표준 SQL의 SELECT 절에 사용되는 CASE 표현식과 동일함
        - 다중 분기 기능 제공
        -- 모든 CASE문은 IF문으로 변환이 가능하지만, IF문을 모두 CASE문으로 변환하는 것은 불가능함
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

      (2) WHILE 문
        - 개발언어의 WHILE문과 동일 기능 및 구조
        (사용형식)
          WHILE 조건 LOOP
            반복처리명령문(들);
            [EXIT WHEN 조건;]
          END LOOP;
          . '조건'이 참이면 반복 수행

      (3) FOR 문
        - 개발언어의 FOR문과 유사한 구조
        - 일반 반복처리를 위한 FOR문과 CURSOR처리를 위한 FOR문이 제공됨
        -- 반복회수를 정확하게 알거나 반복회수가 중요하면 FOR문을 사용
        -- 반복회수를 정확하게 알지 못하거나 반복회수가 중요하지 않으며, 마지막으로 처리해야할 조건을 알고 있으면 WHILE문을 사용
        (일반 FOR문 사용형식)
          FOR 인덱스 IN [REVERSE] 초기값..최대값 LOOP -- 초기값~최대값까지 1씩 증감함, '..'은 생략할 수 없음
            반복처리명령문(들);
          END LOOP;
          . '인덱스' : 제어변수로 사용될 인덱스로 시스템에서 자동으로 설정해줌, 변수를 선언할 필요가 없음
          . 'REVERSE' : 역순으로 반복처리시 사용함
        
        (CURSOR를 위한 FOR문 사용형식) -- FOR문과 CURSOR를 함께 사용하는 것이 가장 안정적인 사용방식
          FOR 레코드명 IN 커서명|커서선언문 LOOP
            반복처리명령문(들);
          END LOOP;
          . '레코드명' : 커서가 가르키는 행의 값을 가지고 있는 변수로 시스템에서 자동으로 설정해줌, 변수를 선언할 필요가 없음
          . 커서 내의 값들(컬럼)의 참조는 '레코드명.커서의 컬럼명' 형식으로 기술함
          . 커서의 OPEN, FETCH, CLOSE 명령 생략
          . 커서선언문 : 선언영역에서 선언해야할 커서선언문 중 'SELECT'문을 서브쿼리 형식으로 기술
          -- DECLARE절의 변수선언을 하지 않아도 됨
-------------------------------------------------------------------------------------------------------------------------------                         
  ** 커서(CURSOR)
    - 오라클 SQL명령어에 의하여 영향을 받은 행들의 집합
    - SELECT문에 의해 반환된 결과 집합의 행들을 차례대로 접근해야 하는 경우 사용함
    - 개발자가 결과를 수동적으로 제어할 필요가 있는 경우 사용
    - IMPLICITE, EXPLICITE CURSOR
    - 커서의 사용은 FOR문을 제외하고 생성(선언) -> OPEN -> FETCH -> CLOSE 단계를 차례대로 실행
    
  1. 익명커서(IMPLICITE CURSOR)
    - 이름이 없는 커서
    - SELECT문이 실행되면 결과(커서)가 자동으로 OPEN이 되고, 결과 출력이 완료된 직후에 자동으로 CLOSE 됨(참조 불가능)
    - 커서속성
      . SQL%ISOPEN : 커서가 OPEN 상태이면 참(true) 반환 - 항상 거짓(false)
      . SQL%NOTFOUND : 커서에 자료가 남아있지 않으면 참(true) 반환
      . SQL%FOUND : 커서에 자료가 남아있으면 참(true) 반환 -- WHILE문의 조건문에 사용할 수 있음
      . SQL%ROWCOUNT : 커서에 존재하는 자료의 개수
      -- 이름이 존재하는 커서는 SQL자리에 커서의 이름을 기술함

  2. 커서(EXPLICITE CURSOR)
    - 이름이 부여된 커서
    - 선언부에서 선언
    (선언형식 - 선언부)
      CURSOR 커서명[(변수명 타입명[,변수명 타입명,...])] -- 필요없으면 기술하지 않아도 됨, 변수명과 타입명만 기술함(크기 제외)
      IS
        SELECT 문;
        
    (선언형식 - 실행부)
      OPEN 커서명[(매개변수[,매개변수,...])]; -- 위의 커서와 같은 타입이어야함

      FETCH 커서명 INTO 변수list;
      
      CLOSE 커서명;
-------------------------------------------------------------------------------------------------------------------------------                         
  ** 저장 프로시져(Stored Procedure)
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
-------------------------------------------------------------------------------------------------------------------------------                         
  ** 함수(User Defined Function)
    - 프로시져와 장점 등이 유사함
    - 반환값이 있음 -- 프로시져는 반환값이 없음
    - 자주 사용되는 서브쿼리 또는 복잡한 산술식 등을 함수로 구현함
    - SELECT 문의 SELECT절, WHERE절에 사용이 가능함 -- 프로시져는 일반쿼리 문에서 사용 불가, 독립적으로 실햄함
    -- 메서드, 프로시져, 함수 등은 하나의 값만 반환하도록 설계하는 것이 좋음
    (사용형식)
      CREATE [OR REPLACE] FUNCTION 함수명 [(
        매개변수 [MODE] 타입 [:=값][,
          :
        매개변수 [MODE] 타입 [:=값])]
        RETURN 데이터 타입 -- 기본형 데이터 타입만 사용 가능, 참조형 데이터 타입은 사용 불가
      IS|AS
        선언영역
      BEGIN
        실행영역
        RETURN 값|expr; -- 실제 반환되는 값, 하나만 반환이 가능함
      END;
      . 'RETURN 데이터 타입' : 반환할 데이터 타입
      . 'RETURN 값|expr' : 반환해야할 값 또는 값을 산출하는 수식 등으로 반드시 1개 이상 존재해야함
      -- CREATE의 RETURN 데이터 타입과 BEGIN의 RETURN 값의 데이터 타입은 동일해야함      
-------------------------------------------------------------------------------------------------------------------------------                         
  ** 트리거(Trigger)
    - 특정 이벤트의 발생 이전 또는 이후에 자동으로 실행되어야할 프로시져
    - 트리거는 문장단위 트리거와 행단위 트리거로 구분됨
    - 문장단위 트리거의 수행시 트리거가 완료되지 않은 상태에서 또다른 트리거를 호출하면
      테이블의 일관성 유지를 위해 해당 테이블에 대한 접근이 금지됨
    -- 잘못 사용하면 락이 걸려 테이블에 대한 접근이 금지될 수 있으므로, 사용에 주의가 필요함  
    -- 문장단위 트리거는 특정 이벤트가 발생하면 오직 한번만 실행됨
    -- 행단위 트리거는 여러개의 행이 업데이트 삭제 수정될 때마다 각 행마다 트리거가 각각 발생함
    -- 트리거 함수(COLUMN NEW, COLUMN OLD)가 존재함
    (사용형식)
      CREATE [OR REPLACE] TRIGGER 트리거명
        timming[BEFORE|AFTER] event[INSERT|UPDATE|DELETE]
        ON 테이블명
        [FOR EACH ROW]
        [WHEN 조건]
     [DECLARE
        선언부
     ]
      BEGIN
        실행부 -- 트리거의 내용, 트리거로 처리해야할 쿼리
      END;
      . 'BEFORE|AFTER' : '실행부'(트리거의 본문)가 실행될 시점
      -- 제품을 입고(BUYPROD UPDATE)한 뒤(AFTER), 재고 테이블(REMAIN UPDATE)에 입력
      . 'INSERT|UPDATE|DELETE' : 트리거를 발생시키는 이벤트로 OR 연산자로 복수개 사용 가능
        ex) INSERT OR DELETE, INSERT OR UPDATE OR DELETE etc...
      . 'FOR EACH ROW' : 행단위 트리거시 기술(생략하면 문장단위 트리거)
      . 'WHEN 조건' : 행단위 트리거에서만 사용이 가능하며, 이벤트 발생에 대한 구체적인 조건을 기술함
      -- COMMIT하지 않으면 홀딩이 되어 다른 사람은 이용할 수 없으므로, INSERT, UPDATE, DELETE 뒤에는 항상 COMMIT을 해주는 것이 좋음
      -- TRIGGER의 트리거명은 일반적으로 'TR_'로 시작함
      -- TRIGGER의 본문은 BEGIN 실행부에 존재함

  1. 트리거 의사레코드 - 행단위 트리거에서만 사용이 가능함
    1) :NEW - INSERT, UPDATE 이벤트시 사용
              데이터가 삽입(갱신)되는 경우 새롭게 들어온 값
              DELETE 시에는 모두 NULL임
    2) :OLD - DELETE, UPDATE 이벤트시 사용
              데이터가 삭제(갱신)되는 경우 이미 존재하고 있던 값
              INSERT 시에는 모두 NULL임
              
  1. 트리거 함수
    - 트리거의 이벤트를 구별하기 위한 함수
    1) INSERTING : 트리거의 이벤트가 INSERT이면 참
    2) UPDATING : 트리거의 이벤트가 UPDATE이면 참
    3) DELETING : 트리거의 이벤트가 DELETE이면 참

    COMMIT;
   
사용예) 2005년 6월 구매가 가장 많은 고객의 주소지 이외의 주소지에 거주하는 회원을 조회하시오.
       Alias는 회원번호, 회원명, 주소
       SELECT AS 회원번호,
              AS 회원명,
              AS 주소  
              
사용예) 사원 테이블에서 사원들의 평균급여보다 더 많은 급여를 받는 사원을 조회하시오.
       Alias는 사원번호, 사원명, 급여, 부서명
       DECLARE
         
       BEGIN
         
       END;              