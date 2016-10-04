#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Author: Nelson Portilla

if [ "$#" = "0" ]; then
	echo $'\nsplitPDF [param1] [param2]\n'
	echo "param1: Archivo pdf de entrada"
	echo "param2: Rango de paginas"$'\n'
	exit
fi
filepdf=$1
rango=$(($2-1))
numeropaginas=$(pdftk $filepdf dump_data | grep NumberOfPages | cut -c16-)
folder=${filepdf/.pdf/""}
mkdir $folder
paginas=$((10#$numeropaginas))
cd "$folder/"
for ((i=1; i<=$paginas; i++))
	do
		limite=$(($i + $rango))
		if (($limite > $paginas)); then
			echo "Last One"
			pdftk "$filepdf" cat $i-$paginas output "$folder$i-_-$paginas.pdf"
			mv "$folder$i-_-$paginas.pdf" "$folder"
			i=$(($i + $rango))
		else
			pdftk "$filepdf" cat $i-$limite output "$folder$i-_-$limite.pdf"
			mv "$folder$i-_-$limite.pdf" "$folder"
			i=$(($i + $rango))
		fi

			


	done
