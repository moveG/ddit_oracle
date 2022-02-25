2021-0716-01)
  4. 변환함수
   - 특정시점에서 다른 타입으로 일시적으로 형변환 -- 그 특정시점이 지나면 다시 원래 타입으로 돌아감
   - TO_CHAR, TO_DATE, TO_NUMBER, CAST -- 뒤로 갈수록 사용 빈도수가 낮아짐
   1) CAST(expr AS 타입)
    - 'expr'로 정의된 자료를 '타입'형태로 일시적으로 형변환

사용예)
       SELECT MEM_NAME AS 회원명,
              CAST(SUBSTR(MEM_REGNO1, 1, 2) AS NUMBER) + 1900 AS 출생년도,
              EXTRACT(YEAR FROM SYSDATE) - (CAST(SUBSTR(MEM_REGNO1, 1, 2) AS NUMBER) + 1900) AS 나이
         FROM MEMBER
        WHERE NOT MEM_REGNO1 LIKE '0%';
        -- CAST로 MEM_REGNO1의 값을 일시적으로 NUMBER로 형변환
        
   2) TO_CHAR(expr[, fmt])
    - 주어진 자료 'expr'을 형식 지정 문자열 'fmt'에 맞추어 문자열로 변형하여 반환
    - 'expr'은 숫자, 날짜, 문자열(CHAR, CLOB => VARCHAR2로) 타입의 자료
    - 영구적 형변환
    -- VARCHAR2를 VARCHAR2로 형변환하는 것은 허용되지 않음
    -- 함수는 그것이 호출된 위치에 반환값을 주기 때문에 SELECT절, WHERE절, 단독으로 사용 가능
    -- 프로시저는 반환값이 없어 SELECT절, WHERE절에 사용할 수 없고, 독립해서 호출하는 방식으로 사용 가능
    -- ""(쌍따옴표)는 컬럼의 별칭, 사용자가 직접 정의한 문자열에 사용함
    -- ''(따옴표) 안에 전부 넣어줘야함
    -- RM은 로마자 형식
    -- DD 오늘 일수, DDD는 1월 1일부터 기산된 일수, J는 기원전 4XXX년 전부터 기산된 일수
    -- D는 일요일부터 기산한 요일의 인덱스
    -- AM/PM은 오전/오후를 구분하는 용도 쓰임, AM/PM으로 고정하지 않음
    -- expr: EXPRESSION(표현), fmt: FORMAT(포맷)

    - 날짜형식지정문자열
    ----------------------------------------------------------------------------------------------------
    형식지정 문자열              의미            사용예
    ----------------------------------------------------------------------------------------------------
    CC                        세기            SELECT TO_CHAR(SYSDATE, 'CC') FROM DUAL;
    AC, BC                    서기            SELECT TO_CHAR(SYSDATE, 'CC BC YYYY"년"') FROM DUAL;
    YYYY, YYY, YY, Y          년도            SELECT TO_CHAR(SYSDATE, 'CC BC YY"년"') FROM DUAL;
    Q                         분기            SELECT TO_CHAR(SYSDATE, 'CC BC YYYY"년" Q"분기"') FROM DUAL;
    MONTH, MON                개월            SELECT TO_CHAR(SYSDATE, 'YYYY MON MONTH') FROM DUAL;
    MM, RM                    개월
    W, WW, WWW                주차
    DD, DDD, J                일수            SELECT TO_CHAR(SYSDATE, 'YYYY MON DD DDD J') FROM DUAL;
    DAY, DY, D                요일            SELECT TO_CHAR(SYSDATE, 'YYYY DAY DY D') FROM DUAL;
    AM, PM, A.M., P.M.        오전/오후
    MI                        분
    SS, SSSSS                 초
    "문자열"                   직접 정의한 사용자 변환 문자열
    ----------------------------------------------------------------------------------------------------
    
    - 숫자형식지정문자열
    ----------------------------------------------------------------------------------------------------
    형식지정 문자열     의미                                  사용예
    ----------------------------------------------------------------------------------------------------
    9                숫자와 대응되어 유효숫자는 유효숫자를       SELECT TO_CHAR(2345, '99,999') FROM DUAL;
                     출력하고 무효의 0은 공백처리
    0                숫자와 대응되어 유효숫자는 유효숫자를       SELECT TO_CHAR(2345, '00,000') FROM DUAL;
                     출력하고 무효의 0은 0을 출력
    $, L             화폐기호를 출력                         SELECT TO_CHAR(12345, 'L99,999') FROM DUAL;
    PR               음수를 '< >'로 묶어서 출력               SELECT TO_CHAR(-12345, '99,999PR') FROM DUAL;
    ,(COMMA)         자리점
    .(DOT)           소수점
    X                16진수로 변환하여 출력                   SELECT TO_CHAR(255, 'XXXX') FROM DUAL;
    ----------------------------------------------------------------------------------------------------   
    -- 9를 사용하면 결과값이 공백2,345가 출력됨
    -- 0을 사용하면 결과값이 02,456가 출력됨
    -- 달러는 $를, 나머지 화폐는 L(LOCATOR) 화폐기호를 사용함
    -- 자리수를 맞출 필요가 있을 경우 0을 많이 사용함
    -- PR을 사용하면 -12345를 <12,345>로 출력함
    -- X를 사용하면 10진수 255를 16진수인 공백공백FF로 변환하여 출력함
    -- XXXX는 4자리의 16진수로 출력하라는 뜻임
    -- 형변환 후 숫자를 더해주거나 빼면 오류가 발생함, 이미 형변환 되어 숫자가 아니기 때문
   
   3) TO_NUMBER(expr[, fmt])
    - 주어진 자료 'expr'의 값을 'fmt' 형식에 맞추어 숫자로 변환
    - 'expr'은 문자열 타입의 자료
    - 'fmt'는 모두 적용되지는 않음(숫자로 형변환 가능한 형식만 적용 가능)
    - 영구적 형변환
    -- ,(COMMA, 자리수)는 대표적으로 적용 불가능한 예시
    -- .(DOT, 소수점)은 적용 가능
    
