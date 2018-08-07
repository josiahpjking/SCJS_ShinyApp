SCJS Police Division Shiny
================================================

Table of contents
=================
<!--ts-->
* [Overview](#overview)
   * [Loader.R script](#1-loader.r)
* [App components](#app-components)
   * [Home tab](#1-home-tab)
   * [Division breakdown](#2-breakdown-by-police-divisions)
   * [Comparison tool](#3-comparison-tool)
   * [Trends tab](#4-trends)
   * [Help/Info/Links](#5-help-info-links)
<!--te-->


Overview
========
The app is contained inside the SCJS_ShinyApp/app folder.  
There is an associated .Rproj file which preserves information about workspace etc required for updating the app. This is found in the SCJS_ShinyApp folder.  

Updating the app can be done via the loader.R script.  
This script is designed to accommodate those who have limited/no experience of R, but need to update the shiny app when receiving a new dataset.  


1 loader.R
----------
The loader.R script does the following (in order):  
- Reads in the relevant variables from NVF datasets (all years)  
(because SG machines appear to give limited CPU resources to R, loading all variables was time-consuming)  
- Tidies demographic variables (police divisions, age etc.)  
(not all of this is necessary, and is leftover from before the decision to focus on police divisions, but it's harmless, and may one day be useful)  
- Recodes the questions.  
This involves separating out groups of variables which match patterns of responses we are interested in, and then recoding them in the data 
(e.g. for polconf, dconf, polop questions, we are interested in responses of 1&2 compared to responses of -2,-1,3,4,&5. So we collapse these to just be 0s and 1s)  
- Checks to see what variables are present in which year.  
(completely unnecessary for the app, but if you're working through it and not familiar with the survey, then useful)  
- Creates datasets of proportions, by police div and by year  
This involves:  
	choosing the variables of interest (separated by individual vs household weighting)  
	calculating sample sizes and weighted proportions for each variable/police division/year  
	reshaping these into long format  
	joining with design factors  
	calculating confidence intervals  
- Gets the data ready for the app  
This involves:  
	joining information about the variables (contained in the data/variable_information.csv)  
	setting up things like user input choices and colour schemes  
	loading the map data (from data/pd_mapdata.RDS)  
- Updates/Overwrites the .Rdata file used in the app  
The .Rdata file is the workspace which the app runs from.  
- Deploys the app locally (i.e. opens it on your machine)  


App components
==============

1 Home Tab
----------
Aims to give a (very broad) overview of the SCJS by focusing on the 3 national indicators included in the survey.   
Infographics on whether they each indicator is improving, maintaining, or worsening.  
Map of police divisions coloured by National Indicators (user selection).  
Button links to the other tabs in the app.  

ui_home.R : layout, including text.  

server_home.R :  
- national indicator graphics (call the correct icon and text to display).  
- observes button clicks to update tab selection.  

server_map.R :  
- map output  

(icons for buttons and indicators are found in  /app/www/ )  


2 Breakdown by police divisions
-------------------------------
Highlights how police divisions have performed relative to the national average.  
Users select a survey area, and a year/police division (depending on graph).  
There are two graphs  
- A single year with all divisions visible and the national average as a solid black line. Divisions are coloured as significantly better/worse than national average.  
- A single division with all years present and the national average for each year as a solid black line. Results for each year are coloured as significantly better/worse than national average.  

ui_overview.R : layout  

server_overview.R :  
- compares all data points to national average in that year for that variable (also wraps some string variables for plotting titles/annotations etc).  
- creates plots. If user selects national indicator, returns barplot, if whole sections of questions returns scatterplots.  
- Updates the input to show either police div or year, depending on which plot is visible.  
- text output for info on plot (depending on what plot is displayed)  
- text output for info on variables (depending on what variable/s selected)  
- observes plot clicks and updates which plot is visible.  

variable_information.R : contains text info on all variables  


3 Comparison Tool
-----------------
This is designed to provide users with a proportion testing tool which can display whole sections of the survey at a time (e.g. if there’s lots of red and green bars, then the two selections are quite different in the selected survey area).  
Users choose a survey area, and make two selections of a police division (or national average) and year.  
Results are compared and colour coded.  

ui_comparison.R : layout

server_compare.R :  
- subsets data into the two user selections (police division, year).  
- checks for common variables  
- tests proportions.  
- makes plots based on above data.  
- text output for info on variables selected  

variable_information.R : contains text info on all variables.  

4 Trends
--------
Simply displays line graphs across time for any variable and any division.  
Does not add much to the app, but offers option to display confidence intervals, and may be preferable for some users.  
Users choose survey variable(s) and police divisions.  

ui_trends.R : layout  

server_trendplot.R :  
- filters data based on user input of variables and police divisions.  
- makes plots (with or without confidence intervals based on user input).  
- updates variable selection based on survey area selection.  
- observes a "RESET" button to reset plot to initial state.  
- observes clicks on link to comparison tab.  


5 Tables
--------
Displays customizable tables of percentages and samplesizes, with the ability to download them as .csv files.  
User chooses area of survey, police divisions, and two years to compare between.  
Table of percentages includes column saying yes/no based on whether there is a signif difference between the two selected years.  

ui_tables.R : layout  

server_table.R :  
- filters the data to the variable and police division inputs.  
- creates downloadable data (no testing)  
- creates table of percentages  (with proportion testing)  
- creates table of samplesizes (no testing)  
- updates selection when "select all" is chosen. (for both variables and police divisions)  
- observes "reset table" button.  
- observes select all option variable/police div inputs  
- download data button  


6 Help Info Links
-----------------
Links to the SCJS publications page, contains info on stats testing, confidence intervals etc.  

ui_help.R : layout of help page, and all text.  

ui_links.R : links present at footer of all tabs  






  
