#!/bin/bash

# USAGE: appendProteome2MaxAnnot.sh [PATH_TO_maxquantAnnot.txt.gz] [PROTEOMEID_TAXID] [DOMAIN]
# DOMAIN options: E = Eukaryota, A = Archaea, B = Bacteria, V = Viruses
# Get the proteomeID and taxID from uniprot. The underscore between them is required

# get command line arguments
annotPath=$1
proteome=$2

if [[ $3 == "E" ]]
then
	domain="Eukaryota"
elif [[ $3 == "A" ]]
then
	domain="Archaea"
elif [[ $3 == "B" ]]
then
	domain="Bacteria"
elif [[ $3 == "V" ]]
then
	domain="Viruses"
fi

# unzip annotation file
gunzip -c $annotPath > "tmpAnnot.txt"

# download proteome mapping from uniprot
curl -O "ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/"${domain}"/"${proteome}".gene2acc.gz"

# unzip proteome mapping
gunzip ${proteome}".gene2acc.gz"

# extract second two columns
cat ${proteome}".gene2acc" | cut -d$'\t' -f2,3 > "tmpMapping.txt"

# concatenate files
cat "tmpAnnot.txt" "tmpMapping.txt" > "maxquantAnnot.txt.new"

# pad missing columns with tabs
python3 padMaxAnnot.py "maxquantAnnot.txt.new" > "maxquantAnnot.txt.padded"

# zip new annotation file
gzip -c "maxquantAnnot.txt.padded" > "maxquantAnnot.txt.gz"

# delete temp files
#rm "tmpAnnot.txt" "tmpMapping.txt" "maxquantAnnot.txt.new" "maxquantAnnot.txt.padded" ${proteome}".gene2acc"

