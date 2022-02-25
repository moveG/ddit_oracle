2021-0721-01) 테이블 조인
  - 관계형 데이터베이스의 핵심 기능
  - 복수개의 테이블에 분산된 자료를 조회하기 위함
  - 테이블 사이에 관계(Relationship)가 맺어져 있어야 함
  - 구분
    . 일반조인 / ANSI JOIN
      - 일반조인 - CARTESIAN PRODUCT, EQUI JOIN, NON EQUI JOIN, SELF JOIN, OUTER JOIN
      -- <내부조인>
        -- NON EQUI JOIN: '=' 이외의 연산자를 사용한 조인
        -- SELF JOIN: 하나의 테이블을 두개로 간주해 자신을 조인
      -- <외부조인>
        -- OUTER JOIN: 조인조건이 맞지 않는 것은 버리고 조건이 맞는 것만 출력
      - ANSI JOIN - CROSS JOIN, NATURAL JOIN, INNER JOIN, OUTER JOIN
      -- <내부조인>
        -- NATURAL JOIN: 조인 조건을 기술하지 않아도 자동으로 조인, 사용 빈도가 낮음
      -- <외부조인>
        -- OUTER JOIN: 일반조인보다 훨씬 더 정확함
    . 내부조인 / 외부조인
    
    (일반조인 사용형식)
      SELECT 컬럼list
        FROM 테이블명1 [별칭1], 테이블명2 [별칭2], [테이블명3 [별칭3],... ]
       WHERE 조인조건1
        [AND 조인조건2]
        [AND 일반조건]...
      - 조인에 사용된 테이블이 n개일 때, 조인조건의 개수는 n-1개 이상이어야함
      - 조인조건과 일반조건의 기술 순서는 의미없음
      
    (ANSI INNER JOIN 사용형식)
      SELECT 컬럼list
        FROM 테이블명1 [별칭1]
       INNER JOIN 테이블명2 [별칭2] ON(조인조건1 [AND 일반조건1])
      [INNER JOIN 테이블명3 [별칭3] ON(조인조건2 [AND 일반조건2])]
            :
      [WHERE 일반조건n]...
      - '테이블명1'과 '테이블명2'는 반드시 조인 가능한 테이블일 것
      - '테이블명3'부터는 '테이블명1'과 '테이블명2'의 결과와 조인
      - ON 절에 사용되는 일반조건1은 '테이블명1'과 '테이블명2'에만 해당되는 조인조건
      - WHERE 절의 조인조건은 모든 테이블에 적용되는 조인조건

    1. CARTESIAN PRODUCT
      - 모든 가능한 행들의 집합을 결과로 반환
      - ANSI에서는 CROSS JOIN이 이에 해당
      - 특별한 목적 이외에는 사용되지 않음
      - 조인조건이 없거나 잘못된 경우 발생
      
사용예) 
       SELECT COUNT(*)
         FROM CART, BUYPROD;
       -- 30636행 (207행 * 148행)
       SELECT COUNT(*)
         FROM BUYPROD;
       -- 207행
       SELECT COUNT(*)
         FROM CART;
       -- 148행  
       SELECT 207 * 148 FROM DUAL;
         
사용예) 
       SELECT COUNT(*)
         FROM CART, BUYPROD, PROD;
         
       SELECT COUNT(*)
         FROM CART
        CROSS JOIN BUYPROD
        CROSS JOIN PROD;

    2. Equi-Join
      - 동등 조인
      - 조인 조건에 '=' 연산자가 사용된 조인
      - ANSI JOIN은 INNER JOIN이 이에 해당
      - 조인조건 또는 SELECT에 사용되는 컬럼 중 두 테이블에서 같은 컬럼명으로
        정의된 경우 '테이블명.컬럼명' 또는 '테이블 별칭.컬럼명' 형식으로 기술
        
