# docker-hbmonitoring
centos6 docker container providing HBmonitoring

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
      - MONGOSERVER=${MONGOSERVER:-}
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
