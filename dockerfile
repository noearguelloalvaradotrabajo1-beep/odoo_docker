FROM odoo:17.0

USER root

# Instalar postgresql-client para el script de espera
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copiar el entrypoint personalizado
COPY ./17.0/entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

# Volver al usuario odoo
USER odoo

CMD ["/custom-entrypoint.sh"]
