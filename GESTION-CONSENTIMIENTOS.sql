-- =============================================
-- DATABASE STRUCTURE SCRIPT
-- Schema: data_protection
-- =============================================

-- EXTENSIONES
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- SCHEMA
CREATE SCHEMA IF NOT EXISTS data_protection;

-- =============================================
-- TABLE: Subjects
-- =============================================
CREATE TABLE IF NOT EXISTS data_protection.subjects
(
    id              UUID        NOT NULL DEFAULT gen_random_uuid(),
    identification  TEXT        NOT NULL,
    full_name       TEXT        NOT NULL,
    phone           TEXT,
    address         TEXT,
    email           TEXT        NOT NULL,
    subject_type    VARCHAR(20),
    contact_person  TEXT,
    is_deleted      BOOLEAN     NOT NULL DEFAULT FALSE,
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_subjects      PRIMARY KEY (id),
    CONSTRAINT ck_subjects_type CHECK (subject_type IN ('PERSONA', 'EMPRESA'))
);

-- =============================================
-- TABLE: Devices
-- =============================================
CREATE TABLE IF NOT EXISTS data_protection.devices
(
    id            UUID        NOT NULL DEFAULT gen_random_uuid(),
    subject_id    UUID        NOT NULL,
    device_type   VARCHAR(50) NOT NULL,
    brand         TEXT,
    model         TEXT,
    serial_number TEXT,
    is_deleted    BOOLEAN     NOT NULL DEFAULT FALSE,
    deleted_at    TIMESTAMPTZ,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_devices          PRIMARY KEY (id),
    CONSTRAINT fk_devices_subjects FOREIGN KEY (subject_id)
        REFERENCES data_protection.subjects(id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: DeviceCredentials
-- =============================================
CREATE TABLE IF NOT EXISTS data_protection.device_credentials
(
    id                 UUID        NOT NULL DEFAULT gen_random_uuid(),
    device_id          UUID        NOT NULL,
    system_user_name   TEXT,
    encrypted_password TEXT        NOT NULL,
    encryption_iv      TEXT,
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_device_credentials           PRIMARY KEY (id),
    CONSTRAINT fk_device_credentials_devices   FOREIGN KEY (device_id)
        REFERENCES data_protection.devices(id) ON DELETE CASCADE
);

-- =============================================
-- TABLE: BiometricAuth
-- =============================================
CREATE TABLE IF NOT EXISTS data_protection.biometric_auth
(
    id                UUID        NOT NULL DEFAULT gen_random_uuid(),
    subject_id        UUID        NOT NULL,
    template_type     VARCHAR(50),
    biometric_vector  BYTEA       NOT NULL,
    consent_text      TEXT        NOT NULL,
    digital_signature TEXT,
    embedding_model   VARCHAR(50),
    embedding_dims    INTEGER,
    confidence_score  FLOAT,
    is_deleted        BOOLEAN     NOT NULL DEFAULT FALSE,
    deleted_at        TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_biometric_auth           PRIMARY KEY (id),
    CONSTRAINT fk_biometric_auth_subjects  FOREIGN KEY (subject_id)
        REFERENCES data_protection.subjects(id)
);

-- =============================================
-- INDEXES (Opcional pero recomendado)
-- =============================================

CREATE INDEX IF NOT EXISTS idx_devices_subject_id
    ON data_protection.devices (subject_id);

CREATE INDEX IF NOT EXISTS idx_device_credentials_device_id
    ON data_protection.device_credentials (device_id);

CREATE INDEX IF NOT EXISTS idx_biometric_auth_subject_id
    ON data_protection.biometric_auth (subject_id);