#!/bin/bash

nginx -p $PWD -c nginx.conf

# nginx does execute FastCGI programs directly
./spawn-fcgi                                            \
    -d $HOME/src/cgroups                                \
    -f $HOME/src/cgroups/dist/build/cgroups/cgroups     \
    -s /tmp/cgroups.socket                              \
    -M 511                                              \
    -u johnw

curl http://localhost:9999/list
