-- =====================================================================
-- MIGRACIÓN: Tabla part_contracts (Encargados/Terceros)
-- Schema: data_protection
-- Ejecutar en los 3 ambientes: securehub_des, securehub_pre, securehub
-- =====================================================================

CREATE TABLE IF NOT EXISTS data_protection.part_contracts
(
    id                  UUID        NOT NULL DEFAULT gen_random_uuid(),
    company_name        TEXT        NOT NULL,
    contact_email       TEXT        NOT NULL,
    contact_person      TEXT,
    purpose_description TEXT        NOT NULL,
    allowed_fields      TEXT[]      NOT NULL DEFAULT '{}',
    contract_file_path  TEXT,
    contract_hash       TEXT,
    valid_from          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_until         TIMESTAMPTZ NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    keycloak_user_id    TEXT,
    keycloak_username   TEXT,
    blockchain_tx_hash  TEXT,
    created_by          UUID,
    revoked_by          UUID,
    revoked_at          TIMESTAMPTZ,
    revoked_reason      TEXT,
    is_deleted          BOOLEAN     NOT NULL DEFAULT FALSE,
    deleted_at          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	subject_id			UUID,
    CONSTRAINT pk_part_contracts PRIMARY KEY (id),
    CONSTRAINT ck_part_status CHECK (status IN ('ACTIVO','SUSPENDIDO','REVOCADO','VENCIDO'))
);

CREATE INDEX IF NOT EXISTS idx_part_contracts_status
    ON data_protection.part_contracts (status);
CREATE INDEX IF NOT EXISTS idx_part_contracts_valid_until
    ON data_protection.part_contracts (valid_until);