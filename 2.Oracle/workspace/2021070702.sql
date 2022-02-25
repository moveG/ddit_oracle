2021-0707-02) Query문
 - 자료 검색(조회) 명령
 - SELECT 문
 - 가장 많이 사용되는 SQL 문
 (사용형식)
 SELECT [DISTINCT] 컬럼명 [AS]["][별칭]["][,]
                         :
                   컬럼명 [AS]["][별칭]["] --마지막에는 ,(콤마)를 붙이지 않는다
   FROM 테이블명 [별칭]
 [WHERE 조건]
 [GROUP BY 컬럼명[,컬럼명,...]]
[HAVING 조건]
 [ORDER BY 컬럼명|컬럼인덱스[ASC|DESC]][]]
         [,컬럼명|컬럼인덱스[ASC|DESC],...]];
         
 -- SELECT 절과 FROM 절은 반드시 포함되어야 함, 나머지 절은 생략 가능함
 -- DISTINCT: 중복을 배제하기 위한 명령어
 -- SELECT 절: 열을 표시
 -- FROM 절: 테이블을 선언할 때 사용, 
 -- DUAL TABLE: 간단하게 함수를 이용해서 계산 결과값을 확인할 때 사용하는 테이블
 -- WHERE 절: 행을 결정, 조건을 기술, 보통 연산자가 온다, 문자나 날씨 데이터는 ''(따옴표) 사용
 -- GROUP BY: 그룹을 묶을 때 사용
 -- HAVING: 그룹화된 데이터에 적용할 조건 명시
 -- ORDER BY: 크기 순으로 정렬 ASC는 오름차순, DESC는 내림차순
 -- AS, "", 별칭 생략 가능
 -- 별칭에 명령문, 특수문자(공백 포함)를 사용하는 경우, ""(쌍따옴표) 반드시 사용
 -- ,(콤마)는 마지막에 안 찍음
 -- 오라클은 대소문자 구분 안함, 그러나 테이블에 저장된 데이터 값에서는 구분함
 -- SELECT문 실행순서: FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY
 -- SELECT문 실핸순서: FROM, WHERE, SELECT
 
  COMMIT;