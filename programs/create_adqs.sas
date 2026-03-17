/*Sample QS dataset (CNS - PANSS scores) */
data qs;
    input USUBJID $ VISIT $ QSTESTCD $ QSSTRESN;
    datalines;
  01 BASE PANSS 80
  01 WEEK1 PANSS 70
  01 WEEK2 PANSS 65
  02 BASE PANSS 90
  02 WEEK1 PANSS 85
  02 WEEK2 PANSS 80
  ;
  run;

/*Sort QS data */
proc sort data=qs;
by USUBJID QSTESTCD VISIT;
run;

/*Derive Baseline */
data baseline;
   set qs;
   where VISIT = "BASE";
   rename QSSTRESN = BASE;
   keep USUBJID QSTESTCD BASE;
run;

/* Create ADQS dataset */
data adqs;
  merge qs baseline;
  by USUBJID QSTESTCD;

  PARAMCD = QSTESTCD;
  PARAM = "PANSS Total Score";

  AVAL = QSSTRESN;
  CHG = AVAL - BASE;

  /*Baseline flag*/
  if VISIT = "BASE" then ABLFL = "Y";

  /*Visit mapping*/
  if VISIT = "BASE" then AVISITN = 0;
  else if VISIT = "WEEK1" then AVISITN = 1;
  else if VISIT = "WEEK2" then AVISITN = 2;

  AVISIT = VISIT;

run;
