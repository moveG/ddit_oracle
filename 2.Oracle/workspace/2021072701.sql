2021-0727-01)
  ** 재고 수불처리를 위한 테이블을 생성하시오.
    1) 테이블명: REMAIN
    2) 컬럼명
    ----------------------------------------------------------------
         컬럼명         데이터 타입       NULL허용여부         제약사항
    ----------------------------------------------------------------
      REMAIN_YEAR     CHAR(4)             N.N            PK
      PROD_ID         VARCHAR2(10)        N.N            PK/FK
      REMAIN_J_00     NUMBER(5)                          DEFAULT 0 -- 기초재고
      REMAIN_I        NUMBER(5)                          DEFAULT 0 -- 입고
      REMAIN_O        NUMBER(5)                          DEFAULT 0 -- 출고
      REMAIN_J_99     NUMBER(5)                          DEFAULT 0 -- 기말재고(현 재고)
      REMAIN_DATE     DATE                                         -- 최신날짜
    ----------------------------------------------------------------
    
    CREATE TABLE REMAIN(
      REMAIN_YEAR     CHAR(4),
      PROD_ID         VARCHAR2(10),
      REMAIN_J_00     NUMBER(5)  DEFAULT 0,
      REMAIN_I        NUMBER(5)  DEFAULT 0,
      REMAIN_O        NUMBER(5)  DEFAULT 0,
      REMAIN_J_99     NUMBER(5)  DEFAULT 0,
      REMAIN_DATE     DATE,
      
    CONSTRAINT pk_remain PRIMARY KEY(REMAIN_YEAR, PROD_ID),
    CONSTRAINT fk_remain_prod FOREIGN KEY(PROD_ID)
      REFERENCES PROD(PROD_ID));
    
    4) DML 명령에 서브쿼리 사용
      (1) INSERT 문에 서브쿼리 사용
        . '( )'를 사용하지 않고 서브쿼리 기술
        . INSERT 문의 VALUES절도 생략

사용예) 재고수불 테이블(REMAIN)에 PROD 테이블의 자료를 이용하여 기초 데이터를 입력하시오.
       년도 : '2005'
       상품코드 : PROD 테이블의 상품코드(PROD_ID)
       기초재고수량 : PROD 테이블의 PROD_PROPERSTOCK
       입고 및 출고 수량 : 없음
       기말재고수량 : PROD 테이블의 PROD_PROPERSTOCK
       날짜 : '2004-12-31'
       -- SELECT 절이 VALUES절의 역할을 함
       -- SELECT 절의 컬럼의 순서와 개수가 테이블에 INSERT되는 컬럼의 순서와 개수가 같아야함.
       
       INSERT INTO REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_J_99, REMAIN_DATE)
         SELECT '2005', PROD_ID, PROD_PROPERSTOCK, PROD_PROPERSTOCK, TO_DATE('20041231')
           FROM PROD;
       
       SELECT * FROM REMAIN;

      (2) UPDATE 문에 서브쿼리 사용
        . 복수개의 컬럼을 갱신하는 경우 '( )' 안에 변경할 컬럼을 기술하여 하나의 SET절로 처리

사용예) 2005년 1월 상품별 매입정보를 이용하여 REMAIN 테이블을 변경하시오.
       (메인쿼리)
       UPDATE REMAIN
          SET REMAIN_I = (서브쿼리1),
              REMAIN_J_99 = (서브쿼리2),
              REMAIN_DATE = TO_DATE('20050131')
        WHERE 조건
       -- 서브쿼리1 : 상품별 매입수량 집계 후 기존값에 새로운값을 누적합계시켜야함

       UPDATE REMAIN
          SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) = (서브쿼리1)
        WHERE 조건

       (서브쿼리 : 2005년 1월 상품별 매입정보)
       SELECT BUY_PROD,
              SUM(BUY_QTY)
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY BUY_PROD;
        
       COMMIT;

       (결합)
       UPDATE REMAIN B
          SET (B.REMAIN_I, B.REMAIN_J_99, B.REMAIN_DATE) =
              (SELECT B.REMAIN_I + A.AMT, B.REMAIN_J_99 + A.AMT, TO_DATE('20050131') -- 주의해야할 부분, 재고는 항상 누적시켜줘야함
                 FROM (SELECT BUY_PROD AS BID,
                              SUM(BUY_QTY) AS AMT
                         FROM BUYPROD
                        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
                        GROUP BY BUY_PROD) A
                WHERE B.PROD_ID = A.BID)       
        WHERE REMAIN_YEAR = '2005'
          AND B.PROD_ID IN (SELECT DISTINCT BUY_PROD AS BID -- 주의해야할 부분, 업데이트를 할 행을 찾는 쿼리
                              FROM BUYPROD                  -- 이 WHERE절을 잘 작성해줘야 매입된 부분만 업데이트 됨 
                             WHERE BUY_DATE BETWEEN TO_DATE('20050101')
                                   AND TO_DATE('20050131'));
       -- 가장 바깥의 WHERE절에 기본키가 모두 언급되어야 가장 효율적인 쿼리가 됨
       
       ROLLBACK; 
         
       SELECT * FROM REMAIN; 

      (3) DELECT 문에 서브쿼리 사용
        . WHERE 조건절에 IN 이나 EXISTS 연산자를 사용하여 삭제할 자료를 좀 더 세밀하게 선택할 수 있음

사용예) 장바구니 테이블에서 2005년 5월 회원번호가 'p001'인 자료를 삭제하시오.
       (서브쿼리 : 2005년 5월 회원번호가 'p001'인 자료 조회)
       SELECT A.CART_MEMBER,
              B.MEM_NAME
         FROM CART A, MEMBER B
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_MEMBER = 'p001'
       -- AND UPPER(A.CART_MEMBER) = 'P001'
          AND A.CART_NO LIKE '200505%';
       
       (메인쿼리 : 서브쿼리의 결과 자료를 삭제)
       DELETE CART C
        WHERE C.CART_MEMBER = 'p001'
          AND C.CART_NO LIKE '200505%';

사용예) 2005년 6월 상품 'P302000001'의 매출자료 중 판매 수량이 5개 이상인 자료만 삭제하시오.
       (서브쿼리 : 2005년 6월 상품번호가 'P302000001'인 매출자료 중 판매 수량이 5개 이상인 자료
             
       (메인쿼리 : 서브쿼리의 결과 자료를 삭제)
       
사용예) 2005년 4월 판매자료 중 판매 금액이 5만원 이하의 자료만 삭제하시오.
       (서브쿼리 : 2005년 4월 판매자료 중 판매 금액이 5만원 이하의 자료)
       SELECT CART_PROD,
              CART_QTY * PROD_PRICE
         FROM CART, PROD
        WHERE CART_PROD = PROD_ID
          AND CART_NO LIKE '200504%'
          AND CART_QTY * PROD_PRICE <= 50000;

       (메인쿼리 : 장바구니 테이블에서 자료 삭제)
       DELETE FROM CART A
        WHERE EXISTS (SELECT 1
                        FROM PROD
                       WHERE A.CART_PROD = PROD_ID
                         AND A.CART_QTY * PROD_PRICE <= 50000)
          AND A.CART_NO LIKE '200504%';
       -- 삭제시 EXISTS 연산자 사용 권장
       
       COMMIT;       