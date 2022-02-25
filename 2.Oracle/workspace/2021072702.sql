2021-0727-02)

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
        
        COMMIT;