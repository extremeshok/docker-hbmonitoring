# docker-hbmonitoring
centos6 docker container providing HBmonitoring

## Requires Mongodb server

## Usage via docker-compose
sample docker-compose.yml
```
###### HBmonitoring
  hbmonitoring:
    image: extremeshok/hbmonitoring:latest
    labels:
      - com.centurylinklabs.watchtower.enable=true
    environment:
      - TZ=${TZ:-UTC}
      - MONGO_HOST=${MONGO_HOST:-}
      - MONGO_PORT=${MONGO_PORT:-}
      - HB_URL=${HB_URL:-}
      - HB_USERNAME=${HB_USERNAME:-}
      - HB_PASSWORD=${HB_PASSWORD:-}
    ports:
      - 8082:8082
    restart: always
```
```
docker-compose pull --include-deps
docker-compose up -d --force-recreate --build
```
