#!/bin/bash

set -e
set -u

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
  server:   localhost
  database: uptime
  connectionString:  mongodb://localhost/uptime

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

echo "Starting mongodb"
/etc/init.d/mongod start

export nodeUser=nodemonit
export NODE_ENV=production
export PATH=/usr/local/bin:$PATH

echo "Starting app.js"
cd /home/nodemonit/uptime && /usr/local/bin/node app.js
