#!/bin/bash

#SBATCH --mail-type=ALL
#SBATCH --nodelist=genogpu2
#SBATCH --gres=gpu:1 -p gpu
#SBATCH --cpus-per-task=5
#SBATCH --mem=30G
#SBATCH --output=directRNA.out

. /local/env/envsnakemake-5.20.1.sh

snakemake --use-conda --cores 5