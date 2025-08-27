-- highlight--1.0.sql

CREATE EXTENSION highlight;

-- create highlight function
CREATE FUNCTION highlight(text TEXT, keyword TEXT) RETURNS TEXT AS $$
BEGIN
    RETURN regexp_replace(text, keyword, '<mark>' || keyword || '</mark>', 'gi');
END;
$$ LANGUAGE plpgsql;
