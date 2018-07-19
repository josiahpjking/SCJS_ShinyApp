linkpanel<-mainPanel(id = "credits",
              tags$h5("Justice Analytical Services"),
              a(img(src = "scotgov.png", height = 50), href = "http://www.gov.scot/Topics/Statistics/Browse/Crime-Justice", target="_blank"),
              
              HTML("
                   <div id='fb-root'></div>
                   
                   <script type='text/javascript'>(function(d, s, id) {
                   var js, fjs = d.getElementsByTagName(s)[0];
                   if (d.getElementById(id)) return;
                   js = d.createElement(s); js.id = id;
                   js.src = '//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.5';
                   fjs.parentNode.insertBefore(js, fjs);
                   }(document, 'script', 'facebook-jssdk'));
                   </script>
                   
                   <div class='fb-share-button' data-href='https://scotland.shinyapps.io/sg-scottish-crime-justice-survey' data-layout='button'></div>
                   
                   <a href='https://scotland.shinyapps.io/sg-scottish-crime-justice-survey'
                   class='twitter-share-button'
                   data-url='https://scotland.shinyapps.io/sg-scottish-crime-justice-survey'
                   data-text='Scottish Crime and Justice Survey'>Tweet
                   </a>
                   
                   <script type='text/javascript'>!function(d,s,id){
                   var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
                   if(!d.getElementById(id)){
                   js=d.createElement(s);
                   js.id=id;js.src=p+'://platform.twitter.com/widgets.js';
                   fjs.parentNode.insertBefore(js,fjs);
                   }
                   }(document, 'script', 'twitter-wjs');
                   </script>
                   ")
)