# maize_for_Li
This is the script repository for Mr. Li's article

## Calculate Breeding Values
Please install the R package first: lme4 & Matrix & lmerTest

    Usage: Rscript blup_code.r ${your phenotype file}
## AFD analysis
    Usage: sh afd.sh -w ${workdir} -p1 ${[pop1 name} -p2 ${pop2 name} -f ${genome *.fai file} -wsz ${window size} -stp ${step size}

#Before use, please extract the vcf file of each pop and compress it with gzip

Options:

    -w   the working path where the result file is stored

    -p1   name of pop 1

    -p2   name of pop 2

    -f   genome fai file

    -wsz   window size for analysis

    -stp   step size for analysis 


## Count the number of F1 heterozygous sites
Before use, please extract the vcf file and compress it with gzip

    Usage: python Get.het_position.py ${vcf file} ${your parent lines} ${output het stat file} > ${output genotype file}

## Transform VCF file to Genotype file
Convert vcf to genotype format file for easy sample extraction and marker,vcf file needs to be compressed with gzip

    Usage: python2 trans_vcf_to_geno.pyc ${gzvcf ifle} ${output name}

## Calculate SNP/gene density
Through this script, the SNP/gene density within the window can be calculated 

    <depth file> has three columns: chromosome / position / count

    Usage: python3 ${genome fai file} ${depth file} ${window size} ${step size} ${output file}

## Pick up sample in vcf file according to the specified genotype
Using the specified genotype (ref:00 ; alt:11 ; hybrid:01), extract the corresponding sample from the vcf file

    Usage:sh pick_sample.sh -i vcf.gz -p refalt -l 4 -g '11|22' -o refalt.out

#need new_vcfgeno2.pyc in common workdir
Options:

    -i  input.vcf.gz

    -p  prefix

    -l  snp number

    -g  genotype to be extracted, use "|" as the delimiter, and add single quotes before and after, 00 means homozygous ref;11 means homozygous alt;01 means hybrid  e.g.: '00|11' 

    -o outputfile

## Calculate geno average and pValue
According to the input genotype file and phenotype file, the phenotype mean and significance (homozygous ref and alt) of each locus genotype can be calculated

Usage: sh calculate_geno_ave_pValue.sh  -g ${geno file} -p ${pheno file} -r ${the line of phenotype} -n ${geno number} -w ${workdir}

#need t.test.R in common workdir

Options:
 
    -g genotype file

    -p phenotype file

    -r The number of columns in the file for the phenotype to be calculated

    -n geno number

    -w workdir

## Other R code
Statistic of effects for reference allele and alternative allele at associated SNPs

    Usage: Rscript update_code.R ${workdir} ${input file} ${output file}
