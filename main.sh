#!/usr/bin/env sh
set -eu

for entry in $(echo "$ACME_CERTS" | tr ";" "\n"); do
  domains=$(echo "$entry" | cut -d ":" -f 1)
  deploys=$(echo "$entry" | cut -d ":" -f 2)
  dns_method=$(echo "$entry" | cut -d ":" -f 3)

  issue_args=$(if [ -z "$dns_method" ]; then echo "-w /webroot"; else echo "--dns $dns_method"; fi)
  domain_args="$(echo "$domains" | tr "," "\n" | sed -e "s/^/--domain /" | tr "\n" " ")"
  deploy_args="$(echo "$deploys" | tr "," "\n" | sed -e "s/^/--deploy-hook /" | tr "\n" " ")"

  # TODO replace cert output by docker deploy
  # https://github.com/acmesh-official/acme.sh/blob/bc90376489aede6c75edabc32e7062c23e264987/deploy/docker.sh#L8
  # TODO PR: cert file names by domain, `printf "hello %s" "world"`
  # https://github.com/acmesh-official/acme.sh/blob/bc90376489aede6c75edabc32e7062c23e264987/deploy/docker.sh#L16

  # SUCKS: issue+deploy not working, solved by post-hook
  # https://github.com/acmesh-official/acme.sh/issues/4556

  code=0
  # shellcheck disable=SC2086
  acme.sh \
    --issue $issue_args \
    --email $ACME_EMAIL \
    $domain_args \
    --post-hook "if [ -n \"\$Le_Domain\" ]; then acme.sh --deploy $deploy_args $domain_args; fi" ||
    code=$?

  # no abort on request error(eg. localhost.pem)
  # # RENEW_SKIP = 2
  # if [ $code -ne 0 ] && [ $code -ne 2 ]; then
  #   return $code
  # fi
done

# TODO https://github.com/sinclair2/bacme

# load extra
# https://github.com/acmesh-official/acme.sh/blob/bc90376489aede6c75edabc32e7062c23e264987/acme.sh#L5767-L5776

# https://acme.zerossl.com/v2/DV90
# eab
# https://github.com/nginx-proxy/acme-companion/blob/b22b6ef76067949456cb6ae5979f194005c7aa4b/app/letsencrypt_service#L274

# ecc
# https://github.com/acmesh-official/acme.sh/blob/master/acme.sh#L1167
