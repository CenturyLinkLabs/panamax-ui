#!/bin/bash

ssh clouduser@8.22.8.121 "cd panamax-vagrant; git pull; ./setup.sh -op=reinstall; cd ~; ./commit.sh; ./screensh.sh"
