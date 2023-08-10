# Thermus_CRISPR_recombination
Analysis of the recombinogenicity of CRISPR repeats in the bacterium Thermus thermophilus

Overview of the analysis:

To investigate the recombinogenicity of CRISPR repeats, we collected colonies of potential recombinants, extracted the DNA, and amplified potentially recombinant cassettes. We sequenced amplicons using Oxford Nanopore technology.

To find recombination events, we call CRISPR cassettes on these amplicons using CRISPRCasFinder.We extracted spacers from each read into the .fasta file (see spacers_extraction.sh) and blasted them against the database of source strain spacers (see spacers_blastn.sh). 

Then we detected recombination events in this data. 

If spacers from different cassettes (of the source strain) become consequent spacers of the same cassette (in the amplicon), we consider it a recombinogenic cassette. 

For the details of recombination detection, see junctions_search.sh.

We checked for the presence of primers in the reads (blast_primers.sh).

Integration of the data on CRISPR cassettes and primers was performed in R Markdown. 

The Data_integration.zip archive contains a directory with .rmd document and all necessary files for its work. 

See this .rmd document to find out details of data filtering and the writing of the resulting tables.

Two other archives (Heatmaps.zip and Circos_plots.zip) contain info about plot construction. Each of them contains a Jupyter notebook and all the necessary files for its work.
