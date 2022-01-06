#!/bin/bash

#PRIMERA PARTE, CONFIRMACIONES Y VERICACIÓN DE ARGUMENTOS

if [ $# -gt 3 -o $# -lt 2 ];  then

    echo -e "Modo de uso: $0 ficheroConexiones user [ mes ]"
    exit 0

elif [ $# -eq 3 ]; then


    if ! [ -d $1 ]; then

        echo -e "Directorio $1 no existe o bien no es un directorio"
        exit 0

    elif [ $2 = "reboot" ]; then

        echo -e "Usuario no válido: $2"
        exit 0

    elif [ $3 != "Jan" -a  $3 != "Feb" -a $3 != "Mar" -a $3 != "Abr" -a $3 != "May" -a $3 != "Jun" -a $3 != "Jul" -a $3 != "Ago" -a $3 != "Sep" -a $3 != "Oct" -a $3 != "Nov" -a $3 != "Dic" ]; then

        echo -e "$3 no es un mes del año"
        exit 0

    else

        dir=$1
        usr=$2
        mes=$3
        mediante_mes="True"

    fi

elif [ $# -eq 2 ]; then

    if ! [ -d $1 ]; then

        echo -e "Directorio $1 no existe o bien no es un directorio"
        exit 0

    elif [ $2 = "reboot" ]; then

        echo -e "Usuario no válido: $2"
        exit 0

    else

        dir=$1
        usr=$2
        mediante_mes="False"

    fi

fi

# SEGUNDA VERSIÓN, RECORRER UN DIRECTORIO E IMPRIMIR LOS ATRIBUTOS DE LOS FICHEROS
# TERCERA VERSION; SABE TRABAJAR CON Kib Y Mib
# CUARTA VERSIÓN; SABE BORRAR ARCHIVOS MAS PEAADOS QUE EL UMBRAL DADO

temp=$(mktemp)

cat $dir > $temp

horas=0
minutos=0
horas_max=0
min_max=0

while read usuario terminal dia Mes dia_del_mes hora_inicio guion hora_fin tiempo_total direccion_ip
do
    if [ $mediante_mes = "True" ]; then

        if [ $usuario = $usr -a $Mes = $mes ]; then

                horas_u=${tiempototal#"\*:"}
                minutos_u=${tiempototal%"\*:"}

                ip=$direccion_ip

                let horas=horas+horas_u
                let minutos=minutos+minutos_u

                if [ $horas_u -gt $horas_max ]; then

                    horas_max=$horas_u
                    min_max=$min_max

                elif [ $horas_u -eq $horas_max ]; then

                    if [ $minutos_u -gt $min_max ]; then

                        horas_max=$horas_u
                        min_max=$min_max

                    fi

                fi

        fi

    else

        if [ $usuario = $usr ]; then

                horas_u=${tiempototal#"\*:"}
                minutos_u=${tiempototal%"\*:"}

                ip=$direccion_ip

                let horas=horas+horas_u
                let minutos=minutos+minutos_u

                if [ $horas_u -gt $horas_max ]; then

                    horas_max=$horas_u
                    min_max=$min_max

                elif [ $horas_u -eq $horas_max ]; then

                    if [ $minutos_u -gt $min_max ]; then

                        horas_max=$horas_u
                        min_max=$min_max

                    fi

                fi

        fi


    fi

done < $temp
rm $temp

echo -e "El usuario $usr ha estado conectado un total de: \n\t * $horas horas y $minutos minutos \n\n Tiempo máximo de conexión: $horas_max horas y $min_max minutos desde $ip"

exit 0
