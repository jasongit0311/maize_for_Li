###############Counting blup value of phenotypic traits in multiple environments
library(Matrix)
library(lme4)
library(lmerTest)

args=commandArgs(T)
dat<-read.table(args[1],header=T,na.strings=NA)

for(i in 1:3) dat[,i] = as.factor(dat[,i])
str(dat)

mod1 = lmer(DA ~ (1|Line) + (1|Env) + (1|Line:Env) + (1|Rep:Env), data=dat)               #

#summary(mod1)
DAblup = ranef(mod1)$Line               
write.csv(DAblup,args[2])  