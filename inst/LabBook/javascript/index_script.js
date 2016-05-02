
toTitleCase = function(str)
{
    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};


write_project_list = function() {
		project_list = [];
		$(".project-section").children(".project").each(function(index, value){
			project_name = $(this).children("h3").html();
			$(this).attr("id","proj"+index);
			project_list.push(project_name);
		});
		$.each(project_list, function(index, value) {
			var project_link = "<a href='#proj"+index+"'>"+value+"</a>";
			$(".project-list").append(project_link);
		});

/*
		// Get current date.
		d           = new Date();
    currentTime = d.getTime() / 86400000;

		// Get cookie value.
		if(!$.cookie("samsLabbook")) {
		  cookieval = "";
		}
		// Work through all cookie vals if present.
		else {
		  cookieval      = $.cookie("samsLabbook");
		  all_cookievals = cookieval.split("--");
		  $.each(all_cookievals, function(index,this_cookieval){
			if(index !== 0) {
				page_src       = this_cookieval.split(":")[0];
				page_visittime = this_cookieval.split(":")[1];
				// Delete reference if last visit date was more than 8 weeks ago.
				if(page_visittime <= currentTime - 56) {
					cookieval = cookieval.replace("--"+this_cookieval,'');
				}
				// If link use was between 2 and 4 weeks
				if(page_visittime >  currentTime - 28 &
				   page_visittime <= currentTime - 14) {
					$('a[href="'+page_src+'"]').css('color', '#9966FF');
				}
				// If link use was between 2 days and 2 weeks
				if(page_visittime >  currentTime - 14 &
				   page_visittime <= currentTime - 2) {
					$('a[href="'+page_src+'"]').css('color', '#FF66FF');
				}
				// If link use was between 0 and 2 days
				if(page_visittime >  currentTime - 2 &
				   page_visittime <= currentTime) {
					$('a[href="'+page_src+'"]').css('color', '#FF33CC');
				}
				page_fontsize = $('a[href="'+page_src+'"]').css('font-size');
				page_fontsize = Number(page_fontsize.replace('px',''));
				if(page_fontsize < 24) {
				  $('a[href="'+page_src+'"]').css('font-size', page_fontsize+1);
				}
			}
		  });
		}

		// Function for setting cookie val.
		$(".project-section").children(".project").children("a").click(function() {
		  linksrc = $(this).attr("href");
		  d  = new Date();
          st = d.getTime() / 86400000;
		  newcookie = "--"+linksrc+":"+st;
		  cookieval = cookieval+newcookie;
		  $.cookie("samsLabbook",cookieval,{ expires: 56 });
		});
		*/
	};

	label_todos = function() {

	  // Load up todo list from cookies
	  var todotext = $.cookie("todolist3");
	  var sectiontexts  = todotext.split("\n\n\n");

	  //console.log(todotext);
	  //console.log(document.cookie);

	  // Cycle through all project titles
	  $(".project-section").children(".project").each(function(){

	    var project_title = $(this).children("h3").html();
	    var project_todos = get_section_todos(todotext, project_title);
	    var num_tasks = project_todos.length;
	    var important_todos = get_section_todos_important(todotext, project_title);
	    var num_important   = important_todos.length;
	    var normal_todos = get_section_todos_normal(todotext, project_title);
	    var num_normal   = normal_todos.length;
	    //console.log(project_title);
	    //console.log(num_normal);

	    if(num_tasks > 0){
	      var todolist = normal_todos.join("\n\n- ");
	      todolist = "- "+todolist;
	      if(num_important > 0){
	        important_todolist = important_todos.join("\n\n- ");
	        important_todolist = "<strong>- "+important_todolist+"</strong>\n\n";
	        important_todolist = "<div style='width:70px; height:40px; float:right'></div>"+important_todolist;
	        todolist = important_todolist + todolist;
	        $(this).prepend("<a href='_2do/2do.html?"+project_title+"'><div class='project-todonum-important'>"+num_important+"</div></a>");
	      }
	      var num_normal = num_tasks - num_important;
 	      $(this).prepend("<a href='_2do/2do.html?"+project_title+"'><div class='project-todonum'>"+num_normal+"</div></a>");
 	      $(this).prepend("<div class='project-todolist'>"+todolist+"</div>");
 	    }

      else {
        $(this).prepend("<a href='_2do/2do.html?"+project_title+"'><div class='project-todo'>!</div></a>");
      }

      });

      // Create overall labels
      var num_all_todos = todotext.split("\n- ");
      num_all_todos = num_all_todos.length - 1;
      var num_important_todos = todotext.split("\n- !");
      num_important_todos = num_important_todos.length - 1;
      var num_normal_todos = num_all_todos - num_important_todos;
      $("body").append("<a href='_2do/2do.html'><div class='all-todo'>"+num_normal_todos+"</div></a>");
      if(num_important_todos > 0) {
        $("body").append("<a href='_2do/2do.html'><div class='important-todo'>"+num_important_todos+"</div></a>");
      }

	};

	activate_todo_rlover = function(){
	  $(".project-todonum, .project-todonum-important").hover(
	    function(){
	      $(this).parent().parent().children(".project-todolist").show();
	    },
	    function(){
	      $(this).parent().parent().children(".project-todolist").hide();
	    }
	  );
	  $(".project-todo").hover(
	    function(){
	      $(this).css("color","rgba(255,255,255,255)");
	    },
	    function(){
	      $(this).css("color","rgba(255,255,255,0)");
	    }
	  );
	};

	add_classes = function(){
	};

	var get_project_dirs = function(){
	  var projects_dirs = [];
	  $(".project-section").children(".project").each(function(){
	    var dir_link = $(this).children("a").attr("href");
	    dir_link = dir_link.replace(/\/.*$/, "");
	    projects_dirs.push(dir_link);
	  });
	  return(projects_dirs);
	};

	var add_code_links = function(){
	  $(".project-section").children(".project").each(function(){
	    var dir_link = $(this).children("a").attr("href");
	    dir_link = dir_link.replace(/\/.*$/, "");

	    var code_link_html = '<div class="datacodelinks">' +
	                         '<a href="'+dir_link+'/data_links.php">Data</a> | ' +
	                         '<a href="'+dir_link+'/code_links.php">Code</a>' +
	                         '</div>';

	    $(this).children("hr").after(code_link_html);
	  });
	};

  var hide_inactive_links = function(){
    //$(".inactive-link").hide();
  };

  var make_sublinks = function(){
    $(".project-section").children(".project").each(function(project_num){
      $(this).children("h3").after('<div class="proj-sublinks-div"></div>');
      $(this).children("h4").each(function(index, value){
        var sublink_name = $(this).html();
        var sublink_id = "proj"+project_num+"sub"+index;
        var sublink = '<div class="proj-sublink"><a href="#'+sublink_id+'">'+sublink_name+'</a></div>';
        $(this).attr("id",sublink_id);
        $(this).parent().children(".proj-sublinks-div").append(sublink);
      });
    });
  };

	$( document ).ready(function(){
	  add_code_links();
	  write_project_list();
	  label_todos();
	  add_classes();
	  hide_inactive_links();
	  make_sublinks();
	});

	$( window ).load(function(){
	  activate_todo_rlover();
	});


