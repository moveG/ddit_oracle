2021-0713-01)
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

사용예) 
       CREATE TABLE T_DATE(
         COL1 DATE,
         COL2 DATE,
         COL3 TIMESTAMP,
         COL4 TIMESTAMP WITH TIME ZONE,
         COL5 TIMESTAMP WITH LOCAL TIME ZONE);
        
       INSERT INTO T_DATE VALUES(SYSDATE, TO_DATE('20201015')+30, SYSDATE, SYSDATE, SYSDATE);
       -- +30: 30일을 더해라
       SELECT * FROM T_DATE;
       
       SELECT TO_CHAR(COL1, 'YYYY-MM-DD PM HH24:MI:SS'), -- AM과 PM은 둘 중 뭘 사용해도 오전/오후 구분해주는 역할만 수행함
              TRUNC(COL1 - COL2) -- TRUNC : 데이터 절삭 기능
         FROM T_DATE;
       
  4. 기타 자료
   - 2진 자료를 저장
   - RAW, LONG RAW, BLOB, BFILE
   -- RAW, LONG RAW는 초기에 사용됨, 지금은 사이즈가 너무 작아 사용 빈도가 낮음
   1) BFILE
    . 2진 자료를 저장
    . 원본 자료를 데이터베이스 외부에 저장하고 데이터베이스에는 경로 정보만 저장
    . 4GB 까지 저장
   (사용형식)
    컬럼명 BEFILE;
     - 오라클에서는 원본 자료(2진 자료)에 대해서 해석하거나 변환하지 않음
     - 2진 자료 저장을 위해 DIRECTORY 객체가 필요
     
사용예) 
       CREATE TABLE T_BFILE(
         COL1 BFILE);
         
      1. 디렉토리 객체 생성  
       CREATE DIRECTORY 디렉토리별칭 AS 절대경로명

       CREATE DIRECTORY TEMP_DIR AS 'D:\A_TeachingMaterial\2.Oracle';
       
      2. 이미지 자료 저장
       INSERT INTO 테이블명
         VALUES(BFILENAME('디렉토리 별칭', '파일명'));
  
       INSERT INTO T_BFILE
         VALUES(BFILENAME('TEMP_DIR', 'SAMPLE.jpg'));
       
       SELECT * FROM T_BFILE; 
        
   2) BLOB
    . 2진 자료를 저장
    . 원본 자료를 데이터베이스 내부에 저장
    . 4GB 까지 저장
    -- BLOB는 사용이 까다롭다
    (사용형식)
    컬럼명 BLOB;
    
    ** BLOB 사용순서
     (1) 테이블 생성
     (2) 디렉토리 객체 생성
     (3) 익명블록 생성
   
사용예) 
       a) 테이블 생성
        CREATE TABLE T_BLOB(
          COL1 BLOB);
       
       b) 디렉토리 객체 생성
        TEMP_DIR 사용
        
       C) 익명블록 생성
        DECLARE
           L_DIR VARCHAR2(20) := 'TEMP_DIR';
          L_FILE VARCHAR2(30) := 'SAMPLE.jpg';
         L_BFILE BFILE;
          L_BLOB BLOB;
        -- 선언부: 변수, 상수, 커서 넣는 부분
        -- 변수 저장
        -- 한글로 된 파일명은 읽을 수 없음
        -- ''(따옴표) 안의 파일명과 확장자의 대소문자는 정확히 구분해줘야 함
        BEGIN
          INSERT INTO T_BLOB(COL1) VALUES(EMPTY_BLOB())
            RETURN COL1 INTO L_BLOB;
          L_BFILE := BFILENAME(L_DIR, L_FILE);
          -- L_DIR, L_FILE을 결합시켜 L_BFILE에 넣음
          DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
          -- BFILE에 들어있는 그림파일과 절대경로를 읽기전용으로 읽어오기 위해 오픈시킴
          DBMS_LOB.LOADFROMFILE(L_BLOB, L_BFILE, DBMS_LOB.GETLENGTH(L_BFILE));
          -- BFILE의 길이만큼 잘라서 데이터베이스 컬럼 안으로 가져와서 저장함
          DBMS_LOB.FILECLOSE(L_BFILE);
          -- 다 읽은 파일을 닫음
          
          COMMIT;
        END;
        
        SELECT * FROM T_BLOB;
        -- 오라클에서는 해석이나 변환을 해주지 않음
        -- 다른 프로그램인 TOAD에서는 변환 가능
        
        COMMIT;
        