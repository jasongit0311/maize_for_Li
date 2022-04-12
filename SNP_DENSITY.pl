#!/usr/bin/perl
use warnings;
use strict;
use File::Basename;
use Cwd 'abs_path';
use File::Basename;
use Getopt::Long;
use FindBin qw($RealBin); 
my $USAGE = qq{
Name: $0
Usage: $0
Function: Prepare files for circos input
Options:
    -out    <string>    Output file prefix
	-fai    <string>    samtools faidx file of reference
	-snp    <string>    SNP file vcf format
	-stp    <integer>   Step size for calculate SNP density [default 5000000]
	-wsz    <integer>   Windows size for calculate SNP density [default 5000000]
}; 
my ($outFile,$karFile,$snpFile,$stepSize,$windowSize);
GetOptions(
	"out=s" => \$outFile,
	"fai=s" => \$karFile,
	"snp=s" => \$snpFile,
	"stp=i" => \$stepSize,
	"wsz=i" => \$windowSize,
);
die "$USAGE" unless ($outFile and $karFile and $snpFile );
$stepSize ||= 20000;
$windowSize ||= 10000;
my %SNPdensity;
my $numChr=0;
open KAR,"<$karFile" or die $!;
while (<KAR>) {
	chomp;
	my @line = split /\t/,$_;
	my ($chr,$len) =@line[0,1];
	my @array;
	for(my $i = 0; $i * $stepSize + $windowSize <= $len; $i++) {
		$array[$i] = [$i * $stepSize + 1, $i * $stepSize + $windowSize, 0, 0, 0, 0];
	}
	$SNPdensity{$chr} = [@array];
	$numChr++;
}
close KAR;
open SNP,"<$snpFile" or die $!;
while (<SNP>) {
	chomp;
	next if (/^#/);
	my @line = split /\t/,$_;
	my $chr =$line[0];
	my $pos =$line[1];
	next unless (exists $SNPdensity{$chr});
	my $index = int(($pos - $windowSize) / $stepSize);
	$index = 0 if ($index < 0);
	for(my $i = $index; $i < @{$SNPdensity{$chr}}; $i++) {
		last if ($SNPdensity{$chr}->[$i]->[0] > $pos);
		next if ($SNPdensity{$chr}->[$i]->[1] < $pos);
		$SNPdensity{$chr}->[$i]->[2] ++;
		$SNPdensity{$chr}->[$i]->[3] +=$line[4];
#		$SNPdensity{$chr}->[$i]->[4] +=$line[5];
#		$SNPdensity{$chr}->[$i]->[5] +=$line[6];
#		$SNPdensity{$chr}->[$i]->[3] +=$line[2];
	}
}
close SNP;
open SNP,">$outFile" or die $!;
foreach my $chr (sort keys %SNPdensity) {
	foreach my $d (@{$SNPdensity{$chr}}) {
		my $density1 = $d->[3]/($d->[2]+1);
#		my $density2 = $d->[4]/$d->[2];
#		my $density3 = $d->[5]/$d->[2];
#        my $density = $d->[3]/$d->[2];
		print SNP join("\t", $chr, $d->[0], $d->[1], $density1),"\n";
	}
}
close SNP;
