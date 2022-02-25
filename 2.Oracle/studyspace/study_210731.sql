사용예) 2005년 4~6월 모든 분류별 매입현황을 조회하시오.
       Alias는 분류코드, 분류명, 매입수량, 매입금액
       (일반외부조인 사용형식) -- 모든 분류별 출력 안됨
       SELECT B.LPROD_GU AS 분류코드,
              B.LPROD_NM AS 분류명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * C.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A, LPROD B, PROD C
        WHERE A.BUY_PROD (+)= C.PROD_ID
          AND C.PROD_LGU (+)= B.LPROD_GU
          AND A.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630')
        GROUP BY B.LPROD_GU, B.LPROD_NM
        ORDER BY 1;
        
       (ANSI외부조인 사용형식)
       SELECT B.LPROD_GU AS 분류코드,
              B.LPROD_NM AS 분류명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * C.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD C ON (A.BUY_PROD = C.PROD_ID AND
              A.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630'))
        RIGHT OUTER JOIN LPROD B ON (C.PROD_LGU = B.LPROD_GU)
        GROUP BY B.LPROD_GU, B.LPROD_NM
        ORDER BY 1;

       (SUBQUERY + 일반외부조인)
       -- D테이블의 분류코드가 TBLA의 BID보다 더 많음
       -- D.LPROD_GU의 분류코드가 TBLA.BID 더 많음
       SELECT D.LPROD_GU AS 분류코드,
              D.LPROD_NM AS 분류명,
              NVL(TBLA.BCNT, 0) AS 매입수량,
              NVL(TBLA.BAMT, 0) AS 매입금액
         FROM (SELECT B.LPROD_GU AS BID,
                      SUM(A.BUY_QTY) AS BCNT,
                      SUM(A.BUY_QTY * C.PROD_COST) AS BAMT
                 FROM BUYPROD A, LPROD B, PROD C
                WHERE A.BUY_PROD = C.PROD_ID
                  AND C.PROD_LGU = B.LPROD_GU
                  AND A.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630')
                GROUP BY B.LPROD_GU, B.LPROD_NM) TBLA,
              LPROD D
        WHERE D.LPROD_GU = TBLA.BID (+)
        ORDER BY 1;

사용예) 2005년 4~6월 모든 분류별 매출현황을 조회하시오.
       Alias는 분류코드, 분류명, 매출수량, 매출금액
       (ANSI외부조인 사용형식)
       SELECT B.LPROD_GU AS 분류코드,
              B.LPROD_NM AS 분류명,
              NVL(SUM(A.CART_QTY), 0) AS 매출수량,
              NVL(SUM(A.CART_QTY * C.PROD_PRICE), 0) AS 매출금액
         FROM CART A
        RIGHT OUTER JOIN PROD C ON (A.CART_PROD = C.PROD_ID AND
              SUBSTR(A.CART_NO, 1, 6) BETWEEN '200504' AND '200506')
        RIGHT OUTER JOIN LPROD B ON (B.LPROD_GU = C.PROD_LGU)
        GROUP BY B.LPROD_GU, B.LPROD_NM
        ORDER BY 1;
        
       (SUBQUERY + 일반외부조인)
       SELECT D.LPROD_GU AS 분류코드,
              D.LPROD_NM AS 분류명,
              NVL(AAAA.CCNT, 0) AS 매출수량,
              NVL(AAAA.CAMT, 0) AS 매출금액
         FROM (SELECT B.LPROD_GU AS CID,
                      SUM(A.CART_QTY) AS CCNT,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS CAMT
                 FROM CART A, LPROD B, PROD C
                WHERE A.CART_PROD = C.PROD_ID
                  AND C.PROD_LGU = B.LPROD_GU
                  AND SUBSTR(A.CART_NO, 1, 6) BETWEEN '200504' AND '200506'
               -- AND SUBSTR(A.CART_NO, 1, 6) IN(200504, 200505, 200506)
                GROUP BY B.LPROD_GU) AAAA,
              LPROD D
        WHERE D.LPROD_GU = AAAA.CID (+)
        ORDER BY 1;

