#!/bin/bash

#The directory ./dCmr4_raw_gff contains .gff files with annotation of CRISPR cassettes (one file per one ONP read).
#The goal of this script is to extract spacers from each read to a .fasta file in a new directory ./spacer_extraction 

seqnum=0
for filename in ` ls ./dCmr4_raw_gff `; do 
 grep 'CRISPRspacer' ./dCmr4_raw_gff/${filename} > ./spacer_extraction/spacer_lines.txt
 cat ./spacer_extraction/spacer_lines.txt | cut -f9 -d '	' | cut -f1 -d ';' | cut -f2 -d '=' > ./spacer_extraction/spacers.txt
 count=1
 readname=` echo ${filename} | cut -f1 -d '.' `
 fastaname=${readname}_spacers.fasta
 for spacer in ` cat ./spacer_extraction/spacers.txt `; do
  spacername=read_${readname}_spacer_${count}
  echo '>'${spacername} >> ./spacer_extraction/${fastaname}
  echo ${spacer} >> ./spacer_extraction/${fastaname}
  count=$((count+1))
 done
seqnum=$((seqnum+1))
echo 'spacers extracted to a .fasta files for '${seqnum}' sequences'
done
