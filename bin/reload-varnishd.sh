#!/bin/bash

# Generate a unique timestamp ID for this version of the VCL
TIME=$(date +%s)

CURRENT_CONFIG=$( $VARNISHADM vcl.list | awk ' /^active/ { print $3 } ' )

# Load the file into memory
varnishadm -S /etc/varnish/secret -T 127.0.0.1:6082 vcl.load varnish_$TIME /etc/varnish/default.vcl

# Active this Varnish config
varnishadm -S /etc/varnish/secret -T 127.0.0.1:6082 vcl.use varnish_$TIME

varnishadm -S /etc/varnish/secret -T 127.0.0.1:6082 vcl.discard $CURRENT_CONFIG

exit 0
