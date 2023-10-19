#!/bin/bash

##### 1 #####

function freqPalabras(){
echo "Estas son las palabras del archivo ordenadas alfabéticamente y por frecuencias"
perl -0777 -lape's/\s+/\n/g' $filename | sort | uniq -c | sort -nr
#perl -0777: perl opera sobre todo el archivo como si fuera una sola línea
#lo siguiente: la salida de perl es una palabra por línea
#sort: ordena alfabéticamente
#uniq: elimina las palabras duplicadas, -c imprime nº de ocurrencias
#sort -nr: ordena numéricamente de forma descendente
#Fuente: https://www.enmimaquinafunciona.com/pregunta/64574/como-contar-el-numero-de-apariciones-de-cada-palabra-en-un-archivo
}

##### 2 #####

function freqLetras(){
cat $filename | tr -cd '[:alpha:]' | grep -o . | sort | uniq -c | sort -nr
#quería usar perl para esto también pero no sé
#tr -cd ...: convierte todo a minúscula y elimina números etcs
#grep -o .: print only the matched parts of a matching line, with each part on a separate output line
#sort, uniq, sort: lo de antes
}

##### 3 #####

function sustituir(){
	read -p "PALABRA/LETRA QUE QUIERES REEMPLAZAR (MAYUS): " palabra1
	read -p "palabra/letra nueva (minus): " palabra2
	sed -i "s/$palabra1/$palabra2/g" resultado.txt
	echo "$palabra1 es $palabra2" >> clave.txt

}

##### 4 #####

function salir(){
	exit 0
}
#Verificación: se ha pasado archivo por parámetro ($1)
if [ $# -ne 1 ]; then
	echo "Necesito un archivo para funcionar. Chao."
	exit 1
fi

filename="$1"

#Verificación: existe el archivo
if [ ! -f "$filename" ]; then
	echo "El archivo que me has pasado no existe. Agur"
	exit 1
fi

#Creamos un archivo de resultado para que todas las modificaciones se guarden en el susodicho
touch resultado.txt
touch clave.txt
echo "" > clave.txt
cat $filename > resultado.txt


#MENÚ

opcion=0

while test $opcion -ne 4
do

echo -e ""
echo -e "MENÚ!"
echo -e "1 - Frecuencia de palabras"
echo -e "2 - Frecuencia de las letras"
echo -e "3 - Realizar sustitucion"
echo -e "4 - Salir"
read -p "Elige una opción: " opcion
echo ""
	case $opcion in
	1) freqPalabras;;
	2) freqLetras;;
	3) sustituir;;
	4) salir;;
	esac
done

