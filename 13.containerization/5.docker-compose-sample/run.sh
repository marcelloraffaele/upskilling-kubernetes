docker run -d --name db -e POSTGRES_PASSWORD=secret postgres
docker run -d --name app -p 3000:3000 --link db myapp


docker compose up -d