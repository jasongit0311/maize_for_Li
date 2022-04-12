while [[ $# -gt 0 ]]
do
key="$1"

case "$key" in
	-p|--prefix)
	prefix="$2"
	shift
	shift
	;;
	-w|--workdir)
	workdir="$2"
	shift
	shift
	;;
	-p1|--pop1)
	pop1="$2"
	shift
	shift
	;;
	-p2|--pop2)
        pop1="$2"
        shift
        shift
        ;;
	-f|--fai)
	fai="$2"
	shift
	shift
	;;
	-wsz|--window)
	window="$2"
	shift
	shift
	;;
	-stp|--step)
	step="$2"
	shift
	shift
	;;
	esac
done
	
function ceil(){
  floor=`echo "scale=0;$1/1"|bc -l ` # 向下取整
  add=`awk -v num1=$floor -v num2=$1 'BEGIN{print(num1<num2)?"1":"0"}'`
  echo `expr $floor  + $add`
}

##step1 caculate_pop_afd
pop1=`ls ${pop1}.vcf.gz | sed 's#.vcf.gz##g'`
pop2=`ls ${pop2}.vcf.gz | sed 's#.vcf.gz##g'`
echo "perl cal_AF.pl $pop1
perl cal_AF.pl $pop2
perl SNP_DENSITY.pl -out $pop1.win.AF -fai $fai -snp $pop1.AF -stp $step -wsz $window
perl SNP_DENSITY.pl -out $pop2.win.AF -fai $fai -snp $pop2.AF -stp $step -wsz $window
paste $pop1.win.AF $pop2.win.AF | cut -f 1-4,8 > Maize_AF_win.txt
perl work.pl ${pop1}vs${pop2}" > run.afd.sh
sh run.afd.sh

##pick top5 region
stat_line=`grep -v -E 'B73|Mt|Pt' ${pop1}vs${pop2}.delta_AF | wc -l | awk '{print $1*0.05}'`
top5_line=`ceil $stat_line`
cat ${pop1}vs${pop2}.delta_AF | grep -v -E 'B73|Mt|Pt' | sort -k4 -gr | head -n $top5_line | sort -k 1n -k 2n,2| awk '{print $1 "\t" $2 "\t" $3 "\t" $4 }' > top5.${pop1}vs${pop2}.AF
