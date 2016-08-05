FROM carrickpark/containerbase

RUN groupadd -r varnishd && useradd -r -g varnishd varnishd

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-transport-https \
        ca-certificates \
        curl \
	&& rm -rf /var/lib/apt/lists/*

ENV VARNISH_VERSION 4.1

RUN curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add -
RUN echo "deb https://repo.varnish-cache.org/debian/ jessie varnish-$VARNISH_VERSION" >> /etc/apt/sources.list.d/varnish-cache.list

# Update the package repository and install applications
RUN apt-get update && apt-get install -y --no-install-recommends \
        varnish=4.1.3-1~jessie \
    && rm -rf /var/lib/apt/lists/*

ADD ./bin/start-varnishd.sh /usr/local/bin/start-varnishd
ADD ./config/webcache.json /config/webcache.json
ADD ./config/default.vcl /etc/varnish/default.vcl

ENV VARNISH_PORT 80
ENV VARNISH_MEMORY 100m

EXPOSE 80

CMD ["start-varnishd"]
