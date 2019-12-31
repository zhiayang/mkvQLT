#!/usr/bin/env bash

if [ -z "${TARGET_BUILD_DIR}" ]; then
	echo "please set TARGET_BUILD_DIR"
	exit -1
fi

if [ -z $(which yasm) ]; then
	echo "yasm not found"
	exit -1
fi

PREFIX="${PROJECT_DIR}/ffmpeg/"
echo "prefix: ${PREFIX}"
echo "intermediate output: ${TARGET_TEMP_DIR}"

FFMPEG_DIR="${PROJECT_DIR}/external/ffmpeg"

mkdir -p ${TARGET_TEMP_DIR}
pushd ${TARGET_TEMP_DIR}

	echo "now in $(pwd)"

	if [ -f "config.h" ]; then
		echo "skipping ffmpeg configuration"
	else
		echo "configuring ffmpeg..."

		${FFMPEG_DIR}/configure --prefix=${PREFIX} --disable-programs --disable-doc --disable-network --disable-indevs --disable-outdevs --disable-avdevice --disable-muxers --disable-encoders --disable-bsfs --disable-filters --disable-protocols --disable-postproc --disable-decoders --enable-encoder=png --enable-protocol=file --enable-decoder=h264 --enable-decoder=hevc --enable-decoder=jpeg2000 --enable-decoder=jpegls --enable-decoder=mjpeg --enable-decoder=mjpegb --enable-decoder=mpeg1video --enable-decoder=mpeg2video --enable-decoder=mpeg4 --enable-decoder=mpegvideo --enable-decoder=png --enable-decoder=wmv1 --enable-decoder=wmv2 --enable-decoder=wmv3 --enable-decoder=wmv3image --enable-decoder=vp8 --enable-decoder=vp9 --enable-gpl --enable-hardcoded-tables
	fi

	echo "building ffmpeg..."
	make -j`sysctl -n hw.ncpu` install

popd
