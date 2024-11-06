#!/usr/bin/bash

rm -rf out

for file in mw/* ; do
mkdir -p out/$(echo $file | cut -c 3-)
done

for file in hires/**/*.dds; do
filenameext=$(echo $file | cut -c 7-)
filename=${filenameext::-4}
echo $file
echo $filenameext
echo $filename

magick $file out/$filename.png

done
