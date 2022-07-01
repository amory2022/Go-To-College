create database go_to_colleg

use go_to_colleg

--importing the data from Kaggel

-----------------------------------------------------------------------------
--Data Exploration
select * 

from go_to_Colleg
----------------*****************______CLEANING DATA________**********************-----------------------

--Change A and B to very good and good in "school_accreditation" field.
select school_accreditation,
	case
		when school_accreditation='B'then 'good'
		when school_accreditation='A' then 'vrey good'
	end

from go_to_Colleg

update go_to_Colleg
set school_accreditation=
	case
		when school_accreditation='B'then 'good'
		when school_accreditation='A' then 'vrey good'
	end

-----------------------------------------------------------------------------------
-- Change 0 and 1 to Yes and No in "parent_was_in_college" and "in college" field.


--We cannot modify the column, so we will add another column.
alter table go_to_Colleg
add parent_was_in_college_2 nchar(5)


update go_to_Colleg
set parent_was_in_college_2=
	case
		when parent_was_in_college=0 then 'No'
		when parent_was_in_college=1 then 'Yes'
	end

alter table go_to_Colleg
add in_college_2 nchar(5)


update go_to_Colleg
set in_college_2=
	case
		when in_college=0 then 'No'
		when in_college=1 then 'Yes'
	end
---------------------------------------------------------------
--Delete Unused Columns.

select * 
from go_to_Colleg


alter table go_to_Colleg
drop column if exists parent_was_in_college,in_college


-----------------------------------------------------------------------------------------


-----------------__________********* DATA ANALYSIS__________****************----------------------


--Percentage of the type_school (academic) in the college.

 select  (count(type_school)) as total_Academic_students

 ,(select count(in_college_2) from go_to_Colleg 
 where in_college_2='Yes' and type_school='Academic' 
 group by type_school) as total_Academic_students_in_college

,(select CONVERT(decimal, count(in_college_2)) from go_to_Colleg where in_college_2='Yes' and type_school='Academic' group by type_school)/
(convert(decimal ,count(type_school)))*100 as precentg_of__Academic_school_in_college


 from go_to_Colleg

 where  type_school='Academic' 

 group by type_school

--Percentage of the type_school (Vocational) in the college.
 
 select  (count(type_school)) as total_Vocational_students

 ,(select count(in_college_2) from go_to_Colleg 
 where in_college_2='Yes' and type_school='Vocational' 
 group by type_school) as total_Vocational_students_in_college

,(select CONVERT(decimal, count(in_college_2)) from go_to_Colleg where in_college_2='Yes' and type_school='Vocational' group by type_school)/
(convert(decimal ,count(type_school)))*100 as precentg_of__Vocational_school_in_college


 from go_to_Colleg

 where  type_school='Vocational' 

 group by type_school
 ---------------------------------------------------------------------------------
--Number of each interested gender in college.

--The total number of males is 485.

select count(gender) as number_of_female,interest
from go_to_Colleg
where gender='female'
group by interest
order by number_of_female desc

--The total number of females is 515.
select count(gender) as number_of_male,interest
from go_to_Colleg
where gender='Male'
group by interest
order by number_of_male desc


------------------------------------------------------
--We see the total average scores for both males and females.


select gender,round(sum(average_grades),2) as total_average_grades

from go_to_Colleg
group by gender

-----------------------------------------------------------------------------
--The relationship of parents' salaries to students' studies.

--Metadata of parental salaries.
select MIN(parent_salary)  as minimum_salary ,max(parent_salary)as maximum_salary ,avg(parent_salary) as average_salary from go_to_Colleg

-- In Indonesian rupiah average salary is 5,200,000.

--The percentage of students who are in college and parents' salaries are more than the average.

select 
(COUNT(parent_salary)) as Salaries_are_above_average 
,(select COUNT(in_college_2)   from go_to_Colleg where in_college_2='Yes' and  parent_salary > 5200000)as number_of_students_in_college,

(select convert(decimal,COUNT(in_college_2))   from go_to_Colleg where in_college_2='Yes' and  parent_salary > 5200000)/
(convert(decimal,COUNT(parent_salary)))*100 as  Percentage_of_students_in_college

from go_to_Colleg 
where parent_salary > 5200000


--------------------------------------------------

--The difference between parents and students in education.

select (count(parent_was_in_college_2) ) as total_of_parent_was_in_college,
(select count(in_college_2) from go_to_Colleg where in_college_2='Yes') as total_of_student_in_college


from go_to_Colleg
where parent_was_in_college_2='Yes'
----------------------------------------------------------------

