2021-0721-01)
    4. SELF JOIN
      - 하나의 테이블에 서로 다른 별칭을 부여하여 수행하는 조인
      - 조인 조건에 '=' 연산자가 사용된 조인

사용예) 거래처 '마르죠'와 동일한 지역(광역시도)에 소재하고 있는 거래처 정보를 조회하시오.
       Alias는 거래처코드, 거래처명, 주소, 담당자
       -- B 테이블이 마르죠와 동일한 지역의 거래처를 찾기 위한 테이블임
       SELECT B.BUYER_ID AS 거래처코드,
              B.BUYER_NAME AS 거래처명,
              B.BUYER_ADD1||' '||B.BUYER_ADD2 AS 주소,
              B.BUYER_CHARGER AS 담당자
         FROM BUYER A, BUYER B
        WHERE A.BUYER_NAME = '마르죠' -- 일반조건
          AND SUBSTR(A.BUYER_ADD1, 1, 2) = SUBSTR(B.BUYER_ADD1, 1, 2);
          
사용예) 사원번호 108번 사원과 같은 부서에 속한 사원들을 조회하시오.
       Alias는 사원번호, 사원명, 부서명, 직무코드
       SELECT B.EMPLOYEE_ID AS 사원번호,
              B.EMP_NAME AS 사원명,
              C.DEPARTMENT_NAME AS 부서명,
              B.JOB_ID AS 직무코드
         FROM HR.EMPLOYEES A, HR.EMPLOYEES B, HR.DEPARTMENTS C
        WHERE A.EMPLOYEE_ID = 108
          AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND B.DEPARTMENT_ID = C.DEPARTMENT_ID
        ORDER BY 1;

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
       
사용예) 모든 상품별 매입현황을 조회화시오.
       -- 모든: OUTER JOIN, 상품별: GROUP BY
       -- 양쪽에 동시에 존재하는 컬럼의 경우 SELECT절에 많은 쪽을 사용해야함
       Alias는 상품코드, 상품명, 매입수량, 매입금액
       (일반외부조인 사용형식)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD (+)= B.PROD_ID
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
       
       (ANSI외부조인 사용형식)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID)
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;  
        
사용예) 2005년 1월 모든 상품별 매입현황을 조회화시오.
       Alias는 상품코드, 상품명, 매입수량, 매입금액
       (일반외부조인 사용형식)        
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD (+)= B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131') -- 내부조인되어 39개의 결과만 출력함
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
       
       -- 해결방법1 : ANSI외부조인 사용
       (ANSI외부조인 사용형식)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'))
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
        
       -- 해결방법2 : 해결안됨
       (ANSI외부조인 사용형식)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM BUYPROD A
        RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID)
        WHERE A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131') -- 내부조인되어 39개의 결과만 출력함
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
        
       -- 해결방법3 : 결합 
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.BUY_QTY), 0) AS 매입수량,
              NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) AS 매입금액
         FROM PROD B, (--2005년도 1월 매입정보(내부조인)) A
        WHERE B.컬럼명 = A.컬럼명 (+)
        ORDER BY 1;
       -- 2005년도 1월 매입정보(내부조인) 
       SELECT BUY_PROD AS BID,
              SUM(BUY_QTY) AS QAMT,
              SUM(BUY_QTY * BUY_COST) AS MAMT
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY BUY_PROD;        
       
       (SUBQUERY + 일반외부조인)
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(A.QAMT, 0) AS 매입수량,
              NVL(A.MAMT, 0) AS 매입금액
         FROM PROD B, (SELECT BUY_PROD AS BID,
                              SUM(BUY_QTY) AS QAMT,
                              SUM(BUY_QTY * BUY_COST) AS MAMT
                         FROM BUYPROD
                        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
                        GROUP BY BUY_PROD) A
        WHERE B.PROD_ID = A.BID (+)
        ORDER BY 1;
        
사용예) 모든 부서별 사원수를 출력하시오.
       Alias는 부서코드, 부서명, 사원수
       (일반외부조인 사용형식)
       SELECT B.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명,
              COUNT(A.EMPLOYEE_ID) AS 사원수
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID (+)
        GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
       -- COUNT(*): NULL 값이 계산되어 사원이 없는 부서에 사원수가 1명으로 출력됨
       -- COUNT(A.EMPLOYEE_ID): 부서코드가 없는 CEO가 존재하기에 107명이 아닌, 106명만 출력됨
       
       (ANSI외부조인 사용형식)
       SELECT LPAD(NVL(TO_CHAR(B.DEPARTMENT_ID), '없음'), 4) AS 부서코드, -- 양쪽 타입을 맞추기 위해 TO_CHAR를 이용해 형변환 해줌
              NVL(B.DEPARTMENT_NAME, '없음') AS 부서명, -- 양쪽 타입이 동일하므로 TO_CHAR을 이용한 형변환이 필요없음
              COUNT(A.EMPLOYEE_ID) AS 사원수
         FROM HR.EMPLOYEES A
         FULL OUTER JOIN HR.DEPARTMENTS B ON (B.DEPARTMENT_ID = A.DEPARTMENT_ID)
        GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
       
사용예) 2005년 4월 모든 상품에 대한 판매현황을 조회하시오.
       Alias는 상품코드, 상품명, 판매수량, 판매금액
       (SUBQUERY + 일반외부조인)
       SELECT BBB.PROD_ID AS 상품코드,
              BBB.PROD_NAME AS 상품명,
              NVL(AAA.CQTY, 0) AS 판매수량,
              NVL(AAA.CPRI, 0) AS 판매금액
         FROM PROD BBB, (SELECT A.CART_PROD AS CID,
                                SUM(A.CART_QTY) AS CQTY,
                                SUM(A.CART_QTY * B.PROD_PRICE) AS CPRI
                           FROM CART A, PROD B
                          WHERE A.CART_PROD = B.PROD_ID
                            AND A.CART_NO LIKE '200504%'
                          GROUP BY A.CART_PROD) AAA
        WHERE BBB.PROD_ID = AAA.CID (+)
        ORDER BY 1;
        
       (ANSI외부조인 사용형식)       
       SELECT B.PROD_ID AS 상품코드,
              B.PROD_NAME AS 상품명,
              NVL(SUM(A.CART_QTY), 0) AS 판매수량,
              NVL(SUM(A.CART_QTY * B.PROD_PRICE), 0) AS 판매금액
         FROM CART A
        RIGHT OUTER JOIN PROD B ON (A.CART_PROD = B.PROD_ID AND
              A.CART_NO LIKE '200504%')
        GROUP BY B.PROD_ID, B.PROD_NAME
        ORDER BY 1;
        
        COMMIT;
    
    