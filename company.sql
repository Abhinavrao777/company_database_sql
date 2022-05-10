use company;

select *
from 
	employee;  

select *
from 
	employee
where 
	sex = 'M' and salary >= 30000;


select * 
from
	employee;

select *
from 
	employee
where 
	sex = 'M' or salary >= 30000;

select *
from
	employee
where  
	not  salary  >= 30000 and sex = 'M';                                                                 


select * 
from 
	employee
where 
	super_ssn is null;


select count(*) 
from
	employee 
where 
	super_ssn is null;

select ssn,
	salary,
	dno
from 
	employee
where
	dno = 5
order by
	salary asc;

select ssn, 
	salary,
    dno
from 
	employee
where 
	dno = 5
order by 
	salary asc limit 3;

select * 
from 
    employee;

select count(*)
 from 
	employee;

select dno,
	count(*) as 'Number of employees'
from 
	employee
group by
	dno;


select dno,
	fname ,
    count(*) as 'Number of employees'
from 
	employee
group by 
	dno 
order by
	dno;

select fname
from 
	employee
where 
	dno = (select Dnumber from department where dname = 'Research')
order by 
	fname;

select * from department;

select * from employee;

select dname, 
	avg(salary) 
from 
	employee 
	inner join 
		department on dno=dnumber 
where 
	salary >= 30000 
group by 
	dname 
order by 
	dname;                         
 
select dname, 
	avg(salary) 
from
	employee 
	inner join 
		department on dno=dnumber 
where 
	salary >= 30000 
order by
	dname; 



###JOINS

use company;

select * from employee;

select * from project;

select pname,
	fname 
from 
	employee
    inner join  
		project on dno=dnum
order by 
	pname;

select pname,
	avg(salary) as "avg_salary" 
from 
	employee 
	inner join  
		project on dno=dnum
group by 
	pname
order by
	pname;

select pname,
	avg(salary) as "avg_salary" 
from 
	employee 
    inner join 
		project on dno=dnum
group by
	pname
order by 
	pname asc;




select dname,
	avg(salary) 
from 
	employee 
	inner join
	department on dno=dnumber
group by 
	dname;
                        
select dname,
	fname ,
    lname,
    dno
from 
	employee 
	inner join 
		department on dno=dnumber;
     



select dname,
	avg(salary) 
from 
	employee 
	inner join 
		department on dno=dnumber
group by
	dname
having 
	avg(salary)>31000
order by
	avg(salary);

select dname, 
	avg(salary) 
from 
	employee 
	inner join 
		department on dno=dnumber 
where 
	salary >= 30000  #it will filter out the rows first then average
group by 
	dname
order by
	dname;



select ssn,
	dno,
    salary,
    Pno  
from 
	employee
	inner join 
		works_on on  employee.ssn=works_on.essn
    inner join 
		project on works_on.Pno=project.Pnumber;


select ssn,
	dno,
    salary,
    Pno  
from 
	employee
	inner join 
		works_on on  employee.ssn=works_on.essn
    inner join 
		project on works_on.Pno=project.Pnumber
where 
	dno=4;

### CREATING VIEWS


select * 
from
	employee;

select * 
from 
	department;

##creating views 

create view employee_info 
as 
select 
ssn,
salary
,minit
,dno,
mgr_start_date
from 
	employee 
    inner join 
		department on dno=dnumber;

select * from employee_info;

update employee_info set salary=50000 where ssn=333445555;

select * from employee;


update employee_info set salary=40000 where ssn=333445555;  


###creating view using some string function

select * from employee;

 create view employee_info1 
 as
 select concat(fname, ' ' , lname) as name ,
	ssn,
	dno
 from
	employee;
 
 select * from  employee_info1;
 
 select name as original_name,
	substring_index(name," ",1) as fname
 from 
	employee_info1;
 
 update employee_info1 set name="Abhinav Rao" where ssn=123456789; # column "name" is not updatable
 
  update employee_info1 set  ssn="123456788" where name="John Smith"; #since ssn is primary key we cannot update it
  
 select * 
 from  
	employee_info1;

