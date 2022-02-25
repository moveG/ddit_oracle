2021-0729-01) 등수계산(RANK 함수)
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
        
        COMMIT;