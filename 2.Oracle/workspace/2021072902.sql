2021-0729-02)
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
    
사용예) 회원 테이블에서 마일리지가 3000이상인 회원을 뷰로 생성하시오.
       Alias는 회원번호, 회원명, 직업, 마일리지
       1) 컬럼list 기술
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE(MID, MNAME, MJOB, MMILE)
       AS
         SELECT MEM_ID AS 회원번호,
                MEM_NAME AS 회원명,
                MEM_JOB AS 직업,
                MEM_MILEAGE AS 마일리지
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000;
          
       2) 컬럼list 미기술 : 컬럼별칭이 뷰의 컬럼명으로 사용됨
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE
       AS
         SELECT MEM_ID AS 회원번호,
                MEM_NAME AS 회원명,
                MEM_JOB AS 직업,
                MEM_MILEAGE AS 마일리지
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000;

       3) 컬럼list와 컬럼별칭 미기술: 원본 테이블의 컬럼명이 뷰의 컬럼명으로 사용됨   
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE
       AS
         SELECT MEM_ID,
                MEM_NAME,
                MEM_JOB,
                MEM_MILEAGE
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000;
               
         SELECT * FROM VIEW_MEM_MILEAGE;          
          
  ** 생성된 뷰 'VIEW_MEM_MILEAGE'에서 회원번호 'e001'회원의 마일리지를 500으로 조정하시오.
       UPDATE VIEW_MEM_MILEAGE
          SET 마일리지 = 500
        WHERE 회원번호 = 'e001';
       -- 뷰의 컬럼명을 사용해야함
       SELECT * FROM VIEW_MEM_MILEAGE;
       
       SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
         FROM MEMBER
        WHERE MEM_ID = 'e001';
       -- 뷰의 데이터를 수정하면 원본 테이블의 데이터도 수정됨
       -- 원본 데이터와 뷰의 데이터가 서로 다르면 모순이 발생하므로 한쪽이 변하면 다른쪽도 변해야 모순이 없음

  ** 회원 테이블에서 회원번호 'g001'회원의 마일리지를 800에서 15000으로 변경하시오.
       UPDATE MEMBER
          SET MEM_MILEAGE = 15000
        WHERE MEM_ID = 'g001';
       -- 원본 테이블의 데이터를 수정
        
       SELECT * FROM VIEW_MEM_MILEAGE; 
       -- 원본 테이블의 데이터가 수정하면 뷰의 데이터도 수정됨

  ** VIEW 사용시 주의사항
    - WITH 절이 사용된 경우 ORDER BY절 사용 금지
    - 집계함수, DISTINCT가 사용된 VIEW를 대상으로 DML명령 사용할 수 없음 -- DISTINCT : 중복 배제
    - 표현식(CASE WHEN ~ THEN, DECODE 등)이나 일반함수를 적용하여 뷰가 생성된 경우 해당 컬럼을 대상으로 수정, 삭제 등 사용 금지
    - CURRVAL, NEXTVAL 등 의사컬럼(Pseudo Column) 사용 금지
    - ROWNUM, ROWID 등 사용시 별칭을 사용해야함
    
사용예) 상품 분류별 상품의 수를 출력하는 뷰 생성
       CREATE OR REPLACE VIEW VIEW_PROD_LGU
       AS
         SELECT PROD_LGU AS PLGU,
                COUNT(*) AS CNT
           FROM PROD
          GROUP BY PROD_LGU;
       
       SELECT * FROM VIEW_PROD_LGU;
       
  ** 뷰 VIEW_PROD_LGU에서 'P102' 자료를 삭제하시오.
       DELETE VIEW_PROD_LGU
        WHERE PLGU = 'P102'
       -- 집계함수(COUNT)가 사용된 VIEW라서 DML명령(DELETE)을 사용할 수 없음

사용예) 회원 테이블에서 마일리지가 3000이상인 회원들로 구성되고 제약조건(CHECK OPTION)을 사용한 뷰를 생성하시오.
       CREATE OR REPLACE VIEW VIEW_MEM_MILEAGE
       AS
         SELECT MEM_ID AS 회원번호,
                MEM_NAME AS 회원명,
                MEM_JOB AS 직업,
                MEM_MILEAGE AS 마일리지
           FROM MEMBER
          WHERE MEM_MILEAGE >= 3000
          
   --  WITH CHECK OPTION
       WITH READ ONLY;
       -- WITH CHECK OPTION과 WITH READ ONLY는 서로 배타적이라 동시에 사용할 수 없음
       
       SELECT * FROM VIEW_MEM_MILEAGE;

  ** 뷰 VIEW_MEM_MILEAGE에서 이혜나 회원('e001')의 마일리지를 1500로 변경하시오.
       UPDATE VIEW_MEM_MILEAGE
          SET 마일리지 = 1500
        WHERE 회원번호 = 'e001';
        -- VIEW를 생성할 때 WITH CHECK OPTION을 넣었기 때문에 WHERE절을 위배한 명령은 수행할 수 없음
        -- 원본 테이블을 수정, 삭제, 추가하는 것은 가능함, 원본 테이블의 변경된 데이터가 뷰의 데이터에도 즉각 반영됨
        
        -- VIEW를 생성할 때 WITH READ ONLY를 넣었기 때문에 VIEW를 수정할 수 없고 읽기 전용으로만 사용 가능함
        -- 원본 테이블을 수정, 삭제, 추가하는 것은 가능함, 원본 테이블의 변경된 데이터가 뷰의 데이터에도 즉각 반영됨

  ** 회원 테이블에서 이혜나 회원('e001')의 마일리지를 1500로 변경하시오.
       UPDATE MEMBER
          SET MEM_MILEAGE = 6500
        WHERE MEM_ID = 'e001';
        
       SELECT * FROM VIEW_MEM_MILEAGE;
       
       COMMIT;