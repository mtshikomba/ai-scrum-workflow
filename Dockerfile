FROM nginxinc/nginx-unprivileged:1.27.5-alpine

COPY --chown=nginx:nginx index.html styles.css /usr/share/nginx/html/
COPY --chown=nginx:nginx docker/nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --quiet --output-document=/dev/null http://127.0.0.1:8080/ || exit 1