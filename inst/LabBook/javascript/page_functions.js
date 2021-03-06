
var add_index_links = function() {
  $('h2').each(function(){
    if ($(this).is(':visible')) {
      var link_name = $(this).html();
      var safe_link_name = link_name.replace(" ","_");
      link_html = "<div class='index-link'><a href='#"+safe_link_name+"'>"+link_name+"</a></div>";
      $(this).attr("id",safe_link_name);
      $('#header').children('#index-links').append(link_html);
    }
  });
}

var build_header = function() {
  
  // Create last modified info
  var last_mod = document.lastModified;
  last_mod = last_mod.replace(/ .*$/, "");
  last_mod = last_mod.replace(/(..)\/(..)\/(..)/,"$2/$1/$3");
  var mod_text = 'Last modified : ' + last_mod;
  jQuery('<div/>', {
    id: 'date_created',
    text: mod_text
  }).prependTo('#header');
  
  // Create link to online webpage
  var page_link = document.location.href;
  page_link = page_link.replace("file:///Users/samwilks/Desktop/LabBook","https://notebooks.antigenic-cartography.org/samwilks");
  var page_title = $(".main_title").html();
  $("#header").children("#date_created").prepend("<a href='"+page_link+"'>"+page_title+"</a>, ");
  
  // Create home link
  var home_link = '<div class="home-link"><a href="../index.html">Sam\'s Lab Book</a>, email: sw463@cam.ac.uk</div>';
  $("#header").prepend(home_link);
  
  // Create link index
  jQuery('<div/>', {
    id: 'index-links'
  }).appendTo('#header');
  
  link_num = 1;
  add_index_links();
  
  // Create dynamic load slider
  $("#header").append("<img src='../styles/images/checkbox_empty.png' id='dynamic-checkbox' class='dynamic-inactive'/>");
  
  // Set style
  $("#header").css("white-space", "normal");
  $("#header").css("margin-top", "10px");
    
};

var include_script = function(script_src, script_type) {
    
  var script = document.createElement('script');
  script.src  = script_src;
  script.type = script_type;
  document.getElementsByTagName('head')[0].appendChild(script);
  
};

var include_css = function(css_src) {
    
  $("head").prepend("<link href='"+css_src+"' rel='stylesheet' type='text/css' />");
  
};


var highlightcode = function() {
   
  $.getScript( "../javascript/highlight_pack.js", function() {
	  $('head').append('<link rel="stylesheet" href="../javascript/styles/tomorrow-night-blue.css">');
	  hljs.configure({
	    languages: ['r']
	  });
	  $('.code').each(function(i, block) {
          hljs.highlightBlock(block);
      });
  });
 
};

