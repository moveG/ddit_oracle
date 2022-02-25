2021-0730-01)
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

사용예) 회원 테이블에서 주민번호 조합으로 인덱스를 생성하시오.
       CREATE INDEX IDX_MEM_REGNO
         ON MEMBER(MEM_REGNO1, MEM_REGNO2);
       
       CREATE INDEX IDX_MEM_NAME
         ON MEMBER(MEM_NAME);
       
       DROP INDEX IDX_MEM_NAME;
         
       SELECT * FROM MEMBER
        WHERE MEM_ADD1 LIKE '대전%';
       
       SELECT * FROM MEMBER
         WHERE MEM_NAME = '신용환';
         
사용예) 회원 테이블의 MEM_REGNO2의 주민번호 중 2~5번째 글자로 구성된 인덱스를 생성하시오.
       CREATE INDEX IDX_MEM_REGNO_SUBSTR
         ON MEMBER(SUBSTR(MEM_REGNO2, 2, 4));
         
       SELECT * FROM MEMBER
         WHERE SUBSTR(MEM_REGNO2, 2, 4) = '4489';
         
    ** 인덱스의 재구성 -- 인덱스를 재구성시키는 이유
      - 해당 테이블의 자료가 많이 삭제된 경우 -- 직접 지시하지 않아도 일정시간이 지나면 자동으로 재구성됨
      - 인덱스를 다른 테이블 스페이스로 이동시킨 후
    (사용형식)      
      ALTER INDEX 인덱스명 REBUILD
         
      COMMIT;