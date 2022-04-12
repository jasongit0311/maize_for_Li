#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: cal_AF.pl
#
#        USAGE: ./cal_AF.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2020年06月10日 09时36分26秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use PerlIO::gzip;
my $sample = $ARGV[0];
#open IN,"$sample.recode.vcf";
open IN ,"zcat $sample.vcf.gz |";
open OUT,">$sample.AF";
print OUT "CHROM\tPOS\tREF\tALT\tREF_AF\tALT_AF\n";
my $alt_ratio;
my $ref_ratio;
while (<IN>){
	chomp;
	next if (/^#/);
	my @line = split /\t/,$_;
	my $ref=0;
	my $alt=0;
	for my $i (9..$#line){
		my @geno = split /:/,$line[$i];
		if ($geno[0] eq "0/0"){
			$ref+=2;
		}elsif ($geno[0] eq "0/1"){
			$ref++;
			$alt++;
		}elsif ($geno[0] eq "1/1"){
			$alt+=2;
		}
	}
	my $total = $alt + $ref;
	if ($total == 0){
		$alt_ratio = 0;
		$ref_ratio = 0;
	}else{
		$alt_ratio = $alt/$total;
		$ref_ratio = $ref/$total;
	}
	
	print OUT "$line[0]\t$line[1]\t$line[3]\t$line[4]\t$ref_ratio\t$alt_ratio\n";
}
