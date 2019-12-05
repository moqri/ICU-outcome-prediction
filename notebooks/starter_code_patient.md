Patient Table Starter Code
================

Author: [Mahdi Moqri](https://www.moqri.com/)

Adopted from <https://github.com/mit-lcp/eicu-code>

The patinet table is a core part of the eICU-CRD and contains all
information related to tracking patient unit stays. The table also
contains patient demographics and hospital level information.

### Loading libraries

``` r
library(data.table)
library(dplyr)
library(magrittr)
library(plyr)
library(knitr)
```

### Examining the patient table

The uniquePid column identifies a single patient across multiple stays.
Let’s look at a single uniquepid.

``` r
# data_folder is the local path to your data
df=fread(file.path(data_folder,'patient.csv'))
kable(head(df))
```

| patientunitstayid | patienthealthsystemstayid | gender | age | ethnicity | hospitalid | wardid | apacheadmissiondx                             | admissionheight | hospitaladmittime24 | hospitaladmitoffset | hospitaladmitsource  | hospitaldischargeyear | hospitaldischargetime24 | hospitaldischargeoffset | hospitaldischargelocation | hospitaldischargestatus | unittype     | unitadmittime24 | unitadmitsource      | unitvisitnumber | unitstaytype   | admissionweight | dischargeweight | unitdischargetime24 | unitdischargeoffset | unitdischargelocation | unitdischargestatus | uniquepid |
| ----------------: | ------------------------: | :----- | :-- | :-------- | ---------: | -----: | :-------------------------------------------- | --------------: | :------------------ | ------------------: | :------------------- | --------------------: | :---------------------- | ----------------------: | :------------------------ | :---------------------- | :----------- | :-------------- | :------------------- | --------------: | :------------- | --------------: | --------------: | :------------------ | ------------------: | :-------------------- | :------------------ | :-------- |
|            141168 |                    128919 | Female | 70  | Caucasian |         59 |     91 | Rhythm disturbance (atrial, supraventricular) |           152.4 | 15:54:00            |                   0 | Direct Admit         |                  2015 | 03:50:00                |                    3596 | Death                     | Expired                 | Med-Surg ICU | 15:54:00        | Direct Admit         |               1 | admit          |            84.3 |            85.8 | 03:50:00            |                3596 | Death                 | Expired             | 002-34851 |
|            141178 |                    128927 | Female | 52  | Caucasian |         60 |     83 |                                               |           162.6 | 08:56:00            |                \-14 | Emergency Department |                  2015 | 19:20:00                |                    2050 | Home                      | Alive                   | Med-Surg ICU | 09:10:00        | Emergency Department |               1 | admit          |            54.4 |            54.4 | 09:18:00            |                   8 | Step-Down Unit (SDU)  | Alive               | 002-33870 |
|            141179 |                    128927 | Female | 52  | Caucasian |         60 |     83 |                                               |           162.6 | 08:56:00            |                \-22 | Emergency Department |                  2015 | 19:20:00                |                    2042 | Home                      | Alive                   | Med-Surg ICU | 09:18:00        | ICU to SDU           |               2 | stepdown/other |              NA |            60.4 | 19:20:00            |                2042 | Home                  | Alive               | 002-33870 |
|            141194 |                    128941 | Male   | 68  | Caucasian |         73 |     92 | Sepsis, renal/UTI (including bladder)         |           180.3 | 18:18:40            |               \-780 | Floor                |                  2015 | 23:30:00                |                   12492 | Home                      | Alive                   | CTICU        | 07:18:00        | Floor                |               1 | admit          |            73.9 |            76.7 | 15:31:00            |                4813 | Floor                 | Alive               | 002-5276  |
|            141196 |                    128943 | Male   | 71  | Caucasian |         67 |    109 |                                               |           162.6 | 20:21:00            |                \-99 | Emergency Department |                  2015 | 17:00:00                |                    5460 | Home                      | Alive                   | Med-Surg ICU | 22:00:00        | ICU to SDU           |               2 | stepdown/other |              NA |            63.2 | 22:23:00            |                1463 | Floor                 | Alive               | 002-37665 |
|            141197 |                    128943 | Male   | 71  | Caucasian |         67 |    109 | Sepsis, pulmonary                             |           162.6 | 20:21:00            |                \-25 | Emergency Department |                  2015 | 17:00:00                |                    5534 | Home                      | Alive                   | Med-Surg ICU | 20:46:00        | Emergency Department |               1 | admit          |           102.1 |           102.1 | 22:00:00            |                  74 | Step-Down Unit (SDU)  | Alive               | 002-37665 |

### Examine a single patient¶

``` r
uniquepid_ = '002-33870'
kable(df %>% subset(uniquepid==uniquepid_))
```

| patientunitstayid | patienthealthsystemstayid | gender | age | ethnicity | hospitalid | wardid | apacheadmissiondx | admissionheight | hospitaladmittime24 | hospitaladmitoffset | hospitaladmitsource  | hospitaldischargeyear | hospitaldischargetime24 | hospitaldischargeoffset | hospitaldischargelocation | hospitaldischargestatus | unittype     | unitadmittime24 | unitadmitsource      | unitvisitnumber | unitstaytype   | admissionweight | dischargeweight | unitdischargetime24 | unitdischargeoffset | unitdischargelocation | unitdischargestatus | uniquepid |
| ----------------: | ------------------------: | :----- | :-- | :-------- | ---------: | -----: | :---------------- | --------------: | :------------------ | ------------------: | :------------------- | --------------------: | :---------------------- | ----------------------: | :------------------------ | :---------------------- | :----------- | :-------------- | :------------------- | --------------: | :------------- | --------------: | --------------: | :------------------ | ------------------: | :-------------------- | :------------------ | :-------- |
|            141178 |                    128927 | Female | 52  | Caucasian |         60 |     83 |                   |           162.6 | 08:56:00            |                \-14 | Emergency Department |                  2015 | 19:20:00                |                    2050 | Home                      | Alive                   | Med-Surg ICU | 09:10:00        | Emergency Department |               1 | admit          |            54.4 |            54.4 | 09:18:00            |                   8 | Step-Down Unit (SDU)  | Alive               | 002-33870 |
|            141179 |                    128927 | Female | 52  | Caucasian |         60 |     83 |                   |           162.6 | 08:56:00            |                \-22 | Emergency Department |                  2015 | 19:20:00                |                    2042 | Home                      | Alive                   | Med-Surg ICU | 09:18:00        | ICU to SDU           |               2 | stepdown/other |              NA |            60.4 | 19:20:00            |                2042 | Home                  | Alive               | 002-33870 |

Here we see two unit stays for a single patient. Note also that both
unit stays have the same patienthealthsystemstayid - this indicates that
they occurred within the same hospitalization.

We can see the unitstaytype was ‘admit’ for one stay, and
‘stepdown/other’ for another. Other columns can give us more
information.

### Identifying patients admitted on a single drug

Let’s look for patients who were admitted on
Zaroxolyn.

``` r
cols=c('patientunitstayid', 'wardid', 'unittype', 'unitstaytype', 'hospitaladmitoffset', 'unitdischargeoffset')
kable(df %>% subset(uniquepid==uniquepid_) %>% select(cols) )
```

| patientunitstayid | wardid | unittype     | unitstaytype   | hospitaladmitoffset | unitdischargeoffset |
| ----------------: | -----: | :----------- | :------------- | ------------------: | ------------------: |
|            141178 |     83 | Med-Surg ICU | admit          |                \-14 |                   8 |
|            141179 |     83 | Med-Surg ICU | stepdown/other |                \-22 |                2042 |

Note that it’s not explicitly obvious which stay occurred first. Earlier
stays will be closer to hospital admission, and therefore have a higher
hospitaladmitoffset. Above, the stay with a hospitaladmitoffset of -14
was first (occurring 14 minutes after hospital admission), followed by
the next stay with a hospitaladmitoffset of -22 (which occurred 22
minutes after hospital admission). Practically, we wouldn’t consider the
first admission a “real” ICU stay, and it’s likely an idiosyncrasy of
the administration system at this particular hospital. Notice how both
rows have the same wardid.

### Patients’ ages

As ages over 89 are required to be deidentified by HIPAA, the age column
is actually a string field, with ages over 89 replaced with the string
value ‘\> 89’.

``` r
kable(head(df %>% group_by(age) %>% tally() %>% arrange(-n)))
```

| age   |    n |
| :---- | ---: |
| \> 89 | 7081 |
| 67    | 5078 |
| 68    | 4826 |
| 72    | 4804 |
| 71    | 4764 |
| 66    | 4677 |

As is common in eICU-CRD, there are a subset of hospitals who routinely
utilize this portion of the medical record (and thus have 90-100% data
completion), while there are other hospitals who rarely use this
interface and thus have poor data completion (0-10%).
