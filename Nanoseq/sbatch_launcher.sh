#!/bin/bash

#SBATCH --job-name=double_nanoseq
#SBATCH --chdir=${working_directory}
#SBATCH --nodelist=genogpu2
#SBATCH --gres=gpu:1 -p gpu
#SBATCH --cpus-per-task=16
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
    --max_cpus 16
    --guppy_gpu true \
    --guppy_config /groups/dog/script/ont/ont-guppy/data/dna_r9.4.1_450bps_hac.cfg

nextflow run nf-core/nanoseq \
    --input ${working_directory}/input_fasta.csv \
    --protocol cDNA \
    --input_path ${data_repo} \
    --flowcell FLO-MIN106 \
    --kit SQK-DCS109 \
    --skip_basecalling \
    --skip_demultiplexing \
    --max_cpus 16 \
    -profile singularity \
    -with-singularity /groups/dog/matthias/singularity/nfcore-nanoseq-dev.img \
    -r 1.0.0
