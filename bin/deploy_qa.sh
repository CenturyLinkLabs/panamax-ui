#!/bin/bash

ssh clouduser@63.128.180.11 "cd panamax-vagrant; git pull; vagrant destroy -f; ./setup.sh -op=install; cd ~; ./commit.sh; ./screensh.sh"
