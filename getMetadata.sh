guppy_version=$(grep guppy results/pipeline_info/software_versions.csv | cut -f 2)
flowcell_id=$(grep " - Flowcell ID: " results/pipeline_info_first_step/pipeline_report.txt | cut -f 2 -d ":" | sed 's/^ //')
kit_version=$(grep " - Kit ID: " results/pipeline_info_first_step/pipeline_report.txt | cut -f 2 -d ":" | sed 's/^ //')
flowcell_version=$(grep "$flowcell_id $kit_version" flowcell_version.txt | cut -f 2 -d "_")
nanostats=$(cat results/nanoplot/summary/NanoStats.txt | sed 's/^/  /')

echo "Flowcell version: $flowcell_version"
echo "Flowcell ID: $flowcell_id,"
echo "Protocol kit version: $kit_version,"
echo "Guppy version: $guppy_version"
echo "Quality Control: $nanostats"