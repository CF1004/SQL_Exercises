CREATE TABLE gender (
    gender_id VARCHAR(2) PRIMARY KEY,
    gender_desc VARCHAR(100) NOT NULL
);

CREATE TABLE dept (
    dept_id VARCHAR(8) PRIMARY KEY,
    dname VARCHAR(50)
);

CREATE TABLE job_titles (
    job_title_id INT PRIMARY KEY,
    job_title_desc VARCHAR(50) NOT NULL
);

CREATE TABLE county (
    co_id VARCHAR(10) PRIMARY KEY,
    county_desc VARCHAR(50) NOT NULL
);

CREATE TABLE city (
    city_id VARCHAR(10) PRIMARY KEY,
    city_desc VARCHAR(50) NOT NULL
);

CREATE TABLE payment_method (
    pay_method_id INT PRIMARY KEY,
    pay_method_desc VARCHAR(50)
);

CREATE TABLE rooms (
    room_id INT PRIMARY KEY,
    room_desc VARCHAR(50)
);

CREATE TABLE qualifications (
    qual_id INT PRIMARY KEY,
    qual_desc VARCHAR(100) NOT NULL
);

CREATE TABLE staff (
    staff_id INT PRIMARY KEY,
    job_title_id INT NOT NULL,
    fname VARCHAR(50) NOT NULL,
    lname CHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    gender_id VARCHAR(2) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    dept_id VARCHAR(8),
    salary DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id),
    FOREIGN KEY (gender_id) REFERENCES gender(gender_id),
    FOREIGN KEY (job_title_id) REFERENCES job_titles(job_title_id)
);

CREATE TABLE staff_qual (
    staff_qual_id INT PRIMARY KEY,
    qual_id INT NOT NULL,
    staff_id INT NOT NULL,
    staff_qual_dt DATE,
    FOREIGN KEY (qual_id) REFERENCES qualifications(qual_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE staff_add (
    staff_add_id INT PRIMARY KEY,
    Address1 VARCHAR(50) NOT NULL,
    Address2 VARCHAR(50),
    city_id VARCHAR(10) NOT NULL,
    co_id VARCHAR(10) NOT NULL,
    address_st_dt DATE NOT NULL,
    address_end_dt DATE,
    staff_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES city(city_id),
    FOREIGN KEY (co_id) REFERENCES county(co_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE patient (
    patient_id INT PRIMARY KEY,
    p_fname VARCHAR(50) NOT NULL,
    p_lname VARCHAR(50) NOT NULL,
    pps_no VARCHAR(8) UNIQUE NOT NULL,
    gender_id VARCHAR(2) NOT NULL,
    DOB DATE NOT NULL,
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    height DECIMAL(3,2) NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    next_of_kin VARCHAR(50) NOT NULL,
    next_of_kin_tel VARCHAR(50),
    FOREIGN KEY (gender_id) REFERENCES gender(gender_id)
);

CREATE TABLE patient_address (
    pat_address_id INT PRIMARY KEY,
    Address1 VARCHAR(50) NOT NULL,
    Address2 VARCHAR(50),
    city_id VARCHAR(10) NOT NULL,
    co_id VARCHAR(10) NOT NULL,
    address_st_dt DATE NOT NULL,
    address_end_dt DATE,
    patient_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES city(city_id),
    FOREIGN KEY (co_id) REFERENCES county(co_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

CREATE TABLE patient_rooms (
    pat_room_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    room_id INT NOT NULL,
    stay_st_dt DATE,
    stay_end_dt DATE,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

CREATE TABLE patient_record (
    pat_record_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    addmittion_dt DATETIME,
    medical_condition VARCHAR(200) NOT NULL,
    heartbeat INT NOT NULL,
    blood_pressure VARCHAR(50) NOT NULL,
    smoker VARCHAR(2),
    last_blood_test DATE,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

CREATE TABLE patient_fees (
    pfee_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    fee DECIMAL(10,2),
    date_paid DATE,
    pay_method_id INT NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (pay_method_id) REFERENCES payment_method(pay_method_id)
);

CREATE TABLE expenses (
    exp_id INT PRIMARY KEY,
    amount INT,
    months DATE,
    staff_id INT,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
