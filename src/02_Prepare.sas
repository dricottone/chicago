libname IPUMS "/home/u44593168";

data IPUMS.houses;
	set IPUMS.raw_h;

	/*
		VACANT
		1: Occuped
		2: Vacant
		
		Recoded from VACS
		1 (For rent) -> 2
		2 (Rented, not occupied) -> 2
		3 (For sale only) -> 2
		4 (Sold, not occupied) -> 2
		5 (For seasonal/recreational/occasional use) -> 2
		6 (For migrant workers) -> 2
		7 (Other vacant) -> 2
		Also recoded from TEN
		1 (Owned with mortgage or loan (include home equity loans)) -> 1
		2 (Owned free and clear) -> 1
		3 (Rented) -> 1
		4 (Occupied without payment of rent) -> 1
	*/
	if US2021C_VACS in ("1" "2" "3" "4" "5" "6" "7") then VACANT=2;
	else if US2021C_TEN in ("1" "2" "3" "4") then VACANT=1;

	/*
		NP_NUM
		Numeric NP if occupied
	*/
	if US2021C_NP in ("B0" "B1" "B2" "B3" "B4" "B5" "B6" "B7" "B8" "B9") then NP_NUM=.;
	else if VACANT in (. 2) then NP_NUM=.;
	else NP_NUM=input(US2021C_NP, 2.);

	/*
		OWN
		Ownership of an occupied housing unit
		1: Owned
		2: Rented

		Recoded from TEN
		1 (Owned with mortgage or loan (include home equity loans)) -> 1
		2 (Owned free and clear) -> 1
		3 (Rented) -> 2
		4 (Occupied without payment of rent) -> 2
	*/
	if US2021C_TEN in ("B") then OWN=.;
	else if US2021C_TEN in ("1" "2") then OWN=1;
	else if US2021C_TEN in ("3" "4") then OWN=2;

	/*
		BLD_CAT
		housing units category
		1: Single unit
		2: Multi-unit
		3: Mobile home
		4: Boat, RV, van, etc.
		
		Recoded from BLD
		1 (Mobile home or trailer) -> 3
		2 (One-family house detached) -> 1
		3 (One-family house attached) -> 1
		4 (2 Apartments) -> 2
		5 (3-4 Apartments) -> 2
		6 (5-9 Apartments) -> 2
		7 (10-19 Apartments) -> 2
		8 (20-49 Apartments) -> 2
		9 (50 or more apartments) -> 2
		10 (Boat, RV, van, etc.) -> 4
	*/
	if US2021C_BLD="BB" then BLD_CAT=.;
	else if US2021C_BLD="01" then BLD_CAT=3;
	else if US2021C_BLD in ("02" "03") then BLD_CAT=1;
	else if US2021C_BLD in ("04" "05" "06" "07" "08" "09") then BLD_CAT=2;
	else if US2021C_BLD="10" then BLD_CAT=4;

	/*
		year moved in category
		1: Before 1990
		2: 1990s
		3: 2000s
		4: 2010-2014
		5: 2015-2016
		6: Since 2017
	*/

	/*
		VALP_NUM
		Numeric VALP
	*/
	if US2021C_VALP="BBBBBBB" then VALP_NUM=.;
	else VALP_NUM=input(US2021C_VALP, 7.);

	/*
		VAL
		Property value adjusted for current year
	*/
	if VALP_NUM=. then VAL=.;
	else if US2021C_ADJHSG in (. 0) then VAL=.;
	else VAL=VALP_NUM*US2021C_ADJHSG;

	/*
		VAL_OWN
		Property value of a housing unit if owner occupied, less than 10 acres, and not a mobile home
	*/
	if VAL=. then VAL_OWN=.;
	else if OWN in (. 0) then VAL_OWN=.;
	else if US2021C_SVAL in ("B" "0") then VAL_OWN=.;
	else VAL_OWN=VAL;

	/*
		VAL_OWN_CAT
		Categories of property value if owner occupied, less than 10 acres, and not a mobile home
		1: Up to $100k
		2: $100k-$200k
		3: $200k-$300k
		4: $300k-$400k
		5: $400k-$500k
		6: $500k-$1m
		7: $1m+
	*/
	if VAL=. then VAL_OWN=.;
	else if OWN in (. 2) then VAL_OWN_CAT=.;
	else if US2021C_SVAL in ("B" "0") then VAL_OWN=.;
	else if VAL_OWN<=99999 then VAL_OWN_CAT=1;
	else if 100000<=VAL_OWN<=199999 then VAL_OWN_CAT=2;
	else if 200000<=VAL_OWN<=299999 then VAL_OWN_CAT=3;
	else if 300000<=VAL_OWN<=399999 then VAL_OWN_CAT=4;
	else if 400000<=VAL_OWN<=499999 then VAL_OWN_CAT=5;
	else if 500000<=VAL_OWN<=999999 then VAL_OWN_CAT=6;
	else if 1000000<=VAL_OWN then VAL_OWN_CAT=7;
