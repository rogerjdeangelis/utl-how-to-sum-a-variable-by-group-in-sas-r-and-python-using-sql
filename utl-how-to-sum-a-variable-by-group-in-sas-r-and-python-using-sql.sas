%let pgm=utl-how-to-sum-a-variable-by-group-in-sas-r-and-python-using-sql;

how to sum a variable by group in sas r and python using sql

   Three Solutions

       1 sas sql     (uses stattransfer to create sas dataset)
       2 r sql       (uses stattransfer to create sas dataset)
       3 python sql  (uses stattransfer to create sas dataset)

github
https://tinyurl.com/dycku42d
https://github.com/rogerjdeangelis/utl-how-to-sum-a-variable-by-group-in-sas-r-and-python-using-sql

inspired by
https://stackoverflow.com/questions/1660124/how-to-sum-a-variable-by-group

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                                     |                                        |                                         */
/*        INPUT                        |           PROCESS                      |            OUTPUT                       */
/*                                     |                                        |                                         */
/*                                     |                                        |                                         */
/*    libname sd1 "d:/sd1";            | %utl_rbegin;                           | ROWNAMES    CATEGORY    SUMFRQ          */
/*    data sd1.have;                   | parmcards4;                            |                                         */
/*      input Category$ Frequency;     | library(haven)                         |     1        First        30            */
/*    cards4;                          | library(sqldf)                         |     2        Second        5            */
/*    First 10                         | source("c:/temp/fn_tosas9.R")          |     3        Third        34            */
/*    First 15                         | have<-read_sas("d:/sd1/have.sas7bdat") |                                         */
/*    First 5                          | want<-sqldf("                          |                                         */
/*    Second 2                         |   select                               |                                         */
/*    Third 14                         |      category                          |                                         */
/*    Third 20                         |     ,sum(frequency) as sumfrq          |                                         */
/*    Second 3                         |   from                                 |                                         */
/*    ;;;;                             |      have                              |                                         */
/*   run;quit;                         |    group by                            |                                         */
/*                                     |      category");                       |                                         */
/*                                     | want;                                  |                                         */
/*                                     | fn_tosas9(dataf=want);                 |                                         */
/*                                     |;;;;                                    |                                         */
/*                                     | %utl_rend;                             |                                         */
/*                                     |                                        |                                         */
/*                                     | libname tmp "c:/temp";                 |                                         */
/*                                     | proc print data=tmp.want;              |                                         */
/*                                     | run;quit;                              |                                         */
/*                                     |                                        |                                         */
/**************************************************************************************************************************/

 /*                   _      __                                          _   _
(_)_ __  _ __  _   _| |_   / _| ___    ___  __ _ ___   _ __  _ __  _   _| |_| |__   ___  _ __
| | `_ \| `_ \| | | | __| | |_ / _ \  / __|/ _` / __| | `__|| `_ \| | | | __| `_ \ / _ \| `_ \
| | | | | |_) | |_| | |_  |  _| (_) | \__ \ (_| \__ \ | |   | |_) | |_| | |_| | | | (_) | | | |
|_|_| |_| .__/ \__,_|\__| |_|  \___/  |___/\__,_|___/ |_|   | .__/ \__, |\__|_| |_|\___/|_| |_|
        |_|                                                 |_|    |___/
*/


libname sd1 "d:/sd1";
data sd1.have;
  input Category$ Frequency;
cards4;
First 10
First 15
First 5
Second 2
Third 14
Third 20
Second 3
;;;;
run;quit;

 /*
/ |  ___  __ _ ___
| | / __|/ _` / __|
| | \__ \ (_| \__ \
|_| |___/\__,_|___/

*/

proc sql;
  create
      table want as
  select
     category
    ,sum(frequency) as sumfrq
  from
     sd1.have
   group by
     category
;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/* Obs    CATEGORY    SUMFRQ                                                                                              */
/*                                                                                                                        */
/*  1      First        30                                                                                                */
/*  2      Second        5                                                                                                */
/*  3      Third        34                                                                                                */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

%utl_rbegin;
parmcards4;
library(haven)
library(sqldf)
source("c:/temp/fn_tosas9.R")
have<-read_sas("d:/sd1/have.sas7bdat")
want<-sqldf("
  select
     category
    ,sum(frequency) as sumfrq
  from
     have
   group by
     category");
want;
fn_tosas9(dataf=want);
;;;;
%utl_rend;

libname tmp "c:/temp";
proc print data=tmp.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  R                                                                                                                     */
/*                                                                                                                        */
/*    CATEGORY sumfrq                                                                                                     */
/*  1    First     30                                                                                                     */
/*  2   Second      5                                                                                                     */
/*  3    Third     34                                                                                                     */
/*                                                                                                                        */
/*  SAS                                                                                                                   */
/*                                                                                                                        */
/*  ROWNAMES    CATEGORY    SUMFRQ                                                                                        */
/*                                                                                                                        */
/*      1        First        30                                                                                          */
/*      2        Second        5                                                                                          */
/*      3        Third        34                                                                                          */
/*                                                                                                                        */
/**************************************************************************************************************************/

 /*____               _   _                             _
|___ /   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
  |_ \  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 ___) | | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|____/  | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
        |_|    |___/                                |_|
*/

%utl_pybegin;
parmcards4;
import os
import sys
import subprocess
import time
from os import path
import pandas as pd
import numpy as np
import pyreadstat as ps
from pandasql import sqldf
mysql = lambda q: sqldf(q, globals())
from pandasql import PandaSQL
pdsql = PandaSQL(persist=True)
sqlite3conn = next(pdsql.conn.gen).connection.connection
sqlite3conn.enable_load_extension(True)
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll')
mysql = lambda q: sqldf(q, globals())
have,meta=ps.read_sas7bdat \
("d:/sd1/have.sas7bdat")
print(have)
want = pdsql('''
  select
     category
    ,sum(frequency) as sumfrq
  from
     have
   group by
     category
''')
print(want)
exec(open('c:/temp/fn_tosas9.py').read())
fn_tosas9(
   want
   ,dfstr="want"
   ,timeest=3
   )
;;;;
%utl_pyend;

libname tmp "c:/temp";
proc print data=tmp.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* Python                                                                                                                 */
/*                                                                                                                        */
/*   CATEGORY  sumfrq                                                                                                     */
/* 0    First    30.0                                                                                                     */
/* 1   Second     5.0                                                                                                     */
/* 2    Third    34.0                                                                                                     */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/*                                                                                                                        */
/* Obs    CATEGORY    SUMFRQ                                                                                              */
/*                                                                                                                        */
/*  1      First        30                                                                                                */
/*  2      Second        5                                                                                                */
/*  3      Third        34                                                                                                */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
