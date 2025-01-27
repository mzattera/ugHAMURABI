﻿0REM Copyright 2024 Massimiliano "Maxi" Zattera
REM
REM Licensed under the Apache License, Version 2.0 (the "License");
REM you may not use this file except in compliance with the License.
REM You may obtain a copy of the License at
REM
REM     http://www.apache.org/licenses/LICENSE-2.0
REM
REM Unless required by applicable law or agreed to in writing, software
REM distributed under the License is distributed on an "AS IS" BASIS,
REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM See the License for the specific language governing permissions and
REM limitations under the License.

TILEMAP ENABLE: CLS
DEFINE SCREEN MODE UNIQUE
DEFINE DOUBLE BUFFER OFF
DEFINE TASK COUNT 1
DEFINE DEFAULT TYPE INTEGER

10 CENTER "HAMURABI"
20 CENTER "CREATIVE COMPUTING"
   CENTER "MORRISTOWN, NEW JERSEY"
30 PRINT:PRINT:PRINT
80 PRINT "TRY YOUR HAND AT GOVERNING ANCIENT SUMERIA";
90 PRINT " FOR A TEN-YEAR TERM OF OFFICE.":PRINT

   REM Initializes random number generator in a way that works for emulators too
   PRINT: PRINT: PRINT "PRESS ANY KEY...";: WAIT KEY: RANDOMIZE RASTER LINE 
 
95  dead=0: DIM percStarved AS FLOAT: percStarved=0.0: DIM app AS FLOAT
100 year=0: population=95: store=2800: harvested=3000: eaten=harvested-store
110 bpa=3: acres=harvested/bpa: babies=5
	plagueRoll=1: REM this is a value in [-3,16] that when <=0 will cause a plague

210 starved=0

215 CLS: PRINT "HAMURABI: I BEG TO REPORT TO YOU": PRINT : year=year+1
217 PRINT "YEAR        : ";year
	PRINT "STARVED     : ";starved
	PRINT "NEW ARRIVALS: ";babies
218 population=population+babies

227 IF plagueRoll>0 THEN 230
228 population=population/2
229 PRINT "A HORRIBLE PLAGUE STRUCK!"

230	PRINT "POPULATION  : ";population
	PRINT "ACRES OWNED : ";acres
	PRINT "HARVESTED   : ";bpa;" BUSHELS/ACRE"
	PRINT "RATS ATE    : ";eaten;" BUSHELS"
	PRINT "IN STORE    : ";store;" BUSHELS": PRINT
270 IF year=11 THEN 860

	REM Check whether player wants to buy land
	
310 bpa=RND(10)+17
312 PRINT "LAND PRICE : ";bpa;" BUSHELS/ACRE."
320 PRINT "BUY HOW MANY ACRES? ";
321 INPUT q: IF q>=0 THEN 322
	GOSUB 850: REM Error message
	GOTO 320
322 IF bpa*q<=store THEN 330
323 GOSUB 710: REM Error message
324 GOTO 320
330 IF q=0 THEN 340
331 acres=acres+q: store=store-bpa*q
334 GOTO 410

	REM Check whether player wants to sell land
	
340 PRINT "SELL HOW MANY ACRES? ";
341 INPUT q: IF q>=0 THEN 342
	GOSUB 850: REM Error message
	GOTO 340
342 IF q<acres THEN 350
343 GOSUB 720: REM Error message
344 GOTO 340
350 acres=acres-q: store=store+bpa*q

	REM Feed people
	
410 PRINT "FEED HOW MANY BUSHELS? ";
411 INPUT q
412 IF q>=0 THEN 420
	GOSUB 850: REM Error message
	GOTO 410
418 REM *** TRYING TO USE MORE GRAIN THAN IS IN SILOS?
420 IF q<=store THEN 430
421 GOSUB 710: REM Error message
422 GOTO 410
430 store=store-q

	REM Plant crop
	
440 PRINT "PLANT HOW MANY ACRES? ";
441 INPUT s: IF s=0 THEN 511
442 IF s>=0 THEN 445
	GOSUB 850: REM Error message
	GOTO 440
444 REM *** TRYING TO PLANT MORE ACRES THAN YOU OWN?
445 IF s<=acres THEN 450
446 GOSUB 720: REM Error message
447 GOTO 440
449 REM *** ENOUGH GRAIN FOR SEED?
450 IF (s/2)<=store THEN 455
452 GOSUB 710: REM Error message
453 GOTO 440
454 REM *** ENOUGH PEOPLE TO TEND THE CROPS?
455 IF s<10*population THEN 510
460 PRINT "YOU HAVE ONLY ";population;" WORKERS!"
470 GOTO 440
510 store=store-(s/2)

	REM Harvest, check rats, recompute store and population
	
