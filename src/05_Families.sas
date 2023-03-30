libname IPUMS "/home/u44593168";

/* Number of households */
proc means data=IPUMS.houses sum;
	var HHWT;
run;

/* Persons per household */
proc means data=IPUMS.houses mean maxdec=1;
	var NP_NUM;
	weight HHWT;
run;

/* Population by household type */
proc gchart data=IPUMS.people;
	format HHT_CAT HHT_CAT_f.;
	donut HHT_CAT / discrete clockwise slice=outside value=none percent=outside freq=PERWT;
run;
quit;

/* Marital Status */
proc gchart data=IPUMS.people;
	format MARRIED MARRIED_f.;
	donut MARRIED / discrete clockwise slice=outside value=none percent=outside freq=PERWT;
run;
quit;

/* Marital status, by sex */
proc sort data=IPUMS.people
		out=IPUMS.sortpeople;
	by SEX;
run;
ods select freqplot;
proc freq data=IPUMS.sortpeople;
	format SEX SEX_f. MAR_CAT MAR_CAT_f.;
	by SEX;
	tables MAR_CAT / plots=freqplot(orient=vertical scale=percent);
	weight PERWT;
run;
proc datasets library=IPUMS nolist;
	delete sortpeople;
run;

/* Fertility */
proc freq data=IPUMS.people;
	format BIRTH BIRTH_f.;
	tables BIRTH;
	weight PERWT;
run;

/* Women who gave birth during past year, by age group */
ods select freqplot;
proc freq data=IPUMS.people;
	format BIRTH BIRTH_f. AGEP_CAT_BIRTH AGEP_CAT_BIRTH_f.;
	tables BIRTH*AGEP_CAT_BIRTH / plots=freqplot(orient=vertical scale=grouppercent);
	weight PERWT;
run;
