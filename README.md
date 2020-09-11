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
