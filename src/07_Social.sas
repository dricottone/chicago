libname IPUMS "/home/u44593168";

/* High school grad or higher */
proc freq data=IPUMS.people;
	format HS HS_f.;
	tables HS;
	weight PERWT;
run;

/* Bachelor's degree or higher */
proc freq data=IPUMS.people;
	format COLLEGE COLLEGE_f.;
	tables COLLEGE;
	weight PERWT;
run;

/* Population by highest level of education */
ods select freqplot;
proc freq data=IPUMS.people;
	format SCHL_CAT SCHL_CAT_f.;
	tables SCHL_CAT / plots=freqplot(orient=vertical scale=percent);
	weight PERWT;
run;

/* Persons with language other than English spoken at home */
proc freq data=IPUMS.people;
	format LAN_CAT LAN_CAT_f.;
	tables LAN_CAT;
	weight PERWT;
run;

/* Language at home, children 5-17 - adults 18+ */
proc sort data=IPUMS.people
		out=IPUMS.sortpeople;
	by AGEP_CAT3;
run;
ods select freqplot;
proc freq data=IPUMS.sortpeople;
	format LAN_CAT2 LAN_CAT2_f. AGEP_CAT3 AGEP_CAT3_f.;
	by AGEP_CAT3;
	tables LAN_CAT2 / plots=freqplot(orient=vertical scale=percent);
	weight PERWT;
run;
proc datasets library=IPUMS nolist;
	delete sortpeople;
run;

/* Foreign-born population */
proc freq data=IPUMS.people;
	format FOREIGN FOREIGN_f.;
	tables FOREIGN;
	weight PERWT;
run;

/* Place of birth for foreign-born population */
ods select freqplot;
proc freq data=IPUMS.people;
	format POBP_CAT POBP_CAT_f.;
	tables POBP_CAT / plots=freqplot(orient=vertical scale=percent);
	weight PERWT;
run;

/* Veteran status */
proc freq data=IPUMS.people;
	format VET VET_f.;
	tables VET;
	weight PERWT;
run;

/* Veterans by wartime service */
proc freq data=IPUMS.people;
	tables MLPJ2 MLPH2 MLPE2 MLPB2 MLPA2;
	weight PERWT;
run;

/*  Total veterans - Male - Female */
proc freq data=IPUMS.people;
	format VET VET_f. SEX SEX_f.; 
	tables VET*SEX / nopercent nocol norow nocum;
	weight PERWT;
run;
