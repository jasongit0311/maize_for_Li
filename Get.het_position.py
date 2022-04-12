import sys
import gzip

parent = sys.argv[2]

def geno(tmpgen):
	if tmpgen.startswith('0/0'):
		geno = 'R'
	elif tmpgen.startswith('1/1'):
		geno = 'A'
	elif tmpgen.startswith('0/1') or tmpgen.startswith('1/0'):
		geno = 'H'
	else:
		geno = 'D'
	return geno

tmpsum = {}
with gzip.open(sys.argv[1]) as vcf, open(sys.argv[3], 'w') as opf:
	for each in vcf:
		if each.startswith('##'):
			continue
		lis = each.strip().split('\t')
		tmplis = []
		if each.startswith('#C'):
			index = {}
			for ind in range(9, len(lis)):
				index[ind] = lis[ind]
				if lis[ind] == parent:
					parind = ind
				else:
					tmplis.append(lis[ind])
			print('Chr\tposition\t' + '\t'.join(tmplis))
		else:
			pargeno = geno(lis[parind])
			for ind in range(9, len(lis)):
				if ind != parind:
					tmpgeno = geno(lis[ind])
					zuhegeno = pargeno + tmpgeno
					tmplis.append(zuhegeno)
					if zuhegeno == 'RA' or zuhegeno == 'AR':
						tmpsum.setdefault(index[parind] + '\t' + index[ind], []).append(1)
			print('%s\t%s\t%s' %(lis[0], lis[1], '\t'.join(tmplis)))
						#tmpsum[index[parind] + '\t' + index[ind]] = [1]
	for ele in sorted(tmpsum):
		opf.write('%s\t%i' %(ele, len(tmpsum[ele])) + '\n')
