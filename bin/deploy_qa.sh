#!/bin/bash

ssh root@205.139.160.215 "cd /home/panamax && git pull && ./setup.sh -op=reinstall"