사용예) 2005년 4~6월 모든 분류별 매입/매출현황을 조회하시오.
       Alias는 분류코드, 분류명, 매입수량, 매입금액, 매출수량, 매출금액
       (ANSI외부조인 사용형식)
       SELECT A.LPROD_GU AS 분류코드,
              A.LPROD_NM AS 분류명,
              NVL(SUM(B.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(B.BUY_QTY * D.PROD_COST), 0) AS 매입금액,
              NVL(SUM(C.CART_QTY), 0) AS 매출수량,
              NVL(SUM(C.CART_QTY * D.PROD_PRICE), 0) AS 매출금액
         FROM PROD D
        INNER JOIN BUYPROD B ON (B.BUY_PROD = D.PROD_ID AND
              B.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630'))
         LEFT OUTER JOIN CART C ON (D.PROD_ID = C.CART_PROD AND
              SUBSTR(C.CART_NO, 1, 6) BETWEEN '200504' AND '200506')
        RIGHT OUTER JOIN LPROD A ON (A.LPROD_GU = D.PROD_LGU)
        GROUP BY A.LPROD_GU, A.LPROD_NM
        ORDER BY 1;
        -- 매입수량 및 금액 오류, 확인

       (SUBQUERY + 일반외부조인)
       SELECT D.LPROD_GU AS 분류코드,
              D.LPROD_NM AS 분류명,
              NVL(TBLA.BCNT, 0) AS 매입수량,
              NVL(TBLA.BAMT, 0) AS 매입금액,
              NVL(TBLB.CCNT, 0) AS 매출수량,
              NVL(TBLB.CAMT, 0) AS 매출금액
         FROM LPROD D,
              (SELECT B.LPROD_GU AS BID,
                      SUM(A.BUY_QTY) AS BCNT,
                      SUM(A.BUY_QTY * C.PROD_COST) AS BAMT
                 FROM BUYPROD A, LPROD B, PROD C
                WHERE A.BUY_PROD = C.PROD_ID
                  AND C.PROD_LGU = B.LPROD_GU
                  AND A.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630')
                GROUP BY B.LPROD_GU) TBLA,
              (SELECT B.LPROD_GU AS CID,
                      SUM(A.CART_QTY) AS CCNT,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS CAMT
                 FROM CART A, LPROD B, PROD C
                WHERE A.CART_PROD = C.PROD_ID
                  AND C.PROD_LGU = B.LPROD_GU
                  AND SUBSTR(A.CART_NO, 1, 6) BETWEEN '200504' AND '200506'
                GROUP BY B.LPROD_GU) TBLB
        WHERE D.LPROD_GU = TBLA.BID (+)
          AND D.LPROD_GU = TBLB.CID (+)
        ORDER BY 1;
        
사용예) 2005년 4~6월 모든 상품별 매입/매출현황을 조회하시오.
       Alias는 상품코드, 상품명, 매입수량, 매입금액, 매출수량, 매출금액
       (ANSI외부조인 사용형식)
       SELECT A.PROD_ID AS 상품코드,
              A.PROD_NAME AS 상품명,
              NVL(SUM(B.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(B.BUY_QTY * A.PROD_COST), 0) AS 매입금액,
              NVL(SUM(C.CART_QTY), 0)AS 매출수량,
              NVL(SUM(C.CART_QTY * A.PROD_PRICE), 0) AS 매출금액
         FROM PROD A
         LEFT OUTER JOIN BUYPROD B ON (A.PROD_ID = B.BUY_PROD AND
              B.BUY_DATE BETWEEN TO_DATE('20050401') AND TO_DATE('20050630'))
         LEFT OUTER JOIN CART C ON (A.PROD_ID = C.CART_PROD AND
              SUBSTR(C.CART_NO, 1, 6) BETWEEN '200504' AND '200506')
        GROUP BY A.PROD_ID, A.PROD_NAME
        ORDER BY 1;
        
사용예) 
       SELECT EMPLOYEE_ID, EMP_NAME
         FROM HR.EMPLOYEES
        WHERE (DEPARTMENT_ID, MANAGER_ID) = (SELECT DEPARTMENT_ID, MANAGER_ID -- 비교될 데이터의 수가 같아야함
                                               FROM HR.DEPARTMENTS
                                              WHERE MANAGER_ID = 121);        
        
사용예) 사원 테이블에서 직원의 수가 10명 이상인 부서를 출력하시오.
       Alias는 부서코드, 부서명
       (메인쿼리 : 부서코드, 부서명 출력)
       SELECT A.DEPARTMENT_ID AS 부서코드,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID = (서브쿼리)
        
       (서브쿼리 : 직원의 수가 10명 이상이 되는 부서의 부서코드)
       SELECT B.DID
         FROM (SELECT DEPARTMENT_ID AS DID,
                      COUNT(*)
                 FROM HR.EMPLOYEES
                GROUP BY DEPARTMENT_ID
               HAVING COUNT(*) >= 10) B;
       -- 집계합수인 COUNT는 WHERE절에 올 수 없고, HAVING절에 넣어서 조건을 만들어줘야함

       (결합 : ANY(=SOME) 연산자 사용)
       SELECT A.DEPARTMENT_ID AS 부서코드,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID = ANY (SELECT B.DID
                                       FROM (SELECT DEPARTMENT_ID AS DID,
                                                    COUNT(*)
                                               FROM HR.EMPLOYEES
                                              GROUP BY DEPARTMENT_ID
                                             HAVING COUNT(*) >= 10) B);
                                            
       (결합 : IN 연산자 사용)
       SELECT A.DEPARTMENT_ID AS 부서코드,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE A.DEPARTMENT_ID IN (SELECT B.DID
                                    FROM (SELECT DEPARTMENT_ID AS DID,
                                                 COUNT(*)
                                            FROM HR.EMPLOYEES
                                           GROUP BY DEPARTMENT_ID
                                          HAVING COUNT(*) >= 10) B);                                            

       (결합: EXISTS 연산자 사용)
         - EXISTS 연산자 왼쪽의 표현식(식 OR 컬럼명)이 없음
         - EXISTS 연산자 오른쪽은 반드시 서브쿼리
       SELECT A.DEPARTMENT_ID AS 부서코드,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.DEPARTMENTS A
        WHERE EXISTS (SELECT 1 -- C.DID보다는 1을 많이 사용함
                        FROM (SELECT B.DEPARTMENT_ID AS DID,
                                     COUNT(*)
                                FROM HR.EMPLOYEES B
                               GROUP BY B.DEPARTMENT_ID
                              HAVING COUNT(*) >= 10) C
                       WHERE C.DID = 50 OR C.DID = 80); --A.DEPARTMENT_ID);        
        
