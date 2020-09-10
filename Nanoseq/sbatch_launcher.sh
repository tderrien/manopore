#!/bin/bash

#SBATCH --mail-type=ALL         	
#SBATCH --mail-user=matthias.lorthiois@univ-rennes1.fr     	
#SBATCH --job-name=double_nanoseq
#SBATCH --chdir=/home/genouest/cnrs_umr6290/mlorthiois/double_nanoseq
#SBATCH --nodelist=cl1n038
#SBATCH --cpus-per-task=36
#SBATCH --mem=30G

working_directory=$(pwd)
data_repo='/home/genouest/cnrs_umr6290/mlorthiois/nanoseq_test/data'

. /local/env/envnextflow-20.04.1.sh

nextflow run nf-core/nanoseq \
    -r 1.0.0 \
    -profile singularity \
    -with-singularity /groups/dog/matthias/singularity/nfcore-nanoseq-1.0.0.img \
    --input ${working_directory}/input.csv \
    --protocol cDNA \
    --input_path ${data_repo} \
    --flowcell FLO-MIN106 \
    --kit SQK-DCS109 \
    --skip_demultiplexing \
    --skip_qc \
    --max_cpus 36

nextflow run nf-core/nanoseq \
    --input ${working_directory}/input_fasta.csv \
    --protocol cDNA \
    --input_path ${data_repo} \
    --flowcell FLO-MIN106 \
    --kit SQK-DCS109 \
    --skip_basecalling \
    --skip_demultiplexing \
    --max_cpus 30 \
    -profile singularity \
    -with-singularity /groups/dog/matthias/singularity/nfcore-nanoseq-dev.img \
    -r 1.0.0
