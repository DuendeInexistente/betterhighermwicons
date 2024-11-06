#!/usr/bin/bash

rm -rf out

for file in mw/* ; do
    mkdir -p out/icons/$(echo $file | cut -c 3-)
done

rm -rf workfold
mkdir workfold


for file in hires/**/*.dds; do
    filenameext=$(echo $file | cut -c 7-)
    filename=${filenameext::-4}
    filenameextspell=$(echo $filenameext | cut -c 5-)
    filenamenpspell=$(echo $filenameext | cut -c 3-)
    echo $file
    echo $filenameext
    echo $filename
    echo $filenameextspell
    echo $filenamenpspell

    rebuilddds () {
    magick workfold/256.png workfold/128.png workfold/64.png workfold/32.png workfold/16.png workfold/8.png  -define dds:mipmaps=fromlist out/icons/$filename.dds
}

#Downscaling
    res=256
    #magick $file out/$filename.png
    magick $file workfold/1.png

    while [ $res -gt 4 ] ; do
        echo $file: $res
        magick $file -scale $resx$res workfold/$res.png
        res=$(($res/2))
    done
#Inserting original images as mipmaps
    case "$file" in


        *_ori.dds | *_alt_*)
        echo lol doing nothing
        ;;

        *\/s\/B_*)
            echo SPELL
            echo converting normal spell
            magick mw/s/${filenameextspell,,} workfold/16.png
            echo converting big spell
            magick mw/${filenameext,,} workfold/32.png
            rebuilddds
            cp out/icons/$filename.dds out/icons/s/b_$filenameextspell
        ;;

        *\/s\/*)
#           we don't want to do anything here
        ;;

        *)
            echo normal
            echo converting normal image
            magick mw/${filenameext,,} workfold/32.png
            rebuilddds
        ;;
    esac



rm -rf workfold


done


for file in out/icons/s/b_* ; do
        #We don't actually want to do this, the game doesn't use mipamps here.
        cp $file $(echo $file | sed -r 's/b_|B_//g')
        echo $(echo $file | sed -r 's/b_|B_//g')
done


#   for file in out/icons/s/B_* ; do     ✔
#   filenob=$(echo $file | sed -r 's/b_|B_//g')
#   echo $file $filenob
#   done
