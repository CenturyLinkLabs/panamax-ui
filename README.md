# Panamax-ui

![Master_Build_Status](https://circleci.com/gh/CenturyLinkLabs/panamax-ui/tree/master.png?circle-token=d850f050b17d488a6a2b5066996875128b874674) [![Coverage Status](https://coveralls.io/repos/CenturyLinkLabs/panamax-ui/badge.png)](https://coveralls.io/r/CenturyLinkLabs/panamax-ui)

This project exposes a friendly user interface to the Panamax API.

## Getting Started

### Pre-requisites 
* Computer
* Ruby 2.1+
* Panamax API running somewhere accessible the the panamax-ui application

### Install steps
```
git clone git@github.com:CenturyLinkLabs/panamax-ui.git
git clone git@github.com:CenturyLinkLabs/ctl-base-ui.git # this needs to live next to the ui project
cd panamax-ui
bundle
# the below environment variables are set by .env in the root of the project.
# You may need to override them to point to the API installation you are using.
# Do not check your local changes into version control
export PMX_API_PORT_3000_TCP_ADDR=localhost
export PMX_API_PORT_3000_TCP_PORT=8888
rails s
```
now visit localhost:3000 and see if it works

### Running tests, etc.
```
rspec spec # ruby specs
rake teaspoon # js specs, can also be accessed in UI at /teaspoon/default
rake jslint # catch those missing semicolons!
```