사용예) 
       SELECT TO_NUMBER('12345', '9999900')   -- 0012345로 변환되지만 숫자에서 앞의 00은 불필요하므로 제거됨
           -- ,TO_NUMBER('12345', '99,999')   -- ,(COMMA, 자리수)는 대표적으로 형변환 불가능한 예시
           -- ,TO_NUMBER('-12345', '99999PR') -- 음의 정수이므로 '< >'로 묶이기 때문에 숫자로 변환 불가능
              ,TO_NUMBER('12345', '99999PR')  --양의 정수이므로 PR이어도 '< >'로 묶이지 않으므로 숫자로 변환 가능
              ,TO_NUMBER('12345')
         FROM DUAL;
         
   4) TO_DATE(expr[, fmt])
    - 주어진 자료 'expr'의 값을 'fmt' 형식에 맞추어 날짜로 변환
    - 'expr'은 문자열 타입의 자료
    - 'fmt'는 모두 적용되지는 않음(날짜로 형변환 가능한 형식만 적용 가능)
    - 원본자료가 날짜형식에 맞도록 제공되어야 함
    - 영구적 형변환
    
사용예) 
       SELECT TO_DATE('20200320', 'YYYYMMDD')
              ,TO_DATE('20200320', 'YYYY/MM/DD')
              ,TO_DATE('20200320', 'YYYY MM DD') 
              ,TO_DATE('20200320', 'YYYY-MM-DD') -- '공백', '-'을 사용해도 기본타입 '/'로 출력됨
              ,TO_DATE('20200320', 'YYYY MM-DD') -- '공백', '-', '/'를 섞어 사용해도 '/'로 출력됨
           -- ,TO_DATE('20200332', 'YYYY MM DD') -- 3월에는 32일이 없으므로 출력이 불가능함
           -- ,TO_DATE('20200320', 'AM YYYYMMDD')
           -- ,TO_DATE('20200320', 'YYYY MONTH DD')
              ,TO_DATE('20200320')
         FROM DUAL;         
         
         COMMIT;
         