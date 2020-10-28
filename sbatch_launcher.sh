#!/bin/bash

#SBATCH --chdir=${working_directory}
#SBATCH --nodelist=genogpu2
#SBATCH --gres=gpu:1 -p gpu
#SBATCH --cpus-per-task=${CPU}
#SBATCH --mem=30G

working_directory=$(pwd)
data_repo='/home/genouest/cnrs_umr6290/mlorthiois/nanoseq_test/data'
CPU=16

. /local/env/envnextflow-20.04.1.sh

nextflow run nf-core/nanoseq \
    -r 1.0.0 \
    -profile singularity \
    -with-singularity /groups/dog/mlorthiois/singularity/nfcore-nanoseq-dev.img \
    --input ${working_directory}/input_first_step.csv \
    --protocol cDNA \
    --input_path ${data_repo} \
    --skip_demultiplexing \
    --max_cpus $CPU \
    --guppy_gpu true \
    --guppy_config /groups/dog/script/ont/ont-guppy/data/dna_r9.4.1_450bps_hac.cfg

mv results/pipeline_info results/pipeline_info_first_step

nextflow run nf-core/nanoseq \
    --input ${working_directory}/input_second_step.csv \
    --protocol cDNA \
    --input_path ${data_repo} \
    --skip_basecalling \
    --skip_demultiplexing \
    --max_cpus $CPU \
    -profile singularity \
    -r 1.0.0

chmod +x getMetadata.sh && ./getMetadata.sh >> metadata_report.txt
