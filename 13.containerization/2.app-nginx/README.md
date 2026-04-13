# 2. app-nginx – La Bella Italia Restaurant

A simple static restaurant website (HTML + CSS + JavaScript) served by **nginx:alpine** inside a Docker container.

## Project structure

```
2.app-nginx/
├── Dockerfile
├── nginx.conf
├── README.md
└── html/
    ├── index.html   # Restaurant page
    ├── style.css    # Styles
    └── app.js       # Interactive menu, counters, form
```

---

## Build the image

```bash
docker build -t app-nginx:1.0 .
```

> Run this command from the `2.app-nginx/` directory (where the `Dockerfile` lives).

---

## Run the container

```bash
docker run -it -p 8080:80 --name restaurant app-nginx:1.0
```

Open your browser at **http://localhost:8080**

---

## Useful commands

| Action | Command |
|--------|---------|
| Build image | `docker build -t app-nginx:1.0 .` |
| Run container | `docker run -d -p 8080:80 --name restaurant app-nginx:1.0` |
| View logs | `docker logs restaurant` |
| Stop container | `docker stop restaurant` |
| Remove container | `docker rm restaurant` |
| Remove image | `docker rmi app-nginx:1.0` |
| Open shell inside | `docker exec -it restaurant sh` |

---

## Rebuild after changes

```bash
docker stop restaurant && docker rm restaurant
docker build -t app-nginx:1.0 .
docker run -d -p 8080:80 --name restaurant app-nginx:1.0
```
