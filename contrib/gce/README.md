# Panamax on Google Compute Engine

First, install the [Google Cloud SDK][gcutil] and log in.

```console
$ gcloud auth login
```

Next, create a project in the [developer console][devcons]. The project ID 
should look something like `golden-cove-408`. For convenience, you should set 
that as the default in the tools.

```console
$ gcloud config set project golden-cove-408
```

Now enable billing. *Note that anything you do past this point can and will 
cost you money*. Navigate to the project console and choose the billing 
settings, then click enable.

In order to create GCE machines, you need to initialize it in the browser at 
least once. Go to Compute->Compute Engine->VM instances and wait for it to show 
up with a screen that has a "create an instance" button.

The included `cloud-config.yaml` file will set up the CoreOS machine to 
automatically download and install Panamax on the first boot.

Run `./provision.sh` with the first argument as the hostname of the machine. 
The script will automatically provision a 50GB data drive for docker containers 
as well as the machine Panamax will run on.

Before provisioning, you might want to add a user config to the user-data. Here 
is an example:

```yaml
users:
  - name: xena
    gecos: Xena Cadenza
    groups:
      - sudo
      - docker
    coreos-ssh-import-github: Xe
```

```console
$ ./provision.sh caml
```

In testing the install of Panamax takes about 15 minutes. If you want you can 
monitor this install by ssh'ing into the machine as soon as you can and then 
running `journalctl -u install-panamax.service -f`.

As soon as the unit finishes, Panamax will be installed on your GCE node.

[gcutil]: https://developers.google.com/compute/docs/gcutil/#install
[devcons]: https://console.developers.google.com/project
