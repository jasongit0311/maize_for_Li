# Whole genome resequencing data analysis of maize germplasm
This is the script repository for Mr. Li's article


## Calculate Breeding Values
Calculate Breeding Values

    Usage: Rscript blup_code.r ${your phenotype file}

Note:

    #Please install the R package first: lme4 & Matrix & lmerTest


## AFD analysis
    Usage: sh afd.sh -w ${workdir} -p1 ${[pop1 name} -p2 ${pop2 name} -f ${genome *.fai file} -wsz ${window size} -stp ${step size}

Note:

    #Before use, please extract the vcf file of each pop and compress it with gzip
    
    #copy SNP_DENSITY.pl cal_AF.pl in common workdir

Options:

    -w   the working path where the result file is stored

    -p1   name of pop 1

    -p2   name of pop 2

    -f   genome fai file

    -wsz   window size for analysis

    -stp   step size for analysis 


## Fst analysis

Usage: using vcftools

    vcftools --vcf in.vcf --weir-fst-pop population1.txt --weir-fst-pop population2.txt  --out p_1_2_bin --fst-window-size 20000 --fst-window-step 10000


## Count the number of heterozygous sites in hybrids
Calculate the number of heterozygous sites in hybrids for female group x male group heterotic pattern

    Usage: python Get.het_position.py ${vcf file} ${your parent lines} ${output het stat file} > ${output genotype file}

Note:

    #Before use, please extract the vcf file and compress it with gzip


## Calculate SNP/gene density
Using this script, the SNP/gene density within the non-overlapping genomic window can be calculated at the genome-wide level

    Usage: python3 ${genome fai file} ${depth file} ${window size} ${step size} ${output file}

Note:

    #<depth file> has three columns: chromosome / position / count


## Calculate the effect of homozygous alleles and heterozygous allele in testcross population
Based on the genotype file and phenotype file, the effect of homozygous alleles (homozygous Ref and Alt) and heterozygous allele of each genotype site can be calculated, and the significance of phenotypic difference between homozygous Ref allele and homozygous Alt allele can be also calculated.

    Usage: sh calculate_geno_ave_pValue.sh  -g ${geno file} -p ${pheno file} -r ${the line of phenotype} -n ${geno number} -w ${workdir}

Note:

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


## Author

Dr. Chunhui Li (lichunhui@caas.cn)
