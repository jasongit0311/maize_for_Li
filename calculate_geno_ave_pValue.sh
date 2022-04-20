while [[ $# -gt 0 ]]
do
key="$1"

case "$key" in
	-g|--genotype) #基因型文件
	geno="$2"
	shift
	shift
	;;
	-p|--pheno) #表型文件
	pheno="$2"
	shift
	shift
	;;
	-r|--order) #表型列数
	order="$2"
	shift
	shift
	;;
	-n|--number) #标记数量
	number="$2"
	shift
	shift
	;;
	-w|--workdir) #工作目录
	workdir="$2"
	shift
	shift
	;;
	esac
done

##grep 0/1/2
phe_name=`cut -f ${order} $pheno | head -n 1`
mkdir $phe_name
cd $workdir/$phe_name
for i in $(seq 2 $number);do
	bin_name=`cut -f 1,${i} $geno | head -n 1 | cut -f 2`
	cut -f 1,${i} $geno | awk '{if($2=="0")print $0}' | cut -f 1 > S0.tmp
	cut -f 1,${i} $geno | awk '{if($2=="1")print $0}' | cut -f 1 > S1.tmp
	cut -f 1,${i} $geno | awk '{if($2=="2")print $0}' | cut -f 1 > S2.tmp
	cut -f 1,${order} $pheno | sed '1d' > S${order}.phe.tmp
	awk  'NR==FNR{a[$1]=$0;next}NR>FNR{if($1 in a)print $0}' S0.tmp S${order}.phe.tmp | awk -v name=$bin_name -v phe=$phe_name '{sum+=$2};END{print phe "\t" name "\t" sum/NR}' > ${bin_name}.S0
	awk  'NR==FNR{a[$1]=$0;next}NR>FNR{if($1 in a)print $0}' S1.tmp S${order}.phe.tmp | awk '{sum+=$2};END{print name "\t" phe "\t" sum/NR}' > ${bin_name}.S1
	awk  'NR==FNR{a[$1]=$0;next}NR>FNR{if($1 in a)print $0}' S2.tmp S${order}.phe.tmp | awk '{sum+=$2};END{print name "\t" phe "\t" sum/NR}' > ${bin_name}.S2
	awk  'NR==FNR{a[$1]=$0;next}NR>FNR{if($1 in a)print $0}' S0.tmp S${order}.phe.tmp | cut -f 2 > S0.value
	awk  'NR==FNR{a[$1]=$0;next}NR>FNR{if($1 in a)print $0}' S2.tmp S${order}.phe.tmp | cut -f 2 > S2.value
	Rscript $workdir/t.test.R S0.value S2.value t.test.result
	paste ${bin_name}.S0 ${bin_name}.S1 ${bin_name}.S2 t.test.result >> ${phe_name}.result.xls
	rm ${bin_name}.S*
done
