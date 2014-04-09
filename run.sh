#!/bin/bash
./spawn-fcgi \
    -d $HOME/src/cgroups \
    -f $HOME/src/cgroups/dist/build/cgroups/cgroups \
    -s /tmp/cgroups.socket \
    -M 511 \
    -u johnw \
    -n
