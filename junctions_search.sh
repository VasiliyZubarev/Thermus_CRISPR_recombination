#!/bin/bash

#The goal of this script is to find events of recombination.
#To do this, it will use blastn result files from the ./spacers_blastn directory (see previous "spacers_blastn.sh" script).
#If the read contains two consequent spacers from two different cassettes of source strain, we consider this event as recombination.

seqnum=0
for filename in ` ls ./spacers_blastn `; do
 readname=` echo ${filename} | cut -f1 -d '.' | cut -f1 -d '_' `
 cassette_previous=` cat ./spacers_blastn/$filename | head -n 1 | cut -f2 -d '	' | cut -f1 -d '_' `
 spacer_previous=` cat ./spacers_blastn/$filename | head -n 1 | cut -f2 -d '	' | cut -f2 -d '_' `
 linenum=1
 jnct=0
 for line in ` cat ./spacers_blastn/${filename} | tr '	' ';' `; do
 cassette_current=` echo ${line} | cut -f2 -d ';' | cut -f1 -d '_' `
 spacer_current=` echo ${line} | cut -f2 -d ';' | cut -f2 -d '_' `

 #Scan the read with "sliding window" comparing current and previous source cassette of each spacer. 
 #If the recombination event is found, report the pair of adjacent spacers that originates from different cassettes with their coordinates on the read.

  if [ ${cassette_current} != ${cassette_previous} ]; then
    start_spacer_current=$((`grep CRISPRspacer ./dCmr4_raw_gff/${readname}.gff | sed "${linenum}q;d" | cut -f4 -d '	'`+`sed "${linenum}q;d" ./spacers_blastn/${filename} | cut -f7 -d '	'`-1))
    end_spacer_current=$((`grep CRISPRspacer ./dCmr4_raw_gff/${readname}.gff | sed "${linenum}q;d" | cut -f4 -d '	'`+`sed "${linenum}q;d" ./spacers_blastn/${filename} | cut -f8 -d '	'`-1))
    start_spacer_previous=$((`grep CRISPRspacer ./dCmr4_raw_gff/${readname}.gff | sed "$((linenum-1))q;d" | cut -f4 -d '	'`+`sed "$((linenum-1))q;d" ./spacers_blastn/${filename} | cut -f7 -d '	'`-1))
    end_spacer_previous=$((`grep CRISPRspacer ./dCmr4_raw_gff/${readname}.gff | sed "$((linenum-1))q;d" | cut -f4 -d '	'`+`sed "$((linenum-1))q;d" ./spacers_blastn/${filename} | cut -f8 -d '	'`-1))
    echo ${readname}';'${cassette_previous}';'${spacer_previous}';'${start_spacer_previous}';'${end_spacer_previous}';'${cassette_current}';'${spacer_current}';'${start_spacer_current}';'${end_spacer_current} >> dCmr4_junctions.csv
    jnct=$((jnct+1))
  fi
  cassette_previous=${cassette_current}
  spacer_previous=${spacer_current}
  linenum=$((linenum+1)) 
 done

#More than one recombination per read is something strange. Report such cases.

 if [ ${jnct} -gt 1 ]; then
  echo 'Warning: cassette with '${jnct}' junctions reported: read '${readname}
 fi
  seqnum=$((seqnum+1))
  echo ${seqnum}' sequences scanned for junctions'
done
