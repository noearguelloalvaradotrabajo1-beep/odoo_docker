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

# Verificar si la base de datos existe y tiene tablas
if ! PGPASSWORD=$PASSWORD psql -h "$HOST" -U "$USER" -d odoo_qfpt -c "SELECT COUNT(*) FROM ir_module_module" &>/dev/null; then
    echo "Base de datos vacía, inicializando con módulo base..."
    exec python3 /usr/bin/odoo -c /etc/odoo/odoo.conf -i base --database odoo_qfpt --stop-after-init
    echo "Inicialización completada, iniciando Odoo normalmente..."
fi

echo "Iniciando Odoo..."
exec python3 /usr/bin/odoo -c /etc/odoo/odoo.conf
