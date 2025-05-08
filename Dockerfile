FROM neilpang/acme.sh

COPY tencent_ssl.sh /root/.acme.sh/deploy/
COPY main.sh service.sh /

ENTRYPOINT ["/service.sh"]

