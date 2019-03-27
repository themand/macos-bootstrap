# macos-bootstrap

This is a set of scripts which I use to bootstrap a new mac. Settings are tailored for my needs and it installs lot of software (proprietary scripts and 3rd party), so it won't suit most people out of the box.

## Usage

#### Step 1: Download and run bootstrap script

```bash
curl -sSLo macos-bootstrap-master.tar.gz https://github.com/themand/macos-bootstrap/archive/master.tar.gz
tar zxf macos-bootstrap-master.tar.gz
macos-bootstrap-master/bootstrap.sh
```
#### Step 2: Perform manual actions

* Reboot
* Configure [System Preferences](manual/macos-preferences.md) with settings which could not be set up using *defaults*
* [Install and configure Little Snitch](manual/little-snitch.md)

#### Step 3: Run install script to install various software

```bash
macos-bootstrap-master/install.sh
```

#### Step 4: 

* [Follow post-bootstrap manual](manual/INDEX.md) for next steps (installation and configuration of GUI applications)

#### Optional cleanup

```bash
rm -r macos-bootstrap-master macos-bootstrap-master.tar.gz
```
