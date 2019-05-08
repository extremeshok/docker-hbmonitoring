#!/bin/bash

set -e
set -u

#ensure this only runs once per a startup
if [ ! -f "/tmp/fixed_ownership" ] ; then
  echo "Setting ownership of /var/www to www-data in the background"
  echo "yes" > /tmp/fixed_ownership
  chown -R --silent www-data:www-data /var/www &
fi


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

echo "launching app"

sleep 10000000

export nodeUser=nodemonit

cd /home/nodemonit/uptime
PATH=/usr/local/bin:$PATH
exec NODE_ENV=production forever start -a -d --sourceDir /home/nodemonit/uptime/ app.js
