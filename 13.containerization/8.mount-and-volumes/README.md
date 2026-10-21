Create a web server using Nginx with a custom configuration file.

```bash
docker run -d \
-v ./nginx.conf:/etc/nginx/nginx.conf:ro \
-p 8080:80 \
nginx:alpine
```

Check the web server response:

```bash
curl localhost:8080
```
