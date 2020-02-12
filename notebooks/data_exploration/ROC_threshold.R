# part 1 calculate ROC curve 

library(readr)
library(tidyverse)
library(dplyr)
library(pROC)

apachResult <- read_csv("../data/apachePatientResult.csv")
patient <- read_csv("../data/patient.csv")

apachResult <- apachResult %>%
  filter(predictedhospitalmortality != -1)
p_join_a <- patient %>% inner_join(apachResult,by="patientunitstayid")

#overall roc
myroc=roc(apachResult$actualicumortality,apachResult$predictedhospitalmortality,
          plot=TRUE,main="All disease",
          cex.lab=2, cex.axis=1.5, cex.main=2, cex.sub=2)
text(x=0.4,y=0.2,cex=2,labels = paste0("ROC-AUC = ",round(myroc$auc,2)))

#individual ROC
diseases = c("Cardiac arrest",
             "CHF, congestive heart failure",
             "CVA, cerebrovascular accident/stroke",
             "Sepsis, pulmonary",
             "Sepsis, renal/UTI")
for (i in 1:5) {
  myroc = p_join_a %>% 
    filter(grepl(diseases[i],apacheadmissiondx,fixed = TRUE)) %>%
    with(roc(actualicumortality,predictedhospitalmortality,
             plot=TRUE,main=diseases[i],
             cex.lab=2, cex.axis=1.5, cex.main=2, cex.sub=2))
  text(x=0.4,y=0.2,cex=2,labels = paste0("ROC-AUC = ",round(myroc$auc,2)))
}


#######################################################
# part 2 find the optimal threshold with Youden Index
Youden<-function(score,y,lambda=0.5){
  max_Youden = 0
  best_c = 0
  for (c in seq(min(score),max(score),0.001)){
    s = sum(score>c&y==1) +0.0
    r = sum(score>c&y==0) +0.0
    u = sum(score<=c&y==1) +0.0
    v = sum(score<=c&y==0) +0.0
    Youden = lambda*s/(s+u)+(1-lambda)*v/(v+r)
    if(Youden>max_Youden){
      max_Youden = Youden
      out = list(
        best_c = c,
        tp = s,
        fp = r,
        fn = u,
        tn = v,
        sensitivity = s/(s+u),
        specificity = v/(v+r),
        accuracy = (s+v)/(s+u+v+r))
    }
  }
  return(out)
}
for (i in 1:5) {
  out = p_join_a %>% 
    filter(grepl(diseases[i],apacheadmissiondx,fixed = TRUE)) %>%
    mutate(y = actualicumortality == "EXPIRED") %>%
    with(Youden(predictedhospitalmortality,y))
  print("----------------------------")
  print(diseases[i])
  print(out)
}



