-- reverse_string--1.0.sql

-- Create the reverse string function
-- IMMUTABLE: always returns the same output for the same input
-- STRICT: avoids executing when input is NULL
CREATE FUNCTION reverse_string(para text) 
RETURNS text 
LANGUAGE plpgsql 
IMMUTABLE 
STRICT AS $$
DECLARE
    ret text;
BEGIN
    ret := reverse(para);  -- Using PostgreSQL's built-in reverse function
    RETURN ret;
END;
$$;