var load_code = function() {
 
  // Do your whiz bang jQuery stuff here
  $(".code").each(function(){
	  $(this).children("a").each(function(){
	  codefile = $(this).attr("href");
	  $(this).parent(".code").load(codefile, function(response, status){
		if(status == "error") {
			codefilesimple = codefile.replace(/^code\//, "");
			$(this).html('<div class="codelink">Sorry there was an error loading the file "'+codefilesimple+'"</div>');
		}
		else {
			codetext = $(this).html();
		//	< &lt;
		//  > &gt;
		//  " &quot;
		//  ' &apos;
		//  & &amp;
			codetext = codetext.replace(/</g,"&lt");
			codetext = codetext.replace(/>/g,"&gt");
			codetext = codetext.replace(/(load|source|sourceCpp|read\.csv|read\.table|save\.image)\(.*?(\)|,)/gi, function myFunction(x){
				//x = x.replace(/\)|\"|\'|,/gi,"");
				//x = x.split("\(");
				//newx = x[0]+"(\"<a href='"+x[1]+"'>"+x[1]+"</a>\"";
				//return newx;
				var regexp = /(load|source|sourceCpp|read\.csv|read\.table|save\.image)\((.*)(,|\))/gi;
				x = x.replace(regexp,"$1(<a href=$2>$2</a>$3");
				return x;
			});
			// Finally append a link to the actual code file.
			codelink = "<div class='codelink'>- Download the following code file <a href='"+codefile+"'>here</a>, to download loaded and sourced files please click on them -</div>";
			$(this).html(codelink+codetext)
		}
		});
	  });
  });
 
};


var switch_pdfs = function() {

	$("img").each(function(){
	
	  var img_src   = $(this).attr("src");
	  var img_ext = img_src.replace(/.*\./,".");
	  var img_style = $(this).attr("style");
	  var img_style = img_style.replace(":","=");
	  var img_style = img_style.replace(";","");
	  
	  if(img_ext == ".pdf" | img_ext == ".PDF") {
	    
	  	var canvas_html = "<canvas class='pdfjs' id='"+img_src+"' "+img_style+"></canvas>";
	  	$(this).replaceWith(canvas_html);
	  
	  }
	
	});

};
 

var load_pdfs = function() {
    PDFJS.workerSrc = '../javascript/pdf.worker.js';
	$(".pdfjs").each(function(){
	    
	    var canvas_width  = $(this).attr("width");
	    var canvas_height = $(this).attr("height");
	    
	    var pdf_loc = $(this).attr("id");
	    
		PDFJS.getDocument(pdf_loc).then(function(pdf) {
		  // Using promise to fetch the page
		  pdf.getPage(1).then(function(page) {
			
			//
			// Prepare canvas using PDF page dimensions
			//
			
			var canvas = document.getElementById(pdf_loc);
			var context = canvas.getContext('2d');
			
			if (typeof canvas_width !== 'undefined') {
			    canvas_width = canvas_width.replace("px","");
			    var viewport = page.getViewport(canvas_width / page.getViewport(1.0).width);
			}
			
			if (typeof canvas_height !== 'undefined') {
			    canvas_height = canvas_height.replace("px","");
			    var viewport = page.getViewport(canvas_height / page.getViewport(1.0).height);
			}
			
			canvas.height = viewport.height;
			canvas.width = viewport.width;
            
			//
			// Render PDF page into canvas context
			//
			var renderContext = {
			  canvasContext: context,
			  viewport: viewport
			};
			page.render(renderContext);
		  });
		});
	
	});

};

var dynamically_update_page = function(){
  
  if($("#dynamic-checkbox").hasClass("dynamic-active")) {
		// Get page url
		var url = window.location.href;
		$("body").append("<iframe id='new-content' src='"+url+"' style='display:none'></iframe>");
  }

};

var update_parent= function(){
  parent.update_html();
}

var update_html = function(){
  
  var new_html = $('#new-content').contents().find("html").html();
  var body_content = new_html.match(/\<body\>(.|\n)*\<\/body\>/);
	var body_content = body_content[0].replace(/((^\<body\>)|(\<\/body\>$))/g,"")
	
	// Update dynamic class to match current.
	var dynamic_class = $("#dynamic-checkbox").attr("class");
	var dynamic_src   = $("#dynamic-checkbox").attr("src");
	body_content = body_content.replace(/<img.*?dynamic.*?\>/g,
	                                    "<img src='"+dynamic_src+"' id='dynamic-checkbox' class='"+dynamic_class+"'/>")
	
	
  setTimeout(function(){
    $("body").html(body_content);
    activate_dynamic_option();
    setTimeout(dynamically_update_page,10);
  },500);
};

var inIframe = function() {
    try {
        return window.self !== window.top;
    } catch (e) {
        return true;
    }
}

var dynamic_hover = false;
var activate_dynamic_option = function(){
  
  $("#dynamic-checkbox").hover(function() {
	  $(this).attr("src","../styles/images/dynamic_hover.png");
  },
	function(){
	  if($(this).hasClass("dynamic-inactive")){
	    $(this).attr("src","../styles/images/dynamic_empty.png");
	  }
	  else {
	    $(this).attr("src","../styles/images/dynamic.gif");
	  }
  });
  
  $("#dynamic-checkbox").click(function() {
    $(this).attr("src","../styles/images/dynamic.gif");
	  if($(this).hasClass("dynamic-inactive")){
	    $(this).removeClass("dynamic-inactive");
	    $(this).addClass("dynamic-active");
	    dynamically_update_page();
	  }
	  else {
	    $(this).removeClass("dynamic-active");
	    $(this).addClass("dynamic-inactive");
	  }
  });

};


var convert_tex = function(){
  
  $("tex").each(function(){
    var domid = $(this)[0];
    var texhtml = domid.outerHTML;
    texhtml = texhtml.replace(/^<tex>/,"<div class='tex-math'>");
    texhtml = texhtml.replace(/<\/tex>$/,"</div>");
    $(this).before(texhtml);
    $(this).remove();
  })

}

var apply_markdown = function(){
  
  $("#page-content").contents().filter(function(){ 
    return this.nodeType === 3; 
  }).replaceWith(function(){
    var dom_el = $(this)[0];
    var content = dom_el.nodeValue;
    content = content.replace(/\^([^\s]+)\^/g,"<sup>$1</sup>");
    content = content.replace(/.*/g, function markit(x){
      x = marked(x);
      x = x.replace(/\n$/,"");
      x = x.replace(/µ/g,"&micro;");
      return x;
    });
    return content;
  });

}

var add_page_wrapper = function(){
  var header_id = $("#header")[0];
  var header_content = header_id.outerHTML;
  $("#header").remove();
  var page_content = $("body").html();
  $("body").html(header_content+"<div id='page-content'>"+page_content+"</div>");
}

var add_cache_control = function(){
  $("head").prepend('<meta http-equiv="Cache-control" content="No-Cache">');
};

var add_image_time = function(){
  $("img").each(function(){
      var src = $(this).attr("src");
      var new_src = src + "?time="+ new Date().getTime();
      $(this).attr("src", new_src);
  });
};



