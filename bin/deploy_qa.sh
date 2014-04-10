#!/bin/bash

ssh clouduser@63.128.180.11 "cd panamax-vagrant && git pull && ./setup.sh -op=reinstall && cd ~ && ./screensh.sh"
