ALTER TABLE organization_working_days
    DROP CONSTRAINT IF EXISTS organization_working_days_pk;

ALTER TABLE organization_working_days
    ADD CONSTRAINT org_organization_id_pk
        PRIMARY KEY (organization_id);
