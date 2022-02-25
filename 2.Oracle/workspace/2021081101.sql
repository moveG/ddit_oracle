/* 사원 */
CREATE TABLE tbl_emp (
	emp_id CHAR(5) NOT NULL, /* 사원번호 */
	emp_name VARCHAR2(30) NOT NULL, /* 사원명 */
	addr VARCHAR2(100) /* 주소 */
);

CREATE UNIQUE INDEX PK_tbl_emp
	ON tbl_emp (
		emp_id ASC
	);

ALTER TABLE tbl_emp
	ADD
		CONSTRAINT PK_tbl_emp
		PRIMARY KEY (
			emp_id
		);

/* 사업장 */
CREATE TABLE tbl_site (
	site_id CHAR(4) NOT NULL, /* 사업장번호 */
	site_name VARCHAR2(50) NOT NULL, /* 사업장명 */
	s_date DATE /* 시공일자 */
);

CREATE UNIQUE INDEX PK_tbl_site
	ON tbl_site (
		site_id ASC
	);

ALTER TABLE tbl_site
	ADD
		CONSTRAINT PK_tbl_site
		PRIMARY KEY (
			site_id
		);

/* 근무 */
CREATE TABLE tbl_work (
	emp_id CHAR(5) NOT NULL, /* 사원번호 */
	site_id CHAR(4) NOT NULL, /* 사업장번호 */
	i_date DATE NOT NULL /* 발령일자 */
);

CREATE UNIQUE INDEX PK_tbl_work
	ON tbl_work (
		emp_id ASC,
		site_id ASC
	);

ALTER TABLE tbl_work
	ADD
		CONSTRAINT PK_tbl_work
		PRIMARY KEY (
			emp_id,
			site_id
		);

/* 사업장자재 */
CREATE TABLE tbl_mat (
	mat_id CHAR(5) NOT NULL, /* 자재코드 */
	mat_name VARCHAR2(50) NOT NULL, /* 자재명 */
	mat_price NUMBER(9) DEFAULT 0, /* 가격 */
	site_id CHAR(4) /* 사업장번호 */
);

CREATE UNIQUE INDEX PK_tbl_mat
	ON tbl_mat (
		mat_id ASC
	);

ALTER TABLE tbl_mat
	ADD
		CONSTRAINT PK_tbl_mat
		PRIMARY KEY (
			mat_id
		);

ALTER TABLE tbl_work
	ADD
		CONSTRAINT FK_tbl_emp_TO_tbl_work
		FOREIGN KEY (
			emp_id
		)
		REFERENCES tbl_emp (
			emp_id
		);

ALTER TABLE tbl_work
	ADD
		CONSTRAINT FK_tbl_site_TO_tbl_work
		FOREIGN KEY (
			site_id
		)
		REFERENCES tbl_site (
			site_id
		);

ALTER TABLE tbl_mat
	ADD
		CONSTRAINT FK_tbl_site_TO_tbl_mat
		FOREIGN KEY (
			site_id
		)
		REFERENCES tbl_site (
			site_id
		);