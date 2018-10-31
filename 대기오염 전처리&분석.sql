--������� (ATMOSPHERE)

CREATE TABLE atmosphere
(day VARCHAR2(10), gu_name VARCHAR2(10), /*���  ex) 201705*/
no2 number(10,4),  /*�̻�ȭ����*/
ozon NUMBER(10,4),  /*������*/
co NUMBER(10,4),  /*�ϻ�ȭź��*/
so2 NUMBER(10,4) ,  /*��Ȳ�갡��*/
fine_dust NUMBER(10),  /*�̼�����*/
cho_fine_dust NUMBER(10)  /*�ʹ̼�����*/ );--- ����, ���� ��� �������. 11120��

DELETE
FROM ATMOSPHERE
    WHERE SUBSTR(day,1,4) NOT IN ('2014','2015','2016');
--- 2014, 2015, 2016 �⵵�� ������ ������ ����. 1426��

DELETE
	FROM ATMOSPHERE
    WHERE gu_name NOT LIKE '%��';--- gu_name�� �������� ������ �����͸� ����� ����. 901��

DELETE
	FROM ATMOSPHERE
    WHERE gu_name IS NULL OR day IS NULL;--- null���� ����. 900��


--�ñ��� �����ڵ� (loc)

CREATE TABLE loc
(gu_num NUMBER(10), gu_name VARCHAR2(20));   --- ���� �ñ�����ȣ, �̸� ������. 284��

DELETE FROM loc
WHERE gu_num> 11740;--- ������ �����͸� ����� ����. 64��

DELETE FROM loc
WHERE gu_num IS NULL OR gu_name IS NULL OR gu_name NOT LIKE '%��';
--- null���� �������� ������ ����. 25��


--���� (cold)

CREATE TABLE cold2
(day VARCHAR2(10), gu_num NUMBER(10), cnt NUMBER(10));---���� �Ϻ�, ���� ���� ������. 276793��

DELETE FROM cold2
	WHERE gu_num> 11740;---���� �����͸� ����� ����. 27401��

DELETE FROM cold2
	WHERE gu_num IS NULL OR day IS NULL OR cnt IS NULL;--- null���� ����. 27400��
(ORA-24344 ���� �߻��ϹǷ� �ʼ�)

CREATE TABLE COLD
AS
SELECT substr(day,1,6) day, gu_num, SUM(cnt) cnt
	FROM cold2
    GROUP BY substr(day,1,6), gu_num;--- ����, ���� ���� ������. 900��



--���� (eye)

CREATE TABLE eye2
(day VARCHAR2(10), gu_num NUMBER(10), cnt NUMBER(10));---���� �Ϻ�, ���� ���� ������. 275800��

DELETE FROM eye2
	WHERE gu_num> 11740;---���� �����͸� ����� ����. 27401��

DELETE FROM EYE2
	WHERE gu_num IS NULL OR day IS NULL OR cnt IS NULL; --- null���� ����. 27400��

CREATE TABLE eye
AS
SELECT substr(day,1,6) day, gu_num, SUM(cnt) cnt
	FROM eye2
    GROUP BY substr(day,1,6), gu_num;--- ����, ���� ���� ������. 900��



--õ�� (asthma)

CREATE TABLE asthma2
(day VARCHAR2(10), gu_num NUMBER(10), cnt NUMBER(10));---���� �Ϻ�, ���� ���� ������.  275758��

DELETE FROM asthma2
	WHERE gu_num> 11740;---���� �����͸� ����� ����. 27401��

DELETE FROM asthma2
	WHERE gu_num IS NULL OR day IS NULL OR cnt IS NULL;--- null���� ����. 27400��

CREATE TABLE asthma
AS
SELECT substr(day,1,6) day, gu_num, SUM(cnt) cnt
	FROM asthma2
    GROUP BY substr(day,1,6), gu_num;--- ����, ���� õ�� ������. 900��



--�Ǻο� (dermatitis)

