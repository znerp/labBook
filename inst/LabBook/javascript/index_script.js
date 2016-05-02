
  toTitleCase = function(str){
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
	  write_project_list();
	  label_todos();
	  add_classes();
	  hide_inactive_links();
	  make_sublinks();
	});

	$( window ).load(function(){
	  activate_todo_rlover();
	});


