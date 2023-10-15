#!/bin/bash

read -p "Introduce el directorio con los archivos cuyo hash deseas: " direct
read -p "Introduce el hash: " hash
read -p "Introduce el nombre/nombre en común de los archivos: " nom
cd $direct

archivo=$(md5sum $nom* | grep $hash)
echo -e "Archivo: [$archivo]"
echo "Fin"
exit 0
