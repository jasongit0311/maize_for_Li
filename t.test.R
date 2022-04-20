args=commandArgs(T)
a=read.table(args[1])
b=read.table(args[2])
pVal=t.test(a$V1,b$V1)$p.value
write.table(pVal,file="t.test.result",row.name=F,quote=F,col.names = F)
