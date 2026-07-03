CREATE DATABASE keycloak;
CREATE DATABASE sonarqube;
CREATE DATABASE securehub_des;
CREATE DATABASE securehub_pre;
CREATE DATABASE securehub;



CREATE USER devuser WITH PASSWORD 'devpass';
CREATE USER preuser WITH PASSWORD 'prepass';
CREATE USER produser WITH PASSWORD 'prodpass';
CREATE USER serveruser WITH PASSWORD 'serverpass';

ALTER DATABASE securehub_des OWNER TO devuser;
ALTER DATABASE securehub_pre OWNER TO preuser;
ALTER DATABASE securehub OWNER TO produser;


ALTER DATABASE keycloak OWNER TO serveruser;
ALTER DATABASE sonarqube OWNER TO serveruser;
GRANT ALL ON SCHEMA public TO devuser;
ALTER SCHEMA public OWNER TO devuser;
--en la carpeta de keycloak colocar
-- setx KC_DB postgres
-- setx KC_DB_URL jdbc:postgresql://localhost:5432/keycloak
-- setx KC_DB_USERNAME devuser
-- setx KC_DB_PASSWORD devpass
--
-- setx KEYCLOAK_ADMIN admin
-- setx KEYCLOAK_ADMIN_PASSWORD admin


docker exec -i postgres15 psql -U postgres -d securehub_des <<EOF
-- Dar permisos al schema data_protection
GRANT USAGE ON SCHEMA data_protection TO devuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA data_protection TO devuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA data_protection TO devuser;

GRANT USAGE ON SCHEMA data_protection TO preuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA data_protection TO preuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA data_protection TO preuser;

GRANT USAGE ON SCHEMA data_protection TO devuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA data_protection TO produser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA data_protection TO produser;

-- Para tablas futuras que se creen (migraciones)
ALTER DEFAULT PRIVILEGES IN SCHEMA data_protection 
  GRANT ALL PRIVILEGES ON TABLES TO devuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA data_protection 
  GRANT ALL PRIVILEGES ON SEQUENCES TO devuser;

-- Verificar
\dn+ data_protection
EOF