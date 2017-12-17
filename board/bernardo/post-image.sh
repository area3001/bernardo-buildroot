#!/bin/sh

BOARD_DIR="$(dirname $0)"

# copy the uEnv.txt to the output/images directory
cp ${BOARD_DIR}/uEnv.txt $BINARIES_DIR/uEnv.txt

mkdir -p ${BINARIES_DIR}/overlays

# compile and copy self-defined overlays
DTC=`ls ${BUILD_DIR}/linux-*/scripts/dtc/dtc | head -n1`
CPP=${HOST_DIR}/bin/arm-linux-cpp
LINUX_INCLUDE=`echo ${BUILD_DIR}/linux-*/include | head -n1 | awk '{print $1;}'`

rm -rf ${BINARIES_DIR}/overlays/*

if ! [ -x $DTC ]; then
	DTC=dtc
else
	echo "Using $DTC"
fi

for DTS in ${BOARD_DIR}/*-overlay.dts; do
	DTSNAME=`basename ${DTS%%-overlay.dts}`
	echo "Compile $DTSNAME ${LINUX_INCLUDE}"
    $CPP -nostdinc -I${LINUX_INCLUDE} -undef -x assembler-with-cpp $DTS > ${BINARIES_DIR}/overlays/${DTSNAME}.tmp.dts
    $DTC -@ -O dtb ${BINARIES_DIR}/overlays/${DTSNAME}.tmp.dts -o ${BINARIES_DIR}/overlays/${DTSNAME}.dtbo
done

GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

genimage \
    --rootpath "${TARGET_DIR}" \
    --tmppath "${GENIMAGE_TMP}" \
    --inputpath "${BINARIES_DIR}" \
    --outputpath "${BINARIES_DIR}" \
    --config "${GENIMAGE_CFG}"
