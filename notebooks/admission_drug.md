Exploring admissionDrug Table
================
true

Adopted from <https://github.com/mit-lcp/eicu-code>

The following columns are available:

  - admissiondrugid - primary key, has no meaning but identifies rows
    uniquely
  - drugOffset - number of minutes from unit admit time that the
    admission drug was administered
  - drugEnteredOffset - number of minutes from unit admit time that the
    admission drug was entered
  - drugNoteType - unique note picklist types e.g.: Comprehensive
    Progress Admission Intubation
  - specialtyType - physician specialty picklist types e.g.:
    anesthesiology gastroenterology oncology
  - userType - who documented the drug from eCareManager user picklist
    types e.g.: eICU Physician, Nurse, Attending Physician
  - rxincluded - Does the Note have associated Rx data: True or False
  - writtenIneICU - Was the Note written in the eICU: True or False
  - drugName - name of the selected admission drug e.g.: POTASSIUM
    CHLORIDE/D5NS METAXALONE PRAVACHOL
  - drugDosage - dosage of the admission drug e.g.: 20.0000 400.000
  - drugUnit - picklist units of the admission drug e.g.: mg mg/kg patch
  - drugAdmitFrequency - picklist frequency with which the admission
    drug is administred e.g.: PRN twice a day at bedtime
  - drughiclseqno - a code representing the drug (hierarchical
    ingredient code list, HICL)

We recommend configuring the `config.ini` file to allow for connection
to the database without specifying your password each time.

### Loading libraries

``` r
library(data.table)
library(dplyr)
library(magrittr)
library(plyr)
```

### Examining the table

``` r
# data_folder is the local path to your data
df=fread(file.path(data_folder,'admissiondrug.csv'))
head(df)
```

    ##    admissiondrugid patientunitstayid drugoffset drugenteredoffset drugnotetype
    ## 1:         1589228            242954         64                79    Admission
    ## 2:         2063596            243285         29                39    Admission
    ## 3:         2063595            243285         29                39    Admission
    ## 4:         2063590            243285         29                39    Admission
    ## 5:         2063594            243285         29                39    Admission
    ## 6:         2063593            243285         29                39    Admission
    ##    specialtytype  usertype rxincluded writtenineicu           drugname
    ## 1:   eCM Primary THC Nurse       TRUE          TRUE            ELIQUIS
    ## 2:   eCM Primary THC Nurse      FALSE          TRUE      VICTOZA 2-PAK
    ## 3:   eCM Primary THC Nurse      FALSE          TRUE POTASSIUM CHLORIDE
    ## 4:   eCM Primary THC Nurse      FALSE          TRUE     CITALOPRAM HBR
    ## 5:   eCM Primary THC Nurse      FALSE          TRUE         OMEPRAZOLE
    ## 6:   eCM Primary THC Nurse      FALSE          TRUE           NAPROXEN
    ##    drugdosage drugunit drugadmitfrequency drughiclseqno
    ## 1:          0                                     37792
    ## 2:          0                                     36436
    ## 3:          0                                       549
    ## 4:          0                                     10321
    ## 5:          0                                      4673
    ## 6:          0                                      3727

### Examine a single patient¶

``` r
patientunitstayid_ = 2704494
df_patientunitstayid=df %>% subset (patientunitstayid==patientunitstayid_)
head(df_patientunitstayid)
```

    ##    admissiondrugid patientunitstayid drugoffset drugenteredoffset
    ## 1:        12752936           2704494       2154              2159
    ## 2:        13383116           2704494     -87132              2153
    ## 3:        13421610           2704494         22                48
    ## 4:        12752932           2704494       2154              2159
    ## 5:        13383117           2704494     -87132              2153
    ## 6:        13421608           2704494         22                48
    ##              drugnotetype specialtytype      usertype rxincluded writtenineicu
    ## 1: Comprehensive Progress   eCM Primary THC Physician       TRUE         FALSE
    ## 2: Comprehensive Progress   eCM Primary THC Physician       TRUE         FALSE
    ## 3:              Admission   eCM Primary     THC Nurse       TRUE          TRUE
    ## 4: Comprehensive Progress   eCM Primary THC Physician       TRUE         FALSE
    ## 5: Comprehensive Progress   eCM Primary THC Physician       TRUE         FALSE
    ## 6:              Admission   eCM Primary     THC Nurse       TRUE          TRUE
    ##       drugname drugdosage drugunit drugadmitfrequency drughiclseqno
    ## 1:       IMDUR          0                                      6341
    ## 2:    PROTONIX          0                                     22008
    ## 3:   ZAROXOLYN          0                                      3663
    ## 4:      CELEXA          0                                     10321
    ## 5: SOLU-MEDROL          0                                     36808
    ## 6:      SURFAK          0                                      1324