CREATE TABLE dermatitis2
(day VARCHAR2(10), gu_num NUMBER(10), cnt NUMBER(10));--- ���� ����, �Ϻ� �Ǻο� ������ 276137��

DELETE FROM dermatitis2
	WHERE gu_num> 11740;    ---����� �����͸� ����� ����. 27401��

DELETE FROM dermatitis2
	WHERE gu_num IS NULL OR day IS NULL OR cnt IS NULL;--- null���� ����. 27400��

CREATE TABLE dermatitis
AS
SELECT substr(day,1,6) day, gu_num, SUM(cnt) cnt
	FROM dermatitis2
    GROUP BY substr(day,1,6), gu_num;--- ����, ���� �Ǻο� ������. 900��


--������ ���� (result)

CREATE TABLE result
AS
SELECT at.DAY, l.GU_NUM, l.GU_NAME, at.no2, at.OZON, at.co, at.SO2, at.FINE_DUST,
at.CHO_FINE_DUST, c.CNT "���� �Ǽ�", e.cnt "���� �Ǽ�", a.cnt "õ�� �Ǽ�",
d.CNT "�Ǻο� �Ǽ�",
      NTILE(5) OVER (ORDER BY c.cntdesc) "���� ���" , NTILE(5) OVER (ORDER BY e.cntdesc)
"���� ���" , NTILE(5) OVER (ORDER BY a.cntdesc) "õ�� ���",
      NTILE(5) OVER (ORDER BY d.cntdesc) "�Ǻκ� ���" , NTILE(5) OVER (ORDER BY at.no2 desc)
"�̻�ȭ���� ���",  NTILE(5) OVER (ORDER BY at.ozon DESC) "���� ���",
      NTILE(5) OVER (order BY at.co desc) "��Ȳ�갡�� ���" , NTILE(5) OVER (ORDER BY at.so2)
"�ϻ�ȭź�� ���", NTILE(5) OVER (ORDER BY at.fine_dust) "�̼����� ���",
      NTILE(5) OVER (ORDER BY at.cho_fine_dust) "�ʹ̼����� ���", abs(NTILE(5) OVER
(ORDER BY c.cntdesc)-NTILE(5) OVER (ORDER BY at.no2 desc)) "����-�̻�ȭ����",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)-NTILE(5) OVER (ORDER BY at.ozon DESC)) "����-����",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)- NTILE(5) OVER (ORDER BY at.co desc)) "����-��Ȳ�갡��",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)- NTILE(5) OVER (ORDER BY at.so2)) "����-�ϻ�ȭź��",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)- NTILE(5) OVER (ORDER BY at.fine_dust)) "����-�̼�����",
      abs(NTILE(5) OVER (ORDER BY c.cntdesc)- NTILE(5) OVER (ORDER BY at.cho_fine_dust)) "����-�ʹ̼�����",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.no2 desc)) "����-�̻�ȭ����",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.ozon DESC)) "����-����",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.co desc)) "����-��Ȳ�갡��",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.so2)) "����-�ϻ�ȭź��",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.fine_dust)) "����-�̼�����",
      abs(NTILE(5) OVER (ORDER BY e.cntdesc)- NTILE(5) OVER (ORDER BY at.cho_fine_dust)) "����-�ʹ̼�����",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)- NTILE(5) OVER (ORDER BY at.no2 desc)) "õ��-�̻�ȭ����",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)- NTILE(5) OVER (ORDER BY at.ozon DESC)) "õ��-����",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)-NTILE(5) OVER (order BY at.co desc)) "õ��-��Ȳ�갡��",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)- NTILE(5) OVER (ORDER BY at.so2)) "õ��-�ϻ�ȭź��",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)-  NTILE(5) OVER (ORDER BY at.fine_dust)) "õ��-�̼�����",
      abs(NTILE(5) OVER (ORDER BY a.cntdesc)- NTILE(5) OVER (ORDER BY at.cho_fine_dust)) "õ��-�ʹ̼�����",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (ORDER BY at.no2 desc)) "�Ǻκ�-�̻�ȭ����",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (ORDER BY at.ozon DESC)) "�Ǻκ�-����",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (order BY at.co desc)) "�Ǻκ�-��Ȳ�갡��",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (ORDER BY at.so2)) "�Ǻκ�-�ϻ�ȭź��",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)- NTILE(5) OVER (ORDER BY at.fine_dust)) "�Ǻκ�-�̼�����",
      abs( NTILE(5) OVER (ORDER BY d.cntdesc)-NTILE(5) OVER (ORDER BY at.cho_fine_dust)) "�Ǻκ�-�ʹ̼�����"
    FROM ATMOSPHERE at, LOC l, COLD c, EYE e, asthma a, dermatitis d
    WHERE at.GU_NAME = l.GU_NAME
	AND c.GU_NUM = l.GU_NUM AND c.day = at.DAY
        AND e.GU_NUM = l.GU_NUM AND e.DAY = at.DAY
        AND a.gu_num = l.GU_NUM AND a.day = at.day
        AND d.GU_NUM = l.GU_NUM AND d.DAY = at.day
	ORDER BY at.day;


