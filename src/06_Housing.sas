libname IPUMS "/home/u44593168";

/* Number of housing units */

/* Occupied vs. Vacant */
proc gchart data=IPUMS.houses;
	format VACANT VACANT_f.;
	donut VACANT / discrete clockwise slice=outside value=none percent=outside freq=HHWT;
run;
quit;

/* Ownership of occupied units */
proc gchart data=IPUMS.houses;
	format OWN OWN_f.;
	donut OWN / discrete clockwise slice=outside value=none percent=outside freq=HHWT;
run;
quit;

/* Types of structure */
proc gchart data=IPUMS.houses;
	format BLD_CAT BLD_CAT_f.;
	donut BLD_CAT / discrete clockwise slice=outside value=none percent=outside freq=HHWT;
run;
quit;

/* Year moved in, by percentage of population */
/* NOTE: Continuous data not available publicly */

/* Median value of owner-occupied housing units */
proc means data=IPUMS.houses median;
	var VAL_OWN;
	weight HHWT;
run;

/* Value of owner-occupied housing units */
ods select freqplot;
proc freq data=IPUMS.houses;
	format VAL_OWN_CAT VAL_OWN_CAT_f.;
	tables VAL_OWN_CAT / plots=freqplot(orient=vertical scale=percent);
	weight HHWT;
run;

/* Moved since previous year */
proc freq data=IPUMS.people;
	format MIG_CAT MIG_CAT_f.;
	tables MIG_CAT;
	weight PERWT;
run;

/* Population migration since previous year */
ods select freqplot;
proc freq data=IPUMS.people;
	format MIG_CAT2 MIG_CAT2_f.;
	tables MIG_CAT2 / plots=freqplot(orient=vertical scale=percent);
	weight PERWT;
run;
