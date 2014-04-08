#!/bin/bash
spawn-fcgi \
    -d $HOME/src/cgroups \
    -a 127.0.0.1 \
    -p 5000 \
    -n \
    -- $HOME/src/cgroups/dist/build/cgroups/cgroups
