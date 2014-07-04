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
cd panamax-ui
git submodule update --init # To download ctl-base-ui
bundle

# the below environment variables are set by .env in the root of the project.
# You may need to override them to point to the API installation you are using.
# Do not check your local changes into version control
export PMX_API_PORT_3000_TCP_ADDR=localhost
export PMX_API_PORT_3000_TCP_PORT=8888
rails s
```
now visit localhost:3000 and see if it works

### Updating ctl-base-ui

#### Pushing a change

If you've pushed a change to the *ctl-base-ui* project that you want to appear
in *panamax-ui* you need to do the following:

```
cd vendor/ctl-base-ui
git checkout origin master
git pull --rebase
cd ../..
git commit -a -m 'Update to latest ctl-base-ui version'
```
This assumes you want *panamax-ui* to reference whatever is currently
at the HEAD of the *ctl-base-ui* master branch -- if you want to link
it to a commit on another branch, simply checkout whichever branch you
want in lieu of master.

#### Pulling a change
After you `git pull --rebase` to update the UI master branch you may
see a git status message like this:

```
    modified:   vendor/ctl-base-ui (new commits)
```

This means there is a new change to *ctl-base-ui* that needs to be
retrieved. You can refresh *ctl-base-ui* by issuing the following
command:
```
git submodule update
```

### Running tests, etc.
```
rspec spec # ruby specs
rake teaspoon # js specs, can also be accessed in UI at /teaspoon/default
rake jslint # catch those missing semicolons!
```
