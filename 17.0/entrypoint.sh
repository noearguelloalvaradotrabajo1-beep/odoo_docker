#!/bin/bash
set -e

echo "=== Iniciando configuración Odoo ==="

# Crear archivo de configuración
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

echo "Esperando PostgreSQL..."
until PGPASSWORD=$PASSWORD psql -h "$HOST" -U "$USER" -d postgres -c '\q'; do
  echo "PostgreSQL no disponible - esperando..."
  sleep 5
done

echo "PostgreSQL listo - Iniciando Odoo..."
exec python3 /usr/bin/odoo -c /etc/odoo/odoo.conf "$@"
