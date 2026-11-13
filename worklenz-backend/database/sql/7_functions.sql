CREATE OR REPLACE FUNCTION sys_insert_project_statuses_v2() RETURNS VOID AS
$$
BEGIN
    INSERT INTO public.sys_project_statuses (name, color_code, icon, sort_order, is_default)
    VALUES ('Payment Complete', '#80ca79', 'check-circle', 8, FALSE),
           ('Follow Up 1', '#cbc8a1', 'clock-circle', 9, FALSE),
           ('Follow Up 2', '#cbc8a1', 'clock-circle', 10, FALSE),
           ('Dropped', '#f37070', 'stop', 11, FALSE);
END;
$$ LANGUAGE plpgsql;
