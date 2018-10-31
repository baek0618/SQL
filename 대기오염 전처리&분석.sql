--대기정보 (ATMOSPHERE)

CREATE TABLE atmosphere
(day VARCHAR2(10), gu_name VARCHAR2(10), /*년월  ex) 201705*/
no2 number(10,4),  /*이산화질소*/
ozon NUMBER(10,4),  /*오존농도*/
co NUMBER(10,4),  /*일산화탄소*/
so2 NUMBER(10,4) ,  /*아황산가스*/
fine_dust NUMBER(10),  /*미세먼지*/
cho_fine_dust NUMBER(10)  /*초미세먼지*/ );--- 월별, 구별 평균 대기정보. 11120건

DELETE
FROM ATMOSPHERE
    WHERE SUBSTR(day,1,4) NOT IN ('2014','2015','2016');
--- 2014, 2015, 2016 년도를 제외한 데이터 삭제. 1426건

DELETE
	FROM ATMOSPHERE
    WHERE gu_name NOT LIKE '%구';--- gu_name이 ‘구’로 끝나는 데이터만 남기고 삭제. 901건

DELETE
	FROM ATMOSPHERE
    WHERE gu_name IS NULL OR day IS NULL;--- null값을 삭제. 900건


--시군구 지역코드 (loc)

CREATE TABLE loc
(gu_num NUMBER(10), gu_name VARCHAR2(20));   --- 전국 시군구번호, 이름 데이터. 284건

DELETE FROM loc
WHERE gu_num> 11740;--- 서울이 데이터만 남기고 삭제. 64건

DELETE FROM loc
WHERE gu_num IS NULL OR gu_name IS NULL OR gu_name NOT LIKE '%구';
--- null값과 비정상적 데이터 삭제. 25건


--감기 (cold)

CREATE TABLE cold2
(day VARCHAR2(10), gu_num NUMBER(10), cnt NUMBER(10));---전국 일별, 구별 감기 데이터. 276793건

DELETE FROM cold2
	WHERE gu_num> 11740;---서울 데이터만 남기고 삭제. 27401건

DELETE FROM cold2
	WHERE gu_num IS NULL OR day IS NULL OR cnt IS NULL;--- null값을 삭제. 27400건
(ORA-24344 에러 발생하므로 필수)

CREATE TABLE COLD
AS
SELECT substr(day,1,6) day, gu_num, SUM(cnt) cnt
	FROM cold2
    GROUP BY substr(day,1,6), gu_num;--- 월별, 구별 감기 데이터. 900건



--눈병 (eye)

CREATE TABLE eye2
(day VARCHAR2(10), gu_num NUMBER(10), cnt NUMBER(10));---전국 일별, 구별 눈병 데이터. 275800건

DELETE FROM eye2
	WHERE gu_num> 11740;---서울 데이터만 남기고 삭제. 27401건

DELETE FROM EYE2
	WHERE gu_num IS NULL OR day IS NULL OR cnt IS NULL; --- null값을 삭제. 27400건

CREATE TABLE eye
AS
SELECT substr(day,1,6) day, gu_num, SUM(cnt) cnt
	FROM eye2
    GROUP BY substr(day,1,6), gu_num;--- 월별, 구별 눈병 데이터. 900건



--천식 (asthma)

CREATE TABLE asthma2
(day VARCHAR2(10), gu_num NUMBER(10), cnt NUMBER(10));---전국 일별, 구별 감기 데이터.  275758건

DELETE FROM asthma2
	WHERE gu_num> 11740;---서울 데이터만 남기고 삭제. 27401건

DELETE FROM asthma2
	WHERE gu_num IS NULL OR day IS NULL OR cnt IS NULL;--- null값을 삭제. 27400건

CREATE TABLE asthma
AS
SELECT substr(day,1,6) day, gu_num, SUM(cnt) cnt
	FROM asthma2
    GROUP BY substr(day,1,6), gu_num;--- 월별, 구별 천식 데이터. 900건



--피부염 (dermatitis)

CREATE TABLE dermatitis2
(day VARCHAR2(10), gu_num NUMBER(10), cnt NUMBER(10));--- 전국 구별, 일별 피부염 데이터 276137건

DELETE FROM dermatitis2
	WHERE gu_num> 11740;    ---서울시 데이터만 남기고 삭제. 27401건

DELETE FROM dermatitis2
	WHERE gu_num IS NULL OR day IS NULL OR cnt IS NULL;--- null값을 삭제. 27400건

CREATE TABLE dermatitis
AS
SELECT substr(day,1,6) day, gu_num, SUM(cnt) cnt
	FROM dermatitis2
    GROUP BY substr(day,1,6), gu_num;--- 월별, 구별 피부염 데이터. 900건


--데이터 종합 (result)

