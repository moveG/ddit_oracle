2021-0709-02)
  (4) LIKE 연산자
    . 패턴을 비교할 때 사용
    . 문자열만 비교할 때 사용
    . 와일드카드로 '%'와 '_'가 사용되어 패턴 문자열을 구성
    . '%' : '%'이 사용된 위치 이후의 모든 문자열과 대응
      EX) '대전%' : '대전'으로 시작되는 모든 단어와 대응
          '대%시' : 첫 글자가 '대'이고 마지막 글자가 '시'인 모든 단어와 대응
          '%다'   : 끝 글자가 '다'인 모든 단어와 대응
          
사용예) 회원테이블에서 대전에 거주하는 회원들을 조회하시오.
       Alias는 회원번호, 회원명, 주소, 직업, 마일리지이다.
       SELECT MEM_ID AS 회원번호,
              MEM_NAME AS 회원명,
              MEM_ADD1||' '||MEM_ADD2 AS 주소,
              MEM_JOB AS 직업,
              MEM_MILEAGE AS 마일리지
         FROM MEMBER
        WHERE MEM_ADD1 LIKE '대전%';
        
문제) 장바구니테이블에서 2005년 7월 판매현황을 조회하시오.
      Alias는 일자, 상품코드, 판매수량이다.
      (LIKE 연산자 사용)
      SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS 일자,
             CART_PROD AS 상품코드,
             CART_QTY AS 판매수량
        FROM CART
       WHERE CART_NO LIKE '200507%';
      -- TO_DATE() 함수: 문자열을 날짜로 변환함
      -- SUBSTR 함수: 문자열을 추출함
      -- 6월, 7월 판매현황은 LIKE 함수로는 구할 수 없음
      -- 데이터양이 많은 경우 LIKE 함수를 사용하면 출력되는 값이 너무 많아 느려지는 경우가 많으므로 사용을 자제하는 편이 좋음
      
      (BETWEEN 연산자 사용)
      SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS 일자,
             CART_PROD AS 상품코드,
             CART_QTY AS 판매수량
        FROM CART
       WHERE SUBSTR(CART_NO,1,6) BETWEEN TO_NUMBER('200506') AND TO_NUMBER('200507');
      -- SUBSTR과 BETWEEN을 사용했을때는 BETWEEN에 %는 사용 안됨 EX) BETWEEN TO_NUMBER('200506%') AND ~ (X)
       
 COMMIT;     