사용예) 매입 테이블에서 2005년 1월 상품별 매입현황을 조회하시오.
       Alias는 상품코드, 상품명, 매입수량합계, 매입금액합계
       (일반조인 사용형식)
       SELECT A.BUY_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              SUM(A.BUY_QTY) AS 매입수량합계,
              SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액합계
         FROM BUYPROD A, PROD B
        WHERE A.BUY_PROD = B.PROD_ID -- 조인조건
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY A.BUY_PROD, B.PROD_NAME
        ORDER BY 1;
        
       (ANSI INNER JOIN 사용형식)
       SELECT A.BUY_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              SUM(A.BUY_QTY) AS 매입수량합계,
              SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액합계
         FROM BUYPROD A
        INNER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID)
        WHERE A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131')
        GROUP BY A.BUY_PROD, B.PROD_NAME
        ORDER BY 1;
         
        SELECT A.BUY_PROD AS 상품코드,
              B.PROD_NAME AS 상품명,
              SUM(A.BUY_QTY) AS 매입수량합계,
              SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액합계
         FROM BUYPROD A
        INNER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID
          AND A.BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050131'))
        GROUP BY A.BUY_PROD, B.PROD_NAME
        ORDER BY 1;
        -- 테이블이 두개 밖에 없어서 AND, WHERE 둘 중 무엇을 사용해도 무방함

사용예) 사원 테이블에서 관리자 사원번호가 121번인 부서에 속한 사원 정보를 조회하시오.
       Alias는 사원번호, 사원명, 부서명, 직무명
       (일반조인 사용형식)
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID -- 조인조건
          AND A.JOB_ID = C.JOB_ID -- 조인조건
          AND B.MANAGER_ID = 121
        ORDER BY 1;
        -- 관리자 사원번호가 121번인 "부서"에 속한 사원 정보: DEPARTMENTS 테이블의 MANAGER_ID를 사용해야함
        
       (ANSI INNER JOIN 사용형식) 
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A
        INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID
          AND B.MANAGER_ID = 121)
        INNER JOIN HR.JOBS C ON (A.JOB_ID = C.JOB_ID)
        ORDER BY 1;

       (ANSI INNER JOIN 사용형식) 
       SELECT A.EMPLOYEE_ID AS 사원번호,
              A.EMP_NAME AS 사원명,
              B.DEPARTMENT_NAME AS 부서명,
              C.JOB_TITLE AS 직무명
         FROM HR.EMPLOYEES A
        INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
        INNER JOIN HR.JOBS C ON (A.JOB_ID = C.JOB_ID)
        WHERE B.MANAGER_ID = 121
        ORDER BY 1;

사용예) 2005년 거래처별 매출현황을 조회하시오.
       Alias는 거래처코드, 거래처명, 매출금액합계
       (일반조인 사용형식) 거래처에서 납품하는 제품들이 얼마나 많이 팔렸나?
       -- 컬럼명에 '_ID'가 붙은 것은 대부분 기본키
       -- 컬럼명에 '_LGU'가 붙은 것은 대부분 분류코드
       -- 날짜는 대부분 일반조건이므로 WHERE절에 작성함
       -- EXTRACT는 날짜 타입에 사용함
       SELECT B.BUYER_ID AS 거래처코드,
              B.BUYER_NAME AS 거래처명,
              SUM(A.CART_QTY * C.PROD_PRICE) AS 매출금액합계
         FROM CART A, BUYER B, PROD C
        WHERE A.CART_PROD = C.PROD_ID
          AND C.PROD_BUYER = B.BUYER_ID
          AND A.CART_NO LIKE '2005%'
       -- AND SUBSTR(A.CART_NO, 1, 4) = '2005'
        GROUP BY B.BUYER_ID, B.BUYER_NAME
        ORDER BY 1;

       (ANSI INNER JOIN 사용형식)
       SELECT B.BUYER_ID AS 거래처코드,
              B.BUYER_NAME AS 거래처명,
              SUM(A.CART_QTY * C.PROD_PRICE) AS 매출금액합계
         FROM BUYER B
        INNER JOIN PROD C ON (B.BUYER_ID = C.PROD_BUYER)
        INNER JOIN CART A ON (C.PROD_ID = A.CART_PROD
       -- AND A.CART_NO LIKE '2005%')
          AND SUBSTR(A.CART_NO, 1, 4) = '2005')
        GROUP BY B.BUYER_ID, B.BUYER_NAME
        ORDER BY 1;
       
        COMMIT;
        