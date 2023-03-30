# ACS 2021 PUMS


## IPUMS

The ACS databases used here were created and maintained by IPUMS USA,
University of Minnesota. Credit for the data belongs with:
 + Steven Ruggles, Sarah Flood, Matthew Sobek, Danika Brockman, Grace Cooper,  Stephanie Richards, and Megan Schouweiler. IPUMS USA: Version 13.0 [dataset]. Minneapolis, MN: IPUMS, 2023.
https://doi.org/10.18128/D010.V13.0
 + Steven Ruggles, Catherine A. Fitch, Ronald Goeken, J. David Hacker, Matt A. Nelson, Evan Roberts, Megan Schouweiler and Matthew Sobek. IPUMS Ancestry Full Count Data: Version 3.0 [dataset]. Minneapolis, MN: IPUMS, 2021.
https://doi.org/10.18128/D014.V3.0


## Household Records

Download a hierachical dataset from IPUMS containing these variables:
 + STATEFIP
 + PUMA
 + REPWT
 + ADJHSG
 + NP
 + TEN
 + VACS
 + VALP
 + SVAL
 + BLD

It should use the ACS 2021 5-year sample.

Optionally, subset the extraction to just Illinois cases (based on `STATEFIP`).
I subset later the cases anyway.

Also collect the SAS read instructions and the basic codebook.

```bash
$ gunzip usa_00006.dat.gz
$ wc -l usa_00006.dat
293143 usa_00006.dat
```

Now I manipulate the codebook into something useful for `awk(1)`.

```bash
$ sed -e '11,110!d' usa_00006.cbk | awk '{ print $4 }' | xargs echo
1 4 4 6 8 13 10 1 13 2 5 12 1 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 2 2 1 1 7 1
```

Examine the `STATEFIP` field. If I hadn't subset cases in the IPUMS portal,
I would do that now.

```bash
$ awk 'BEGIN {FIELDWIDTHS="1 4 4 6 8 13 10 1 13 2 5 12 1 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 2 2 1 1 7 1"} {if ($1=="H"){print $10}}' usa_00006.dat | sort -n | uniq -c
 293143 17
```

Now subset cases based on the `PUMA` field.

```bash
$ awk 'BEGIN {FIELDWIDTHS="1 4 4 6 8 13 10 1 13 2 5 12 1 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 2 2 1 1 7 1"} $11~/035(0[1234]|2[0123456789]|3[012])/' usa_00006.dat >usa_00006_chi.dat
$ wc -l usa_00006_chi.dat
52097 usa_00006_chi.dat
```

With this, I have a household data file that is restricted to just Chicago.


## Person Records

Download a rectangular dataset from IPUMS containing these variables:
 + STATEIP
 + PUMA
 + REPWTP
 + HHT
 + ADJINC
 + AGEP
 + FER
 + JWMNP
 + JWRIP
 + JWTRNS
 + LANX
 + MAR
 + MIG
 + MLPA
 + MLPB
 + MLPCD
 + MLPE
 + MLPFG
 + MLPH
 + MLPJ
 + SCHL
 + SEX
 + HISP
 + LANP
 + MIGPUMA
 + MIGSP
 + NATIVITY
 + PINCP
 + POBP
 + POVPIP
 + RAC1P

Follow all the same preparation steps as with the household extraction.

```bash
$ wc -l usa_00007.dat
621164 usa_00007.dat
$ sed -e '11,132!d' usa_00007.cbk | awk '{ print $4 }' | xargs echo
4 4 6 8 13 10 13 2 5 12 1 1 4 10 1 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 2 1 3 2 2 1 1 1 1 1 1 1 1 1 1 2 1 2 4 5 3 1 7 3 3 1
$ awk 'BEGIN {FIELDWIDTHS="4 4 6 8 13 10 13 2 5 12 1 1 4 10 1 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 2 1 3 2 2 1 1 1 1 1 1 1 1 1 1 2 1 2 4 5 3 1 7 3 3 1"} {print $8}' usa_00007.dat | sort -n | uniq -c
 621164 17
$ awk 'BEGIN {FIELDWIDTHS="4 4 6 8 13 10 13 2 5 12 1 1 4 10 1 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 7 2 1 3 2 2 1 1 1 1 1 1 1 1 1 1 2 1 2 4 5 3 1 7 3 3 1"} $9~/035(0[1234]|2[0123456789]|3[012])/' usa_00007.dat >usa_00007_chi.dat
$ wc -l usa_00007_chi.dat 
101501 usa_00007_chi.dat
```

