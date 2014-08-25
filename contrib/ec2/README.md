## Amazon Web Services - EC2
This is a guide to installing Panamax on [EC2 CoreOS AMI](http://coreos.com/docs/running-coreos/cloud-providers/ec2/)

### Create a CoreOS VM in EC2
1. Choose **Launch Instance** in EC2 Dashboard 
1. Select **Community AMIs** in AMI Selection wizard and search for **CoreOS**. Recommended images are: _CoreOS-stable-367.1.0-hvm_ and _CoreOS-stable-367.1.0_.
1. Make sure the AMI has the following specs at **minimum**: 1 vCPU, 4 GB RAM, 40 GB HDD. For example, **m3.medium** at a minimum.
1. Select Auto-assign Public IP as **enabled**.
1. Change storage to Root (/dev/xvda) to 40GB General Purpose (SSD)
1. Configure the following security rules by opening the following ports:
   * 22,TCP, Source= Anywhere
   * 3000, TCP, Source = Anywhere
   * If your App requires additional ports, make sure to go       back and add them.) 
1. Create and save your key as a local file (e.g coreos-private-key.pem).
1. Run `$ chmod 400 coreos-private-key.pem` to change permission on .pem file to use in SSH

### Install Panamax

1. Once the VM is created, SSH into the box with:

   `$ ssh -i  coreos-private-key.pem core@<AMI public DNS ID or Public IP of the VM>`

1. Confirm your CoreOS version is 367.1.0 by running `$ cat /etc/os-release` and confirm you are on the stable branch by running `$ cat /etc/coreos/update.conf`
1. Run: `$ sudo su`
1. Download & unzip the latest setup script from [http://download.panamax.io/installer/pmx-installer-latest.zip](http://download.panamax.io/installer/pmx-installer-latest.zip):

    `$ curl -O http://download.panamax.io/installer/pmx-installer-latest.zip && unzip pmx-installer-latest.zip -d /var/panamax`
1. Change to the /var/panamax directory: `$ cd /var/panamax`
1. Run: `$ ./coreos install --dev`
1. Once the installer completes, you can access panamax at: `http:// _Public IP_ :3000/`

[See our Known Issues page for items related to an EC2 installation.](https://github.com/CenturyLinkLabs/panamax-ui/wiki/Known-Issues#running-on-ec2)