CREATE TABLE result
AS
SELECT at.DAY, l.GU_NUM, l.GU_NAME, at.no2, at.OZON, at.co, at.SO2, at.FINE_DUST,
at.CHO_FINE_DUST, c.CNT "감기 건수", e.cnt "눈병 건수", a.cnt "천식 건수",
d.CNT "피부염 건수",
      NTILE(5) OVER (ORDER BY c.cntdesc) "감기 등급" , NTILE(5) OVER (ORDER BY e.cntdesc)
"눈병 등급" , NTILE(5) OVER (ORDER BY a.cntdesc) "천식 등급",
      NTILE(5) OVER (ORDER BY d.cntdesc) "피부병 등급" , NTILE(5) OVER (ORDER BY at.no2 desc)
"이산화질소 등급",  NTILE(5) OVER (ORDER BY at.ozon DESC) "오존 등급",
      NTILE(5) OVER (order BY at.co desc) "아황산가스 등급" , NTILE(5) OVER (ORDER BY at.so2)
"일산화탄소 등급", NTILE(5) OVER (ORDER BY at.fine_dust) "미세먼지 등급",
      NTILE(5) OVER (ORDER BY at.cho_fine_dust) "초미세먼지 등급", abs(NTILE(5) OVER
(ORDER BY c.cntdesc)-NTILE(5) OVER (ORDER BY at.no2 desc)) "감기-이산화질소",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)-NTILE(5) OVER (ORDER BY at.ozon DESC)) "감기-오존",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)- NTILE(5) OVER (ORDER BY at.co desc)) "감기-아황산가스",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)- NTILE(5) OVER (ORDER BY at.so2)) "감기-일산화탄소",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)- NTILE(5) OVER (ORDER BY at.fine_dust)) "감기-미세먼지",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)- NTILE(5) OVER (ORDER BY at.cho_fine_dust)) "감기-초미세먼지",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.no2 desc)) "눈병-이산화질소",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.ozon DESC)) "눈병-오존",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.co desc)) "눈병-아황산가스",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.so2)) "눈병-일산화탄소",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.fine_dust)) "눈병-미세먼지",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.cho_fine_dust)) "눈병-초미세먼지",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)- NTILE(5) OVER (ORDER BY at.no2 desc)) "천식-이산화질소",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)- NTILE(5) OVER (ORDER BY at.ozon DESC)) "천식-오존",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)-NTILE(5) OVER (order BY at.co desc)) "천식-아황산가스",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)- NTILE(5) OVER (ORDER BY at.so2)) "천식-일산화탄소",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)-  NTILE(5) OVER (ORDER BY at.fine_dust)) "천식-미세먼지",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)- NTILE(5) OVER (ORDER BY at.cho_fine_dust)) "천식-초미세먼지",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (ORDER BY at.no2 desc)) "피부병-이산화질소",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (ORDER BY at.ozon DESC)) "피부병-오존",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (order BY at.co desc)) "피부병-아황산가스",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (ORDER BY at.so2)) "피부병-일산화탄소",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (ORDER BY at.fine_dust)) "피부병-미세먼지",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)-NTILE(5) OVER (ORDER BY at.cho_fine_dust)) "피부병-초미세먼지"
    FROM ATMOSPHERE at, LOC l, COLD c, EYE e, asthma a, dermatitis d
    WHERE at.GU_NAME = l.GU_NAME
	AND c.GU_NUM = l.GU_NUM AND c.day = at.DAY
        AND e.GU_NUM = l.GU_NUM AND e.DAY = at.DAY
        AND a.gu_num = l.GU_NUM AND a.day = at.day
        AND d.GU_NUM = l.GU_NUM AND d.DAY = at.day
	ORDER BY at.day;


--대기오염~질병 연관관계 (result2)  [ abs( 질병건수등급 ? 오염등급 ) ]

