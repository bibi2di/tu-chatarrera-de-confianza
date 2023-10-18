#!/bin/bash

read -p "Introduce el directorio con los archivos cuyo hash deseas: " direct
read -p "Introduce el hash: " hash

cd $direct

archivo=$(md5sum * | grep $hash)
echo -e "Archivo: [$archivo]"
echo "Fin"
exit 0
