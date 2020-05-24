#!/bin/bash

# Reset dummynet to default config
dnctl -f flush
pfctl -F all