## extract date, month and year 

select bdate,
	extract(year from bdate) as year,
	extract(month from bdate) as month,
	extract(day from bdate) as day
from 
	employee;


###

create view employee_info3
as 
select ssn,
	salary,
    minit,
    dno,
    mgr_start_date
from 
	employee 
	inner join 
		department on dno=dnumber;


select * from employee_info;   

select * from employee_info3;


##use company database
## OVER


use company;

select * from employee;

#'group by' clause is that it leads to a reduction in the number of rows. It also leads to the loss of the individual properties of the various rows.
 
#NOTE----#to overcome we gonna use OVER function instead of group by;



##eg1

select concat(fname," ",lname) as emp_name,
	dno,
    salary as individual_salary,
	sum(salary) over() as total_salary,
	sum(salary) over(partition by dno) as dno_total_salary   #partition by dno
from 
	employee;   

select * from employee;

##eg2

select concat(fname," ",lname) as emp_name,
	dno,
    salary as individual_salary,
	sum(salary) over() as total_salary,
	sum(salary) over(partition by sex) as gender_total_salary  #partition by sex
from 
	employee;   

##eg3


select count(distinct(dno)) from employee;

select concat(fname," ",lname) as emp_name,
	dno,
	salary as individual_salary,
	count(dno) over() as total_distinct_department 
from 
	employee;


##eg4

select concat(fname," ",lname) as emp_name,
	dno,
    salary as individual_salary,
	count(dno) over() as total_distinct_department ,
	count(dno) over(partition by super_ssn) as super_ssn_department
from 
	employee;



##eg5

 #FRAMES
#the concept of frames and how frames move while a query is executed
#The following query demonstrates the use of moving frames to compute running totals within each department. 
#Similar queries can be used to determine rolling averages computed from the current row and the rows that immediately precede and follow it.



select concat(fname," ",lname) as fullname,
	ssn,
    salary,
    dno,
	sum(salary) over(partition by dno order by ssn rows  unbounded preceding) as commulative_total,
	sum(salary) over(partition by dno order by ssn rows between  1 preceding and 1 following) as one_above_and_one_below
from
	employee;


select 
	ssn, 
	concat(fname, ' ', lname) as emp_name, 
    dno, 
    salary,
	first_value(salary) over (partition by dno order by ssn rows unbounded preceding) as first_val,  
	nth_value(salary,2) over (partition by dno order by ssn rows unbounded preceding) as second_val
from
	employee;
    
    
select ssn,
	concat(fname, ' ', lname) as emp_name, 
    dno, 
    salary,
	first_value(salary) over (partition by dno order by ssn rows  unbounded preceding) as first_val,  
	nth_value(salary,2) over (partition by dno order by ssn rows between 1  preceding and 1 following ) as second_val
from 
	employee;
    
    
select ssn,
	concat(fname, ' ', lname) as emp_name,
    dno, 
    salary,
	first_value(salary) over (partition by dno order by ssn rows  unbounded preceding) as first_val,  
	nth_value(salary,3) over (partition by dno order by ssn rows unbounded preceding) as second_val
from
	employee;
    
select ssn, 
	salary,
	row_number()     over (order by salary ) as 'row_number',
	rank()           over (order by salary ) as 'rank',
	dense_rank()     over (order by salary ) as 'dense_rank'
from 
	employee;


select ssn, 
	salary,
	row_number()     over (order by ssn desc) as 'row_number',
	rank()           over (order by ssn desc ) as 'rank',
	dense_rank()     over (order by ssn desc ) as 'dense_rank'
from
	employee;


###using window clause



## eg 2 of window clause

select concat(fname," ",lname) as emp_name,
	dno,
	salary as individual_salary,
	sum(salary) over()  as total_salary,
	sum(salary) over a  as dno_total_salary from employee 
    
		window a as (partition by dno);   ## defining window function
        #partition by dno
        


