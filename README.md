# docker-hbmonitoring

https://hub.docker.com/r/extremeshok/hbmonitoring

centos8 docker container providing HostBill Cloud Monitoring Node (HBmonitoring)

## Requires Mongodb 4.2 server

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
###### Mongodb
    mongodb:
      image: mongo:4.2
      labels:
        - com.centurylinklabs.watchtower.enable=true
      command: --nohttpinterface
      environment:
          - MONGO_DATA_DIR=/data/db
          - MONGO_LOG_DIR=/dev/null
      volumes:
          - ./data/db:/data/db
      restart: always
```
```
docker-compose pull --include-deps
docker-compose up -d --force-recreate --build
```
