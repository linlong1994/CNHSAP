# CNHSAP -- Cell-free Non-human Sequence Analysis Pipeline

## Introduction
CNHSAP is a pipeline for cell-free non-human sequence identification and characterization statistic，like abundance and coverage. The pipeline contains two steps. The first step is to align the sequences to the human reference to get the statistic of human alignmant for abundance calculation in step2 and get the non-human sequences after alingment. Step2 takes the non-human sequences and use Kraken2 and MetaPhlAn2 to pre-classfy the sequences to get the individual candidates. Joint the population-level candidates, a final candidates is gotten for BWA to align the non-human sequences to cal the sequnece abundance. The formula for abundance calculation is :
           Abundance = 2 * ((number of reads virus mapped genome size to micro genome)/(micro genome size)) / ((number of reads mapped to human genome)/(human genome size))
           
           