CREATE TABLE result2
AS
SELECT ROUND(AVG("감기-이산화질소"),3)"감기-이산화질소", ROUND(AVG("감기-오존"),3)"감기-오존",
ROUND(AVG("감기-아황산가스"),3)"감기-아황산가스",ROUND(AVG("감기-일산화탄소"),3)"감기-일산화탄소",
ROUND(AVG("감기-미세먼지"),3)"감기-미세먼지", ROUND(AVG("감기-초미세먼지"),3)"감기-초미세먼지",
ROUND(AVG("눈병-이산화질소"),3)"눈병-이산화질소", ROUND(AVG("눈병-오존"),3)"눈병-오존",
ROUND(AVG("눈병-아황산가스"),3)"눈병-아황산가스",ROUND(AVG("눈병-일산화탄소"),3)"눈병-일산화탄소",
ROUND(AVG("눈병-미세먼지"),3)"눈병-미세먼지", ROUND(AVG("눈병-초미세먼지"),3)"눈병-초미세먼지",
ROUND(AVG("천식-이산화질소"),3)"천식-이산화질소", ROUND(AVG("천식-오존"),3)"천식-오존",
ROUND(AVG("천식-아황산가스"),3)"천식-아황산가스",ROUND(AVG("천식-일산화탄소"),3)"천식-일산화탄소",
ROUND(AVG("천식-미세먼지"),3)"천식-미세먼지", ROUND(AVG("천식-초미세먼지"),3)"천식-초미세먼지",
ROUND(AVG("피부병-이산화질소"),3)"피부병-이산화질소",ROUND(AVG("피부병-오존"),3)"피부병-오존",
ROUND(AVG("피부병-아황산가스"),3)"피부병-아황산가스",ROUND(AVG("피부병-일산화탄소"),3)"피부병-일산화탄소",
 ROUND(AVG("피부병-미세먼지"),3)"피부병-미세먼지", ROUND(AVG("피부병-초미세먼지"),3)"피부병-초미세먼지"
FROM result;



--1. 대기오염이 질병 발생 건수에 유의미한 영향을 미칠까?

--1.1 질병-대기오염 전체 연관도 순위 출력
SELECT item "질병-대기오염", cnt "연관도", RANK() OVER (ORDER BY cntasc) 순위
FROM result2
unpivot(cnt FOR item IN(
"감기-이산화질소","감기-오존","감기-아황산가스","감기-일산화탄소","감기-미세먼지","감기-초미세먼지",
"눈병-이산화질소","눈병-오존","눈병-아황산가스","눈병-일산화탄소","눈병-미세먼지","눈병-초미세먼지",
"천식-이산화질소","천식-오존","천식-아황산가스","천식-일산화탄소","천식-미세먼지","천식-초미세먼지",
"피부병-이산화질소","피부병-오존","피부병-아황산가스","피부병-일산화탄소","피부병-미세먼지","피부병-초미세먼지"));


--1.2 질병별 가장 영향을 끼치는 요인 2위까지 출력

SELECT substr("질병-대기오염",1,INSTR("질병-대기오염",'-')-1) "질병"
,substr("질병-대기오염",INSTR("질병-대기오염",'-')+1,length("질병-대기오염")) "대기오염", "연관 순위"
FROM(SELECT "질병-대기오염",RANK() OVER(PARTITION BY substr("질병-대기오염",1,INSTR("질병-대기오염",'-')-1) ORDER BY 연관도 ) "연관 순위"
	FROM (SELECT item "질병-대기오염", cnt "연관도", RANK() OVER (ORDER BY cntasc) 순위
FROM result2
unpivot(cnt FOR item IN(
"감기-이산화질소", "감기-오존", "감기-아황산가스", "감기-일산화탄소", "감기-미세먼지", "감기-초미세먼지",
"눈병-이산화질소", "눈병-오존", "눈병-아황산가스", "눈병-일산화탄소", "눈병-미세먼지", "눈병-초미세먼지",
"천식-이산화질소", "천식-오존", "천식-아황산가스", "천식-일산화탄소", "천식-미세먼지", "천식-초미세먼지",
"피부병-이산화질소", "피부병-오존", "피부병-아황산가스", "피부병-일산화탄소", "피부병-미세먼지", "피부병-초미세먼지"))))
WHERE "연관 순위" <= 2 ;



--2. 미세먼지가 많이 발생하는 달은 언제일까?

    SELECT SUBSTR(day,5,2)월, ROUND(AVG(fine_dust),2) "평균미세먼지",
           round((AVG(fine_dust)-NVL(LAG(AVG(fine_dust),1) OVER (ORDER BY SUBSTR(day,5,2)),47.28))/
           NVL(LAG(AVG(fine_dust),1) OVER (ORDER BY SUBSTR(day,5,2)),47.28)*100,2) "전월대비 상승률",
           RANK() OVER(ORDER BY ROUND(AVG(fine_dust),2) desc) 순위
       FROM result
       group BY SUBSTR(day,5,2)
       ORDER BY 월;




-- 문제1. 월,월별 감기 발생건수, 전월대비 상승률, 감기건수 순위를 출력 하시오.

  SELECT SUBSTR(day,5,2)월, ROUND(AVG("감기 건수"),2) "평균 감기건수",
       round((AVG("감기 건수") - NVL(LAG(AVG("감기 건수"),1) OVER (ORDER BY SUBSTR(day,5,2)),107540.05))
       /NVL(LAG(AVG("감기 건수"),1) OVER (ORDER BY SUBSTR(day,5,2)),107540.05),3)*100 "상승률",
       RANK() OVER(ORDER BY AVG("감기 건수") desc) 순위
           FROM result
           Group BY SUBSTR(day,5,2)
           ORDER BY 월;



