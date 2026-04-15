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
CREATE TABLE IF NOT EXISTS data_protection.Subjects
(
    Id UUID NOT NULL DEFAULT gen_random_uuid(),
    Identification VARCHAR(20) NOT NULL,
    FullName VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    Address TEXT,
    Email VARCHAR(150) NOT NULL,
    SubjectType VARCHAR(20),
    ContactPerson VARCHAR(255),
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_Subjects PRIMARY KEY (Id),
    CONSTRAINT UQ_Subjects_Identification UNIQUE (Identification),
    CONSTRAINT UQ_Subjects_Email UNIQUE (Email),
    CONSTRAINT CK_Subjects_Type CHECK (SubjectType IN ('PERSONA', 'EMPRESA'))
);

-- =============================================
-- TABLE: Devices
-- =============================================
CREATE TABLE IF NOT EXISTS data_protection.Devices
(
    Id UUID NOT NULL DEFAULT gen_random_uuid(),
    SubjectId UUID NOT NULL,
    DeviceType VARCHAR(50) NOT NULL,
    Brand VARCHAR(50),
    Model VARCHAR(50),
    SerialNumber VARCHAR(100),
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_Devices PRIMARY KEY (Id),
    CONSTRAINT UQ_Devices_Serial UNIQUE (SerialNumber),
    CONSTRAINT FK_Devices_Subjects FOREIGN KEY (SubjectId)
        REFERENCES data_protection.Subjects(Id)
        ON DELETE CASCADE
);

-- =============================================
-- TABLE: DeviceCredentials
-- =============================================
CREATE TABLE IF NOT EXISTS data_protection.DeviceCredentials
(
    Id UUID NOT NULL DEFAULT gen_random_uuid(),
    DeviceId UUID NOT NULL,
    SystemUser VARCHAR(100),
    EncryptedPassword BYTEA NOT NULL,
    EncryptionIV BYTEA NOT NULL,
    UpdatedAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_DeviceCredentials PRIMARY KEY (Id),
    CONSTRAINT FK_DeviceCredentials_Devices FOREIGN KEY (DeviceId)
        REFERENCES data_protection.Devices(Id)
        ON DELETE CASCADE
);

-- =============================================
-- TABLE: BiometricAuth
-- =============================================
CREATE TABLE IF NOT EXISTS data_protection.BiometricAuth
(
    Id UUID NOT NULL DEFAULT gen_random_uuid(),
    SubjectId UUID NOT NULL,
    TemplateType VARCHAR(20),
    BiometricVector BYTEA NOT NULL,
    ConsentText TEXT NOT NULL,
    DigitalSignature TEXT,
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_BiometricAuth PRIMARY KEY (Id),
    CONSTRAINT FK_BiometricAuth_Subjects FOREIGN KEY (SubjectId)
        REFERENCES data_protection.Subjects(Id)
);

-- =============================================
-- INDEXES (Opcional pero recomendado)
-- =============================================

CREATE INDEX IF NOT EXISTS IDX_Devices_SubjectId
    ON data_protection.Devices (SubjectId);

CREATE INDEX IF NOT EXISTS IDX_DeviceCredentials_DeviceId
    ON data_protection.DeviceCredentials (DeviceId);

CREATE INDEX IF NOT EXISTS IDX_BiometricAuth_SubjectId
    ON data_protection.BiometricAuth (SubjectId);