CREATE OR REPLACE FUNCTION hotel_fngetdocno(cmp_id BIGINT, doctype VARCHAR)
RETURNS TABLE (
    nextnum BIGINT
)
AS $$
DECLARE
    nextval BIGINT;
BEGIN
    -- Get current number based on document type
    IF doctype = 'GRC' THEN
        SELECT COALESCE(nextgrcno, 1) INTO nextval
        FROM res_company
        WHERE id = cmp_id;
    ELSIF doctype = 'RC' THEN
        SELECT COALESCE(nextrcno, 1) INTO nextval
        FROM res_company
        WHERE id = cmp_id;
    ELSIF doctype = 'PR' THEN
        SELECT COALESCE(nextprno, 1) INTO nextval
        FROM res_company
        WHERE id = cmp_id;
    ELSIF doctype = 'DM' THEN
        SELECT COALESCE(nextdmno, 1) INTO nextval
        FROM res_company
        WHERE id = cmp_id;
    ELSIF doctype = 'CM' THEN
        SELECT COALESCE(nextcmno, 1) INTO nextval
        FROM res_company
        WHERE id = cmp_id;
    ELSE
        nextval := 1;
    END IF;

    -- Ensure nextval is at least 1
    IF nextval IS NULL OR nextval = 0 THEN
        nextval := 1;
    END IF;

    -- Increment the next number in the table
    IF doctype = 'GRC' THEN
        UPDATE res_company SET nextgrcno = nextval + 1 WHERE id = cmp_id;
    ELSIF doctype = 'RC' THEN
        UPDATE res_company SET nextrcno = nextval + 1 WHERE id = cmp_id;
    ELSIF doctype = 'PR' THEN
        UPDATE res_company SET nextprno = nextval + 1 WHERE id = cmp_id;
    ELSIF doctype = 'DM' THEN
        UPDATE res_company SET nextdmno = nextval + 1 WHERE id = cmp_id;
    ELSIF doctype = 'CM' THEN
        UPDATE res_company SET nextcmno = nextval + 1 WHERE id = cmp_id;
    END IF;

    -- Return the next number
    RETURN QUERY SELECT nextval AS nextnum;
END;
$$ LANGUAGE plpgsql;
