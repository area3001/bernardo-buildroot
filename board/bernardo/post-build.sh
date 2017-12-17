#!/bin/bash

set -u
set -e

BOARD_DIR="$(dirname $0)"

function make_real_dir
{
  DIR="$1"

  if [ -h "${TARGET_DIR}${DIR}" ]; then
    echo "TARGET: replace ${TARGET_DIR}${DIR} as dir"
    rm -f "${TARGET_DIR}${DIR}"
    mkdir -p "${TARGET_DIR}${DIR}"
  fi

  if [ ! -d "${TARGET_DIR}${DIR}" ]; then
    echo "TARGET: create dir ${TARGET_DIR}${DIR}"
    mkdir -p "${TARGET_DIR}${DIR}"
  fi
}

# copy a clean uEnv.txt to the output/images directory
cp ${BOARD_DIR}/uEnv.txt $BINARIES_DIR/uEnv.txt

mkdir -p ${BINARIES_DIR}/overlays-tmp

# compile and copy self-defined overlays
DTC=`ls ${BUILD_DIR}/linux-*/scripts/dtc/dtc | head -n1`
CPP=${HOST_DIR}/bin/arm-linux-cpp
LINUX_INCLUDE=`echo ${BUILD_DIR}/linux-*/include | head -n1 | awk '{print $1;}'`

rm -rf ${BINARIES_DIR}/overlays-tmp/*

if ! [ -x $DTC ]; then
	DTC=dtc
else
	echo "Using $DTC"
fi

for DTS in ${BOARD_DIR}/*-overlay.dts; do
	DTSNAME=`basename ${DTS%%-overlay.dts}`
	echo "Compile $DTSNAME"
    $CPP -nostdinc -I${LINUX_INCLUDE} -undef -x assembler-with-cpp $DTS > ${BINARIES_DIR}/overlays-tmp/${DTSNAME}.tmp.dts
    $DTC -@ -O dtb ${BINARIES_DIR}/overlays-tmp/${DTSNAME}.tmp.dts -o ${BINARIES_DIR}/overlays-tmp/${DTSNAME}.dtbo
    cp ${BINARIES_DIR}/overlays-tmp/${DTSNAME}.dtbo ${TARGET_DIR}/lib/firmware/${DTSNAME}.dtbo
    echo "dtb_overlay=/lib/firmware/${DTSNAME}.dtbo" >> $BINARIES_DIR/uEnv.txt
done

# test for some key directories under rund
make_real_dir /etc/dropbear
make_real_dir /boot

# add boot partition mount
grep -q "^/dev/mmcblk0p1" $TARGET_DIR/etc/fstab || echo "/dev/mmcblk0p1	/boot		vfat	defaults,rw	0	0" >> $TARGET_DIR/etc/fstab
