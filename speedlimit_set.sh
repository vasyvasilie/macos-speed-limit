#!/bin/bash

# config
out="128Kbyte/s"
in="128Kbyte/s"

# Reset dummynet to default config
dnctl -f flush
pfctl -F all

# Compose an addendum to the default config; creates a new anchor
(cat /etc/pf.conf &&
  echo 'dummynet-anchor "my_anchor"' &&
  echo 'anchor "my_anchor"') | pfctl -q -f -

# Configure the new anchor
cat <<EOF | pfctl -q -a my_anchor -f -
no dummynet quick on lo0 all
dummynet out all pipe 1
dummynet in all pipe 3

EOF

# Create the dummynet queue
dnctl pipe 1 config bw $out
dnctl pipe 3 config bw $in

# Activate PF
pfctl -E