--������~���� �������� (result2)  [ abs( �����Ǽ���� ? ������� ) ]

CREATE TABLE result2
AS
SELECT ROUND(AVG("����-�̻�ȭ����"),3)"����-�̻�ȭ����", ROUND(AVG("����-����"),3)"����-����",
ROUND(AVG("����-��Ȳ�갡��"),3)"����-��Ȳ�갡��",ROUND(AVG("����-�ϻ�ȭź��"),3)"����-�ϻ�ȭź��",
ROUND(AVG("����-�̼�����"),3)"����-�̼�����", ROUND(AVG("����-�ʹ̼�����"),3)"����-�ʹ̼�����",
ROUND(AVG("����-�̻�ȭ����"),3)"����-�̻�ȭ����", ROUND(AVG("����-����"),3)"����-����",
ROUND(AVG("����-��Ȳ�갡��"),3)"����-��Ȳ�갡��",ROUND(AVG("����-�ϻ�ȭź��"),3)"����-�ϻ�ȭź��",
ROUND(AVG("����-�̼�����"),3)"����-�̼�����", ROUND(AVG("����-�ʹ̼�����"),3)"����-�ʹ̼�����",
ROUND(AVG("õ��-�̻�ȭ����"),3)"õ��-�̻�ȭ����", ROUND(AVG("õ��-����"),3)"õ��-����",
ROUND(AVG("õ��-��Ȳ�갡��"),3)"õ��-��Ȳ�갡��",ROUND(AVG("õ��-�ϻ�ȭź��"),3)"õ��-�ϻ�ȭź��",
ROUND(AVG("õ��-�̼�����"),3)"õ��-�̼�����", ROUND(AVG("õ��-�ʹ̼�����"),3)"õ��-�ʹ̼�����",
ROUND(AVG("�Ǻκ�-�̻�ȭ����"),3)"�Ǻκ�-�̻�ȭ����",ROUND(AVG("�Ǻκ�-����"),3)"�Ǻκ�-����",
ROUND(AVG("�Ǻκ�-��Ȳ�갡��"),3)"�Ǻκ�-��Ȳ�갡��",ROUND(AVG("�Ǻκ�-�ϻ�ȭź��"),3)"�Ǻκ�-�ϻ�ȭź��",
 ROUND(AVG("�Ǻκ�-�̼�����"),3)"�Ǻκ�-�̼�����", ROUND(AVG("�Ǻκ�-�ʹ̼�����"),3)"�Ǻκ�-�ʹ̼�����"
FROM result;



--1. �������� ���� �߻� �Ǽ��� ���ǹ��� ������ ��ĥ��?

