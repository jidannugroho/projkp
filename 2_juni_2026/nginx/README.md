# Nginx Configuration

Directory ini berisi konfigurasi Nginx untuk Asset Core.

## 📁 File Structure

```
nginx/
├── nginx.conf          # Main Nginx configuration
├── Dockerfile          # Optional: Custom Nginx image
├── ssl/                # SSL certificates (production)
│   ├── cert.pem       # SSL certificate
│   └── key.pem        # Private key
└── README.md          # This file
```

## 📄 Files

### nginx.conf
Main configuration file yang mengatur:
- **Reverse Proxy**: Frontend dan Backend
- **WebSocket**: Socket.IO support
- **Static Files**: Caching untuk assets
- **Rate Limiting**: Proteksi dari abuse
- **Security Headers**: Keamanan
- **SSL/TLS**: HTTPS configuration (commented out)

### Dockerfile (Optional)
Custom Nginx image jika diperlukan customization lebih lanjut.
Saat ini menggunakan `nginx:alpine` dari Docker Hub.

### ssl/ Directory
Tempat menyimpan SSL certificates untuk HTTPS.

```
nginx/ssl/
├── cert.pem          # Certificate chain
└── key.pem           # Private key
```

## 🚀 Quick Start

### 1. Using Official Nginx Image (Default)
```yaml
# docker-compose.yml menggunakan:
image: nginx:alpine
```

Ini adalah cara paling simple dan recommended.

### 2. Using Custom Dockerfile
Edit `docker-compose.yml`:
```yaml
nginx:
  build:
    context: ./nginx
    dockerfile: Dockerfile
```

## 🔧 Configuration

### URL Routing

| Path | Proxy To | Port |
|------|----------|------|
| `/` | frontend | 8080 |
| `/api/*` | backend | 5001 |
| `/socket.io` | backend | 5001 |
| Static files | frontend | 8080 |

### Environment Variables

Dikonfigurasi di `.env`:
```env
NGINX_PORT=80                  # HTTP port
NGINX_HTTPS_PORT=443           # HTTPS port (optional)
```

## 🔐 SSL/TLS Setup

### Self-Signed Certificate (Testing)
```bash
mkdir -p nginx/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/key.pem \
  -out nginx/ssl/cert.pem
```

### Let's Encrypt (Production)
```bash
sudo certbot certonly --standalone -d your-domain.com

sudo cp /etc/letsencrypt/live/your-domain.com/fullchain.pem nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/your-domain.com/privkey.pem nginx/ssl/key.pem
```

### Enable SSL in nginx.conf
Uncomment section SSL dan update domain name.

## 📊 Common Commands

```bash
# Test configuration
docker-compose exec nginx nginx -t

# View logs
docker-compose logs -f nginx

# Reload configuration (graceful)
docker-compose exec nginx nginx -s reload

# Restart Nginx
docker-compose restart nginx

# Shell access
docker-compose exec nginx sh
```

## 🐛 Troubleshooting

### 502 Bad Gateway
- Check backend health: `docker-compose logs backend`
- Verify connection: `docker-compose exec nginx curl http://backend:5001/health`

### Static files not loading (404)
- Check frontend container: `docker-compose logs frontend`
- Verify files exist: `docker-compose exec frontend ls /app/dist`

### WebSocket fails
- Check backend Socket.IO: `docker-compose logs backend | grep -i socket`
- Test connection: `curl -N -H "Connection: Upgrade" http://localhost/socket.io`

### Port already in use
```bash
# Find process
lsof -i :80

# Kill process
kill -9 <PID>

# Or use different port in .env
```

## 📚 Resources

- [Nginx Official Docs](https://nginx.org/en/docs/)
- [Docker Nginx Image](https://hub.docker.com/_/nginx)
- [Nginx Best Practices](https://www.nginx.com/resources/)

## 💡 Tips

1. **Never edit nginx.conf inside container** - ubah di host, lalu reload
2. **Use `nginx -t`** sebelum reload untuk validasi
3. **Monitor logs** - `docker-compose logs -f nginx`
4. **Backup certificates** - jangan sampai hilang SSL keys
5. **Use health checks** - verify Nginx dan upstream services

---

Need help? Check `NGINX_SETUP.md` in root directory for detailed guide.
