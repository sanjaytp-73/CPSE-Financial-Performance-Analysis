USE cpse_financial_analysis;

CREATE TABLE CPSE_Master (
    cpse_id VARCHAR(20) PRIMARY KEY,
    canonical_name VARCHAR(255) NOT NULL,
    normalized_name_key VARCHAR(255) NOT NULL,
    ministry VARCHAR(255),
    department VARCHAR(255),
    cognate_group VARCHAR(255),
    present_in_statement_1 ENUM('Yes', 'No'),
    present_in_statement_13 ENUM('Yes', 'No'),
    present_in_statement_9 ENUM('Yes', 'No'),
    present_in_statement_10 ENUM('Yes', 'No')
);

SHOW TABLES;
DESCRIBE cpse_master;

CREATE TABLE fact_profit_loss (
    cpse_id VARCHAR(20) PRIMARY KEY,
    source_serial VARCHAR(20),
    company_name_source VARCHAR(255),
	profit_loss_fy2024_25_lakh DECIMAL(18,2),
	profit_loss_fy2023_24_lakh DECIMAL(18,2),
	profit_loss_fy2022_23_lakh DECIMAL(18,2),
    fy2024_25_data_status VARCHAR(50),
    source_file VARCHAR(255),
    source_sheet VARCHAR(100),
    unit VARCHAR(30),
    source_excel_row_number INT,

    FOREIGN KEY (cpse_id)
    REFERENCES cpse_master(cpse_id)
);

CREATE TABLE fact_turnover (
    cpse_id VARCHAR(20) PRIMARY KEY,
    source_serial VARCHAR(20),
    company_name_source VARCHAR(255),
    turnover_fy2024_25_lakh DECIMAL(18,2),
    turnover_fy2023_24_lakh DECIMAL(18,2),
    turnover_fy2022_23_lakh DECIMAL(18,2),
    rank_fy2024_25 INT,
    source_file VARCHAR(255),
    source_sheet VARCHAR(100),
    unit VARCHAR(30),
    source_excel_row_number INT,

    FOREIGN KEY (cpse_id)
    REFERENCES cpse_master(cpse_id)
);

CREATE TABLE fact_st_borrowings (
    cpse_id VARCHAR(20) PRIMARY KEY,
    source_serial VARCHAR(20),
    cognate_group_source VARCHAR(255),
    company_name_source VARCHAR(255),
    central_govt_lakh DECIMAL(18,2),
    state_govt_lakh DECIMAL(18,2),
    holding_company_lakh DECIMAL(18,2),
    banks_lakh DECIMAL(18,2),
    foreign_parties_lakh DECIMAL(18,2),
    others_lakh DECIMAL(18,2),
    total_borrowings_lakh DECIMAL(18,2),
    source_file VARCHAR(255),
    source_sheet VARCHAR(100),
    reporting_date DATE,
    unit VARCHAR(30),
    source_excel_row_number INT,

    FOREIGN KEY (cpse_id)
    REFERENCES cpse_master(cpse_id)
);

CREATE TABLE fact_lt_borrowings (
    cpse_id VARCHAR(20) PRIMARY KEY,
    source_serial VARCHAR(20),
    cognate_group_source VARCHAR(255),
    company_name_source VARCHAR(255),
    central_govt_lakh DECIMAL(18,2),
    state_govt_lakh DECIMAL(18,2),
    holding_company_lakh DECIMAL(18,2),
    banks_lakh DECIMAL(18,2),
    foreign_parties_lakh DECIMAL(18,2),
    others_lakh DECIMAL(18,2),
    total_borrowings_lakh DECIMAL(18,2),
    source_file VARCHAR(255),
    source_sheet VARCHAR(100),
    reporting_date DATE,
    unit VARCHAR(30),
    source_excel_row_number INT,

    FOREIGN KEY (cpse_id)
    REFERENCES cpse_master(cpse_id)
);

CREATE TABLE fact_employee_benefits (
    source_serial VARCHAR(20) PRIMARY KEY,
    cognate_group VARCHAR(255),
    employee_benefit_expense_fy2024_25_lakh DECIMAL(18,2),
    financial_year VARCHAR(10),
    unit VARCHAR(30),
    source_excel_row_number INT
);

SHOW TABLES;