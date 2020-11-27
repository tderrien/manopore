guppy_version=$(grep guppy results/pipeline_info_first_step/software_versions.csv | cut -f 2 | cut -d"+" -f1)
flowcell_version=$(grep "$1 $2" flowcell_version.txt | cut -f 2 -d "_")
nanostats=$(cat results/nanoplot/summary/NanoStats.txt | sed 's/^/  /')

echo "Flowcell version: $flowcell_version"
echo "Flowcell ID: $1,"
echo "Protocol kit version: $2,"
echo "Guppy version: $guppy_version"
echo "$nanostats"