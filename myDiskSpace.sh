#!/bin/bash

if ! [ $# -eq 2 ]; then

    echo -e "Modo de uso: $0 directorio audio|imagen|office|video"
    exit 0

else

    dir=$1
    archivo=$2

case $archivo in

    audio)
        ext=(mp3 ogg wav);;

    imagen)
        ext=(jpeg jpg png gif);;

    office)
        ext=(doc odt xls ods);;

    video)
        ext=(avi mkv mp4);;

    *)
        echo "Tipo de fichero no permitido: $archivo"+
        exit
esac

temp=$(mktemp)

ls -l $dir | grep -v ^total > $temp

tam=0
while read permisos links propietario grupo tamao mes dia hora nombrearchivo
do

    if [ -f $dir/$nombrearchivo ]; then

        extension={$nombrearchivo%"\*."}
        for i in ${ext[@]}
        do

            if [  $extension = $i ]

                let tam=tam+$tamao

            fi

        done

    fi

done < $temp
rm $temp
let mebi=1024*1024
tamb=$(echo "scale=2; $tam/$mebi" | bc -l)
echo -e "Los ficheros de tipo $archivo ocupan $tamb Mebibytes en el directorio $dir"
exit
