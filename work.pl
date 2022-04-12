#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: work.pl
#
#        USAGE: ./work.pl  
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
#      CREATED: 2020年06月22日 14时22分57秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
my $sample = $ARGV[0];
open IN,"Maize_AF_win.txt";
open OUT1,">$sample.delta_AF";

while (<IN>){
	chomp;
	my @as = split /\t/,$_;
	my $delta1 = $as[3] - $as[4];
	my $data1 = abs($delta1);
	print OUT1 "$as[0]\t$as[1]\t$as[2]\t$data1\n";
}
