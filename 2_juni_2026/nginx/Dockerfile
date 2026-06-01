# Optional: Custom Nginx Dockerfile
# Gunakan ini jika ingin build custom nginx image
# Otherwise, gunakan official nginx:alpine image di docker-compose.yml

FROM nginx:alpine

# Install additional tools (optional)
# RUN apk add --no-cache curl wget

# Copy configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy SSL certificates (jika ada)
# COPY ssl/ /etc/nginx/ssl/

# Create log directory
RUN mkdir -p /var/log/nginx && \
    touch /var/log/nginx/access.log /var/log/nginx/error.log && \
    chmod 755 /var/log/nginx

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1

# Expose ports
EXPOSE 80 443

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
