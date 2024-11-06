#!/usr/bin/bash

rm -rf out

for file in mw/* ; do
    mkdir -p out/$(echo $file | cut -c 3-)
done

rm -rf workfold
mkdir workfold


for file in hires/**/*.dds; do
    filenameext=$(echo $file | cut -c 7-)
    filename=${filenameext::-4}
    filenameextspell=$(echo $filenameext | cut -c 5-)
    echo $file
    echo $filenameext
    echo $filename
    echo $filenameextspell

    res=256
    #magick $file out/$filename.png
    magick $file workfold/1.png

    while [ $res -gt 4 ] ; do
        echo $file: $res
        magick $file -scale $resx$res workfold/$res.png
        res=$(($res/2))
    done

    case ""$file"" in

        *\/s\/*)
            echo SPELL
            echo converting normal spell
            magick mw/s/${filenameextspell,,} workfold/16.png
            echo converting big spell
            magick mw/${filenameext,,} workfold/32.png
        ;;

        *)
            normal
            echo converting normal image
            magick mw/${filenameext,,} workfold/32.png
        ;;
    esac

done
