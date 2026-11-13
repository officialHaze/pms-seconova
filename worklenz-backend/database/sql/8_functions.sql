-- Delete all existing rows
CREATE OR REPLACE FUNCTION sys_delete_project_statuses() RETURNS VOID AS
$$
BEGIN
    DELETE FROM public.sys_project_statuses;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sys_insert_project_statuses_v2() RETURNS VOID AS
$$
BEGIN
    INSERT INTO public.sys_project_statuses (name, color_code, icon, sort_order, is_default)
    VALUES ('Payment Complete', '#80ca79', 'check-circle', 8, FALSE),
           ('Follow Up 1', '#cbc8a1', 'clock-circle', 9, FALSE),
           ('Follow Up 2', '#cbc8a1', 'clock-circle', 10, FALSE),
           ('Dropped', '#f37070', 'stop', 11, FALSE),
           ('Cancelled', '#f37070', 'close-circle', 0, FALSE),
           ('Blocked', '#cbc8a1', 'stop', 1, FALSE),
           ('On Hold', '#cbc8a1', 'stop', 2, FALSE),
           ('Proposed', '#cbc8a1', 'clock-circle', 3, TRUE),
           ('In Planning', '#cbc8a1', 'clock-circle', 4, FALSE),
           ('In Progress', '#80ca79', 'clock-circle', 5, FALSE),
           ('Completed', '#80ca79', 'check-circle', 6, FALSE),
           ('Continuous', '#80ca79', 'clock-circle', 7, FALSE);
END;
$$ LANGUAGE plpgsql;

SELECT sys_delete_project_statuses();
SELECT sys_insert_project_statuses_v2();

DROP FUNCTION IF EXISTS sys_insert_project_statuses_v2();
DROP FUNCTION IF EXISTS sys_delete_project_statuses();
