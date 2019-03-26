######
#DATA - this is not reactive. For each variable in each year it tests whether a division is signif different from national average and specifies the direction.
# it also takes into account the direction of the variable (some are reverse coded).
# the testing is done as per the current method for the SCJS, which asks |p1-p2| > sqrt(ci1^2 + ci2^2).
# the CIs are calculated as SE(p)*1.96*design factor (pre defined for each year). This is all done in the loader.R script.
######

#filter to just national average data
df %>% filter(police_div=="National Average",!is.na(variable)) %>% mutate(
  nat_avgp = percentage,
  nat_avgci = ci
) %>% select(variable,year,nat_avgp,nat_avgci) %>% 
  #join and do proportion testing for all other data.
  left_join(df, .) %>% 
  mutate(
    p_diff=percentage-nat_avgp,
    p_diff2=ifelse(reverse_coded==1,0-p_diff,p_diff),
    p_direction=ifelse(p_diff2==0,"No difference",
                       ifelse(p_diff2>0,"More Positive","Less Positive")),
    c=sqrt((ci^2)+(nat_avgci^2)),
    change=ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="More Positive","More Positive",
                  ifelse(((abs(p_diff)/100)>c)==TRUE & p_direction=="Less Positive","Less Positive","No difference")),
    
    #####
    # TEXT wrapping (easiest way to make plotly show all the labels etc.)
    #####
    wrapped_name = sapply(name_trunc, FUN = function(x) {paste(strwrap(x, width = 35), collapse = "<br>")}),
    
    #text for current_plot
    my_text = paste0("<b>",police_div,"</b><br>",year,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize,"<br><i><b>Click to see just this variable.<i></b>"),
    #text for current_plot
    my_text_a = paste0("<b>",police_div,"</b><br>",year,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize,"<br><i><b>Click to see this division relative<br>to the national average over time.<i></b>"),
    #text for trendplot
    my_text2 = paste0("<b>",year,"</b><br>",police_div,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize,"<br><i><b>Click to see this year<br>for all divisions.<i></b>"),
    #truncated text for multi questions
    my_text3 = paste0(wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize),
    #text for nat average lines
    natav_text = paste0("<b>",police_div,"</b><br>",year,"<br>",wrapped_name,"<br><b>",round(percentage, digits=1),"</b>% +/-",round(ci*100, digits=1),", N = ",samplesize),
    #wrapped pdiv name
    wrappedpolice_div=sapply(gsub(" Division","",police_div), FUN = function(x) {paste(strwrap(x, width = 20), collapse = "<br>")})
  ) %>% 
  select(-c(p_direction,c)) -> df