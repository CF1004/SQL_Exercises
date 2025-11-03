# SQL Exercises & Answers

A compact collection of **41 SQL exercises** (questions + answers) I completed for the *Hospital Admissions Database (2020)*.  
This set demonstrates practical, real-world SQL skills: selection & filtering, joins, aggregation, subqueries, simple ETL logic, troubleshooting and query refinement. All queries are written in T-SQL (SQL Server) style.

---

## ⚙️ Tools & Prerequisites
- **SQL / T-SQL (SQL Server)** — queries use `DATEDIFF`, `GETDATE()`, `FORMAT()` and T-SQL idioms.  
- **Database:** This README assumes the `Hospital Admissions 2020` schema and sample data exist (tables like `staff`, `dept`, `expenses`, `patient`, `rooms`, `patient_rooms`, etc.).  
- If you want the schema / sample data or a runnable `.bak` / `.sql`, I can add it to the repo.

---

## Exercises & Answers

### Exercise 1 — Show all the staff who have a salary equal to 25000. List their first name and last name.
```sql
select fname as 'First Name', lname as 'Last Name', Salary as 'Salary'
from staff
where salary = 25000;
```
### Exercise 2 — Show all the staff who have a salary greater than 40k, list their first and last names as NAME
```sql
select (fname + ' ' + lname) as 'Name', Salary as 'Salary'
from staff
where salary > 40000;
```
### Exercise 3 — Identify all staff who do not have a salary equal to 25k.
```sql
select (fname + ' ' + lname) as 'Name', Salary as 'Salary'
from staff
where salary != 25000;
```
### Exercise 4 — Identify all staff who have a salary less than 60k.
```sql
select (fname + ' ' + lname) as 'Name', cast(Salary as int) as 'Salary'
from staff
where salary < 60000;
```
### Exercise 5 — Identify all staff who have a salary between 40k and 60k
```sql
select (fname + ' ' + lname) as 'Name', cast(Salary as int) as 'Salary'
from staff
where salary between 40000 and 60000;
```
### Exercise 6 — Identify all staff who have a salary of either 25k or 20k.
```sql
select (fname + ' ' + lname) as 'Name', cast(Salary as int) as 'Salary'
from staff
where salary = 25000 or salary = 20000;
```
### Exercise 7 — How many employees are there?
```sql
select COUNT(staff_id) as 'Number of Employees'
from staff;
```
### Exercise 8 — What is the max salary?
```sql
select MAX(salary) as 'Maximum Salary'
from staff;

select (fname + ' ' + lname) as 'Name', Salary as 'Maximum Salary'
from staff
where salary = (select MAX(salary) from staff);

select * from staff;
```
### Exercise 9 — What is the min salary?
```sql
select (fname + ' ' + lname) as 'Name', cast(Salary as int) as 'Minimum Salary'
from staff
where salary = (select MIN(salary) from staff);
```
### Exercise 10 — What is the average salary?
```sql
select AVG(cast(salary as int)) as 'Average Salary in this Building'
from staff;
```
### Exercise 11 — Who has the max salary? List the first and last names as NAME
```sql
select (fname + ' ' + lname) as 'Name', cast(Salary as int) as 'Maximum Salary'
from staff
where salary = (select MAX(salary) from staff);
```
Exercise 12 — Who has the min salary? List the first and last names as NAME and their city and county as ADDRESS.
```sql
select (staff.fname + ' ' + staff.lname) as 'NAME',
       (city.city_desc + ' ' + county.county_desc) as 'ADDRESS',
       CAST(Salary as int) as 'SALARY'
from staff
inner join staff_add
  on staff.staff_id = staff_add.staff_id
inner join county
  on county.co_id = staff_add.co_id
inner join city
  on city.city_id = staff_add.city_id
where salary = (select MIN(salary) from staff);
```
### Exercise 13 — Who is in the Accident and Emergency Department? List the first name, last name, department name.
```sql
select staff.fname as 'First Name', staff.lname as 'Last Name', dept.dname
from staff
inner join dept
  on staff.dept_id = dept.dept_id
where dept.dname = 'Accident and Emergency';
```
### Exercise 14 — Who in the General Medical department earns more than 50k? List the first name, last name, department name and salary.
```sql
select staff.fname as 'First Name', staff.lname as 'Last Name', dept.dname, cast(staff.salary as int) as 'Salary'
from staff
inner join dept
  on staff.dept_id = dept.dept_id
where dept.dname = 'General Medical Department' and salary > 50000;
```
### Exercise 15 — Who is born before 01.01.1970 in the general medical department? Name, department name and age.
```sql
select (staff.fname + ' ' + staff.lname) as 'Name',
       dept.dname as 'Department Name',
       DATEDIFF(year, staff.DOB, GETDATE()) as 'Age',
       staff.DOB
from staff
inner join dept
  on staff.dept_id = dept.dept_id
where DOB < '1970-01-01' and dept.dname = 'General Medical Department';
```
OR
```sql
select (staff.fname + ' ' + staff.lname) as 'Name', dept.dname as 'Department Name', staff.DOB,
(year (getdate())-year(dob)) as 'Age'
from staff
inner join dept
on staff.dept_id = dept.dept_id
where DOB < '1970-01-01' and dept.dname = 'General Medical Department';
```
### Exercise 16 — Who does not work in the General Medical Department? Show the names.
```sql
select staff.fname as 'First Name', staff.lname as 'Last Name', dept.dname
from staff
inner join dept
  on staff.dept_id = dept.dept_id
where not dept.dname = 'General Medical Department';
```
### Exercise 17 — What are the total wages paid for each department? Show dept name and the amount.
```sql
select cast(sum(staff.salary) as int) as 'Salary', dept.dname as 'Department Name'
from staff
inner join dept
  on staff.dept_id = dept.dept_id
group by dept.dname
order by Salary desc;
```
### Exercise 18 — Now show the total expenses for each employee. List name, address and total expenses.
```sql
-- (sample inserts provided in original file to populate expenses table)
select * from staff_add;
select * from expenses;

select (staff.fname + ' ' + staff.lname) as 'Name',
       (staff_add.Address1 + ' ' + staff_add.Address2) as 'Address',
       SUM(expenses.Amount) as 'Total Expenses'
from staff
inner join staff_add
  on staff.staff_id = staff_add.staff_id
inner join expenses
  on staff.staff_id = expenses.staff_id
group by (staff.fname + ' ' + staff.lname), (staff_add.Address1 + ' ' + staff_add.Address2)
order by 'Total Expenses' desc;
```
    Note: Tom Redmond was given 2 addresses which is why he can appear twice in Total Expenses

