#!/bin/bash

# Example of bash/awk/R  for mAtthais 
####################################

# list all sequencing summary file
LST=$(find /groups/dog/matthias/bench_nanoseq/results/twiny_RAD004 -name "sequencing_summary.txt" | grep -v work)


for f in $LST;do


	# extract guppy version
	guppy_version=$(echo $f | sed -e 's/\// /g' | awk '{print $7}')
	
	# extract sample_id
	sample_id=$(    echo $f | sed -e 's/\// /g' | awk '{print $6}')

	# get only pass reads and pass bash to awk variables with -v
	 awk -v guppy_version=$guppy_version -v sample_id=$sample_id 'NR>1{print sample_id, guppy_version, $15}' $f

done | awk 'BEGIN{print "sample_id guppy_version mean_qscore_template"}{print $0}' >  mean_qscore_template_pass.txt
####################################

# Then in R with 3.5.1
source /local/env/envr-3.5.1.sh
conda activate /home/genouest/cnrs_umr6290/mlorthiois/workspace/macfab/.snakemake/conda/614739c0

# install.package("reshape") if not installed
Rscript plot.R
