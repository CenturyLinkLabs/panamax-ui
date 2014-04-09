#!/bin/bash

ssh clouduser@63.128.180.11 "cd panamax-vagrant && git pull && ./setup.sh -op=reinstall && vagrant ssh && docker push 74.201.240.198:5000/panamax-ui && docker push 74.201.240.198:5000/panamax-api && docker pull lapax/tiny-haproxy && exit && cd ~ && ./screensh.sh"
