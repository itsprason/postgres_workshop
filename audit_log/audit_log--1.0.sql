-- audit_log--1.0.sql

-- Create a new schema for the extension
CREATE SCHEMA logging;

-- Create a log table to store events
CREATE TABLE logging.audit_logs (
    id serial,
    log_time timestamp DEFAULT now(),
    schemaname text,
    tablename text,
    operation text,
    username text DEFAULT current_user,
    new_val json,
    old_val json
);

-- Create the audit log function
-- RETURNS trigger used to hook the function to a trigger
CREATE FUNCTION logging.log_to_table() RETURNS trigger AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO logging.audit_logs(schemaname, tablename, operation, new_val) 
        VALUES (TG_TABLE_SCHEMA, TG_RELNAME, TG_OP, row_to_json(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO logging.audit_logs(schemaname, tablename, operation, new_val, old_val) 
        VALUES (TG_TABLE_SCHEMA, TG_RELNAME, TG_OP, row_to_json(NEW), row_to_json(OLD));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO logging.audit_logs(schemaname, tablename, operation, old_val) 
        VALUES (TG_TABLE_SCHEMA, TG_RELNAME, TG_OP, row_to_json(OLD));
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;

-- SECURITY DEFINER used to succeed the function, even with normal user

-- Create a table to test out the function
CREATE TABLE public.employee (
    id serial,
    employee_name text,
    employee_dob date,
    address text,
    department text,
    salary numeric
);

-- Create the trigger
CREATE TRIGGER audit_log_employee
    BEFORE INSERT OR UPDATE OR DELETE 
    ON public.employee
    FOR EACH ROW 
    EXECUTE PROCEDURE logging.log_to_table();

