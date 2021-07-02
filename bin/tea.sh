#!/bin/bash

prog=${0##*/}
pushd $(dirname "$0") >/dev/null || exit
SCRIPTPATH=$(pwd -P)
popd >/dev/null || exit

SERVICENAME="tea"
JARNAME="tea-0.0.1-SNAPSHOT.jar"
JARFILE="${SCRIPTPATH}/../libs/${JARNAME}"
LOG_PATH="${SCRIPTPATH}/../logs"
PROPERTIES="${SCRIPTPATH}/../conf/${SERVICENAME}.yml"

start() {
  ps -ef | grep ${JARNAME} | grep -v grep
  if [[ $? -ne 0 ]]; then
    echo "start ${SERVICENAME}" $(date)
    exec java -Xmx512m -Xms512m -Xmn256m -jar -Dspring.config.location=${PROPERTIES} -Dinstance="${SERVICENAME}" -Dlog.dir="${LOG_PATH}" "${JARFILE}" >/dev/null 2>&1 &

    port=$(grep " port:" "${PROPERTIES}" | cut -d ":" -f2 | sed 's/ *//g')
    for ((i = 1; i < 70; i++)); do
      rst=$(netstat -anlp | grep "LISTEN" | grep "\b${port}\b")
      if [[ $? -eq 0 ]]; then
        echo -e "\n${SERVICENAME} started in" ${i} "seconds"
        echo "${rst}"
        break
      fi
      printf .
      sleep 1
    done
  else
    echo "${SERVICENAME} already running, skip..."
  fi
}

stop() {
  ps -ef | grep ${JARNAME} | grep -v grep | awk '{print $2}' | while read pid; do
    kill -9 "${pid}"
  done
}

case "$1" in
start)
  start
  ;;
stop)
  stop
  ;;
restart)
  stop
  start
  ;;
*)
  printf 'Usage: %s {start|stop|restart}\n' "$prog"
  ;;
esac
