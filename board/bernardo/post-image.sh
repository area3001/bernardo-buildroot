#!/bin/sh

BOARD_DIR="$(dirname $0)"

# copy the uEnv.txt to the output/images directory
cp ${BOARD_DIR}/uEnv.txt $BINARIES_DIR/uEnv.txt

# compile and copy self-defined overlays
DTC=`ls ${BUILD_DIR}/linux-*/scripts/dtc/dtc | head -n1`
if ! [ -x $DTC ]; then
	DTC=dtc
else
	echo "Using $DTC"
fi

for DTS in ${BOARD_DIR}/*-overlay.dts; do
	DTSNAME=`basename ${DTS%%-overlay.dts}`
	echo "Compile $DTSNAME"
	$DTC -O dtb $DTS -o ${BINARIES_DIR}/${DTSNAME}.dtbo
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
