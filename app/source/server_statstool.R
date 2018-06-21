output$stt_results<-renderPrint({
  p1=as.numeric(input$stt_p1)/100
  p2=as.numeric(input$stt_p2)/100
  ss1=as.numeric(input$stt_ss1)
  ss2=as.numeric(input$stt_ss2)
  ci1=1.96*sqrt(((p1*(1-p1)))/ss1)*des_factors$des_f[des_factors$year==input$stt_y1]
  ci2=1.96*sqrt(((p2*(1-p2)))/ss2)*des_factors$des_f[des_factors$year==input$stt_y2]
  signif=ifelse(abs(p1-p2)>sqrt((ci1^2)+ci2^2),"<font color='green'>is significantly different from</font>","<font color='red'>is NOT significantly different from</font>")
  cat(input$stt_p1,"+/-",round(ci1*100,1),"<br><b>",signif,"</b><br>",input$stt_p2,"+/-",round(ci2*100,1),sep=" ")
})
