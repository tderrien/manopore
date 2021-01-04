# Manopore

Manopore is based on [Nanoseq](https://github.com/nf-core/nanoseq) which is a bioinformatics analysis pipeline that can be used to perform basecalling, demultiplexing, mapping and QC of Nanopore DNA/RNA sequencing data. Nanoseq v1.1 also perform a reference-guided transcript discovery and quantification using [bambu](https://github.com/GoekeLab/bambu).

## Usage

1. Add at the top of `sbatch_launcher.sh`:

   - The directory where your fast5 are located.
   - The sample id.
   - The reference annotation and genome.
   - The Flowcell ID and the kit.
   - The protocol (cDNA, directRNA, DNA)

2. Everything is done on your side. Now, Manopore will automaticaly create the input files, run Nanoseq on GPU, and put a Quality Check online (NanoPlot).

## Outputs

At the end of Manopore, you will find :

- The `fastq.gz` file created by guppy.
- All the Quality Control done by PycoQC, NanoPlot, MultiQC.
- The sorted BAM file computed by minimap2
- BigWig and bigBed for visualisation.
- Transcript reconstruction and quantification (bambu).

## Issues

At the moment (Dec 2020), it presents a problem (see [issue](https://github.com/nf-core/nanoseq/issues/77)), and has to be used in two steps. (04/01/20 : [Should be fixed in the next release](https://github.com/nf-core/nanoseq/issues/77#issuecomment-748228147))
