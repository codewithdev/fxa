#!/bin/sh

set -e

rm -rf coverage
rm -rf .nyc_output

if [ -z "$NODE_ENV" ]; then export NODE_ENV=dev; fi;
if [ -z "$CORS_ORIGIN" ]; then export CORS_ORIGIN="http://foo,http://bar"; fi;

set -u

DEFAULT_ARGS="--require ts-node/register --recursive --timeout 5000 --exit"

npx ts-node ./scripts/gen_keys.js
npx ts-node ./scripts/gen_vapid_keys.js
npx ts-node ./scripts/oauth_gen_keys.js
node ../fxa-auth-db-mysql/bin/db_patcher > /dev/null
npm run lint:eslint
grunt copyright

GLOB=$*
if [ -z "$GLOB" ]; then
  echo "Local tests"
  ./scripts/mocha-coverage.js $DEFAULT_ARGS test/local

  echo "Oauth tests"
  ./scripts/mocha-coverage.js $DEFAULT_ARGS test/oauth

  echo "Remote tests"
  ./scripts/mocha-coverage.js $DEFAULT_ARGS test/remote

  echo "Script tests"
  ./scripts/mocha-coverage.js $DEFAULT_ARGS test/scripts

else
  ./scripts/mocha-coverage.js $DEFAULT_ARGS $GLOB
fi
