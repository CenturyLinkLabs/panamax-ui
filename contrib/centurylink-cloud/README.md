## CenturyLink Cloud
This is a guide to installing Panamax on [CenturyLink Cloud](http://www.centurylinkcloud.com)

### Create a DHCP_PXE Server in CLC
1. Login to your [CLC control panel](https://control.tier3.com)
1. Add a VLAN (e.g. CoreOSVLAN) in the data center you want to deploy Panamax to. You need to add a VLAN specific for panamax. [Here are specific steps to add a VLAN.](https://t3n.zendesk.com/entries/21806469-Creating-and-Deleting-VLANs)
1. Browse to Blueprints Library and deploy the **DHCP-PXE Server** blueprint. _NOTE_: Be sure to select the VLAN created above for network.

### Create a CoreOS Server with Panamax
1. Deploy the **CoreOS Server with Panamax** blueprint being sure to select the VLAN created above for the network.
1. For the **Execute on Server** option, be sure to select the name of the DHCP_PXE server you created in the previous step, not the CoreOS machine you are currently creating. **This is a very important step.** The server credentials entered will **NOT** actually be used to login to the server as you will use SSH key authorization to access your CoreOS servers.
1. After the Blueprint task is complete, view the **build log** and search for the text **"IP Address of CoreOS Server"** to obtain the IP address that was used for deploying the server. Take note of this address for future use as it will not be displayed in the control panel.

Panamax will be installed on the CoreOS machine by this point. 

### Final Configuration
1. Add public access for Panamax by adding a public IP to the DHCP_PXE server from the control panel
1. Open ports **22**, **3000** for the Public IP
1. SSH to the DHCP_PXE server on the Public IP with root & password given during blueprint creation: `$ ssh root@<public IP>`
1. Make note of the IP of the CoreOS VM by running the following: `$ tail /var/log/syslog`.
1. Make note of the private IP of the DHCP_PXE server by running: `$ ifconfig`.
1. Change the sshd_config file on the DHCP_PXE server so that public access is allowed:
    * Add "GatewayPorts yes" to the file **/etc/ssh/sshd_config**
    * Run: `$ service ssh restart`
1. Run the following command on the DHCP_PXE server to give access to 3000 from public IP: `$ ssh -f -N root@<DHCP server private IP> -R *:3000:<Core OS Vm IP>:3000`
1. Access Panamax at http://_public-IP_:3000 !

_NOTE_: If you prefer not to expose a public IP to access Panamax, [see these instructions.](https://t3n.zendesk.com/entries/20914433-How-To-Configure-Client-VPN)

### Reconfiguration after DHCP_PXE reboots
When ever your DHCP_PXE server is rebooted, you need to restart the SSH tunnels between the DHCP server and the CoreOS VM. Following these steps to re-establish:

1. Make note of the CoreOS private IP address by running the following on the DHCP_PXE server: `$ cat /var/log/syslog` - The IP will be included in the last entry.
1. Run the following command on the DHCP_PXE server adding the IP address from above: `$ ssh -f -N root@<DHCP_server_private_IP> -R *:3000:<CoreOS_private_IP>:3000`
