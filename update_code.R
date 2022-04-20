
args=commandArgs(T)
setwd(args[1])

geneall<-read.table(args[2],header=T)
gene<-geneall[,-c(1,2)]


taxan<-NULL
for (colID in 1:dim(gene)[2]) {
tgene<-gene[,colID]
Ref=as.character(gene[1,colID])
Alt=as.character(gene[2,colID])

ref<-NULL
alt<-NULL
for (rowID in 3:dim(gene)[1]) {
if (as.character(tgene[rowID])==Ref) ref<-c(ref,as.numeric(as.character(geneall[rowID,2]))) else NULL
}

for (rowID in 3:dim(gene)[1]) {
if (as.character(tgene[rowID])==Alt) alt<-c(alt,as.numeric(as.character(geneall[rowID,2]))) else NULL
}

pvalue<-wilcox.test(ref,alt)$p.value
allv<-cbind(colnames(gene)[colID],mean(ref,na.rm=TRUE),mean(alt,na.rm=TRUE),pvalue)

taxan<-rbind(taxan,allv)

colnames(taxan)=c("QTN","Ref_mean","Alt_mean","p.value")
write.csv(taxan, args[3],sep="")
}