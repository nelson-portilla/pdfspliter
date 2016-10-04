#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Author: Nelson Portilla

if [ "$#" = "0" ]; then
	echo $'\nsplitPDF [param1] [param2]\n'
	echo "param1: Archivo pdf de entrada"
	echo "param2: Archivo plano con la secuencia"$'\n'
	exit
fi
filepdf=$1
listaserie=$2

numeropaginas=$(pdftk $filepdf dump_data | grep NumberOfPages | cut -c16-)
folder=${filepdf/.pdf/""}
mkdir $folder
paginas=$((10#$numeropaginas))
cd "$folder/"
paginicial=$((10#1))
while IFS='' read -r line || [[ -n "$line" ]]; do
	if (($line > $paginas)); then
	echo $'\nEl numero excede al total de paginas\n'
	echo 'Corrija la serie en el archivo'
	exit
	else
    echo "Text read from file: $line"
	pdftk "$filepdf" cat $paginicial-$line output "$folder$paginicial-_-$line.pdf"
	mv "$folder$paginicial-_-$line.pdf" "$folder"			
	fi
	paginicial=$((10#$line))
done < "$2"
if (($paginicial < $paginas)); then
	echo "Ultima particion: de $paginicial a $paginas"
	pdftk "$filepdf" cat $paginicial-$paginas output "$folder$paginicial-_-$paginas.pdf"
	mv "$folder$paginicial-_-$paginas.pdf" "$folder"
fi
