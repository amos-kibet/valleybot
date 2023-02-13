#!/bin/bash
# make sure this bash script has executable permission, if doesn't have, run following command
# > $ chmod +x *./sh/deploy.sh

echo "running the valleybot"

docker run -d -e FB_PAGE_ACCESS_TOKEN=[fb_page_token_here] \
-e FB_WEBHOOK_VERIFY_TOKEN=[fb_webhook_verify_token_here] \
-p 4000:4000 \
--name valleybot valleybot

echo "completed!"