### Exercise 19 — Sum the expenses by department
```sql
select sum(expenses.Amount) as 'Total Expenses', dept.dname as 'Department Name'
from expenses
inner join staff
  on expenses.staff_id = staff.staff_id
inner join dept
  on staff.dept_id = dept.dept_id
group by dept.dname
order by 'Total Expenses' desc;
```
### Exercise 20 — Show the expense for all employees who earn 60k or more. List name, dept name, expenses and salary.
```sql
select (staff.fname + ' ' + staff.lname) as 'Name',
       dept.dname as 'Department Name',
       staff.salary as 'Salary',
       SUM(expenses.Amount) as 'Expenses'
from staff
inner join dept
  on staff.dept_id = dept.dept_id
inner join expenses
  on staff.staff_id = expenses.staff_id
where staff.salary > 60000
group by staff.fname, staff.lname, dept.dname, staff.salary
order by 4 desc,3;
```
### Exercise 21 — Show the details for anyone who got expenses in December and is born before 1.1.1975: Name, Address, age, dept and expenses.
```sql
select 
  (staff.fname + ' ' + staff.lname) as 'Name', 
  (staff_add.Address1 + ' ' + staff_add.Address2) as 'Address',
  DATEDIFF(year, staff.DOB, getdate()) as 'Age',
  dept.dname as 'Department Name', 
  SUM(expenses.Amount) as 'Expenses'
from staff
inner join dept
  on staff.dept_id = dept.dept_id
inner join expenses
  on staff.staff_id = expenses.staff_id
inner join staff_add
  on staff.staff_id = staff_add.staff_id
where expenses.Months between '2011-12-01' and '2011-12-31' and staff.DOB < '1975-01-01'
group by staff.staff_id, staff.fname, staff.lname, staff_add.Address1, staff_add.Address2, staff.DOB, dept.dname;
```
### Exercise 22 — Who has the max amount of expenses in the year? List the name and amount.
```sql
select top 1 with ties (staff.fname + ' ' + staff.lname) as 'Name', sum(expenses.Amount) as 'Maximum Amount of Expenses'
from staff
inner join expenses
  on staff.staff_id = expenses.staff_id
where YEAR(expenses.months) = 2011
group by staff.staff_id, staff.fname, staff.lname
order by SUM(expenses.Amount) desc;
```
### Exercise 23 — Who has the min amount of expenses in the year? List the name and amount.
```sql
select top 1 with ties (staff.fname + ' ' + staff.lname) as 'Name', sum(expenses.Amount) as 'Minimum Amount of Expenses'
from staff
inner join expenses
  on staff.staff_id = expenses.staff_id
where YEAR(expenses.months) = 2011
group by staff.staff_id, staff.fname, staff.lname
order by SUM(expenses.Amount) asc;
```
### Exercise 24 — What is the average amount of expenses?
```sql
select avg(expenses.Amount) as 'Average Amount of Expenses'
from expenses;

-- Average per employee version:
select avg(TotalExpenses) as 'Average Expenses Per Employee'
from (
  select staff_id, SUM(Amount) as TotalExpenses
  from expenses
  group by staff_id
) as EmployeeExpenses;
```
### Exercise 25 — How many expenses cheques were written?
```sql
select COUNT(exp_id) as 'Number of Expense Cheques'
from expenses;
```
### Exercise 26 — Show the December expenses for each employee. Name, expenses and Date paid in the following format December 31st, 2011.
```sql
select CONCAT(staff.fname, ' ', staff.lname) as 'Name',
       SUM(expenses.Amount) as 'Expenses',
       'December 31st, 2011' as 'Date Paid'
from staff
inner join expenses
  on staff.staff_id = expenses.staff_id
where MONTH(expenses.months) = 12
group by staff.staff_id, staff.fname, staff.lname;
```
### Exercise 27 — Which employees did not get any expenses in March? Name, dept.
```sql
select staff.staff_id, CONCAT(staff.fname, ' ', staff.lname) as 'Guys without any Expenses in March', dept.dname as 'Department'
from staff
inner join dept
  on staff.dept_id = dept.dept_id
except
select staff.staff_id, CONCAT(staff.fname, ' ', staff.lname) as 'Guys without any Expenses in March', dept.dname as 'Department'
from staff
inner join dept
  on staff.dept_id = dept.dept_id
inner join expenses
  on staff.staff_id = expenses.staff_id
where MONTH(expenses.months) = 3;
```
### Exercise 28 — List any staff whose last name is Williams – name, address, dept and salary.
```sql
select (staff.fname + ' ' + staff.lname) as 'Name',
       (staff_add.Address1 + ' ' + staff_add.Address2) as 'Address',
       dept.dname as 'Department',
       cast(staff.salary as int) as 'Salary'
from staff
left join dept
  on staff.dept_id = dept.dept_id
left join staff_add
  on staff.staff_id = staff_add.staff_id
where staff.lname = 'Williams';
```
### Exercise 29 — List all the staff from a city beginning with K. Name, city and salary. Order by salary and then name.
```sql
select (staff.fname + ' ' + staff.lname) as 'Name',
       city.city_desc as 'City',
       staff.salary as 'Salary'
from staff
left join staff_add
  on staff.staff_id = staff_add.staff_id
left join city
  on staff_add.city_id = city.city_id
where city.city_desc like 'K%'
order by 3 desc,1;
```
### Exercise 30 — Who is the oldest staff member who has less than 30k? List their Name, dept and salary. Order by salary.
```sql
select top 1 with ties MIN(staff.dob) as 'Oldest Person',
       (staff.fname + ' ' + staff.lname) as 'Name',
       dept.dname as 'Department',
       cast(staff.salary as int) as 'Salary'
from staff
left join dept
  on staff.dept_id = dept.dept_id
where staff.salary < 30000
group by staff.fname, staff.lname, dept.dname, staff.salary
order by 4;
```
### Exercise 31 — Sum the expenses for all those who are from Kilkenny county
```sql
-- initial attempt (row duplication issue because some staff have multiple addresses)
select SUM(expenses.Amount) as 'Expenses Total of all the guys from Kilkenny'
from expenses
inner join staff
  on expenses.staff_id = staff.staff_id
left join staff_add
  on staff.staff_id = staff_add.staff_id
left join county
  on staff_add.co_id = county.co_id
where county.co_id = 'KK';

-- de-duplicated approach:
select SUM(distinctExpenses.expenses_Amount) as 'Expenses Total of all the guys from Kilkenny'
from (
  select distinct expenses.exp_id, expenses.Amount as expenses_Amount
  from expenses
  inner join staff
    on expenses.staff_id = staff.staff_id
  left join staff_add
    on staff.staff_id = staff_add.staff_id
  left join county
    on staff_add.co_id = county.co_id
  where county.co_id = 'KK'
) as distinctExpenses;
```
### Exercise 32 — List all the staff and their qualifications. Show staff first and last name as Name and the qualification description.
```sql
select (staff.fname + ' ' + staff.lname) as 'Name', qualifications.qual_desc as 'Qualification'
from staff
left join staff_qual
  on staff.staff_id = staff_qual.Staff_id
left join qualifications
  on staff_qual.qual_id = qualifications.qual_id;
```
### Exercise 33 — List all the staff names (first and last as Name), their roles descriptions, their department description.
```sql
select (staff.fname + ' ' + staff.lname) as 'Name', job_titles.job_title_desc as 'Role', dept.dname as 'Department'
from staff
left join job_titles
  on staff.job_title_id = job_titles.job_title_id
left join dept
  on staff.dept_id = dept.dept_id;
```
### Exercise 34 — The manager wants to create an address book. Show the first and last names and each of the address lines of both staff and patients.
```sql
select staff.fname as 'First Name', staff.lname as 'Last Name', staff_add.Address1 as 'Address 1', staff_add.Address2 as 'Address 2',
       city.city_desc as 'City', county.county_desc as 'County', staff.phone as 'Phone', staff.email as 'Email'
from staff
left join staff_add
  on staff.staff_id = staff_add.staff_id
left join city
  on staff_add.city_id = city.city_id
left join county
  on staff_add.co_id = county.co_id
union
select patient.p_fname as 'First Name', patient.p_lname as 'Last Name', patient_address.Address1 as 'Address 1', patient_address.Address2 as 'Address 2',
       city.city_desc as 'City', county.county_desc as 'County', patient.Phone as 'Phone', patient.email as 'Email'
from patient
left join patient_address
  on patient.patient_id = patient_address.patient_id
left join city
  on patient_address.city_id = city.city_id
left join county
  on patient_address.co_id = county.co_id;

    Note: Tom Redmond has two addresses — he may appear twice in results.
```
### Exercise 35 — What rooms were never occupied by any patient? Name the rooms.
```sql
select rooms.room_id as 'Rooms never occupied by patients'
from rooms
except
select patient_rooms.room_id as 'Rooms never occupied by patients'
from patient_rooms;

-- alternative:
select rooms.room_id as 'Room ID', rooms.room_desc 'Rooms never occupied by patients'
from rooms
where rooms.room_id not in (select patient_rooms.room_id from patient_rooms);
```
### Exercise 36 — What rooms had the most patients?
```sql
select COUNT(patient_rooms.patient_id) as 'How Many Patients', patient_rooms.room_id as 'Room ID', rooms.room_desc as 'Room Description'
from patient_rooms
left join rooms
  on patient_rooms.room_id = rooms.room_id
group by patient_rooms.room_id, rooms.room_desc
order by 1 desc;
```
### Exercise 37 — Show all the patients who are smokers list first and last names as Patient Name, their gender, DOB and their blood pressure.
```sql
select (patient.p_fname + ' ' + patient.p_lname) as 'Patient Name', gender.gender_desc as 'Gender', patient.DOB as 'Date of Birth', max(patient_record.blood_pressure) as 'Blood Pressure'
from patient
inner join gender
  on patient.Gender_id = gender.gender_id
inner join patient_record
  on patient.patient_id = patient_record.patient_id
where patient_record.Smoker = 'Y'
GROUP BY patient.p_fname, patient.p_lname, gender.gender_desc, patient.DOB;

-- alternate showing all blood pressure readings:
select (patient.p_fname + ' ' + patient.p_lname) as 'Patient Name', gender.gender_desc as 'Gender', patient.DOB as 'Date of Birth', patient_record.blood_pressure as 'Blood Pressure'
from patient
inner join gender
  on patient.Gender_id = gender.gender_id
inner join patient_record
  on patient.patient_id = patient_record.patient_id
where patient_record.Smoker = 'Y'
order by 4,1 desc;
```
### Exercise 38 — Show the patient first and last name as Patient name, their gender, their admission date and medical condition, the room they were located in and the fee that they paid along with the date.
```sql
-- Incorrect naive sum shows duplicates; correct approach shown below.

select patient.patient_id as 'Patient ID', (patient.p_fname + ' ' + patient.p_lname) as 'Patient Name',
       gender.gender_desc as 'Gender', patient_record.addmittion_dt as 'Admission Date', patient_record.medical_condition as 'Medical Condition',
       patient_rooms.room_id as 'Room ID', rooms.room_desc as 'Room', patient_fees.fee as 'Fee', patient_fees.date_paid as 'Fee Date Paid'
from patient
left join gender
  on patient.Gender_id = gender.gender_id
left join patient_record
  on patient.patient_id = patient_record.patient_id
left join patient_rooms
  on patient.patient_id = patient_rooms.patient_id
left join rooms
  on patient_rooms.room_id = rooms.room_id
left join patient_fees
  on patient.patient_id = patient_fees.patient_id
order by patient_fees.fee desc;

-- Better: show total fees per patient:
select patient.patient_id as 'Patient ID', (patient.p_fname + ' ' + patient.p_lname) as 'Patient Name', gender.gender_desc as 'Gender', 
  SUM(patient_fees.fee) as 'Fee'
from patient
left join gender
  on patient.Gender_id = gender.gender_id
left join patient_fees
  on patient.patient_id = patient_fees.patient_id
group by patient.patient_id, patient.p_fname, patient.p_lname, gender.gender_desc
order by Fee desc;

-- Examine tables:
select * from patient_fees;
select * from patient;

select SUM(fee) as 'Fee Total', patient_id
from patient_fees
group by patient_id
order by 1 desc;
```
### Exercise 39 — What patients are not yet assigned to a room?
```sql
select patient.patient_id as 'Patient ID', (patient.p_fname + ' ' + patient.p_lname) as 'Patient Name'
from patient
left join patient_rooms
  on patient.patient_id = patient_rooms.patient_id
where patient.patient_id not in (select patient_rooms.patient_id from patient_rooms);
```
### Exercise 40 — If employees were to get an increase of 10% next year then show the employee first and last name as Employee Name, the current salary and the increased salary as Proposed Salary. Also show the difference between both salary columns as Salary Difference.
```sql
select (staff.fname + ' ' + staff.lname) as 'Employee Name', staff.salary as 'Current Salary', (staff.salary * 1.1) as 'Propesed Salary',
       (staff.salary * 1.1) - staff.salary as 'Salary Difference'
from staff;
```
### Exercise 41 — Everyone paid under 40k is going to get a 15% increase and all others will get a 10% increase. Show the employee first and last name as Employee Name, the current salary and the increased salary as Proposed Salary. Also show the difference between both salary columns as Salary Difference.
```sql
select (staff.fname + ' ' + staff.lname) as 'Employee Name', staff.salary as 'Current Salary', (staff.salary * 1.15) as 'Proposed Salary',
       (staff.salary * 1.15) - staff.salary as 'Salary Difference'
from staff
where salary < 40000
union
select (staff.fname + ' ' + staff.lname) as 'Employee Name', staff.salary as 'Current Salary', (staff.salary * 1.1) as 'Proposed Salary',
       (staff.salary * 1.1) - staff.salary as 'Salary Difference'
from staff 
where salary >= 40000;
```
## 🧠 Conclusions
- **Data Selection & Filtering** — precise retrieval using `WHERE`, pattern matching, and logical operators.  
- **Aggregations & Calculations** — sums, averages, min/max, grouping, and computed columns.  
- **Joins & Relationships** — combining data across multiple tables and resolving one-to-many duplication issues.  
- **Date Handling & Business Logic** — working with `DATEDIFF`, date filters, and formatted outputs.  
- **Troubleshooting & Query Refinement** — identifying duplicates, optimizing joins, and rewriting queries for accurate aggregation. 
