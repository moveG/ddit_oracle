2021-0726-01)

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
        
        COMMIT;
    