--1.1 ����-������ ��ü ������ ���� ���
SELECT item "����-������", cnt "������", RANK() OVER (ORDER BY cntasc) ����
FROM result2
unpivot(cnt FOR item IN(
"����-�̻�ȭ����","����-����","����-��Ȳ�갡��","����-�ϻ�ȭź��","����-�̼�����","����-�ʹ̼�����",
"����-�̻�ȭ����","����-����","����-��Ȳ�갡��","����-�ϻ�ȭź��","����-�̼�����","����-�ʹ̼�����",
"õ��-�̻�ȭ����","õ��-����","õ��-��Ȳ�갡��","õ��-�ϻ�ȭź��","õ��-�̼�����","õ��-�ʹ̼�����",
"�Ǻκ�-�̻�ȭ����","�Ǻκ�-����","�Ǻκ�-��Ȳ�갡��","�Ǻκ�-�ϻ�ȭź��","�Ǻκ�-�̼�����","�Ǻκ�-�ʹ̼�����"));


--1.2 ������ ���� ������ ��ġ�� ���� 2������ ���

SELECT substr("����-������",1,INSTR("����-������",'-')-1) "����"
,substr("����-������",INSTR("����-������",'-')+1,length("����-������")) "������", "���� ����"
FROM(SELECT "����-������",RANK() OVER(PARTITION BY substr("����-������",1,INSTR("����-������",'-')-1) ORDER BY ������ ) "���� ����"
	FROM (SELECT item "����-������", cnt "������", RANK() OVER (ORDER BY cntasc) ����
FROM result2
unpivot(cnt FOR item IN(
"����-�̻�ȭ����", "����-����", "����-��Ȳ�갡��", "����-�ϻ�ȭź��", "����-�̼�����", "����-�ʹ̼�����",
"����-�̻�ȭ����", "����-����", "����-��Ȳ�갡��", "����-�ϻ�ȭź��", "����-�̼�����", "����-�ʹ̼�����",
"õ��-�̻�ȭ����", "õ��-����", "õ��-��Ȳ�갡��", "õ��-�ϻ�ȭź��", "õ��-�̼�����", "õ��-�ʹ̼�����",
"�Ǻκ�-�̻�ȭ����", "�Ǻκ�-����", "�Ǻκ�-��Ȳ�갡��", "�Ǻκ�-�ϻ�ȭź��", "�Ǻκ�-�̼�����", "�Ǻκ�-�ʹ̼�����"))))
WHERE "���� ����" <= 2 ;



--2. �̼������� ���� �߻��ϴ� ���� �����ϱ�?

    SELECT SUBSTR(day,5,2)��, ROUND(AVG(fine_dust),2) "��չ̼�����",
           round((AVG(fine_dust)-NVL(LAG(AVG(fine_dust),1) OVER (ORDER BY SUBSTR(day,5,2)),47.28))/
           NVL(LAG(AVG(fine_dust),1) OVER (ORDER BY SUBSTR(day,5,2)),47.28)*100,2) "������� ��·�",
           RANK() OVER(ORDER BY ROUND(AVG(fine_dust),2) desc) ����
       FROM result
       group BY SUBSTR(day,5,2)
       ORDER BY ��;




-- ����1. ��,���� ���� �߻��Ǽ�, ������� ��·�, ����Ǽ� ������ ��� �Ͻÿ�.

  SELECT SUBSTR(day,5,2)��, ROUND(AVG("���� �Ǽ�"),2) "��� ����Ǽ�",
       round((AVG("���� �Ǽ�") - NVL(LAG(AVG("���� �Ǽ�"),1) OVER (ORDER BY SUBSTR(day,5,2)),107540.05))
       /NVL(LAG(AVG("���� �Ǽ�"),1) OVER (ORDER BY SUBSTR(day,5,2)),107540.05),3)*100 "��·�",
       RANK() OVER(ORDER BY AVG("���� �Ǽ�") desc) ����
           FROM result
           Group BY SUBSTR(day,5,2)
           ORDER BY ��;



