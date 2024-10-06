FROM neilpang/acme.sh
RUN apk --no-cache add -f bash

COPY tencent_ssl.sh /root/.acme.sh/deploy/
COPY service.sh /

RUN mkdir /dist

ENTRYPOINT ["/service.sh"]

