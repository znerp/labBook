// JavaScript Document
updateindex = function(){
	// Update links
	$(".pres-index-item").children("a").each(function(){
	itemname = $(this).attr("href");
	if(itemname == "#"+currentpage) {
		$(this).addClass("pres-intex-item-selected");
	}
	else {
		$(this).removeClass("pres-intex-item-selected");
	}
	});
	// Set hash to current section
	history.replaceState(null, null, "#"+currentpage);
};

scrolltoelement = function(elname){
	$('html, body').animate({
		scrollTop: $(elname).offset().top
	}, 0);
};

gotonext = function(){
	currentnum      = $.inArray(currentpage, all_pages);
	if(currentnum < all_pages.length-1) {
		scrolltoelement('#'+all_pages[currentnum+1]);
		currentnum = currentnum+1;
	}
	currentpage = all_pages[currentnum];
	updateindex();
};

gotoprev = function(){
	currentnum      = $.inArray(currentpage, all_pages);
	if(currentnum !== 0) {
		scrolltoelement('#'+all_pages[currentnum-1]);
		currentnum = currentnum-1;
	}
	currentpage = all_pages[currentnum];
	updateindex();
};

make_index = function(){
  
	all_pages = [];
	$(".pres-page").each(function(index,value){
		var pagename = $(this).attr("id");
		if(pagename) {
		spacepagename = pagename.replace(/_/g," ");
		index_html = "<span class='pres-index-item'><a href='#"+pagename+"'>"+spacepagename+"</a></span>";
		$(".pres-index").append(index_html);
		all_pages[index] = pagename;
		}
	});

	currentpage = window.location.hash;
	if(currentpage === "") {
		currentpage = all_pages[0];
	}
	else {
	  currentpage = currentpage.substring(1);
	}

	$("body").keydown(function(e) {
		if(e.keyCode == 37) { // left
			gotoprev();
		}
		else if(e.keyCode == 39) { // right
			gotonext();
		}
		return false;
	});

	$(".pres-index-item").children("a").click(function(){
		currentpage = $(this).attr("href");
		currentpage = currentpage.substring(1);
		scrolltoelement('#'+currentpage);
		updateindex();
		return false;
	});

	/*$(".pres-page").mouseover(function(){
		currentpage = $(this).attr("id");
		updateindex();
	});*/

	updateindex();

};

var convert_tex = function(){
  
  $("tex").each(function(){
    var domid = $(this)[0];
    var texhtml = domid.outerHTML;
    texhtml = texhtml.replace(/^<tex>/,"<div class='tex-math'>");
    texhtml = texhtml.replace(/<\/tex>$/,"</div>");
    $(this).before(texhtml);
    $(this).remove();
  });

};

var apply_markdown = function(){
  
  $(".pres-page").each(function(){
		$(this).contents().filter(function(){ 
			return this.nodeType === 3; 
		}).replaceWith(function(){
			var dom_el = $(this)[0];
			var content = dom_el.nodeValue;
			content = content.replace(/\^([^\s]+)\^/g,"<sup>$1</sup>");
			content = content.replace(/µ/g,"&micro;");
			content = content.replace(/[^\s].*/g, function markit(x){
			  // Replace digits to stop automatic numbering
			  x = x.replace(/(\d+)\./g,"$1&#46;");
			  // Replace micro symbol with ascii
			  x = x.replace(/µ/g,"&micro;");
			  // Replace micro symbol with ascii
			  x = x.replace(/\-\-\>/g,"<br/>");
			  
			  // Split based on $ symbol to avoid effecting mathjax
			  x_splits = x.split(/\$/);
			  // Only mark stuff between dollar signs
			  for(i=0; i < x_splits.length; i++){
			    if(i % 2 === 0){
			      console.log(x_splits[i]);
			      new_xsplit  = marked(x_splits[i]);
				    new_xsplit  = new_xsplit.replace(/\n$/,"");
				    x_splits[i] = new_xsplit;
			    }
			    else {
			      x_splits[i] = "$"+x_splits[i]+"$";
			    }
			  }
			  x = x_splits.join("");
				return x;
			});
			return content;
		});
  });

};

var make_cover = function(){
  $("body").prepend("<div id='pres-cover'></div>");
};

var fade_cover = function(){
  page_positions = [];
  $(".pres-page").each(function(){
    page_positions.push($(this).offset().top);
  });
  
  $( window ).scroll(function() {
    var pos = $(window).scrollTop();
    rel_pages = [];
    for(i=0; i < page_positions.length; i++) {
      if(page_positions[i] - 500 < pos) {
        rel_pages.push(i);
      }
    }
    var page_num = Math.max(...rel_pages) + 1;
    currentpage = $(".pres-page:nth-child("+page_num+")").attr("id");
		updateindex();
  });
  
  $("#pres-cover").fadeOut(500);
};

$( document ).ready(function(){
  make_cover();
  make_index();
  convert_tex();
  apply_markdown();
});

$(window).load(function(){
  MathJax.Hub.Queue(fade_cover);
});