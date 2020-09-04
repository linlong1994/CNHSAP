#!/usr/bin/perl -w
use strict;
use File::Basename;
die "perl $0 bamstat read_classification.txt reference_fai reference_name samtools bam\n" unless @ARGV==6;


my %map;
my $stat=shift;
open Stat,"tail -n +2 $stat|";
while(<Stat>){
	chomp;
	my @t=split /\t/;
	$map{$t[0]}=$t[2] - $t[3];
}
close Stat;

open Read,shift;
my $Refai = shift;
my $reference_len = `awk '{sum+=\$2} END {print sum}' $Refai`;
chomp $reference_len;
my $refName=shift;
my $samtools=shift;
my $bam=shift;
my $coverage_region_length=`$samtools depth $bam |wc -l`;
chomp $coverage_region_length;
my $coverage_rate = $coverage_region_length/$reference_len;
while(<Read>){
	chomp;
	my @t=split /\t/;
	my $count=0;
	for my $j(1..$#t){
	$count +=$1 if $t[$j]=~/\:(\d+)$/;
	}
	my $abu;
	if ((! exists($map{$t[0]})) or $map{$t[0]} eq 0 ){
		$abu = 'NA'
	}
	else{
	$abu=2*$count*3099706404/($reference_len*$map{$t[0]});}
	print "$t[0]\t$refName\t$abu\t$coverage_region_length\t$reference_len\t$coverage_rate\n";
}
close Read;
