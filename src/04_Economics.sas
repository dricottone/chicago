libname IPUMS "/home/u44593168";

/* Per capita income */
proc means data=IPUMS.people sum noprint;
	var INC;
	weight PERWT;
	output out=IPUMS.sumproduct sum=GDP;
run;
proc means data=IPUMS.people sum noprint;
	var PERWT;
	output out=IPUMS.sumpopulation sum=POP;
run;
data IPUMS.productpercapita;
	merge
		IPUMS.sumproduct (keep=GDP)
		IPUMS.sumpopulation (keep=POP);
	INCOME_PER_CAPITA=GDP/POP;
run;
proc print data=IPUMS.productpercapita;
	var INCOME_PER_CAPITA;
run;
proc datasets library=IPUMS nolist;
   delete sumproduct sumpopulation productpercapita;
run;

/* Median household income */
proc means data=IPUMS.mergehouses median;
	var HHINC;
	weight HHWT;
run;

/* Household income */
ods select freqplot;
proc freq data=IPUMS.mergehouses;
	format HHINC_CAT HHINC_CAT_f.;
	tables HHINC_CAT / plots=freqplot(orient=vertical scale=percent);
	weight HHWT;
run;

/* Persons below poverty line */
proc freq data=IPUMS.people;
	format POV POV_f.;
	tables POV / plots=freqplot(orient=vertical scale=percent);
	weight PERWT;
run;

/* Persons below poverty line - Children (Under 18) - Seniors (65 and over) */
proc sort data=IPUMS.people
		out=IPUMS.sortpeople;
	by AGEP_CAT2;
run;
proc gchart data=IPUMS.sortpeople;
	format POV POV_f. AGEP_CAT2 AGEP_CAT2_f.;
	by AGEP_CAT2;
	donut POV / discrete clockwise slice=outside value=none percent=outside freq=PERWT;
run;
quit;
proc datasets library=IPUMS nolist;
	delete sortpeople;
run;

/* Mean travel time to work */
proc means data=IPUMS.people mean;
	var COMM;
	weight PERWT;
run;

/* Means of transportation to work */
proc freq data=IPUMS.people;
	format COMM_CAT COMM_CAT_f.;
	tables COMM_CAT / plots=freqplot(orient=vertical scale=percent);
	weight PERWT;
run;
