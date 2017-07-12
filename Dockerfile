FROM carrickpark/containerbase

RUN groupadd -r varnishd && useradd -r -g varnishd varnishd

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-transport-https \
        debian-archive-keyring \
        ca-certificates \
        curl \
        gnupg2 \
	&& rm -rf /var/lib/apt/lists/*

ENV VARNISH_MAJOR_VERSION 5

RUN curl -L -o varnishgpgkey.sh https://packagecloud.io/varnishcache/varnish${VARNISH_MAJOR_VERSION}/gpgkey
RUN apt-key add varnishgpgkey.sh
RUN rm varnishgpgkey.sh

ENV VARNISH_PACKAGE_FILE /etc/apt/sources.list.d/varnishcache_varnish${VARNISH_MAJOR_VERSION}.list

RUN touch $VARNISH_PACKAGE_FILE
RUN echo "deb https://packagecloud.io/varnishcache/varnish5/debian/ stretch main" >> $VARNISH_PACKAGE_FILE
RUN echo "deb-src https://packagecloud.io/varnishcache/varnish5/debian/ stretch main" >> $VARNISH_PACKAGE_FILE

# Update the package repository and install applications
RUN apt-get update && apt-get install -y --no-install-recommends \
    varnish=5.1.2-1~stretch \
    && rm -rf /var/lib/apt/lists/*

ADD ./bin/start-varnishd.sh /usr/local/bin/start-varnishd
ADD ./bin/reload-varnishd.sh /usr/local/bin/reload-varnishd
ADD ./config/webcache.json.template /config/webcache.json.template
ADD ./config/default.vcl.template /etc/varnish/default.vcl.template

ENV CP_TEMPLATE_AGENT /config/webcache.json.template:/config/webcache.json
ENV CP_TEMPLATE /etc/varnish/default.vcl.template:/etc/varnish/default.vcl:reload-varnishd

ENV VARNISH_PORT 80
ENV VARNISH_MEMORY 100m

EXPOSE 80

CMD ["start-varnishd"]
