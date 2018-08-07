SCJS Police Division Shiny
================================================

Table of contents
=================
<!--ts-->
* [Structure](#structure)
* [App components](#app-components)
<!--te-->


Structure
==========
The app is contained inside the SCJS_ShinyApp/app folder.  
There is an associated .Rproj file which preserves information about workspace etc required for updating the app. This is found in the SCJS_ShinyApp folder.  

Updating the app can be done via the loader.R script.  
This script is designed to accommodate those who have limited/no experience of R, but need to update the shiny app when receiving a new dataset.  


1 loader.R
----------
The loader.R script does the following (in order):  
    • Reads in the relevant variables from NVF datasets (all years)  
(because SG machines appear to give limited CPU resources to R, loading all variables was time-consuming)  
    • Tidies demographic variables (police divisions, age etc.)  
(not all of this is necessary, and is leftover from before the decision to focus on police divisions, but it's harmless, and may one day be useful)  
    • Recodes the questions.  
This involves separating out groups of variables which match patterns of responses we are interested in, and then recoding them in the data 
(e.g. for polconf, dconf, polop questions, we are interested in responses of 1&2 compared to responses of -2,-1,3,4,&5. So we collapse these to just be 0s and 1s)  
    • Checks to see what variables are present in which year.  
(completely unnecessary for the app, but if you're working through it and not familiar with the survey, then useful)  
    • Creates datasets of proportions, by police div and by year  
This involves:  
	choosing the variables of interest (separated by individual vs household weighting)  
	calculating sample sizes and weighted proportions for each variable/police division/year  
	reshaping these into long format  
	joining with design factors  
	calculating confidence intervals  
    • Gets the data ready for the app  
This involves:  
	joining information about the variables (contained in the data/variable_information.csv)  
	setting up things like user input choices and colour schemes  
	loading the map data (from data/pd_mapdata.RDS)  
    • Updates/Overwrites the .Rdata file used in the app  
The .Rdata file is the workspace which the app runs from.  
    • Deploys the app locally (i.e. opens it on your machine)  


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