사용예) 80번 부서에서 급여가 평균 이상인 사원을 조회하시오.
       Alias는 사원번호, 급여, 부서코드
       (PARWISE 방식 설명용)
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.SALARY 급여,
              A.DEPARTMENT_ID AS 부서코드
         FROM HR.EMPLOYEES A
        WHERE (A.EMPLOYEE_ID, A.DEPARTMENT_ID) IN (SELECT B.EMPLOYEE_ID, B.DEPARTMENT_ID
                                                     FROM HR.EMPLOYEES B
                                                    WHERE B.SALARY >= (SELECT AVG(C.SALARY)
                                                                         FROM HR.EMPLOYEES C
                                                                        WHERE C.DEPARTMENT_ID = B.DEPARTMENT_ID)
                                                      AND B.DEPARTMENT_ID = 80)
        ORDER BY 3, 2;

       (간단한 방식)
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.SALARY 급여,
              A.DEPARTMENT_ID AS 부서코드
         FROM HR.EMPLOYEES A
        WHERE A.DEPARTMENT_ID = 80
          AND A.SALARY >= (SELECT AVG(SALARY)
                             FROM HR.EMPLOYEES
                            WHERE DEPARTMENT_ID = 80)
        ORDER BY 3, 2;        
        
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
       
사용예) 회원 테이블에서 평균 마일리지보다 많은 마일리지를 보유한 회원의 회원번호, 회원명, 마일리지를 출력하시오.
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE > (평균 마일리지 : 서브쿼리);
         
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE > (SELECT AVG(MEM_MILEAGE)
                               FROM MEMBER);
        
