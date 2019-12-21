FROM nginx:1.17-alpine
ENV SERVICE_AVAILABLE_DIR=/etc/sv \
    SERVICE_ENABLED_DIR=/etc/service

ENV SVDIR=${SERVICE_ENABLED_DIR} \
  SVWAIT=7
ARG CONSUL_TEMPLATE_VERSION=0.19.5
ENV CONSUL_URL consul:8500

ADD https://rawgit.com/dockage/runit-scripts/master/scripts/installer /opt/
ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /opt
RUN apk update \
  && apk --no-cache add runit unzip \
  && mkdir -p ${SERVICE_AVAILABLE_DIR} ${SERVICE_ENABLED_DIR} \
  && chmod +x /opt/installer \
  && sync \
  && /opt/installer \
  && rm -rf /var/cache/apk/* /opt/installer \
  && unzip /opt/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -d /usr/local/bin \
  && rm -rf /opt/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && apk del unzip

ADD nginx.service ${SERVICE_ENABLED_DIR}/nginx/run
ADD consul-template.service ${SERVICE_ENABLED_DIR}/consul-template/run
RUN chmod +x ${SERVICE_ENABLED_DIR}/nginx/run \
    && chmod +x ${SERVICE_ENABLED_DIR}/consul-template/run
RUN rm -v /etc/nginx/conf.d/*
ADD nginx.conf index.html /etc/consul-templates/

CMD ["/sbin/runsvdir", "/etc/service"]