#!/bin/bash
#SBATCH --gres=gpu:1 -p gpu
#SBATCH --cpus-per-task=16
#SBATCH --mem=40G
#SBATCH --output=manopore.out
#SBATCH --job-name=manopore

################################################################################
data_repo=/home/genouest/cnrs_umr6290/mlorthiois/workspace/manopore/test_nanoseq_v1.1/data
sample_id="Bear"
annotation_ref="/groups/dog/data/canFam3/annotation/Ensembl99/Canis_familiaris.CanFam3.1.99.gtf"
fasta_ref="/groups/dog/data/canFam3/sequence/softmasked/Canis_familiaris.CanFam3.1.72.dna_sm.toplevel.fa"
flowcell='FLO-MIN106'
kit='SQK-DCS109'
CPU=16
protocol='cDNA'
################################################################################

. /local/env/envnextflow-20.04.1.sh

################################################################################
### Create samplesheets
if [ ! -f "input_first_step.csv" ]; then
    echo "Create samplesheets 1 and 2"
    echo "group,replicate,barcode,input_file,genome,transcriptome" > input_first_step.csv
    echo "$sample_id,1,1,,$fasta_ref,$annotation_ref" >> input_first_step.csv

    echo "group,replicate,barcode,input_file,genome,transcriptome" > input_second_step.csv
    echo "$sample_id,1,1,results/guppy/fastq/${sample_id}_R1.fastq.gz,$fasta_ref,$annotation_ref" >> input_second_step.csv
fi

################################################################################
nextflow run nf-core/nanoseq \
    -profile singularity \
    --input input_first_step.csv \
    --input_path $data_repo \
    --flowcell $flowcell \
    --kit $kit \
    --skip_demultiplexing \
    --max_cpus $CPU \
    --guppy_gpu true \
    --protocol $protocol \
    -r 1.1.0 \
    -resume

mv results/pipeline_info results/pipeline_info_first_step

nextflow run nf-core/nanoseq \
    -profile singularity \
    --input input_second_step.csv \
    --input_path $data_repo \
    --protocol $protocol \
    --skip_basecalling \
    --skip_demultiplexing \
    --max_cpus $CPU \
    -resume \
    -r 1.1.0

################################################################################
echo "Creating metadata_report.txt file..."
chmod +x ./getMetadata.sh && ./getMetadata.sh $flowcell $kit > metadata_report.txt
echo "metadata_report.txt file created!"

## Put NanoPlot report on Web
echo "Publishing NanoPlot report on Web..."
guppy_version=$(grep guppy results/pipeline_info_first_step/software_versions.csv | cut -f 2 | cut -d"+" -f1 | sed 's/\./-/g')
new_report="results/nanoplot/summary/${sample_id}_${guppy_version}_$kit.html"
cp results/nanoplot/summary/NanoPlot-report.html $new_report
/home/genouest/cnrs_umr6290/tderrien/bin/putonWeb.sh $new_report ~tderrien/webdata/igdrion