사용예) 회원 테이블에서 평균 마일리지보다 많은 마일리지를 보유한 회원의 회원번호, 회원명, 마일리지, 평균 마일리지를 출력하시오.        
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS 마일리지,
              (SELECT ROUND(AVG(MEM_MILEAGE))
                 FROM MEMBER) AS 평균마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE > (SELECT AVG(MEM_MILEAGE)
                               FROM MEMBER);
                               
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_MILEAGE AS 마일리지,
              A.AMILE AS 평균마일리지
         FROM MEMBER, (SELECT ROUND(AVG(MEM_MILEAGE)) AS AMILE
                       FROM MEMBER) A
        WHERE MEM_MILEAGE > A.AMILE;

사용예) 회원들의 자료에서 성별 평균마일리지를 구하고 자신의 성별 평균마일리지보다 적은 마일리지를 보유한 회원의 2005년 4~6월 구매현황을 조회하시오.
       Alias는 회원번호, 회원명, 구매금액합계
       1) 회원들의 자료에서 성별 평균마일리지를 구하고 자신의 성별 평균마일리지보다 적은 마일리지를 보유한 회원정보
       (메인쿼리 : 회원 테이블에서 (서브쿼리) 조건을 만족하는 회원정보 출력)
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명
         FROM MEMBER
        WHERE 
          AND MEM_MILEAGE < (서브쿼리)
       
       (서브쿼리 : 성별 평균마일리지)
       SELECT C.MEM_ID,
              C.MEM_NAME,
              B.G1,
              C.MEM_MILEAGE,
              ROUND(B.AMILE)
         FROM (SELECT A.GEN AS G1,
                      AVG(A.MEM_MILEAGE) AS AMILE
                 FROM (SELECT MEM_ID, MEM_NAME,
                      CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '1' OR SUBSTR(MEM_REGNO2, 1, 1) = '3' THEN
                                        '남'
                      ELSE
                                        '여'
                      END AS GEN,
                      MEM_MILEAGE
                 FROM MEMBER) A
        GROUP BY A.GEN) B,         
                 (SELECT MEM_ID, MEM_NAME,
                      CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '1' OR SUBSTR(MEM_REGNO2, 1, 1) = '3' THEN
                                '남'
                      ELSE
                                '여'
                      END AS GEN,
                      MEM_MILEAGE
                 FROM MEMBER) C
        WHERE C.GEN = B.G1       
          AND C.MEM_MILEAGE >= B.AMILE
        ORDER BY 3, 4;
          
       2) 2005년 4~6월 구매현황
       SELECT CART_MEMBER AS 회원번호,
              TBLB.CNAME AS 회원명,
              SUM(CART_QTY * PROD_PRICE) AS 구매급액합계
         FROM CART, PROD,
              (SELECT C.MEM_ID AS CID,
                      C.MEM_NAME AS CNAME,
                      B.G1,
                      C.MEM_MILEAGE,
                      ROUND(B.AMILE)
                 FROM (SELECT A.GEN AS G1,
                              AVG(A.MEM_MILEAGE) AS AMILE
                         FROM (SELECT MEM_ID, MEM_NAME,
                               CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '1' OR SUBSTR(MEM_REGNO2, 1, 1) = '3' THEN
                                         '남'
                               ELSE
                                         '여'
                               END AS GEN,
                               MEM_MILEAGE
                          FROM MEMBER) A
                GROUP BY A.GEN) B,         
                         (SELECT MEM_ID, MEM_NAME,
                               CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '1' OR SUBSTR(MEM_REGNO2, 1, 1) = '3' THEN
                                         '남'
                               ELSE
                                         '여'
                               END AS GEN,
                               MEM_MILEAGE
                          FROM MEMBER) C
                WHERE C.GEN = B.G1       
                  AND C.MEM_MILEAGE >= B.AMILE
                ORDER BY 3, 4) TBLB
        WHERE CART_MEMBER = TBLB.CID 
          AND CART_PROD = PROD_ID
          AND SUBSTR(CART_NO, 1, 6) BETWEEN '200504' AND '200506'
        GROUP BY CART_MEMBER, TBLB.CNAME;       
       
