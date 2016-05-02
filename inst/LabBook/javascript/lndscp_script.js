
$( document ).ready(function() {
  
  $(".lndscp-btn").addClass("lndscp-btn-selected");
  
  $( ".lndscp-btn" ).click(function() {
    if($(this).hasClass("lndscp-btn-selected")) {
      $(this).removeClass("lndscp-btn-selected");
      $(this).addClass("lndscp-btn-deselected");
    }
    else if($(this).hasClass("lndscp-btn-deselected")) {
      $(this).removeClass("lndscp-btn-deselected");
      $(this).addClass("lndscp-btn-selected");
    }
  });
  
});

