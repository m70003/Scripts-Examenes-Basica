#!/bin/bash

# Comprobación de argumentos y asignación de variables

if [ $# -lt 1 ]; then

    echo -e "Modo de uso: $0 extension [ directorio_1 ] [ directorio_2 ] ... [ directorio_n ]"
    exit 0

elif [ $# -eq 1 ]; then

    dir_act=.
    lista_dir=($dir_act)
    ext=$1

elif [ $# -gt 1 ]; then

    ext=$1
    lista_dir=()

    for i in $@; do
        #Añado los argumentos que se le pasa al script a una lista
        lista_dir=("${lista_dir[@]}" $i)

    done

    #Elimino el primer elemento de la lista que es la extensión
    lista_dir=( "${lista_dir[@]/$1}" )

    #echo ${lista_dir[@]}
fi

# Cuerpo del script
num=0
for i in ${lista_dir[@]}; do

    dir=$i
    temp=$(mktemp)

    ls -l $dir | grep -v ^total > $temp

    while read permisos links propietario grupo tamao mes dia hora nombrearchivo
    do

        if [ -f $dir/$nombrearchivo ]; then
            ext_archivo=${nombrearchivo#*.}

                if [ $ext_archivo = $ext ]; then
                    let num=num+1
                    echo -e " Encontrado fichero: $nombrearchivo en directorio: $dir"

                fi
        fi

    done < $temp
    rm $temp

done

echo -e "Se han encontrado $num ficheros"
exit 0
