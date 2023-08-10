#!/bin/bash
end=$((` cat ../reads/dCmr4_all_onlyname.fasta | wc -l `/2))
seqnum=0
for i in $(seq 1 $end); do

 #extract one read from large .fasta with all reads

 i_name=$((2*i-1))
 i_read=$((2*i))
 sed "${i_name}q;d" ../reads/dCmr4_all_onlyname.fasta > oneread.fasta
 sed "${i_read}q;d" ../reads/dCmr4_all_onlyname.fasta >> oneread.fasta
 readname=`sed "1q;d" oneread.fasta | cut -f2 -d '>'`

 #blast the read against a database with primers

 blastn -task blastn-short -query oneread.fasta -db /home/niagara/Storage/MetaRus/M_Zubarev/Thermus/Analysis/escaper_libraries/spacers_pseudoalignment/primers_blastdb/primers_blastdb -out ./blast_primers/${readname}.blastn -outfmt 6 -evalue 0.001
 
 #report results to a .csv table in a form "read_name,primer_state"

 if [ `cat ./blast_primers/${readname}.blastn | wc -l` -gt 2 ]; then
 echo ${readname}';multimapper' >> primers.csv 
 elif [[ `grep F1 ./blast_primers/${readname}.blastn | wc -l` -eq 1 && `grep R1 ./blast_primers/${readname}.blastn | wc -l` -eq 1 ]]; then
 echo ${readname}';F1_R1' >> primers.csv
 elif [[ `grep F1 ./blast_primers/${readname}.blastn | wc -l` -eq 1 && `grep R2 ./blast_primers/${readname}.blastn | wc -l` -eq 1 ]]; then
 echo ${readname}';F1_R2' >> primers.csv
 elif [[ `grep F2 ./blast_primers/${readname}.blastn | wc -l` -eq 1 && `grep R2 ./blast_primers/${readname}.blastn | wc -l` -eq 1 ]]; then
 echo ${readname}';F2_R2' >> primers.csv
 elif [ `grep F1 ./blast_primers/${readname}.blastn | wc -l` -eq 1 ]; then
 echo ${readname}';F1' >> primers.csv
 elif [ `grep F2 ./blast_primers/${readname}.blastn | wc -l` -eq 1 ]; then
 echo ${readname}';F2' >> primers.csv
 elif [ `grep R1 ./blast_primers/${readname}.blastn | wc -l` -eq 1 ]; then
 echo ${readname}';R1' >> primers.csv
 elif [ `grep R2 ./blast_primers/${readname}.blastn | wc -l` -eq 1 ]; then
 echo ${readname}';R2' >> primers.csv
 else
 echo ${readname}';no_primers' >> primers.csv
 fi
 seqnum=$((seqnum+1))
 echo ${seqnum}' sequences checked for primers presence'
done
