#!/bin/bash
#SBATCH --nodelist=genogpu2
#SBATCH --gres=gpu:1 -p gpu
#SBATCH --cpus-per-task=16
#SBATCH --mem=30G


# Do not remove parentheses!! Need to be an absolute path in format
# Do not specify fast5 dir but the parent dir to have metadata available
data_repo=(/groups/dog/data/canFam3/NGS/Melanoma/RNA/MINION/Bear/20200227_1750_MN29715_FAL43795_4f1b5364/)
sample_id="Bear"
annotation_ref="/groups/dog/data/canFam3/annotation/Ensembl99/Canis_familiaris.CanFam3.1.99.gtf"
fasta_ref="/groups/dog/data/canFam3/sequence/softmasked/Canis_familiaris.CanFam3.1.72.dna_sm.toplevel.fa"
flowcell='FLO-MIN106'
kit='SQK-DCS109'
# Choose your guppy version here : https://hub.docker.com/r/genomicpariscentre/guppy-gpu/tags
guppy_version="4.2.2"
CPU=16

. /local/env/envnextflow-20.04.1.sh

### Clone last version of Nanoseq
git clone https://github.com/nf-core/nanoseq.git
cd nanoseq

### Update Guppy version & choose cache directory
echo "singularity.cacheDir = '/home/genouest/cnrs_umr6290/mlorthiois/workspace/singularity'" >> nextflow.config
sed -i -r "s/guppy-gpu:[0-9].[0-9].[0-9]{{1,2}}/guppy-gpu:$guppy_version/g" conf/base.config

### Join fast5 pass and fail
mkdir data
find $data -name "*.fast5" | xargs ln -s -t data

### Create samplesheets
echo "sample,fastq,barcode,genome,transcriptome" >> input_first_step.csv
echo "$sample_id,,1,$fasta_ref,$annotation_ref" >> input_first_step.csv

echo "sample,fastq,barcode,genome,transcriptome" >> input_second_step.csv
echo "$sample_id,results/guppy/fastq/$sample_id.fastq.gz,1,$fasta_ref,$annotation_ref" >> input_second_step.csv

### Run Nanoseq
nextflow run main.nf \
    -profile singularity \
    -with-singularity /groups/dog/mlorthiois/singularity/nfcore-nanoseq-dev.img \
    --input input_first_step.csv \
    --protocol cDNA \
    --input_path data \
    --skip_demultiplexing \
    --max_cpus $CPU \
    --guppy_gpu true \
    --flowcell $flowcell \
    --kit $kit

mv results/pipeline_info results/pipeline_info_first_step

nextflow run nf-core/nanoseq \
    --input input_second_step.csv \
    --protocol cDNA \
    --input_path data \
    --skip_basecalling \
    --skip_demultiplexing \
    --max_cpus $CPU \
    -profile singularity

chmod +x ../getMetadata.sh && ../getMetadata.sh >> metadata_report.txt
### Add date to report
date=$(find $data_repo -name "report*.md" | xargs grep "exp_start_time" | cut -f2 -d : | tr -d ' "' | cut -f1 -d 'T')
echo "Sequencing date: $date" >> metadata_report.txt

## Put NanoPlot report on Web
new_report="results/nanoplot/summary/$sample_id.$guppy_version.$kit.$date.html"
cp results/nanoplot/summary/NanoPlot-report.html $new_report
putonWeb.sh $new_report ~tderrien/webdata/igdrion/
