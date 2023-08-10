#!/bin/bash

#The directory ./spacer_extraction contains .fasta files with all CRISPR spacers from each ONP read (see "spacer_extraction.sh" script).
#The goal of this script is to blast spacers against database of initial strain spacers (./dCmr4_spacers_blastdb/dCmr4_spacers_blastdb) and determine origin of each spacer.


#to count spacers that are blasted properly (one significant blast hit)
#we will retain only cassettes with all spacers blasted properly.
good_align=0

#to count spacers with more than one significant blast hit (poor sequencing quality can lead to that)
multialign=0

#to count spacers with no significant blast hits (poor sequencing quality can lead to that)
no_align=0

seqnum=0
for filename in ` ls ./spacer_extraction `; do
readname=` echo ${filename} | cut -f1 -d '.' `
blastn_name=${readname}_spacers.blastn
blastn -task blastn-short -query ./spacer_extraction/${filename} -db ./dCmr4_spacers_blastdb/dCmr4_spacers_blastdb -out ./spacers_blastn/${blastn_name} -outfmt 6 -evalue 1.0e-5
spacers_n=` cat ./spacer_extraction/${filename} | grep '>' | wc -l `
targets_n=` cat ./spacers_blastn/${blastn_name} | cut -f2 -d '	' | sort | uniq | wc -l `
mapped_n=` cat ./spacers_blastn/${blastn_name} | cut -f1 -d '	' | sort | uniq | wc -l `

if [ ${mapped_n} -lt ${targets_n} ]; then
 multialign=$((multialign+1))
 rm ./spacers_blastn/${blastn_name}
elif [ ${mapped_n} -lt ${spacers_n} ]; then
 no_align=$((no_align+1))
 rm ./spacers_blastn/${blastn_name}
else
 good_align=$((good_align+1))
fi

seqnum=$((seqnum+1))
echo ${seqnum}' spacer sets blasted against spacer database'
done
echo mutlimapped: $multialign unmapped: $no_align mapped $good_align

