-- ���� ��� �Ǹ� ������ ���
select c.name, s
from (select custid, avg(saleprice)s
        from orders
        group by custid) o, customer c
where c.custid = o.custid;

-- ����ȣ�� 3������ ���� �� �Ǹűݾ��� �հ踦 ���
select SUM(saleprice) "total"
from Orders od
where exists (select *
                from Customer cs
                where custid <= 3 and cs.custid = od.custid);
                
select * from book;

-- å �̸��� �ظ����Ͷ�� �ܾ ���Ե� ������� ����Ͻÿ�
select * from book
where bookname like '%�ظ�����%';

create view v_book
as select * from book
where bookname like '%�ظ�����%';

-- �ּҿ��� �����̶�� �ܾ ���Ե� �並 �����Ͻÿ�
select * from customer
where address like '%����%';

create view vw_customer
as select * from customer
where address like '%����%';

select * from vw_customer;

-- �ֹ����̺��� ���̸�, �����̸��� �ٷ� Ȯ���� �� �ִ� �並 ������ ��
-- �迬�� ���� ������ ������ �ֹ���ȣ, ������, �ֹ��ݾ��� ����Ͻÿ�

create view vw_orders(orderid, name, bookid, custid, bookname, saleprice, orderdate)
as select o.orderid, c.name, o.bookid, o.custid, b.bookname, o.saleprice, o.orderdate
   from orders o, customer c, book b
   where o.custid = c.custid and o.bookid = b.bookid;
   
select * from vw_orders;

select orderid, bookname, saleprice 
from vw_orders
where name='�迬��';

-- ������ �並 �����Ѵ�
create or replace view vw_customer(custid, name, address)
as select custid, name, address
from customer
where address like '%����%';

select * from customer;

select * from vw_customer;

-- �� ����
drop view vw_customer;

--(1)�ǸŰ����� 5õ�� �̻��� ������ ������ȣ, �����̸�, ���̸�, ���ǻ�, �ǸŰ����� �����ִ� highorders �並 �����Ͻÿ�
create view highorders(bookid, bookname, name, publisher, saleprice)
as select o.bookid, b.bookname, c.name, b.publisher, o.saleprice 
from orders o, customer c, book b
where saleprice > 5000 and o.custid = c.custid and o.bookid = b.bookid;

select * from highorders;

--(2)������ �並 �̿��Ͽ� �Ǹŵ� ������ �̸��� ���� �̸��� ����ϴ� sql���� �ۼ��Ͻÿ�
select bookname, name from highorders;

--(3)highorders �並 �����ϰ��� �Ѵ�. �ǸŰ��� �Ӽ��� �����ϴ� ����� �����Ͻÿ�
--���� �� 2�� sql���� �ٽ� �����Ͻÿ�
create or replace view highorders(bookid, bookname, name, publisher)
as select o.bookid, b.bookname, c.name, b.publisher
from orders o, customer c, book b
where o.custid = c.custid and o.bookid = b.bookid;

select bookname, name from highorders;

-- �� ����
drop view vw_customer;

-- insertbook ���ν���
CREATE OR REPLACE PROCEDURE INSERTBOOK (
    myBookId in number,
    myBookName in varchar2,
    myPublisher in varchar2,
    myPrice in number)
AS 
BEGIN
  insert into book(bookid, bookname, publisher, price)
  values(myBookId, myBookName, myPublisher, myPrice);
END INSERTBOOK;

-- insertbook ���ν��� ����
exec insertbook(13, '����������', '������м���', 25000);

select * from book;

-- insertorupdate ���ν���
CREATE OR REPLACE PROCEDURE INSERTORUPDATE (
    myBookId in number,
    myBookName in varchar2,
    myPublisher in varchar2,
    myPrice int
)
AS 
    myCount number;
BEGIN
  select count(*) into myCount from book
  where bookname like myBookName;
  
  if myCount != 0 then
        update book set price = myPrice
        where bookname like myBookname;
  else
        insert into book(bookid, bookname, publisher, price)
        values(myBookId, myBookName, myPublisher, myPrice);
  end if;
END INSERTORUPDATE;

-- insertorupdate ����
exec insertorupdate(16, '��������ſ�', '������м���', 30000);

exec insertorupdate(16, '��������ſ�', '������м���', 20000);

-- avergageprice ���ν���
CREATE OR REPLACE PROCEDURE AVERAGEPRICE (
    averageVal out number)
AS 
BEGIN
  select avg(price) into averageVal from book
  where price is not null;
END AVERAGEPRICE;

-- avergageprice ����
set serveroutput on;
declare
    averageVal number;
begin
    averagePrice(averageVal);
    DBMS_OUTPUT.PUT_LINE('������� ����: '||averageVal);
end;