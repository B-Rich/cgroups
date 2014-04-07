#!/bin/bash
# spawn-fcgi \
#     -d $HOME/src/cgroups \
#     -s /tmp/cgroups.socket \
#     -n \
#     -M 511 \
#     -u johnw \
#     -- $HOME/src/cgroups/dist/build/cgroups/cgroups
spawn-fcgi \
    -d $HOME/src/cgroups \
    -s /tmp/cgroups.socket \
    -n \
    -p 5000 \
    -u johnw \
    -- $HOME/src/cgroups/dist/build/cgroups/cgroups
