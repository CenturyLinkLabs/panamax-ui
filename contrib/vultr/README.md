## Vultr

### Create a CoreOS VM on Vultr
1. [Follow these instructions](https://coreos.com/docs/running-coreos/cloud-providers/vultr/) using the Stable branch.
1. When creating your VM, be sure to select the 2CPU, 2GB flavor at a minimum.
1. Make note of the public IP for your CoreOS VM after its created

### Install Panamax

1. Once the VM is created, SSH into the box.

   `$ ssh core@<Public IP of the VM>`

1. Run: `$ sudo su`
1. Download & unzip the latest setup script from [http://download.panamax.io/installer/pmx-installer-latest.zip](http://download.panamax.io/installer/pmx-installer-latest.zip):

    `$ curl -O http://download.panamax.io/installer/pmx-installer-latest.zip && unzip pmx-installer-latest.zip -d /var/panamax`
1. Change to the /var/panamax directory: `$ cd /var/panamax`
1. Run: `$ ./coreos install --stable`
1. Once the installer completes, you can access panamax at: `http:// _Public IP_ :3000/`
