$(document).ready(function() {
  // Configure/customize these variables.
  var showChar = 100;  // How many characters are shown by default
  var ellipsestext = "...";
  var moretext = "Show more >";
  var lesstext = "Show less";
  
  
  $('.more2').each(function() {
    var content = $(this).html();
    
    if(content.length > showChar) {
      
      var c = content.substr(0, showChar);
      var h = content.substr(showChar, content.length - showChar);
      
      var html = c + '<span class="moreellipses">' + ellipsestext+ '&nbsp;</span><span class="morecontent2"><span>' + h + '</span>&nbsp;&nbsp;<a href="" class="morelink2">' + moretext + '</a></span>';
      
      $(this).html(html);
    }
    
  });
  
  $(".morelink2").click(function(){
    if($(this).hasClass("less")) {
      $(this).removeClass("less");
      $(this).html(moretext);
    } else {
      $(this).addClass("less");
      $(this).html(lesstext);
    }
    $(this).parent().prev().toggle();
    $(this).prev().toggle();
    return false;
  });
});