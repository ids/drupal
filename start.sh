#!/usr/bin/env bash
set -x

pid=0

# SIGTERM-handler
term_handler() {
	echo "Handling SIGTERM for graceful apache shutdown..."
  if [ $pid -ne 0 ]; then
		echo "Altering SIGTERM for graceful apache shutdown..."
    kill -USR1 "$pid"
    wait "$pid"
		sleep 5s
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap term_handler SIGTERM

# run application
echo "Starting Apache with SIGTERM handler..."

echo "Make sure the shared files directory is clean..."
rm -rf /var/www/html/sites/default/files/lost*

echo "Start Apache2 / Drupal7..."
apachectl start
sleep 3s
pid=`cat /var/run/apache2/apache2.pid`

echo "Apache PID: ${pid}"

# wait forever
echo "Waiting to capture SIGTERM event..."
while true
do
  tail -f /dev/null & wait ${!}
done


