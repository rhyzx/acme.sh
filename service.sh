#!/usr/bin/env sh
set -eu

term() {
  echo "term"
  exit 0
}
trap 'term' HUP

# start as foreground service
while :; do
  # TODO deploy error?
  ./main.sh
  sleep 86400
  # sleep &
  # wait $!
done
