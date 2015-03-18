


library(RCurl)
auth<-paste("Authorization: HCP ",base64enc::base64encode(charToRaw("sra")),
           ":",digest::digest("sra12345",algo="md5",serialize=FALSE),sep="" )

namespace<-"https://cu.sradata.hcp-demo.hcpdomain.com"
    queryfilename<-"query1.xml"

HCPtools::getObjectsList(namespace,auth,queryfilename)

f<-RCurl::CFILE(queryfilename,mode="rb")
#j<-RCurl::CFILE("queryresult.txt",mode="wb")
k = RCurl::basicTextGatherer()
 
auth1<-c(auth,"Content-Type: application/xml","Accept: application/xml")
#auth1<-paste(auth,"Content-Type: application/xml","Accept: application/xml",sep='\n' )


verbose <-TRUE


    RCurl::curlPerform(url = paste(namespace,"/query?prettyprint",sep=""),
                       ssl.verifyhost = FALSE,
                       ssl.verifypeer = FALSE, 
                       post = 1L,
                       httpheader = auth1,
                   
                       upload=TRUE,
                       customrequest= "POST",
                       infilesize = file.info(queryfilename)[1, "size"],
                       #readfunction= f@ref,
                       readdata = f@ref,
                          
                                           
                      #headerfunction=k$update,
                       #encoding="gzip",
                       verbose=verbose 
    )
  close(f)
  
  