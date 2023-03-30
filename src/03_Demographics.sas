libname IPUMS "/home/u44593168";

/* Population */
proc means data=IPUMS.people sum;
	var PERWT;
run;

/* Median Age */
proc means data=IPUMS.people median maxdec=1;
	var AGEP_NUM;
	weight PERWT;
run;

/* Population by age range */
ods select freqplot;
proc freq data=IPUMS.people;
	format AGEP_CAT AGEP_CAT_f.;
	tables AGEP_CAT / plots=freqplot(orient=vertical scale=percent);
	weight PERWT;
run;

/* Population by age category */
proc gchart data=IPUMS.people;
	format AGEP_CAT2 AGEP_CAT2_f.;
	donut AGEP_CAT2 / discrete clockwise slice=outside value=none percent=outside freq=PERWT;
run;
quit;

/* Sex */
proc gchart data=IPUMS.people;
	format SEX SEX_f.;
	donut SEX / discrete clockwise slice=outside value=none percent=outside freq=PERWT;
run;
quit;

/* Race & Ethnicity */
ods select freqplot;
proc freq data=IPUMS.people;
	format RACE_ETH RACE_ETH_f.;
	tables RACE_ETH / plots=freqplot(orient=vertical scale=percent);
	weight PERWT;
run;
