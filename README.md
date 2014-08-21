![Panamax - Docker Management for Humans](http://panamax.ca.tier3.io/panamax_ui_wiki_screens/panamax_logo-title.png)

[Panamax](http://panamax.io) is a containerized app creator with an open-source app marketplace hosted in GitHub. Panamax provides a friendly interface for users of Docker, Fleet & CoreOS. With Panamax, you can easily create, share, and deploy any containerized app no matter how complex it might be. Learn more at [Panamax.io](http://panamax.io) or browse the [Panamax Wiki](https://github.com/CenturyLinkLabs/panamax-ui/wiki).

# Panamax-ui

![Master_Build_Status](https://circleci.com/gh/CenturyLinkLabs/panamax-ui/tree/master.png?circle-token=d850f050b17d488a6a2b5066996875128b874674) [![Coverage Status](https://coveralls.io/repos/CenturyLinkLabs/panamax-ui/badge.png)](https://coveralls.io/r/CenturyLinkLabs/panamax-ui)

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
git submodule update --remote
git commit -a -m 'Update to latest ctl-base-ui version'
```
This assumes you want *panamax-ui* to reference whatever is currently
at the HEAD of the *ctl-base-ui* master branch. If you would like
to track another branch, you must add that branch to the submodule:
```
git submodule add -b feature/my-branch [URL to repo]
```

Running the update command will cause the submodule to track that branch.

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
