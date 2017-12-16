## Prerequisites
Prerequisites on ubuntu 64 bit (for TI CGT PRU compiler 32 bit installer):

```
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libc6:i386 libx11-6:i386 libasound2:i386 libatk1.0-0:i386 libcairo2:i386 libcups2:i386 libdbus-glib-1-2:i386 libgconf-2-4:i386 libgdk-pixbuf2.0-0:i386 libgtk-3-0:i386 libice6:i386 libncurses5:i386 libsm6:i386 liborbit2:i386 libudev1:i386 libusb-0.1-4:i386 libstdc++6:i386 libxt6:i386 libxtst6:i386 libgnomeui-0:i386 libusb-1.0-0-dev:i386 libcanberra-gtk-module:i386 gtk2-engines-murrine:i386
```

Prerequisites for buildroot [https://buildroot.org/downloads/manual/manual.html#requirement-mandatory]()

## Getting started
Clone the repository
```
git clone https://github.com/area3001/bernardo-buildroot
cd bernardo-buildroot
git submodule update --init
cd buildroot
```
To build:
```
make BR2_EXTERNAL=../ bernardo_defconfig
make BR2_EXTERNAL=../
```
Use the option ```BR2_JLEVEL=<number>``` to set the ```J=<number>``` for make. Then wait...

## TODO
* define the device tree for the bernardo cape
* Optimize the kernel defconfig
* Configure sigrok
* Add startup scripts and udev rules
* Documentation
