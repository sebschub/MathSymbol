#!/bin/bash

font=$1

case $font in
    "MdSymbol" | "MnSymbol" )
	echo "Chosen font family is $font"
	;;
    *)
	echo "Entered font not supported"
	exit 1
	;;
esac

cd ..
rm source/* enc/*
cp enc/$1/* enc/
cp source/$1/* source/

cd source

for i in A B C D E F S
do
  for j in "" "-Bold"
  do
    for k in 5 6 7 8 9 10 12
    do
      mf2pt1.pl $font$i$j$k --encoding=../enc/$font$i.enc
    done
  done
done

cd ../scripts/
mkdir finalpfb
for i in "" "-Bold"
do 
  for j in 5 6 7 8 9 10 12
  do
    ./mkMn.ff $font $j $i # 2>&1 | grep -v showpage
    # ./postprocess.ff $j $i
    # t1disasm MnSymbol$i$j.pfb | gawk -f packsubr.awk | t1asm -b > finalpfb/MnSymbol$i$j.pfb
  done
done

