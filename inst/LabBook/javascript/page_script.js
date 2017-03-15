
var add_index_links = function() {
  $('h2').each(function(){
    if ($(this).is(':visible')) {
      var link_name = $(this).html();
      var safe_link_name = link_name.replace(" ","_");
      link_html = "<li class='index-link'><a href='#"+safe_link_name+"'>"+link_name+"</a></li>";
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

  // Create link back to index
  $('#header').prepend("<div id='main-index-link'><a href='../../index.html'>Back to index</a></div>|");

  // Create link index
  $("#header").append("<ul id='index-links' class='nav nav-pills'></ul>");

  link_num = 1;
  add_index_links();

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

  $.getScript( "../../javascript/highlight_pack.js", function() {
	  $('head').append('<link rel="stylesheet" href="../../javascript/styles/tomorrow-night-blue.css">');
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


var set_markdown = function(content){
  content = content.replace(/\^([^\s]+)\^/g,"<sup>$1</sup>");
  content = content.replace(/.*/g, function markit(x){
    x = marked(x);
    x = x.replace(/\n$/,"");
    x = x.replace(/µ/g,"&micro;");
    return x;
  });
  return content;
}

var apply_markdown = function(){

  // Apply to general page content
  $("#page-content").contents().filter(function(){
    return this.nodeType === 3;
  }).replaceWith(function(){
    var dom_el = $(this)[0];
    var content = dom_el.nodeValue;
    content = set_markdown(content);
    return content;
  });

  // Apply also to specific classes
  $(".alert").each(function(){
    var old_html = $(this).html();
    var new_html = set_markdown(old_html);
    $(this).html(new_html);
  });

};

var add_page_wrapper = function(){
  var header_id = $("#header")[0];
  var header_content = header_id.outerHTML;
  $("#header").remove();
  var page_content = $("body").html();
  $("body").html(header_content+"<div id='page-content'>"+page_content+"</div>");
}

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

var convert_tags = function(){

  $("note").each(function(){
    var domid = $(this)[0];
    var texhtml = domid.outerHTML;
    texhtml = texhtml.replace(/^<note>/,"<div class='alert alert-warning' style='padding-left: 40px; margin-bottom:-10px;'><span class='glyphicon glyphicon-unchecked' style='position:relative; left: -25px; margin-right: -15px'/><strong>Note:</strong> ");
    texhtml = texhtml.replace(/<\/note>$/,"</div>");
    $(this).before(texhtml);
    $(this).remove();
  })

  $("result").each(function(){
    var domid = $(this)[0];
    var texhtml = domid.outerHTML;
    texhtml = texhtml.replace(/^<result>/,"<div class='alert alert-success' style='padding-left: 40px; margin-bottom:-10px;'><span class='glyphicon glyphicon-unchecked' style='position:relative; left: -25px; margin-right: -15px'/>");
    texhtml = texhtml.replace(/<\/result>$/,"</div>");
    $(this).before(texhtml);
    $(this).remove();
  })

  $("idea").each(function(){
    var domid = $(this)[0];
    var texhtml = domid.outerHTML;
    texhtml = texhtml.replace(/^<idea>/,"<div class='alert alert-info' style='padding-left: 40px; margin-bottom:-10px;'><span class='glyphicon glyphicon-unchecked' style='position:relative; left: -25px; margin-right: -15px'/>");
    texhtml = texhtml.replace(/<\/idea>$/,"</div>");
    $(this).before(texhtml);
    $(this).remove();
  })

}


$( document ).ready(function() {

	// Load up other javascript files
	include_script('../../javascript/pdf.js', 'text/javascript');
	include_script('../../javascript/marked.js', 'text/javascript');
	include_script('../../javascript/bootstrap-3.3.6-dist/js/bootstrap.min.js', 'text/javascript');
	include_css('../../javascript/bootstrap-3.3.6-dist/css/bootstrap.min.css');
	include_script('https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_CHTML', 'text/javascript');

	// Add page wrapper
	add_page_wrapper();

	// Run javascript code to finish setting up page
	load_code();

	// Create header
	build_header();

	// Set tex-math divs for tex elements
	convert_tex();

	// Switch out other tags with proper html
	convert_tags();

	// Set tex-math class to children
	$('*', $('.tex-math')).each(function () {
		$(this).addClass("tex-math");
	});

});

$( window ).load(function() {

	// Apply markdown
	apply_markdown();

	// Apply code highlighting to code at the bottom of page
	highlightcode();

	// Hack to set padding-top correctly
	$(".code").css({"padding-top":"20px"});

})

