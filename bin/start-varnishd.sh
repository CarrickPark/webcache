#!/bin/bash
exec varnishd -F -f /etc/varnish/default.vcl -s malloc,${VARNISH_MEMORY} -a 0.0.0.0:${VARNISH_PORT} -T 127.0.0.1:6082 -p http_req_hdr_len=16384 -p http_resp_hdr_len=16384
