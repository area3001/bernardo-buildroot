#!/bin/bash
#Script that will download, compile and install PulseView and its dependencies
# For more information visit:
# https://onetransistor.blogspot.com/2017/11/script-to-compile-and-install-pulseview.html

set -e

echo "PulseView: Download, build and install"
echo "Installing dependencies"

sudo apt -y install autoconf autoconf-archive automake check cmake doxygen g++ gcc git-core libboost-filesystem-dev libboost-system-dev libboost-test-dev libboost-thread-dev libftdi-dev libglib2.0-dev libglibmm-2.4-dev libqt5svg5-dev libtool libusb-1.0-0-dev libzip-dev make pkg-config python3-dev python-dev python-gi-dev python-numpy python-setuptools qtbase5-dev swig libserialport-dev libftdi1-dev libieee1284-3-dev

echo "Downloading and building sources"
mkdir -p pulseview_sources
cd pulseview_sources

echo "1. libserialport"
git clone git://sigrok.org/libserialport
cd libserialport
./autogen.sh
./configure
make
sudo make install
cd ..

echo "2. libsigrok"
git clone git://sigrok.org/libsigrok
cd libsigrok
./autogen.sh
./configure
make
sudo make install
cd ..

echo "3. libsigrokdecode"
git clone git://sigrok.org/libsigrokdecode
cd libsigrokdecode
./autogen.sh
./configure
make
sudo make install
cd ..

echo "4. pulseview"
git clone git://sigrok.org/pulseview
cd pulseview
cmake .
make
sudo make install
cd ..

echo "Deleting sources"
cd ..
rm -rf pulseview_sources

echo "Done"