사용예) 사원 테이블에서 'Seattle'에 근무하는 사원과 'IT'부서에 근무하는 사원을 조회하시오.
       1) 'Seattle'에 근무하는 사원
       Alias는 사원번호, 사원명, 소재지, 직무명
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        ORDER BY 1;
              
       2) 'IT'부서에 근무하는 사원
       Alias는 사원번호, 사원명, 소재지, 직무명       
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'IT'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;
              
       3) 결합 : UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'IT'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;
     -- UNION을 할 때 ORDER BY절은 마지막에만 나올 수 있음        
              
       4) 'Administration'부서에 근무하는 사원
       Alias는 사원번호, 사원명, 소재지, 직무명       
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Administration'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;  
  
       5) 결합 : UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 부서명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Administration'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;  
  
       6) 결합 : UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Accounting'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;
  
       7) 결합 : UNION ALL -- 두 테이블에서 중복 값을 중복 출력함
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C, HR.LOCATIONS D
        WHERE D.CITY = 'Seattle'
          AND D.LOCATION_ID = B.LOCATION_ID
          AND B.DEPARTMENT_ID = A.DEPARTMENT_ID
          AND A.JOB_ID = C.JOB_ID
        UNION ALL
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              D.CITY AS 소재지,
              B.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.JOBS B, HR.DEPARTMENTS C, HR.LOCATIONS D
        WHERE C.DEPARTMENT_NAME = 'Accounting'
          AND B.JOB_ID = A.JOB_ID
          AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
          AND C.LOCATION_ID = D.LOCATION_ID    
        ORDER BY 1;  
  
사용예) 회원 테이블에서 마일리지가 3000이상인 회원과 직업이 공무원인 회원을 조회하시오.
       1) 마일리지가 3000이상인 회원
       Alias는 회원번호, 회원명, 주소, 마일리지
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
        
       2) 직업이 공무원인 회원
       Alias는 회원번호, 회원명, 주소, 마일리지  
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '공무원';
        
       3) 결합 : UNION -- 마일리지가 3000이상인 회원 7명, 직업이 공무원인 4명을 합쳐 두조건을 모두 만족하는 1명의 중복을 제외해서 10명이 출력됨
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000
        UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '공무원';

       4) 결합 : UNION -- 타입이 달라서 출력이 불가능함
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000
        UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_JOB AS 직업 -- 타입이 달라서 출력이 불가능함
         FROM MEMBER
        WHERE MEM_JOB = '공무원';

       5) 결합 : UNION -- 마일리지와 주민번호1은 타입은 동일하지만 값이 달라서 중복으로 판단하지 않고 각각을 모두 출력함
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 3000
        UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              TO_NUMBER(MEM_REGNO1) AS 주민번호1
         FROM MEMBER
        WHERE MEM_JOB = '공무원';
        -- 될 수 있으면 값을 맞춰주는 것이 좋음       
       
사용예) 회원 테이블에서 마일리지가 2000이상인 회원과 직업이 주부인 회원을 조회하시오.
       1) 마일리지가 2000이상인 회원
       Alias는 회원번호, 회원명, 주소, 마일리지
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 2000;
        
       2) 직업이 주부인 회원
       Alias는 회원번호, 회원명, 주소, 마일리지  
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '주부';
        
       3) 결합 : UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 2000
        UNION
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '주부';

       4) 결합 : UNION ALL -- f001 같은 경우 마일리지가 2000이상이어서 출력되고, 직업이 주부라서 출력됨, 중복을 제거하지 않음
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_MILEAGE >= 2000
        UNION ALL
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_JOB = '주부';

