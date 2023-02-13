#!/bin/bash

set -e

MIX_ENV=${mix_env:-dev}
export MIX_ENV="$MIX_ENV"

echo "==> Setting up for MIX_ENV=$MIX_ENV " 

if [[ $MIX_ENV -eq "test" ]]
 then
    echo "==> Skipping services"
elif [[ $MIX_ENV -eq "prod" ]]
  then
    echo "==> Running app in 'prod' mode"
    ./run-prod.sh
else
  echo "==> Running app in 'dev' mode"
  ./run.sh
fi

echo "==> Setting up dependencies"
mix deps.get
mix compile --warnings-as-errors