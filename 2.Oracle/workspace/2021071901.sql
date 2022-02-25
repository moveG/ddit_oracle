2021-0719-01)
  2. AVG(expr)
   - 'expr'로 정의된 컬럼이나 수식의 값에 대한 산술평균 값을 반환
   
사용예) 모든 회원들의 평균 마일리지를 조회하시오.
       SELECT ROUND(AVG(MEM_MILEAGE), 2) AS "평균 마일리지"
         FROM MEMBER;
         
사용예) 모든 여성 회원들의 평균 마일리지를 조회하시오.   
       SELECT ROUND(AVG(MEM_MILEAGE), 2) AS "평균 마일리지"
         FROM MEMBER
        WHERE SUBSTR(MEM_REGNO2, 1, 1) IN('2', '4');
        
사용예) 회원들의 성별 평균 마일리지를 조회하시오.
       SELECT CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '2'
                     OR SUBSTR(MEM_REGNO2, 1, 1) = '4' THEN
                        '여성회원'
                   ELSE 
                        '남성회원' END AS 구분,
              ROUND(AVG(MEM_MILEAGE)) AS "평균 마일리지"
         FROM MEMBER
        GROUP BY CASE WHEN SUBSTR(MEM_REGNO2, 1, 1) = '2'
                        OR SUBSTR(MEM_REGNO2, 1, 1) = '4' THEN
                           '여성회원'
                      ELSE 
                           '남성회원' END;
                           
사용예) 사원 테이블에서 각 부서별 평균급여를 구하시오.
       Alias는 부서코드, 부서명, 평균급여
       SELECT A.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명,
              '$'||TO_CHAR(ROUND(AVG(SALARY)), '99,999') AS 평균급여
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
        GROUP BY A.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
        -- DEPARTMENT_ID처럼 여러 테이블에서 사용되는 컬럼은 전부 별칭을 붙여, 확실하게 구분해줘야함
        -- B.DEPARTMENT_NAME처럼 한 테이블에서만 사용하는 컬럼은 별칭(B)은 빼도 무방하지만, 될 수 있으면 전부 별칭을 붙여주는게 좋음
        
사용예) 2005년 1~6월 월별 평균 매입액을 조회하시오.
       -- 매입액 BUYPROD, 매출자료 CART, 상품자료 PROD, 회원자료 MEMBER, 거래처자료 BUYER
       SELECT EXTRACT(MONTH FROM BUY_DATE)||'월' AS 월,
              TO_CHAR(ROUND(AVG(BUY_QTY * BUY_COST)), '99,999,999')||' 원' AS "평균 매입액"
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050630')
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
        ORDER BY 1;
        
사용예) 2005년 1~6월 월별 평균 매입액과 매입액 합계를 조회하되, 평균 매입액이 400만원 이상인 월만 조회하시오.
       SELECT EXTRACT(MONTH FROM BUY_DATE)||'월' AS 월,
              TO_CHAR(ROUND(AVG(BUY_QTY * BUY_COST)), '99,999,999')||' 원' AS "평균 매입액",
              TO_CHAR(SUM(BUY_QTY * BUY_COST), '999,999,999')||' 원' AS "매입액 합계"
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050630')
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
       HAVING AVG(BUY_QTY * BUY_COST) >= 4000000
        ORDER BY 1;        
        
사용예) 2005년 1~6월 월별 평균 매입액과 매입액 합계와 매입건수를 조회하되, 평균 매입액이 400만원 이상인 월만 조회하시오.
       SELECT EXTRACT(MONTH FROM BUY_DATE)||'월' AS 월,
              COUNT(*)||' 건' AS 매입건수,
              TO_CHAR(ROUND(AVG(BUY_QTY * BUY_COST)), '99,999,999')||' 원' AS "평균 매입액",
              TO_CHAR(SUM(BUY_QTY * BUY_COST), '999,999,999')||' 원' AS "매입액 합계"
         FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20050101') AND TO_DATE('20050630')
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
       HAVING AVG(BUY_QTY * BUY_COST) >= 4000000
        ORDER BY 1;
        
사용예) 2005년 분류별 평균 판매금액을 조회하시오.
       SELECT B.LPROD_GU AS 분류코드,
              B.LPROD_NM AS 분류명,
              TO_CHAR(ROUND(AVG(A.CART_QTY * C.PROD_PRICE)), '9,999,999')||' 원' AS "평균 판매금액"
         FROM CART A, LPROD B, PROD C
        WHERE A.CART_PROD = C.PROD_ID
          AND C.PROD_LGU = B.LPROD_GU
          AND SUBSTR(A.CART_NO, 1, 4) = '2005'
        GROUP BY B.LPROD_GU, B.LPROD_NM
        ORDER BY 1;

