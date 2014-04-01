#!/bin/bash

ssh clouduser@63.128.180.11 "cd /home/panamax && git pull && ./setup.sh -op=reinstall && cd ~ && ./screensh.sh"