511 GOSUB 800: REM Put random value in c
512 REM *** A BOUNTIFUL HARVEST!
515 bpa=c: harvested=s*bpa: eaten=0
521 GOSUB 800: REM Put random value in c
522 IF (c MOD 2)<>0 THEN 530
523 REM *** RATS ARE RUNNING WILD!!
525 eaten=store/c
530 store=store-eaten+harvested
531 GOSUB 800: REM Put random value in c
532 REM *** LET'S HAVE SOME BABIES
533 babies=INT((20.0*acres+store)*c/population/100.0)+1
539 REM *** HOW MANY PEOPLE HAD FULL TUMMIES?
540 fed=q/20
541 REM *** HORROS, A 15% CHANCE OF PLAGUE
	REM This is indeed 20% chance
542 plagueRoll=RND(20)-3:
550 IF population<fed THEN 210
551 REM *** STARVE ENOUGH FOR IMPEACHMENT?
552 starved=population-fed: IF starved>(0.45*population) THEN 560
553 percStarved=(percStarved*(year-1)+100.0*starved/population)/year
555 population=fed: dead=dead+starved: GOTO 215
560 PRINT: PRINT "YOU STARVED ";starved;" PEOPLE IN ONE YEAR!!!"

	REM Impeachment message
	
565 PRINT "DUE TO THIS EXTREME MISMANAGEMENT YOU HAVE NOT ONLY ";
566 PRINT "BEEN IMPEACHED AND THROWN OUT OF OFFICE BUT YOU HAVE ";
567 PRINT "ALSO BEEN DECLARED NATIONAL FINK!!!!": GOTO 990

	REM Asked to sell too many bushels
	
710 PRINT "YOU HAVE ONLY ";
711 PRINT store;" BUSHELS."
712 RETURN

	REM Asked to sell too many acres
	
720 PRINT "YOU OWN ONLY ";acres;" ACRES."
730 RETURN

	REM Roll a 5-side dice in c
	
800 c=RND(5)+1
801 RETURN

	REM An invalid order was entered
	REM Print error instead of ending like in the original
	
850 PRINT "I CANNOT DO WHAT YOU WISH."
857 RETURN

	REM End of game
	
860 PRINT: PRINT "IN YOUR OFFICE TERM "; INT(percStarved); "% ";
862 PRINT "PEOPLE DIED ON AVERAGE EACH YEAR. A TOTAL OF ";
865 PRINT dead;"!!": app=acres/population
870 PRINT "YOU STARTED WITH 10 ACRES/PERSON AND ENDED WITH ";
875 PRINT INT(app);" ACRES/PERSON.": PRINT
880 IF percStarved>33.0 THEN 565: REM Impeachemnt message
885 IF app<7.0 THEN 565
890 IF percStarved>10.0 THEN 940
892 IF app<9.0 THEN 940
895 IF percStarved>3.0 THEN 960
896 IF app<10.0 THEN 960
900 PRINT "A FANTASTIC PERFORMANCE!!! CHARLEMANGE, DISRAELI, AND ";
905 PRINT "JEFFERSON COMBINED COULD NOT HAVE DONE BETTER!":GOTO 990
940 PRINT "YOUR HEAVY-HANDED PERFORMANCE SMACKS OF NERO AND IVAN IV. ";
945 PRINT "THE PEOPLE (REMIANING) FIND YOU AN UNPLEASANT RULER, AND, ";
950 PRINT "FRANKLY, HATE YOUR GUTS!!":GOTO 990
960 PRINT "YOUR PERFORMANCE COULD HAVE BEEN SOMEWHAT BETTER, BUT ";
965 PRINT "REALLY WASN'T TOO BAD AT ALL. ";INT(0.8*RND(population));" PEOPLE ";
970 PRINT "WOULD DEARLY LIKE TO SEE YOU ASSASSINATED BUT WE ALL HAVE OUR ";
975 PRINT "TRIVIAL PROBLEMS."

990 PRINT: FOR n=1 TO 10: BELL: NEXT n
995 PRINT "SO LONG FOR NOW.": PRINT
999 PRINT "PRESS ANY KEY...";: WAIT KEY: GOTO 95



