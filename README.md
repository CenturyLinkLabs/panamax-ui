[![Panamax - Docker Management for Humans](http://img.youtube.com/vi/xGjBZ0lZG5E/0.jpg)](https://www.youtube.com/watch?v=xGjBZ0lZG5E "Panamax Overview Video")

[Panamax](http://panamax.io) is a containerized app creator with an open-source app marketplace hosted in GitHub. Panamax provides a friendly interface for users of Docker, Fleet & CoreOS. With Panamax, you can easily create, share, and deploy any containerized app no matter how complex it might be. Learn more at [Panamax.io](http://panamax.io) or browse the [Panamax Wiki](https://github.com/CenturyLinkLabs/panamax-ui/wiki).

# Panamax-ui

[![](https://badge.imagelayers.io/centurylink/panamax-ui.svg)](https://imagelayers.io/?images=centurylink/panamax-ui:latest 'Get your own badge on imagelayers.io')![Master_Build_Status](https://circleci.com/gh/CenturyLinkLabs/panamax-ui/tree/master.png?circle-token=d850f050b17d488a6a2b5066996875128b874674) [![Coverage Status](https://coveralls.io/repos/CenturyLinkLabs/panamax-ui/badge.png)](https://coveralls.io/r/CenturyLinkLabs/panamax-ui)

This project exposes a friendly user interface to the [Panamax API](https://github.com/CenturyLinkLabs/panamax-api), and is one of the components used by [Panamax-Coreos](https://github.com/CenturyLinkLabs/panamax-coreos)

## Getting Started

### Pre-requisites
* Computer
* Ruby 2.1+
* Panamax API running somewhere accessible to the panamax-ui application

### Install steps
```
git clone git@github.com:CenturyLinkLabs/panamax-ui.git
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