#USER DEFINED FUNCTION 
/*
There are numerous operations that you may want to repeat multiple times in a piece of code, which unfortunately don’t have an inbuilt function.
 This is where we have to use a User-defined function
*/


#eg1 #advanced use of UDF


use company;

delimiter $$


create function project_pay_calc( pno int, num_of_hours float(4,2))
returns float(8,2) deterministic
begin
declare project_pay_per_hour float(8,2);

if (pno > 0 and pno <=5 ) then
set project_pay_per_hour = 1000;

elseif (pno > 5 and pno <= 10) then
set project_pay_per_hour = 2000;

else
set project_pay_per_hour = 3000;

end if;
return (project_pay_per_hour * num_of_hours);
end

$$
delimiter ;
desc department;


desc works_on;

select essn, 
	pno,
    hours,
	project_pay_calc(pno, hours) as total_project_pay
from 
	works_on;


##eg2

select * from employee; 

delimiter $$
create function grade(salary float)
returns char(50) deterministic
begin
declare grade_info char default null;

if salary >= 40000 
	then set grade_info="A";
elseif salary>30000 and salary<40000
	then  set grade_info = "B";
else  
	set grade_info="C";

end if;
return (grade_info);
end $$
delimiter ;

select fname,
	ssn,
    sex,
    dno,
    grade(salary) 
from 
	employee;
    


#stored procedure
/*
A stored procedure is a collection of SQL statements and SQL command logic which is compiled and stored in a database.
They are typically made to encapsulate complex and frequently utilized business logic.

*/

#creating a stored procedure
delimiter $$
create procedure  employee_details (in n char(9))
begin 
select * from employee where ssn=n;
end 
$$
delimiter ;

#calling procedure
call employee_details(123456789);
call employee_details(0);
call employee_details();  #error atleast one argument

#eg2
 c
 
 delimiter ##

create procedure dependent_info(in n char(20))
begin 
select * from dependent  where n = relationship;
end
##
delimiter ;

 call  dependent_info("son");
 
 
#eg3

select * from employee;

 delimiter ##

create procedure salary_info(out records int)
begin 
select sum(salary) into records from employee  where sex = "M" group by dno;
end
##
delimiter ;

call salary_info(@record);  #result consist of more than one row thus can't excute

#eg5 of 3

delimiter ##
create procedure salary_info1(out records int)
begin 
select sum(salary) into records from employee  where sex = "M";
end
##
delimiter ;

call salary_info1(@record);

select @record;

##CONDITIONAL STATEMENT


#eg1
use company;

select * from employee;
## grade A -- salary is greater than 40000
## grade B -- salary is less than 40000

delimiter $$
create procedure grade_result(out grade character(20), in id int)
begin 
declare salary_emp int default 0;
select salary into salary_emp from employee where ssn=id;
if salary_emp>40000 then set grade="A";
else  set grade="B";
end if ;
END $$
delimiter ;

call grade_result(@grade,123456789);

select @grade;

#eg2

delimiter $$
create procedure grade_result2(out grade character(20), in id int)
begin 
declare salary_emp int default 0;
select salary into salary_emp from employee where ssn=id;
if salary_emp>40000 then set grade="A";
else  set grade="B";
end if ;
select @grade;
END $$
delimiter ;


call grade_result2(@grade,123456789);



##CASE STATEMENT

##eg1

delimiter $$
create procedure grade_result5(out grade character(20), in id int)
begin 
declare salary_emp int default 0;
select salary into salary_emp from employee where ssn=id;

case salary_emp
when 55000
then set grade ="A";

when 44000
then set grade="B";

else
set grade="C";
END case;
end $$
delimiter ;

call grade_result5(@grade,33445555);

select @grade;


#eg2

delimiter $$
create procedure grade_result6(out grade character(20), in id int)
begin 
declare salary_emp int default 0;
select salary into salary_emp from employee where ssn=id;

case salary_emp
when 55000
then set grade ="A";

when 44000
then set grade="B";

else
set grade="C";
END case;
select @grade;
end $$
delimiter ;

call grade_result6(@grade,33445555);













