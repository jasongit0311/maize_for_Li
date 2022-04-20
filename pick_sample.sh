while [[ $# -gt 0 ]]
do
key="$1"

case "$key" in 
	-i|--input) #input.vcf.gz
	input="$2"
	shift
	shift
	;;
	-p|--prefix) #output prefix
	prefix="$2"
	shift
	shift
	;;
	-l|--line_1) #snp number
	line_1="$2"
	shift
	shift
	;;
	-g|--genotype) #genotype to be extracted, use "|" as the delimiter, and add single quotes before and after, 00 means homozygous ref;11 means homozygous alt;01 means hybrid  e.g.: '00|11'
	genotype="$2"
	shift
	shift
	;;
	-o|--out) #outputfile
	out="$2"
	shift
	shift
	;;
	esac
done

## step1 trans your vcf
/usr/bin/python2 new_vcfgeno2.py $input ${prefix}.geno
sed -i 's/\///g' ${prefix}.geno
line=`echo $line | awk -v line=$line_1 '{print line+1}'`

## pick your sample depending on the genotype of your input
for i in $(seq 2 $line);do
	name=`cat ${prefix}.geno | cut -f 1,2,5- | awk -F"\t" '{for(i=1;i<=NF;i=i+1){a[NR,i]=$i}}END{for(j=1;j<=NF;j++){str=a[1,j];for(i=2;i<=NR;i++){str=str "\t" a[i,j]}print str}}' | head -n 2 | cut -f ${i} | awk '{printf $1 "-" $2}' |sed 's/-$//g'`
	ref=`cat ${prefix}.geno | cut -f 1,2,5- | awk -F"\t" '{for(i=1;i<=NF;i=i+1){a[NR,i]=$i}}END{for(j=1;j<=NF;j++){str=a[1,j];for(i=2;i<=NR;i++){str=str "\t" a[i,j]}print str}}' | sed '1,2d' |  cut -f 1,${i} | grep -w 00 | cut -f 1 | awk '{printf $1 ","}' | sed 's/,$//g' | awk '{print "ref:" $0}'`
	alt=`cat ${prefix}.geno | cut -f 1,2,5- | awk -F"\t" '{for(i=1;i<=NF;i=i+1){a[NR,i]=$i}}END{for(j=1;j<=NF;j++){str=a[1,j];for(i=2;i<=NR;i++){str=str "\t" a[i,j]}print str}}' | sed '1,2d' |  cut -f 1,${i} | grep -w -E $genotype | cut -f 1 | awk '{printf $1 ","}' | sed 's/,$//g' |awk '{print "alt:" $0}'`
	echo "$name $ref $alt" >> $out
done
sed -i 's/ /\t/g' $out
rm ${prefix}.geno
