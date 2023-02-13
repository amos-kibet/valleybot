#!/bin/bash

set -e

MIX_ENV=${mix_env:-prod}
export MIX_ENV="$MIX_ENV"

echo "==> Initial Setup <=="

mix deps.get --only prod

echo "==> Compile Assets <=="

mix compile

echo "==> PORT=4001 mix phx-server <=="