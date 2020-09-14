# CNHSAP -- Cell-free Non-human Sequence Analysis Pipeline

## Introduction
CNHSAP is a pipeline for cell-free non-human sequence identification and characterization statistic，like abundance and coverage. The pipeline contains two steps. The first step is to align the sequences to the human reference to get the statistic of human alignmant for abundance calculation in step2 and get the non-human sequences after alingment. Step2 takes the non-human sequences and use Kraken2 and MetaPhlAn2 to pre-classfy the sequences to get the individual candidates. Joint the population-level candidates, a final candidates is gotten for BWA to align the non-human sequences to cal the sequnece abundance. The formula for abundance calculation is :
           Abundance = 2 * ((number of reads virus mapped genome size to micro genome)/(micro genome size)) / ((number of reads mapped to human genome)/(human genome size))
           
![Image](https://github.com/linlong1994/CNHSAP/blob/master/pipeline.png)


## Requirements:

python3: v3.6.1
python2: v2.7.11 
  
Software for This pipeline:
* [Kraken v2](https://ccb.jhu.edu/software/kraken2/index.shtml)
* [bwa 0.7.17-r1188](https://github.com/lh3/bwa)
* [Metaphlan2](https://github.com/biobakery/metaphlan)
* [Samtools v1.9](http://samtools.sourceforge.net/)
* [Bgzip v1.3](http://www.htslib.org/doc/bgzip.html)
* [Tabix v1.3](http://www.htslib.org/doc/tabix.html)


## Installation
```
git clone https://github.com/linlong1994/CNHSAP.git
```
Notes: The above dependent software needs to be installed separately according to their instructions.

## Usage
### 1.Build the index for database
1) Download the reference genomes
For every species in https://github.com/linlong1994/CNHSAP/blob/master/panel/database.karius.kraken.metaphalan2.panel.uniq.txt, there is a representative gemone selected for it. You can directly download it by using: 
```
awk -F '\t' '{print $2}' |while read line 
do
    wget $line
done
```
For some genomes, you may find it under your Kraken2 library directory.

2)Build BWA index:
For every donwloaded genomes:
```
bwa index $genome
```
3)Build samtools index:
```
samtools faidx $genome
```
4)Edit the /your_install_path/panel/final.database.txt file, and change the genome path to your own path.

### 2.Run the pipeline.

### Step1: Align to human reference to get the human reads statistics

```
fq='your_data/*.fq.gz'
sample_id='your_sample_id'
outdir='your_step1_output'
faidxed_reference='human_reference_with_samtools_faidx_index'
indexed_reference='human_referece_with_bwa_index'
bwa='your_bwa_path'
samtools='you_rsamtools_path'
bgzip='your_bgzip_path'
tabix='your_tabix_path'

your_installed_path/NHSAP.py GNHS  -I $fq -b $bwa -s $samtools -si $sample_id -bg $bgzip -tx $tabix -R $indexed_reference -O $outdir
```

This step will output $sample_id.sorted.rmdup.bam and a $sample_id.sorted.rmdup.bamstats.summary.txt under the $output dir.
Columns in $sample_id.sorted.rmdup.bamstats.summary.txt are:
```
Sample_id     Errorrate       Total_read_count       Unmapped_reads_count        Coverage_for_mapped_reads  Coverage_for_good_mapped_reads Reads_Length Duplicate_rate
```

### Step2: Align to panel references to get the non-human reads statistics
```
fq='your_data/*.fq.gz'
sample_id='your_sample_id'
outdir='your_step2_output'
summary_file='generated_from_step1'
kraken2='your_kraken2_path'
kraken2db='your_kraken2_library_path'
metaphlan2='your_metaphlan2_path'
metaphlan2database='your_metaphlan2_database_path'
metaphlan2pkl='your_metaphlan2_pkl_path'
panel='your_installed_path/panel/final.panel.txt'
db='Editted_your_installed_path/panel/final.database.txt'
ncpu=cpu_number
bwa='your_bwa_path'
samtools='you_rsamtools_path'
bgzip='your_bgzip_path'
tabix='your_tabix_path'

your_installed_path/NHSAP.py GNHA --input $fq --kraken2 $kraken2 --kraken2database $kraken2db --metaphlan2 $metaphlan2 --metaphlan2database $metaphlan2database --metaphlan2pkl $metaphlan2pkl --sample_id $sample_id --outdir $outdir --panel $panel --db $db --bamstats_summury $summary_file --bwa $bwa --samtools $samtools --bgzip $bgzip --tabix $tabix --nCPU $ncpu
```
This will output a $sample_id.abundance.txt under the $output directory.
Columns are:
```
Sample_id  Micro_species_name     Abundance Coverage
```



