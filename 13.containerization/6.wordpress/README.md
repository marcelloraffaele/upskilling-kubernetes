```bash
docker volume create db_data

docker run -d \
  --name db \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=exampledb \
  -e MYSQL_USER=exampleuser \
  -e MYSQL_PASSWORD=examplepass \
  mysql:5.6

```

I can create an Adminer instance to manage the database:
```bash
docker run --link db:db -p 9000:8080 adminer

```

Or I can create a wordpress instance:

```bash
docker volume create wp_data

docker run -d \
  --name wordpress_app \
  --restart always \
  --link db:db \
  -p 8080:80 \
  -e WORDPRESS_DB_HOST=db:3306 \
  -e WORDPRESS_DB_USER=exampleuser \
  -e WORDPRESS_DB_PASSWORD=examplepass \
  -e WORDPRESS_DB_NAME=exampledb \
  -v wp_data:/var/www/html \
  wordpress:latest


```