run;

data IPUMS.people;
	set IPUMS.raw_p;
	/*
		AGEP_NUM
		Numeric AGEP
		
		Recoded from AGEP
		B0-B9 -> .
	*/
	if US2021C_AGEP in ("B0" "B1" "B2" "B3" "B4" "B5" "B6" "B7" "B8" "B9") then AGEP_NUM=.;
	else AGEP_NUM = input(US2021C_AGEP, 2.);

	/*
		AGEP_CAT
		Categories of AGEP
		1: Under 10
		2: 10-19
		3: 20-29
		4: 30-39
		5: 40-49
		6: 50-59
		7: 60-69
		8: 70-79
		9: 80 and over
	*/
	if AGEP_NUM=. then AGEP_CAT=.;
	else if AGEP_NUM<=9 then AGEP_CAT=1;
	else if 10<=AGEP_NUM<=19 then AGEP_CAT=2;
	else if 20<=AGEP_NUM<=29 then AGEP_CAT=3;
	else if 30<=AGEP_NUM<=39 then AGEP_CAT=4;
	else if 40<=AGEP_NUM<=49 then AGEP_CAT=5;
	else if 50<=AGEP_NUM<=59 then AGEP_CAT=6;
	else if 60<=AGEP_NUM<=69 then AGEP_CAT=7;
	else if 70<=AGEP_NUM<=79 then AGEP_CAT=8;
	else if 80<=AGEP_NUM then AGEP_CAT=9;

	/*
		AGEP_CAT2
		Categories of AGEP
		1: Under 18
		2: 18-64
		3: 65 and over
	*/
	if AGEP_NUM=. then AGEP_CAT2=.;
	else if AGEP_NUM<=17 then AGEP_CAT2=1;
	else if 18<=AGEP_NUM<=64 then AGEP_CAT2=2;
	else if 65<=AGEP_NUM then AGEP_CAT2=3;

	/*
		AGEP_CAT3
		Categories of AGEP
		1: Under 18
		2: 18 and over
	*/
	if AGEP_NUM=. then AGEP_CAT3=.;
	else if AGEP_NUM<=17 then AGEP_CAT3=1;
	else if 18<=AGEP_NUM then AGEP_CAT3=2;

	/*
		SEX
		Categories of sex
		1: Male
		2: Female
	*/
	if US2021C_SEX="B" then SEX=.;
	else if US2021C_SEX="1" then SEX=1;
	else if US2021C_SEX="2" then SEX=2;

	/*
		RACE_ETH - combined race and ethnicity
		1: White
		2: Black
		3: American Indian/Alaska Native
		4: Asian
		5: Native Hawaiian/Pacific Islander
		6: Other
		7: Multiple
		8: Hispanic
	
		Recoded from RAC1P
		1 (White alone) -> 1
		2 (Black or African American alone) -> 2
		3 (American Indian alone) -> 3
		4 (Alaska Native alone) -> 3
		5 (American Indian and/or Alaska Native tribes alone) -> 3
		6 (Asian alone) -> 4
		7 (Native Hawaiian and Other Pacific Islander alone) -> 5
		8 (Some Other Race alone) -> 6
		9 (Two or More Races) -> 7
		. -> .
		Also recoded from HISP
		1 (Not Spanish/Hispanic/Latino) -> keep RAC1P recode
		2-24 (any of 23 different Hispanic categories) -> 8
	*/
	if US2021C_RAC1P="B" then RACE_ETH=.;
	else if US2021C_RAC1P="1" then RACE_ETH=1;
	else if US2021C_RAC1P="2" then RACE_ETH=2;
	else if US2021C_RAC1P in ("3" "4" "5") then RACE_ETH=3;
	else if US2021C_RAC1P="6" then RACE_ETH=4;
	else if US2021C_RAC1P="7" then RACE_ETH=5;
	else if US2021C_RAC1P="8" then RACE_ETH=6;
	else if US2021C_RAC1P="9" then RACE_ETH=7;
	if US2021C_HISP in ("02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24") then RACE_ETH=8;

	/*
		PINCP_NUM
		Numeric PINCP
	*/
	if US2021C_PINCP="BBBBBBB" then PINCP_NUM=.;
	else PINCP_NUM=input(US2021C_PINCP, 7.);

	/*
		INC
		Personal income adjusted for current year
	*/
	if PINCP_NUM=. then INC=.;
	else if US2021C_ADJINCP in (. 0) then INC=.;
	else INC=PINCP_NUM*US2021C_ADJINCP;

	/*
		POV
		Poverty status
		1: Poverty
		2: Non-poverty
	*/
	if US2021C_POVPIP="BBB" then POV=.;
	else if US2021C_POVPIP<100 then POV=1;
	else POV=2;

	/*
		COMM
		Commute minutes if 16 or older
	*/
	if US2021C_JWMNP="BBB" then COMM=.;
	else if AGEP_NUM<16 then COMM=.;
	else COMM=input(US2021C_JWMNP, 3.);

	/*
		COMM_CAT
		Commute categories if 16 or older
		1: Drove alone
		2: Carpooled
		3: Public transit
		4: Bicycle
		5: Walked
		6: Other
		7: Worked at home
		
		Recoded from JWTRNS
		1 (Car, truck, or van) -> 1
		2 (Bus) -> 3
		3 (Subway or elevated rail) -> 3
		4 (Long-distance train or commuter rail) -> 3
		5 (Light rail, streetcar, or trolley) -> 3
		6 (Ferryboat) -> 3
		7 (Taxicab) -> 6
		8 (Motorcycle) -> 6
		9 (Bicycle) -> 4
		10 (Walked) -> 5
		11 (Worked from home) -> 7
		12 (Other method) -> 6
		Also recoded from JWRIP
		1 (Drove alone) -> 1
		2-10 (In 2+ person carpool) -> 2
	*/
	if US2021C_JWTRNS="BB" then COMM_CAT=.;
	else if US2021C_JWTRNS="01" then COMM_CAT=1;
	else if US2021C_JWTRNS in ("02" "03" "04" "05" "06") then COMM_CAT=3;
	else if US2021C_JWTRNS="07" then COMM_CAT=6;
	else if US2021C_JWTRNS="08" then COMM_CAT=6;
	else if US2021C_JWTRNS="09" then COMM_CAT=4;
	else if US2021C_JWTRNS="10" then COMM_CAT=5;
	else if US2021C_JWTRNS="11" then COMM_CAT=7;
	else if US2021C_JWTRNS="12" then COMM_CAT=6;
	if US2021C_JWTRNS="01" and US2021C_JWRIP="01" then COMM_CAT=1;
	else if US2021C_JWTRNS="01" and US2021C_JWRIP in ("02" "03" "04" "05" "06" "07" "08" "09" "10") then COMM_CAT=2;
	if AGEP_NUM<16 then COMM_CAT=.;

	/*
		HHT_CAT
		House type category
		1: Married couples
		2: Male householder
		3: Female householder
		4: Non-family
		
		Recoded from HHT
		1 (Married couple household) -> 1
		2 (Other family household: Male householder, no spouse present) -> 2
		3 (Other family household: Female householder, no spouse present) -> 3
		4 (Nonfamily household: Male householder: Living alone) -> 4
		5 (Nonfamily household: Male householder: Not living alone) -> 4
		6 (Nonfamily household: Female householder: Living alone) -> 4
		7 (Nonfamily household: Female householder: Not living alone) -> 4
	*/
	if US2021C_HHT="B" then HHT_CAT=.;
	else if US2021C_HHT="1" then HHT_CAT=1;
	else if US2021C_HHT="2" then HHT_CAT=2;
	else if US2021C_HHT="3" then HHT_CAT=3;
	else if US2021C_HHT in ("4" "5" "6" "7") then HHT_CAT=4;

	/*
		MARRIED
		Marital status if 15 or older
		1: Married
		2: Not married
		
		Recoded from MAR
		1 (Married) -> 1
		2 (Widowed) -> 2
		3 (Divorced) -> 2
		4 (Separated) -> 2
		5 (Never married or under 15 years old) -> 2
	*/
	if US2021C_MAR="B" then MARRIED=.;
	else if AGEP_NUM=. or AGEP_NUM<15 then MARRIED=.;
	else if US2021C_MAR="1" then MARRIED=1;
	else if US2021C_MAR in ("2" "3" "4" "5") then MARRIED=2;

	/*
		MAR_CAT
		Categories of marital status if 15 or older
		1: Never married
		2: Married
		3: Divorced or separated
		4: Widowed
		
		Recoded from MAR
		1 (Married) -> 2
		2 (Widowed) -> 4
		3 (Divorced) -> 3
		4 (Separated) -> 3
		5 (Never married or under 15 years old) -> 1
	*/
	if US2021C_MAR="B" then MAR_CAT=.;
	else if AGEP_NUM=. or AGEP_NUM<15 then MARRIED=.;
	else if US2021C_MAR="5" then MAR_CAT=1;
	else if US2021C_MAR="1" then MAR_CAT=2;
	else if US2021C_MAR in ("3" "4") then MAR_CAT=3;
	else if US2021C_MAR="2" then MAR_CAT=4;

	/*
		BIRTH
		Gave birth in last year if woman and 15-50
		1: Gave birth in last year
		2: Did not give birth in last year
		
		Recoded from FER
		1 (Yes) -> 1
		2 (No) -> 2
	*/
	if US2021C_FER="B" then BIRTH=.;
	else if US2021C_FER="1" then BIRTH=1;
	else if US2021C_FER="2" then BIRTH=2;

	/*
		AGEP_CAT_BIRTH
		Age categories if woman and 15-50
		1: 15-19
		2: 20-24
		3: 25-29
		4: 30-35
		5: 35-39
		6: 40-44
		7: 45-50
	*/
	if SEX in (. 1) then AGEP_CAT_BIRTH=.;
	else if AGEP_NUM=. then AGEP_CAT_BIRTH=.;
	else if 15<=AGEP_NUM<=19 then AGEP_CAT_BIRTH=1;
	else if 20<=AGEP_NUM<=24 then AGEP_CAT_BIRTH=2;
	else if 25<=AGEP_NUM<=29 then AGEP_CAT_BIRTH=3;
	else if 30<=AGEP_NUM<=34 then AGEP_CAT_BIRTH=4;
	else if 35<=AGEP_NUM<=39 then AGEP_CAT_BIRTH=5;
	else if 40<=AGEP_NUM<=44 then AGEP_CAT_BIRTH=6;
	else if 45<=AGEP_NUM<=50 then AGEP_CAT_BIRTH=7;

	/*
		MIG_CAT
		moved in last year
		1: Moved in last year
		2: Did not move in last year
		
		Recoded from MIG
		1 (Yes, same house (nonmovers)) -> 2
		2 (No, outside US and Puerto Rico) -> 1
		3 (No, different house in US or Puerto Rico) -> 1
	*/
	if US2021C_MIG="B" then MIG_CAT=.;
	else if US2021C_MIG="1" then MIG_CAT=2;
	else if US2021C_MIG in ("2" "3") then MIG_CAT=1;

	/*
		MIGSP_NUM
		Numeric MIGSP
	*/
	if US2021C_MIGSP="BBB" then MIGSP_NUM=.;
	else MIGSP_NUM=input(US2021C_MIGSP, 3.);
	
	/*
		MIGPUMA_NUM
		Numeric MIGPUMA
	*/
	if US2021C_MIGPUMA="BBBBB" then MIGPUMA_NUM=.;
	else MIGPUMA_NUM=input(US2021C_MIGPUMA, 5.);
	
	/*
		MIG_CAT2
		lived last year categories
		1: Same house year ago
		2: From same county
		3: From different county
		4: From different state
		5: From abroad
		
		Recoded from MIG
		1 (Yes, same house (nonmovers)) -> 1
		2 (No, outside US and Puerto Rico) -> 5
		3 (No, different house in US or Puerto Rico) ...
			- If MIGSP~=17 (Illinois) -> 4
			- If MIGSP=17 but MIGPUMA~=03400 (Cook county) -> 3
			- If MIGSP=17 and MIGPUMA=03400 -> 2
	*/
	if US2021C_MIG="B" then MIG_CAT2=.;
	else if US2021C_MIG="1" then MIG_CAT2=1;
	else if US2021C_MIG="3" and MIGSP_NUM=17 and MIGPUMA_NUM=3400 then MIG_CAT2=2;
	else if US2021C_MIG="3" and MIGSP_NUM=17 then MIG_CAT2=3;
	else if US2021C_MIG="3" then MIG_CAT2=4;
	else if US2021C_MIG="2" then MIG_CAT2=5;

	/*
		HS
		1: High school graduate
		2: Not a high school graduate
		
		Recoded from SCHL
		1-15 (up to 12th grade no diploma) -> 2
		16-24 (Regular high school diploma or more) -> 1
	*/
		if US2021C_SCHL="BB" then HS=.;
		else if AGEP_NUM<25 then SCHL_CAT=.;
		else if US2021C_SCHL in ("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15") then HS=2;
		else if US2021C_SCHL in ("16" "17" "18" "19" "20" "21" "22" "23" "24") then HS=1;

	/*
		COLLEGE
		1: Bachelor's degree
		2: No bachelor's degree
		
		Recoded from SCHL
		1-20 (up to Associate's degree) -> 2
		21-24 (Bachelor's degree or more) -> 1
	*/
		if US2021C_SCHL="BB" then COLLEGE=.;
		else if AGEP_NUM<25 then SCHL_CAT=.;
		else if US2021C_SCHL in ("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20") then COLLEGE=2;
		else if US2021C_SCHL in ("21" "22" "23" "24") then COLLEGE=1;

	/*
		SCHL_CAT
		Education categories if 25 or older
		1: No degree
		2: High school
		3: Some college
		4: Bachelor's
		5: Post-grad
		
		Recoded from SCHL
		1-15 (up to 12th grade no diploma) -> 1
		16 (Regular high school diploma) -> 2
		17 (GED or alternative credential) -> 2
		18 (Some college, but less than 1 year) -> 3
		19 (1 or more years of college credit, no degree) -> 3
		20 (Associate's degree) -> 3
		21 (Bachelor's degree) -> 4
		22 (Master's degree) -> 5
		23 (Professional degree beyond a bachelor's degree) -> 5
		24 (Doctorate degree) -> 5
	*/
		if US2021C_SCHL="BB" then SCHL_CAT=.;
		else if AGEP_NUM<25 then SCHL_CAT=.;
		else if US2021C_SCHL in ("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15") then SCHL_CAT=1;
		else if US2021C_SCHL in ("16" "17") then SCHL_CAT=2;
		else if US2021C_SCHL in ("18" "19" "20") then SCHL_CAT=3;
		else if US2021C_SCHL in ("21") then SCHL_CAT=4;
		else if US2021C_SCHL in ("22" "23" "24") then SCHL_CAT=5;

	/*
		LAN_CAT
		Language spoken in home categories
		1: Language other than English spoken at home
		2: English only
		
		Recoded from LANX
		1 (Yes, speaks another language) -> 1
		2 (No, speaks only English) -> 2
	*/
	if US2021C_LANX="B" then LAN_CAT=.;
	else if US2021C_LANX="1" then LAN_CAT=1;
	else if US2021C_LANX="2" then LAN_CAT=2;

	/*
		LANP_NUM
		Numeric LANP
	*/
	if US2021C_LANP="BBBB" then LANP_NUM=.;
	else LANP_NUM=input(US2021C_LANP,4.);
	
	/*
		LAN_CAT2
		Language spoken in home categories
		1: English only
		2: Spanish
		3: Indo-European
		4: Asian/Islander
		5: Other
		
		Recoded from LANX
		2 (No, speaks only English) -> 1
		Also recoded from LANP
		1200-1205 -> 2
		1053-1056, 1069-1073, 1110-1564, 1711-1799 -> 3
		1643-1710, 1800-3798 -> 4
		1000-1052, 1057-1063, 1074-1109, 1565-1642, 3799-9499, 9600-9999 -> 5
	*/
	if US2021C_LANX="B" then LAN_CAT2=.;
	else if US2021C_LANX="2" then LAN_CAT2=1;
	else if 1200<=US2021C_LANP<=1205 then LAN_CAT2=2;
	else if 1053<=US2021C_LANP<=1056 or 1069<=US2021C_LANP<=1073 or 1110<=US2021C_LANP<=1564 or 1711<=US2021C_LANP<=1799 then LAN_CAT2=3;
	else if 1643<=US2021C_LANP<=1710 or 1800<=US2021C_LANP<=3798 then LAN_CAT2=4;
	else if 1000<=US2021C_LANP<=1052 or 1057<=US2021C_LANP<=1063 or 1074<=US2021C_LANP<=1109 or 1565<=US2021C_LANP<=1642 or 3799<=US2021C_LANP<=9499 or 9600<=US2021C_LANP<=9999 then LAN_CAT2=5;

	/*
		FOREIGN
		Foreign-born status
		1: Foreign-born
		2: Not foreign-born
		
		Recoded from NATIVITY
		1 (Native) -> 2
		2 (Foreign born) -> 1
	*/
	if US2021C_NATIVITY="B" then FOREIGN=.;
	else if US2021C_NATIVITY="1" then FOREIGN=2;
	else if US2021C_NATIVITY="2" then FOREIGN=1;

	/*
		POBP_NUM
		Numeric POBP if foreign-born
	*/
	if US2021C_POBP="BBB" then POBP_NUM=.;
	else if US2021C_NATIVITY="1" then POBP_NUM=.;
	else POBP_NUM=input(US2021C_POBP, 3.);

	/*
		POBP_CAT
		Place of birth categories if foreign-born
		1: Europe
		2: Asia
		3: Africa
		4: Oceania
		5: Latin America
		6: North America
	*/
	if POBP_NUM=. then POBP_CAT=.;
	else if 100<=POBP_NUM<=169 then POBP_CAT=1;
	else if 200<=POBP_NUM<=254 then POBP_CAT=2;
	else if POBP_NUM=300 or 302<=POBP_NUM<=399 then POBP_CAT=5;
	else if POBP_NUM=301 then POBP_CAT=6;
	else if 400<=POBP_NUM<=469 then POBP_CAT=3;
	else if 501<=POBP_NUM<=554 then POBP_CAT=4;

	/*
		MLPJ2
		WW2 Veteran status
		1: Veteran
	*/
	if US2021C_MLPJ in ("B" "0") then MLPJ2=.;
	else if US2021C_MLPJ="1" then MLPJ2=1;

	/*
		MLPH2
		Korea Veteran status
		1: Veteran
	*/
	if US2021C_MLPH in ("B" "0") then MLPH2=.;
	else if US2021C_MLPH="1" then MLPH2=1;

	/*
		MLPFG2
		February 1955 - July 1964 Veteran status
		1: Veteran
	*/
	if US2021C_MLPFG in ("B" "0") then MLPFG2=.;
	else if US2021C_MLPFG="1" then MLPFG2=1;

	/*
		MLPE2
		Vietnam Veteran status
		1: Veteran
	*/
	if US2021C_MLPE in ("B" "0") then MLPE2=.;
	else if US2021C_MLPE="1" then MLPE2=1;

	/*
		MLPCD2
		May 1975 - July 1990 Veteran status
		1: Veteran
	*/
	if US2021C_MLPCD in ("B" "0") then MLPCD2=.;
	else if US2021C_MLPCD="1" then MLPCD2=1;

	/*
		MLPB2
		Gulf (1990s) Veteran status
		1: Veteran
	*/
	if US2021C_MLPB in ("B" "0") then MLPB2=.;
	else if US2021C_MLPB="1" then MLPB2=1;

	/*
		MLPA2
		Gulf (2001-) Veteran status
		1: Veteran
	*/
	if US2021C_MLPA in ("B" "0") then MLPA2=.;
	else if US2021C_MLPA="1" then MLPA2=1;

	/*
		VET
		Veteran status
		1: Veteran
		2: Not veteran
	*/
	if MLPJ2=1 or MLPH2=1 or MLPFG2=1 or MLPE2=1 or MLPCD2=1 or MLPB2=1 or MLPA2=1 then VET=1;
	else VET=2;
