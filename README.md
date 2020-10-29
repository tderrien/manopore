# Informations

- [Nanoseq](https://github.com/nf-core/nanoseq) is a bioinformatics analysis pipeline that can be used to perform basecalling, demultiplexing, mapping and QC of Nanopore DNA/RNA sequencing data.
- At the moment (Oct 2020), it presents a problem (see [issue](https://github.com/nf-core/nanoseq/issues/77)), and has to be used in two steps.
- The singularity images that working are stored in `/groups/dog/mlorthiois/singularity`.

# Usage

1. In `sbatch_launcher`, add :

   - The base directory of your sample (not fast5_pass or fast5_fail, the parent dir)
   - The reference annotation and genome
   - The Flowcell ID and the kit
   - The version of Guppy (need to be available [here](https://hub.docker.com/r/genomicpariscentre/guppy-gpu/tags))

2. This pipeline will automaticaly create the input files, pull Nanoseq from github, run Nanoseq on GPU, and put a Quality Check online (NanoPlot).

# Guppy mode

To print all `genouest` guppy workflows :

```
/groups/dog/script/ont/ont-guppy/bin/guppy_basecaller --print_workflows
```