사용예) 2005년 4월과 7월에 팔린 상품정보를 조회하시오.
       1) 2005년 4월에 팔린 상품정보 -- 67개 출력
       Alias는 상품코드, 상품명, 판매가격, 거래처명
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        ORDER BY 1;

       2) 2005년 7월에 팔린 상품정보
       Alias는 상품코드, 상품명, 판매가격, 거래처명 -- 20개 출력
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;

       3) 결합 : UNION -- 68개 출력
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        UNION
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;

       3) 결합 : UNION ALL -- 87개 출력
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        UNION ALL
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;       
       
사용예) 2005년 4월에 판매된 상품 중, 7월에도 판매된 상품정보를 조회하시오.
       Alias는 상품코드, 상품명, 판매가격, 거래처명
       1) 결합 : INTERSECT
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200504%'
        INTERSECT
       SELECT DISTINCT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              B.PROD_PRICE AS 판매가격,
              C.BUYER_NAME AS 거래처명
         FROM CART A, PROD B, BUYER C
        WHERE A.CART_PROD = B.PROD_ID
          AND B.PROD_BUYER = C.BUYER_ID
          AND A.CART_NO LIKE '200507%'
        ORDER BY 1;
  
사용예) 부서명이 'Shipping'에 속한 사원 중 'Matthew Weiss' 사원의 팀에 소속된 직원을 조회하시오.
       1) 부서명이 'Shipping'에 속한 사원 -- 45명 출력
       Alias는 사원번호, 사원명, 부서명, 입사일, 급여
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              A.HIRE_DATE AS 입사일,
              A.SALARY AS 급여
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE B.DEPARTMENT_NAME = 'Shipping'
          AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
        ORDER BY 1;

       2) 'Mattew Weiss' 사원의 팀에 소속된 직원 -- 8명 출력
       Alias는 사원번호, 사원명, 부서명, 입사일, 급여
       SELECT C.EMPLOYEE_ID AS 사원번호,
              C.EMP_NAME AS 사원명,
              D.DEPARTMENT_NAME AS 부서명,
              C.HIRE_DATE AS 입사일,
              C.SALARY AS 급여
         FROM (SELECT A.EMPLOYEE_ID AS EID
                 FROM HR.EMPLOYEES A
                WHERE A.EMP_NAME = 'Matthew Weiss') B,
              HR.EMPLOYEES C, HR.DEPARTMENTS D
        WHERE C.MANAGER_ID = B.EID
          AND C.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY 1;
        
       3) 결합 : INTERSECT -- 8명 출력
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              A.HIRE_DATE AS 입사일,
              A.SALARY AS 급여
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND B.DEPARTMENT_NAME = 'Shipping'
        INTERSECT
       SELECT C.EMPLOYEE_ID AS 사원번호,
              C.EMP_NAME AS 사원명,
              D.DEPARTMENT_NAME AS 부서명,
              C.HIRE_DATE AS 입사일,
              C.SALARY AS 급여
         FROM (SELECT A.EMPLOYEE_ID AS EID
                 FROM HR.EMPLOYEES A
                WHERE A.EMP_NAME = 'Matthew Weiss') B,
              HR.EMPLOYEES C, HR.DEPARTMENTS D
        WHERE C.MANAGER_ID = B.EID
          AND C.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY 1;       
       
사용예) 장바구니 테이블에서 4월과 6월에 판매된 상품 중 4월에만 판매된 상품을 조회하시오.
       1) 4월에 판매된 상품 -- 67명 출력
       Alias는 상품번호, 상품명, 수량합계, 판매금액합계
       SELECT DISTINCT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명,
              SUM(A.CART_QTY) AS 수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200504%'
        GROUP BY A.CART_PROD, B.PROD_NAME
        ORDER BY 1;
        
       2) 6월에 판매된 상품 -- 15명 출력
       Alias는 상품번호, 상품명, 수량합계, 판매금액합계
       SELECT DISTINCT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명,
              SUM(A.CART_QTY) AS 수량합계,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200506%'
        GROUP BY A.CART_PROD, B.PROD_NAME
        ORDER BY 1;
        
       3) 결합 : MINUS -- 53명 출력
       SELECT DISTINCT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명
