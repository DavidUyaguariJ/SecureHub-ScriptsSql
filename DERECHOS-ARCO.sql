-- =============================================
-- TABLE: ArcoRequests (Solicitudes ARCO/ARCO-P)
-- =============================================
CREATE TABLE IF NOT EXISTS data_protection.arco_requests
(
    id                  UUID        NOT NULL DEFAULT gen_random_uuid(),
    subject_id          UUID        NOT NULL,
    request_type        VARCHAR(20) NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    description         TEXT,
    biometric_auth_id   UUID,
    response_text       TEXT,
    response_file_path  TEXT,
    rejected_reason     TEXT,
    requested_at        TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date            TIMESTAMPTZ,
    resolved_at         TIMESTAMPTZ,
    resolved_by         UUID,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_arco_requests         PRIMARY KEY (id),
    CONSTRAINT fk_arco_subject          FOREIGN KEY (subject_id)
        REFERENCES data_protection.subjects(id),
    CONSTRAINT fk_arco_biometric        FOREIGN KEY (biometric_auth_id)
        REFERENCES data_protection.biometric_auth(id),
    CONSTRAINT ck_arco_request_type     CHECK (request_type IN
        ('ACCESO','RECTIFICACION','CANCELACION','OPOSICION','PORTABILIDAD')),
    CONSTRAINT ck_arco_status           CHECK (status IN
        ('PENDIENTE','EN_PROCESO','COMPLETADO','RECHAZADO'))
);

-- =============================================
-- TABLE: ArcoAuditLog (Trazabilidad de acciones)
-- =============================================
CREATE TABLE IF NOT EXISTS data_protection.arco_audit_log
(
    id              UUID        NOT NULL DEFAULT gen_random_uuid(),
    arco_request_id UUID        NOT NULL,
    action          VARCHAR(50) NOT NULL,
    previous_status VARCHAR(20),
    new_status      VARCHAR(20),
    performed_by    UUID,
	performed_by_name VARCHAR(100),
    performed_by_role VARCHAR(20),
    notes           TEXT,
    ip_address      TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_arco_audit_log        PRIMARY KEY (id),
    CONSTRAINT fk_audit_arco_request    FOREIGN KEY (arco_request_id)
        REFERENCES data_protection.arco_requests(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_arco_requests_subject_id
    ON data_protection.arco_requests (subject_id);
CREATE INDEX IF NOT EXISTS idx_arco_requests_status
    ON data_protection.arco_requests (status);
CREATE INDEX IF NOT EXISTS idx_arco_audit_request_id
    ON data_protection.arco_audit_log (arco_request_id);