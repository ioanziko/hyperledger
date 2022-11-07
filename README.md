## HFabD+M

HFabD+M is a web-based platform for deploying and managing a Hyperledger Fabric network.

## Features 

HFabD+M supports:
- Automate deployment of Hyperledger Fabric Network
- Chaincode and package distribution
- Universal Managment Channel

## Video Presentation

https://user-images.githubusercontent.com/21145894/176901978-65e19cf3-953b-47e1-989c-77a2b77f9eb4.mp4

## Getting Started 
1. Run ```./pre_setup.sh <HOSTNAME> <USERNAME> <PASSWORD>``` (/EXTRA FILES and SOURCE CODES/pre_setup.sh) which install Apache and create the proper certifications. Username and password that you give as attributes is the credentials for Apache. 
2. Copy all files/folders exept /EXTRA FILES and SOURCE CODES into ```var/www/html```.
3. Download the [Hyperledger Fabric](https://hyperledger-fabric.readthedocs.io/en/latest/install.html) manually and place them in ```var/www/html/bin``` folder.
4. Open the web page (localhost, 127.0.0.1, hostname) service in any browser. 
5. Following the steps as shown on the presentation video.

## TODO
- Documentation
- Create web based platform for the managment tools
- Fix folders permission problems

**New Version Available 20/11/2022**
