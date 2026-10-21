
## build
```bash
docker build -t app1:1.0 .
```

## run
```bash
docker run -it -p 8080:3000 --name app1 -d app1:1.0
```