사용예) 2005년 회원의 연령대별 평균 판매금액을 조회하시오.
       SELECT TRUNC((EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM C.MEM_BIR)) / 10) * 10||'대' AS 연령대,
              TO_CHAR(ROUND(AVG(A.CART_QTY * B.PROD_PRICE)), '9,999,999')||' 원' AS "평균 판매금액"
         FROM CART A, PROD B, MEMBER C
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_MEMBER = C.MEM_ID
          AND A.CART_NO LIKE '2005%'
        GROUP BY TRUNC((EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM C.MEM_BIR)) / 10) * 10
        ORDER BY 1;

문제) 사원들 중 자기가 속한 부서의 평균급여보다 적은 급여를 받는 직원정보를 조회하시오.
     Alias는 사원번호, 사원명, 부서번호, 부서명, 급여, 부서평균급여
     제출일자 : 2021년 7월 31일까지
     제출방법 : 교사용 PC 공유폴더에 전송(SEM-PC D:\공유폴더\oracle\homework)
     문서타입 : 메모장에 저장된 TEXT문서
     문서이름 : 본인이름_0731.TXT
     SELECT TBLB.EMPLOYEE_ID AS 사원번호,
            TBLB.EMP_NAME AS 사원명,
            TBLA.DEPT_ID AS 부서번호,
            TBLA.DEPT_NAME AS 부서명,
            TBLB.SALARY AS 급여,
            TBLA.DEPT_AVG AS 부서평균급여
       FROM (SELECT A.DEPARTMENT_ID AS DEPT_ID,
                    A.DEPARTMENT_NAME AS DEPT_NAME,
                    ROUND(AVG(B.SALARY)) AS DEPT_AVG
               FROM HR.DEPARTMENTS A, HR.EMPLOYEES B
              WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
              GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME) TBLA,
            HR.EMPLOYEES TBLB
      WHERE TBLA.DEPT_ID = TBLB.DEPARTMENT_ID
        AND TBLB.SALARY < TBLA.DEPT_AVG
      ORDER BY 3;
      
  3. COUNT(column명|*)
   - 그룹내의 행의 수(자료의 개수)를 반환
   - 외부조인연산에 사용되는 경우 '*'를 사용하면 부정확한 결과를 반환하기 때문에 해당 테이블의 컬럼명을 기술해야 함
   -- '*'만 사용하면 NULL인 컬럼도 1로 나오지만, 컬럼명을 쓰면 NULL인 컬럼은 나오지 않음
   
사용예) 사원 테이블에서 각 부서별 사원수를 조회하시오.
       SELECT DEPARTMENT_ID AS 부서코드,
              COUNT(*) AS 사원수1,
              COUNT(LAST_NAME) AS 사원수2
         FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID
        ORDER BY 1;
        
       SELECT DEPARTMENT_ID AS 부서코드,
              COUNT(*) AS 사원수1,
              COUNT(LAST_NAME) AS 사원수2
         FROM HR.EMPLOYEES
        GROUP BY ROLLUP(DEPARTMENT_ID)
        ORDER BY 1;        
        
사용예) 2005년 5월 분류코드별 판매건수를 조회하시오.
       SELECT B.PROD_LGU AS 분류코드,
              COUNT(*) AS 판매건수
         FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_NO LIKE '200505%'
        GROUP BY B.PROD_LGU
        ORDER BY 1;
        
사용예) 2005년 5~6월 회원별 매입횟수를 조회하시오.
       Alias는 회원번호, 매입횟수
       SELECT A.CID AS 회원번호,
              COUNT(*) AS 매입건수
         FROM (SELECT DISTINCT CART_NO AS CNO,
                      CART_MEMBER AS CID
                 FROM CART
                WHERE SUBSTR(CART_NO, 1, 6) IN('200505', '200506')
                ORDER BY 2)A
        GROUP BY A.CID
        ORDER BY 1;
       
-- DB는 미래 확장성이 있는 형태로 설계되어야함

사용예) 모든 부서별 사원수를 조회하시오. (NULL 부서코드는 무시)
       SELECT B.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서명,
              COUNT(JOB_ID) AS 사원수
         FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
        WHERE A.DEPARTMENT_ID (+)= B.DEPARTMENT_ID
        GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
        ORDER BY 1;
        -- 외부조인을 할 때는 값이 많은 쪽을 사용해야함
        -- 값이 적을 쪽을 사용하면 NULL이 삽입됨
        -- 외부조인 연산자(+)는 값이 적은 쪽에 넣어줌
        -- 사원이 없는 부서에 사원수가 1이 조회된 이유는 NULL값이 들어가서, NULL들어간 COUNT(*)가 줄 수를 카운트해서 사원수가 1이 됨
        -- COUNT(*) 대신 COUNT(컬럼명)을 쓰면 사원이 없는 부서에 정상적으로 사원수가 0으로 조회됨
        -- B.DEPARTMENT_ID가 A.DEPARTMENT_ID보다 값이 많으므로 A.DEPARTMENT_ID에 (+)를 붙여줘서 B.DEPARTMENT_ID만큼 확장시켜줌
        COMMIT;
