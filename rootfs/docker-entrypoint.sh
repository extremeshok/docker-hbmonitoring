#!/bin/bash

set -e
set -u

XS_MONGO_HOST=${MONGO_HOST:-mongodb}
XS_MONGO_PORT=${MONGO_PORT:-27017}

if [ "$HB_URL" == "" ] || [ "$HB_USERNAME" == "" ] || [ "$HB_PASSWORD" == "" ] ; then
  echo "ERROR: Missing either HB_URL, HB_USERNAME, HB_PASSWORD"
  echo "sleeping ......"
  sleep 1d
  exit 1
fi

if [ -w "/home/nodemonit/uptime/config/default.yaml" ] ; then
  echo "Configuring"
  cat << EOF > /home/nodemonit/uptime/config/default.yaml
mongodb:
  server:   $XS_MONGO_HOST:$XS_MONGO_PORT
  database: uptime
  connectionString:  mongodb://$XS_MONGO_HOST:$XS_MONGO_PORT/uptime

monitor:
  hbURL: 'https://$HB_URL/'
  api_username: $HB_USERNAME
  api_password: $HB_PASSWORD
  name:                   origin
  apiUrl:                 'http://localhost:8082/api' # must be accessible without a proxy
  pollingInterval:        10000      # ten seconds
  timeout:                5000       # five seconds
  userAgent:              HBMonitoring/1.0

analyzer:
  updateInterval:         60000      # one minute
  qosAggregationInterval: 600000     # ten minutes
  pingHistory:            8035200000 # three months

autoStartMonitor: true

server:
  port:     8082

EOF
cat /home/nodemonit/uptime/config/default.yaml
fi

while ! nc -z -v $XS_MONGO_HOST $XS_MONGO_PORT 2> /dev/null ; do
  echo "Waiting for MONGODB ${XS_MONGO_HOST}:${XS_MONGO_PORT} ..."
  sleep 2
done

echo "Starting app.js"
export nodeUser=nodemonit
export NODE_ENV=production
cd /home/nodemonit/uptime
/usr/bin/forever -f -d --sourceDir /home/nodemonit/uptime/ app.js