run;

proc summary data=IPUMS.people;
	class SERIAL;
	var INC;
	output out=IPUMS.sumpeople sum=HHINC;
run;

data IPUMS.mergehouses;
	/*
		HHINC
		Household income
		
		Merged from an aggregation of the person-level data table
	*/
	merge
		IPUMS.houses (keep=SERIAL HHWT STRATA REPWT1-REPWT80 in=HOUSE)
		IPUMS.sumpeople (keep=SERIAL HHINC);
	by SERIAL;
	if HOUSE;
	if HHINC=0 then HHINC=.;

	/*
		HHINC_CAT
		Household income categories
		1: Under $50K
		2: $50K - $100K
		3: $100K - $200K
		4: Over $200K
	*/
	if HHINC=. then HHINC_CAT=.;
	else if HHINC<50000 then HHINC_CAT=1;
	else if 50000<=HHINC<100000 then HHINC_CAT=2;
	else if 100000<=HHINC<200000 then HHINC_CAT=3;
	else if 200000<=HHINC then HHINC_CAT=4;
run;

proc datasets library=IPUMS nolist;
   delete sumpeople;
run;

proc format;
	value SEX_f 	1="Male"
					2="Female";

	value AGEP_CAT_f 	1="0-9"
						2="10-19"
						3="20-29"
						4="30-39"
						5="40-49"
						6="50-59"
						7="60-69"
						8="70-79"
						9="80+";

	value AGEP_CAT2_f 	1="Under 18"
						2="18 to 64"
						3="65 and over";

	value AGEP_CAT3_f 	1="Under 18"
						2="18 and over";

	value RACE_ETH_f 	1="White"
						2="Black"
						3="Native"
						4="Asian"
						5="Islander"
						6="Other"
						7="Two+"
						8="Hispanic";

	value HHT_CAT_f 	1="Married couples"
						2="Male householder"
						3="Female householder"
						4="Non-family";

	value MARRIED_f 	1="Married"
						2="Single";

	value MAR_CAT_f 	1="Never married"
						2="Now married"
						3="Divorced"
						4="Widowed";

	value BIRTH_f 	1="Gave birth in last year"
					2="Did not give birth in last year";

	value AGEP_CAT_BIRTH_f 	1="15-19"
							2="20-24"
							3="25-29"
							4="30-34"
							5="35-39"
							6="40-44"
							7="45-50";

	value VACANT_f 	1="Occuped"
					2="Vacant";

	value OWN_f 	1="Owner occupied"
					2="Renter occupied";

	value VAL_OWN_CAT_f 	1="Under $100K"
							2="$100K-$200K"
							3="$200K-$300K"
							4="$300K-$400K"
							5="$400K-$500K"
							6="$500K-$1M"
							7="Over $1M";

	value HS_f 	1="High school grad or higher"
				2="Not a high school grad";

	value COLLEGE_f 	1="Bachelor's degree or higher"
						2="No Bachelor's degree";

	value SCHL_CAT_f 	1="No degree"
						2="High school"
						3="Some college"
						4="Bachelor's"
						5="Post-grad";

	value LAN_CAT_f 	1="Language other than English spoken at home"
						2="English only";

	value LAN_CAT2_f 	1="English only"
						2="Spanish"
						3="Indo-European"
						4="Asian/Islander"
						5="Other";

	value FB_f 	1="Foreign-born"
				2="Not foreign-born";

	value POBP_CAT_f 	1="Europe"
						2="Asia"
						3="Africa"
						4="Oceania"
						5="Latin America"
						6="North America";

	value VET_f 	1="Veteran"
					2="Not a veteran";

	value HHINC_CAT_f 	1="Under $50K"
						2="$50K - $100K"
						3="$100K - $200K"
						4="Over $200K";

	value POV_f 	1="Below poverty line"
					2="Above poverty line";

	value COMM_CAT_f 	1="Drove alone"
						2="Carpooled"
						3="Public transit"
						4="Bicycle"
						5="Walked"
						6="Other"
						7="Worked at home";

	value BLD_CAT_f 	1="Single unit"
						2="Multi-unit"
						3="Mobile home"
						4="Boat, RV, van, etc.";

	value MIG_CAT_f 	1="Moved in last year"
						2="Did not move in last year";

	value MIG_CAT2_f 	1="Same house year ago"
						2="From same county"
						3="From different county"
						4="From different state"
						5="From abroad";
run;
