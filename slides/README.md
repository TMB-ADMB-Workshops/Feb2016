# TMB install 
![ADMB/TMB is Awesome!](../images/ADMBTMB_Logo.png "ADMB-TMB")       
[Please go here for TMB install instructions ](https://github.com/kaskr/adcomp/wiki)      

## git  references
[git software: ](http://git-scm.com)      
[for Git help reference card: ](http://gitref.org)         
[for advanced git: ](http://progit.org)      
[Intro to git video (best to watch first, then again after some practice)](https://www.youtube.com/watch?v=ZDR433b0HJY)         

## Common git commands
|           |                 |
|------------|----------|
|git init		|	git checkout      |
|git clone	|		git merge      |
|git add		|	 git push      |
|git status	|		git fetch      |
|git commit	|		git pull      |
|git branch	|		git log      |

     
The above covers the basics of git (use 99% of time)      

## Remote access
1.  Please join my meeting. https://global.gotomeeting.com/join/534027645
2.  Use your microphone and speakers (VoIP) - a headset is recommended.  Or, call in using your telephone.
  * Dial +1 (224) 501-3312
  * Access Code: 534-027-645
  * Audio PIN: Shown after joining the meeting
  * Meeting ID: 534-027-645


## Schedule
|Mon|pm| Closer look at installation, GitHub, RStudio/Emacs/other |
|Tue |am| Working with parameters, nonlinear models |
|Tue |pm| Anatomy of the TMB package, objects, and overall design, group projects (breakouts?)|
|Tue (Fat) |ppm| Some sort of Mardi gras celebration... |
|Wed|am| Group project updates, Stock assessment models, debugging uncertainty estimates, MCMC developments (Cole) |
|Wed|pm| Debugging in TMB, contributing to the development, working on projects from groups|
|Thu|am| Group project updates, Random effects, geostatistical methods |
|Thu|pm| Related C++ libraries and R packages, CppAD, glmmTMB |
|Fri|am| Group project updates, Geostatistical and spatio-temporal models continued |
|Fri|pm| TBD (one degree of freedom) |

## Topics to consider for breakout groups
Below are some case studies that might be of interest for different groups (**please consider submitting your topic of interest!**)

  * Random effects for estimating future fishery weights at age (Jim I.)
  * Time series modeling (building from examples)

## Remote access
1.  Please join my meeting. https://global.gotomeeting.com/join/534027645

2.  Use your microphone and speakers (VoIP) - a headset is recommended.  Or, call in using your telephone.

  * Dial +1 (224) 501-3312
  * Access Code: 534-027-645
  * Audio PIN: Shown after joining the meeting

  * Meeting ID: 534-027-645


Arni, did you have an updated sense of how to structure the workshop given then exchanges we had yesterday?  I think we had settled on a morning-lecture, afternoon-workshop format with 2 days devoted to the geostatistical index standardization tool and spatio-temporal models. do you have ideas for teh remaining 3 days?

## TMB Improvement efforts
Below is a list provided from the core developer (Kasper Kristiansen) on ways the workshop may contribute to the TMB work.

1. Documentation. Some example tasks:
   * Create text versions of Latex displaymath formulas (so that formulas show up nicely not only in the pdf docs).
   * Doxygen documentation clean up.
   * Roxygen documentation clean up.

2. More streamlined testing workflow. Could be something like travis
   (Ben Bolker set it up for glmmTMB). But travis might not be sufficient.
   The ideal setup should run *all* tests on *all* combinations of
   * Operating system
   * With/without precompile
   * CRAN version / not CRAN version
   It should further be able to detect performance regressions - both
   in terms of runtime, compilation time and memory usage.
   (BTW we should keep an eye on https://github.com/r-hub/proposal )

3. Make debugging work on windows.

4. Make good consistent test scripts of e.g. the TMB array class,
   matrices etc. Purpose is to demonstrate syntax and test for
   correctness. There are some tests in "adcomp/tmb_syntax" but it
   needs improvement.

# Participants

| name | email | notes | N |
| --- | --- | --- | --- |
|Arni Magnusson |arnima@hafro.is |Hafro, Instructor! |1|
|Jim Thorson |James.Thorson@noaa.gov |NOAA, Instructor! |2|
|Jim Ianelli |jim.ianelli@noaa.gov |NOAA Uber Excel User| 3|
|Kirstin Holsman |Kirstin.Holsman@noaa.gov|NOAA|4|
|Martin Dorn |martin.dorn@noaa.gov  |NOAA, limited experience |5|
|Steve Martell |Martell.Steve@gmail.com |SeaState, Mac fanboy |6|
|Lee Qi |leeqi@uw.edu |UW |7|
|Teresa A’mar |teresa.amar@noaa.gov |NOAA Off of Sci and Tech. |8|
|Gwladys Lambert |gwladys.lambert@noaa.gov |NOAA Post doc |9|
|Johnoel Ancheta |johnoel@hawaii.edu |Univ of Hawaii, ADMB dude |10|
|Felipe Carvalho |felipe.carvalho@noaa.gov |JIMAR/NOAA |11|
|Yi-Jay Chang |yi-jay.chang@noaa.gov |JIMAR |12|
|Marc Nadon |marc.nadon@noaa.gov |JIMAR |13|
|Jessica Hale |jrh33@uw.edu |UW |14|
|Paul Spencer |Paul.Spencer@noaa.gov |NOAA |15|
|Anne Hollowed |Anne.Hollowed@noaa.gov |NOAA First day or 2 |16|
|Marie Ferguson |marie.ferguson@noaa.gov |NOAA |17|
|Andre Punt |aepunt@uw.edu |UW |18|
|Brandon Chasco |brandon.chasco@gmail.com |UW/OSU |19|
|Jin Gao|jingao@uw.edu | |20|
|Cole Monnahan|monnahc@uw.edu | |21|
|Bill Clark| | | 22|
|Kelli Johnson |kfjohns@uw.edu | |23|
|Allan Hicks |Allan.Hicks@noaa.gov | |24|
|Noble Hendrix | | |25|
|Elizabeth Phillips |emp11@uw.edu| |26 |

## Remote access participants
SEFSC Beaufort lab

NEFSC Legault/Brooks/Shank

(D)UMASS Gavin Fay, Megan Winton (mwinton@umassd.edu) 

NWFSC  / Newport lab

SWFSC (Huihua, 5-10 people)
