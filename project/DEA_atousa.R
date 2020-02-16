library(ggplot2)
library(boxr)
library(tidyverse)
library(dplyr)
patient<-box_read("603451871010",read_fun=utils::read.csv)
apache<-box_read("603473066277",read_fun=utils::read.csv)
#avg apache score
apache_patient<-merge(apache,patient,by.x = "patientunitstayid",by.y = "patientunitstayid" ,all.x=TRUE)
levels(apache_patient$unitdischargestatus)[levels(apache_patient$unitdischargestatus)==""] <- "NA"
apache_patient_na_removed<-apache_patient%>%subset(!(unitdischargestatus=="NA"))
apache_patient_na_removed%>%group_by(unitdischargestatus)%>%summarize(mean(apachescore))
apache_patient_na_removed%>%summarize(mean(apachescore))
#number of visit
visit_number<-patient%>%group_by(uniquepid)%>%select(uniquepid,patientunitstayid)%>%distinct()%>%summarize(n())
colnames(visit_number)[2]<-'Number'
a<-visit_number%>%group_by(Number)%>%summarize(n())
colnames(a)<-c('number_of_visit','number_of_people')
a%>%summarize(sum(number_of_people))
write.csv(a,'Num_visit_pie_data.csv')


#time in hospital
time_hospital<-box_read("608970308512",read_fun=utils::read.csv)
colnames(time_hospital)[3]<-'time_hospital'
colnames(time_hospital)[1]<-'patientunitstayid'


#time in hospital boxplot
ggplot(time_hospital, aes(x = Unitdischargestatus, y = time_hospital/24, fill = Unitdischargestatus)) +
  geom_boxplot(alpha=0.7) +
  scale_y_continuous(name = "Time spent in hospital (Day)",
                     breaks = seq(0, 60, 3),
                     limits=c(0, 60)) +
  scale_x_discrete(name = "Status") +
  theme_bw() +
  theme(plot.title = element_text(size = 14, family = "Tahoma", face = "bold"),
        text = element_text(size = 12, family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x=element_text(size = 11),
        legend.position = "bottom") +
  scale_fill_brewer(palette = "Accent") +
  labs(fill = "Status")+ coord_flip()
p10

#time in hospital boxplot based on disease

time_hospital_patient<-merge(patient,time_hospital,by ='patientunitstayid')
#write.csv(time_hospital_patient,'time_hospital_patient.csv')
time_hospital_patient<-box_read("609422477416",read_fun=utils::read.csv) 
#time_hospital_patient<-read_csv("time_hospital_patient.csv")
time_hospital_patient$apacheadmissiondx<-as.factor(time_hospital_patient$apacheadmissiondx)
time_hospital_patient_filter<-time_hospital_patient%>%filter(apacheadmissiondx %in% c('Sepsis, renal/UTI (including bladder)','CVA, cerebrovascular accident/stroke','CHF, congestive heart failure','Sepsis, pulmonary','Cardiac arrest (with or without respiratory arrest; for respiratory arrest see Respiratory System)'))
time_hospital_patient_filter$apacheadmissiondx<-droplevels(time_hospital_patient_filter$apacheadmissiondx)
levels( time_hospital_patient_filter$apacheadmissiondx)[1]<-'Cardiac arrest'
#write.csv(time_hospital_patient_filter,'time_hospital_patient_filter.csv')
ggplot(data=time_hospital_patient_filter,aes(x = apacheadmissiondx, y = time_hospital/24, fill = Unitdischargestatus)) +
  geom_boxplot(alpha=0.7) +
  scale_y_continuous(name = "Time spent in hospital (Day)",
                     breaks = seq(0, 45, 3),
                     limits=c(0, 45)) +
  scale_x_discrete(name = "Disease") +
  theme_bw() +
  theme(plot.title = element_text(size = 11, family = "Tahoma", face = "bold"),
        text = element_text(size = 11, family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x=element_text(size = 10,face="bold",angle=30, hjust=1),
        legend.position = "right") +
  scale_fill_brewer(palette = "Accent") +
  labs(fill = "Unit discharged status")


#time in hospital age
time_hospital_age<-box_read("613936652308",read_fun=utils::read.csv)
colnames(time_hospital_age)[4]<-'time_hospital'
colnames(time_hospital_age)[1]<-'age'
time_hospital_age<-time_hospital_age%>%subset(!is.na(age))#complete cases in age
time_hospital_age$age<-as.factor(time_hospital_age$age)

#time in hospital gender
time_hospital_gender<-box_read("613935867309",read_fun=utils::read.csv)
colnames(time_hospital_gender)[4]<-'time_hospital'
colnames(time_hospital_gender)[1]<-'Gender'
time_hospital_gender<-time_hospital_gender%>%subset(!is.na(Gender))#complete cases in gender
time_hospital_gender$Gender<-as.factor(time_hospital_gender$Gender)
time_hospital_gender_filter<-time_hospital_gender%>%subset(Gender %in% c('Female','Male'))
time_hospital_gender_filter$Gender<-droplevels(time_hospital_gender_filter$Gender)

ggplot(data=time_hospital_gender_filter,aes(x = Gender, y = time_hospital/24, fill = Unitdischargestatus)) +
  geom_boxplot(alpha=0.7) +
  scale_y_continuous(name = "Time spent in hospital (Day)",
                     breaks = seq(0, 45, 3),
                     limits=c(0, 45)) +
  scale_x_discrete(name = "Gender") +
  
  theme_bw() +
  theme(plot.title = element_text(size = 11, family = "Tahoma", face = "bold"),
        text = element_text(size = 11, family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x=element_text(size = 11,face="bold",angle=30, hjust=1),
        legend.position = "right") +
  scale_fill_brewer(palette = "Accent") +
  labs(fill = "Unit discharged status")