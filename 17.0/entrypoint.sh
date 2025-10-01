#!/bin/bash
set -e

# Configuración para Render
if [ ! -f /etc/odoo/odoo.conf ]; then
    echo "Creando configuración de Odoo para Render..."
    cat > /etc/odoo/odoo.conf << EOF
[options]
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${HOST}
db_port = 5432
db_user = ${USER}
db_password = ${PASSWORD}
without_demo = True
proxy_mode = True
EOF
fi

# Esperar a PostgreSQL solo si HOST está definido
if [ -n "$HOST" ]; then
    echo "Esperando a PostgreSQL en $HOST:5432..."
    until PGPASSWORD=$PASSWORD psql -h "$HOST" -U "$USER" -d postgres -c '\q'; do
        >&2 echo "PostgreSQL no disponible - esperando..."
        sleep 5
    done
    echo "PostgreSQL está listo!"
fi

echo "Iniciando Odoo..."
exec "$@"
