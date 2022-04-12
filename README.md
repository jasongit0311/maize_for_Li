# maize_for_Li
This is the script repository for Mr. Li's article

## Calculating Breeding Values
Please install the R package first: lme4 & Matrix & lmerTest

Rscript blup_code.r ${your phenotype file}
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


## Counting the number of F1 heterozygous sites
Before use, please extract the vcf file and compress it with gzip

Usage: python Get.het_position.py ${vcf file} ${your parent lines} ${output het stat file} > ${output genotype file}
