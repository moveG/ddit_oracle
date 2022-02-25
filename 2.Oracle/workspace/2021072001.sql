2021-0720-01)
  4. MAX(column명), MIN(column명)
   - MAX : 주어진 컬럼명 중 최대값을 반환
   - MIN : 주어진 컬럼명 중 최소값을 반환
   - 집계함수는 다른 집계함수를 포함할 수 없다.
   -- 집계함수는 겹쳐 사용할 수 없음
   -- 중복사용이 필요할 때는 서브쿼리를 사용함
   
사용예) 2005년 월별 매입액 중 최대매입제품과 최소매입제품의 최대매입액, 최소매입액을 조회하시오.
       Alias는 월, 최대매입액, 최소매입액
       SELECT EXTRACT(MONTH FROM BUY_DATE) AS 월,
              MAX(BUY_QTY * BUY_COST) AS 최대매입액,
              MIN(BUY_QTY * BUY_COST) AS 최소매입액
         FROM BUYPROD
        WHERE EXTRACT(YEAR FROM BUY_DATE) = 2005
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
        ORDER BY 1;
            
사용예) 2005년 5월 최대구매 고객정보를 조회하시오.
       Alias는 회원번호, 회원명, 구매금액
       -- 데이터베이스는 1촌(부모-자식)만 인식
       SELECT A.CART_MEMBER AS 회원번호,
              B.MEM_NAME AS 회원명,
              SUM(A.CART_QTY * C.PROD_PRICE) AS 구매금액
         FROM CART A, MEMBER B, PROD C
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_PROD = C.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER, B.MEM_NAME
        ORDER BY 3 DESC;
        -- 모든 회원의 구매금액을 내림차순으로 출력함
        -- 최대구매 회원만 출력할 수는 없음
        -- 최대구매 회원 한명만 출력하려면 서브쿼리를 사용해야함
        
       SELECT A.CART_MEMBER AS 회원번호,
              B.MEM_NAME AS 회원명,
              MAX(SUM(A.CART_QTY * C.PROD_PRICE)) AS 구매금액
         FROM CART A, MEMBER B, PROD C
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_PROD = C.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY A.CART_MEMBER, B.MEM_NAME;
        -- MAX(SUM()): 집계함수 안에 집계함수를 사용할 수 없음, 오류가 발생함
        
       SELECT A.CART_MEMBER AS 회원번호,
              B.MEM_NAME AS 회원명,
              SUM(A.CART_QTY * C.PROD_PRICE) AS 구매금액
         FROM CART A, MEMBER B, PROD C
        WHERE A.CART_MEMBER = B.MEM_ID
          AND A.CART_PROD = C.PROD_ID
          AND A.CART_NO LIKE '200505%'
          AND ROWNUM = 1
        GROUP BY A.CART_MEMBER, B.MEM_NAME
        ORDER BY 3 DESC;
        -- ROWNUM은 회원번호 옆의 숫자를 의미한다, 이것은 오라클에서 임의로 부여한 의사코드임
        -- ROWNUM 1을 해도 최대구매 고객인 신영남이 아니라, 다른 사람이 출력됨
        -- 데이터가 SORT되기 전에 개수부터 카운트해서 다른 사람이 출력됨
        
사용예) 2005년 5월 최대구매 고객정보를 조회하시오.
       Alias는 회원번호, 회원명, 구매금액
       (SUBQUERY)
       SELECT A.MID AS 회원번호,
              A.MNAME AS 회원명,
              A.AMT AS 구매금액
         FROM (SELECT A.CART_MEMBER AS MID,
                      B.MEM_NAME AS MNAME,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS AMT
                 FROM CART A, MEMBER B, PROD C
                WHERE A.CART_MEMBER = B.MEM_ID
                  AND A.CART_PROD = C.PROD_ID
                  AND A.CART_NO LIKE '200505%'
                GROUP BY A.CART_MEMBER, B.MEM_NAME
                ORDER BY 3 DESC) A
        WHERE ROWNUM = 1;
        
       (SUBQUERY)
       SELECT D.MID AS 회원번호,
              D.MNAME AS 회원명,
              E.MEM_ADD1||' '||MEM_ADD2 AS 주소,
              E.MEM_HP AS 연락처,
              D.AMT AS 구매금액
         FROM (SELECT A.CART_MEMBER AS MID,
                      B.MEM_NAME AS MNAME,
                      SUM(A.CART_QTY * C.PROD_PRICE) AS AMT
                 FROM CART A, MEMBER B, PROD C
                WHERE A.CART_MEMBER = B.MEM_ID
                  AND A.CART_PROD = C.PROD_ID
                  AND A.CART_NO LIKE '200505%'
                GROUP BY A.CART_MEMBER, B.MEM_NAME
                ORDER BY 3 DESC) D, MEMBER E
        WHERE D.MID = E.MEM_ID
          AND ROWNUM = 1;
        -- MEMBER가 서브쿼리 안밖으로 중복 사용됨, 안쪽의 MEMBER를 바깥에서 사용할 수 없음
        -- 서브쿼리 안쪽의 별칭과 바깥의 별칭은 중복되어도 상관이 없음
        
        COMMIT;