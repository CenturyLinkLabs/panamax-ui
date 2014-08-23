## Brightbox

### Create a CoreOS VM on Brightbox
1. Create a new server group with the following Firewall rules:
   * 22,TCP, Source= Anywhere
   * 3000, TCP, Source = Anywhere
   * Any additional ports your application requires
1. On the Image Library dashboard, search for the CoreOS image: _img-vxa1g_, and create a new Cloud Server
   * Select the server cloud create above
   * Use, at minimum, the Small (2GB) Server type
1. Create a new public IP on the Cloud IPs dashboard and assign it to the newly created CoreOS server

### Install Panamax

1. Once the VM is created, SSH into the box. _NOTE_: you previously needed to upload your public key to Brightbox.

   `$ ssh core@<Public IP of the VM>`

1. Run: `$ sudo su`
1. Download & unzip the latest setup script from [http://download.panamax.io/installer/pmx-installer-latest.zip](http://download.panamax.io/installer/pmx-installer-latest.zip):

    `$ curl -O http://download.panamax.io/installer/pmx-installer-latest.zip && unzip pmx-installer-latest.zip -d /var/panamax`
1. Change to the /var/panamax directory: `$ cd /var/panamax`
1. Run: `$ ./coreos install --stable`
1. Once the installer completes, you can access panamax at: `http:// _Public IP_ :3000/`

