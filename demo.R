---
title: "HCP API Demo with Rstudio"
author: "Craig Parman"
date: "Monday, March 16, 2015"
output:
  html_document:
    keep_md: yes
  pdf_document: default
---



Use Case:

Scientist has a spreadsheet with a list of bam files from a sequencing project.  The user also has annotations about the patients the samples were collect from and some processing information.  The would like to store this data for future use and annotate the data so it can be found but future researchers.

Prerequisites:

#first lets setup the envioronment

require(XML)
require(RCurl)
require(devtools)
require(digest)
require(base64enc)

#Install the HCPtools package from github

#install_git("git://github.com/ceparman/HCPtools.git")

require(HCPtools)


Load annotation file
 
annotations<-read.csv("SRAfilesandAnnotations.txt",sep="\t",as.is=TRUE,header=TRUE)

#create a set of dummy bam files

for(i in 1:nrow(annotations))  {
  file<-file(annotations[i,1])
  cat("I am a dummy BAM",file=file,sep="\n")
  cat("I only have 2 lines\n",file=file)
 close(file)

 }






#getObjectsList(namespace,auth) 


#Generate authentication string

#auth<-paste("Authorization: HCP ",base64encode(charToRaw("sra")),":",
            digest("sra12345",algo="md5",serialize=FALSE),sep="" )
            
#namespace<-"https://cu.sradata.hcp-demo.hcpdomain.com"


for(i in 1:nrow(annotations))  {

#for each file 
file<-annotations[i,1]
#load file
filename<-paste(annotations[i,2],".bam",sep="")
 putFile(file,filename,namespace,auth,verbose=TRUE)

#annotate file

ann<-listToXML("annotation",as.list(annotations[i,2:14]))

saveXML(ann,file="ann.xml")

addCustAnnotation(filename,namespace,auth,"ann.xml","custom",verbose=TRUE)


ann<-listToS3XML(as.list(annotations[i,2:14]))

saveXML(ann,file="ann.xml")

addCustAnnotation(filename,namespace,auth,"ann.xml",".metapairs",verbose=TRUE)

}



#query custom metadata

xmlFile<-"query1.xml"

result<-xmlFileQuery(xmlFile, namespace, auth, verbose = FALSE)

xpathSApply(result,"//object",xmlGetAttr,"urlName")
