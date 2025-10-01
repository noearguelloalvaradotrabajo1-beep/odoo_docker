FROM odoo:17.0

# Usar el entrypoint personalizado en lugar de esperar archivos faltantes
COPY ./17.0/entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

CMD ["/custom-entrypoint.sh"]