--            SUM(A.CART_QTY) AS 수량합계,
--            SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200504%'
--      GROUP BY A.CART_PROD, B.PROD_NAME
        MINUS
       SELECT DISTINCT A.CART_PROD AS 상품번호,
              B.PROD_NAME AS 상품명
--            SUM(A.CART_QTY) AS 수량합계,
--            SUM(A.CART_QTY * B.PROD_PRICE) AS 판매금액합계
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200506%'
--      GROUP BY A.CART_PROD, B.PROD_NAME
        ORDER BY 1;       
       
사용예) 회원 테이블에서 마일리지가 많은 회원부터 차례대로 순위(등수)를 부여하시오.
       Alias는 회원번호, 마일리지, 등수
       1) RANK 사용
       SELECT MEM_ID AS 회원번호,
              MEM_MILEAGE AS 마일리지,
              RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS 등수
         FROM MEMBER;
         
       2) DENSE_RANK 사용         
       SELECT MEM_ID AS 회원번호,
              MEM_MILEAGE AS 마일리지,
              DENSE_RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS 등수
         FROM MEMBER;
         
       3) ROW_NUMBER 사용         
       SELECT MEM_ID AS 회원번호,
              MEM_MILEAGE AS 마일리지,
              ROW_NUMBER() OVER(ORDER BY MEM_MILEAGE DESC) AS 등수
         FROM MEMBER;
         
사용예) 회원 테이블에서 마일리지가 많은 회원부터 차례대로 순위(등수)를 부여하고 상위 5명을 조회하시오.
       Alias는 회원번호, 회원명, 마일리지, 등수
       SELECT A.MID AS  회원번호,
              B.MEM_NAME AS 회원명,
              B.MEM_MILEAGE AS 마일리지,
              A.MRK AS 등수
         FROM (SELECT MEM_ID AS MID,
                      RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS MRK
                 FROM MEMBER) A, MEMBER B
        WHERE A.MID = B.MEM_ID
          AND A.MRK <= 5
        ORDER BY 4;

사용예) 장바구니 테이블에서 2005년 5월 구매금액이 많은 회원부터 순위를 부여하시오.
       Alias는 회원번호, 회원명, 구매금액, 등수
       SELECT A.CART_MEMBER AS 회원번호,
              C.MEM_NAME AS 회원명,
              SUM(A.CART_QTY * B.PROD_PRICE) AS 구매금액,
              RANK() OVER(ORDER BY SUM(A.CART_QTY * B.PROD_PRICE) DESC) AS 등수
         FROM CART A, PROD B, MEMBER C
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_MEMBER = C.MEM_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER, C.MEM_NAME
        ORDER BY 3 DESC;
        -- RANK() OVER 안에 집계함수가 없다면, GROUP BY절에 RANK() OVER~을 모두 넣어줘야함
               
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
       
사용예) HR계정의 EMPLOYEES, DEPARTMENTS, JOB_HISTORY 테이블에 별칭('시노늄명') EMP, DEPT, JOBH 을 부여하시오.
       CREATE OR REPLACE SYNONYM EMP FOR HR.EMPLOYEES;
       CREATE OR REPLACE SYNONYM DEPT FOR HR.DEPARTMENTS;
       CREATE OR REPLACE SYNONYM JOBH FOR HR.JOB_HISTORY;
       
       SELECT * FROM EMP;
       SELECT * FROM DEPT; -- 테이블명(HR.DEPARTMENTS) 대신 시노늄명(DEPT)만 간단하게 사용할 수 있음
       SELECT * FROM JOBH;
       -- 테이블명(HR.EMPLOYEES, HR.DEPARTMENTS, HR.JOB_HISTORY) 대신 시노늄명(EMP, DEPT, JOBH)만 간단하게 사용할 수 있음
              
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
         
         COMMIT;