``` r
cols = c('admissiondrugid','patientunitstayid','drugoffset','drugenteredoffset','drugname','drughiclseqno')
df_patientunitstayid %>% select (cols)
```

    ##     admissiondrugid patientunitstayid drugoffset drugenteredoffset
    ##  1:        12752936           2704494       2154              2159
    ##  2:        13383116           2704494     -87132              2153
    ##  3:        13421610           2704494         22                48
    ##  4:        12752932           2704494       2154              2159
    ##  5:        13383117           2704494     -87132              2153
    ##  6:        13421608           2704494         22                48
    ##  7:        12752935           2704494       2154              2159
    ##  8:        13383119           2704494     -87132              2153
    ##  9:        13421609           2704494         22                48
    ## 10:        12752941           2704494       2154              2159
    ## 11:        13383118           2704494     -87132              2153
    ## 12:        13421612           2704494         22                48
    ## 13:        12752940           2704494       2154              2159
    ## 14:        13383115           2704494     -87132              2153
    ## 15:        13421615           2704494         22                48
    ## 16:        12752938           2704494       2154              2159
    ## 17:        13383110           2704494     -87132              2153
    ## 18:        13421614           2704494         22                48
    ## 19:        12752933           2704494       2154              2159
    ## 20:        13383114           2704494     -87132              2153
    ## 21:        13421613           2704494         22                48
    ## 22:        12752937           2704494       2154              2159
    ## 23:        13383112           2704494     -87132              2153
    ## 24:        13421611           2704494         22                48
    ## 25:        12752939           2704494       2154              2159
    ## 26:        13383111           2704494     -87132              2153
    ## 27:        13421607           2704494         22                48
    ## 28:        12752934           2704494       2154              2159
    ## 29:        13383113           2704494     -87132              2153
    ## 30:        13421606           2704494         22                48
    ##     admissiondrugid patientunitstayid drugoffset drugenteredoffset
    ##            drugname drughiclseqno
    ##  1:           IMDUR          6341
    ##  2:        PROTONIX         22008
    ##  3:       ZAROXOLYN          3663
    ##  4:          CELEXA         10321
    ##  5:     SOLU-MEDROL         36808
    ##  6:          SURFAK          1324
    ##  7: HYDRALAZINE HCL            89
    ##  8:       ZAROXOLYN          3663
    ##  9:          CELEXA         10321
    ## 10:       ZAROXOLYN          3663
    ## 11:          SURFAK          1324
    ## 12:       NEURONTIN          8831
    ## 13:          SURFAK          1324
    ## 14:       NEURONTIN          8831
    ## 15:      EXEMESTANE         20803
    ## 16:        PROTONIX         22008
    ## 17:          CELEXA         10321
    ## 18:           COREG         13795
    ## 19:           COREG         13795
    ## 20:           IMDUR          6341
    ## 21: HYDRALAZINE HCL            89
    ## 22:       NEURONTIN          8831
    ## 23:      EXEMESTANE         20803
    ## 24:        PROTONIX         22008
    ## 25:     SOLU-MEDROL         36808
    ## 26:           COREG         13795
    ## 27:           IMDUR          6341
    ## 28:      EXEMESTANE         20803
    ## 29: HYDRALAZINE HCL            89
    ## 30:     SOLU-MEDROL         36808
    ##            drugname drughiclseqno

Here we can see that these drugs were documented 2153 minutes (1.5 days)
after ICU admission, but administered 87132 minutes (60 days) *before*
ICU admission (thus, the negative offset). Since it’s reasonable to
assume the patient is still taking the drug (as this is the
admissiondrug table), `drugoffset` can likely be treated as a start time
for a prescription of the drug.

### Identifying patients admitted on a single drug

Let’s look for patients who were admitted on Zaroxolyn.

``` r
drug = 'ZAROXOLYN'
cols=c('admissiondrugid', 'patientunitstayid'
  , 'drugoffset', 'drugenteredoffset'
  , 'drugname', 'drughiclseqno')
df_drug_name = df %>% subset (drugname==drug) %>% select (cols)
cat(length(unique(df_drug_name$patientunitstayid)),'unit stays with', drug)
```

    ## 227 unit stays with ZAROXOLYN

Instead of using the drug name, we could try to use the HICL code.

``` r
hicl = 3663
df_drug_hicl = df %>% subset (drughiclseqno==hicl) %>% select (cols)
cat(length(unique(df_drug_hicl$patientunitstayid)),'unit stays with HICL =', hicl)
```

    ## 533 unit stays with HICL = 3663

As we can see, using the HICL returned many more observations. Let’s
take a look at a few:

``` r
# rows in HICL which are *not* in the drug dataframe
idx = setdiff(df_drug_hicl$admissiondrugid,df_drug_name$admissiondrugid)
# count the drug names
table(df_drug_hicl %>% subset (admissiondrugid %in% idx) %>% select(drugname))
```

    ## 
    ## METOLAZONE 
    ##        767

All the rows use the drug name “Metolazone”. Metolazone is the generic
name for the brand Zaroxolyn. This demonstrates the utility of using
HICL codes to identify drugs - synonyms like these are very common and
can be tedious to find.

### Hospitals with data available¶

``` r
patient=fread(file.path(data_folder,'patient.csv'))


patient_admission=patient %>% left_join(df) 
```

    ## Joining, by = "patientunitstayid"

``` r
patient_group=patient_admission %>% group_by(hospitalid) %>% tally(name = "patients")
df_group=patient_admission %>% subset(!is.na(admissiondrugid)) %>% group_by(hospitalid) %>% tally(name = "drugs")

hospitals= patient_group %>% full_join(df_group)
```

    ## Joining, by = "hospitalid"

``` r
hospitals=hospitals[order(-hospitals$drugs),]
hospitals=hospitals %>% mutate (data_completion=drugs/patients*100)
head(hospitals)
```

    ## # A tibble: 6 x 4
    ##   hospitalid patients  drugs data_completion
    ##        <int>    <int>  <int>           <dbl>
    ## 1        420   342170 341168            99.7
    ## 2        142    33887  33003            97.4
    ## 3        382    29047  28871            99.4
    ## 4        365    25941  25735            99.2
    ## 5        281    25564  25092            98.2
    ## 6        391    22992  22840            99.3

``` r
hospitals[is.na(hospitals)] = 0
hist(hospitals$data_completion,xlab = 'Number of hospitals', ylab = 'Percent of patients with data')
```

![](admission_drug_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

As is common in eICU-CRD, there are a subset of hospitals who routinely
utilize this portion of the medical record (and thus have 90-100% data
completion), while there are other hospitals who rarely use this
interface and thus have poor data completion (0-10%).
