
  // Function for getting contents of todo backup
  get_todo_backup = function(){

    $.ajax({
        url: "https://notebooks.antigenic-cartography.org/samwilks/_2do/lists/2do_latest.txt",
        type: 'get',
        dataType: 'html',
        async: false
    }).done(function(page_contents){
      todo_backup = page_contents;
    }).fail(function(){
      $("#update-todo, #restore-todo").css("background-color","#FFF");
		  $("#update-todo, #restore-todo").css("border-color","#EEE");
		  $("#update-todo, #restore-todo").css("color","#CCC");
      get_todo_backup_local();
    });

    return todo_backup;

  }

  // Function for getting contents of todo backup locally
  get_todo_backup_local = function(){
    $.ajax({
        url: "lists/2do_latest.txt",
        type: 'get',
        dataType: 'html',
        async: false
    }).done(function(page_contents){
      todo_backup = page_contents;
    })
  }

  // Function for converting to proper case
  String.prototype.toProperCase = function () {
		return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
	};


	// Function for making todo box
	make_todobox = function(value, classes){
	  var todo_html = "<div class='todo alert alert-info "+classes+"'>"
	                  +"<textarea rows='1' spellcheck='false' class='todo-item'>"+value+"</textarea>"
	                  +"<span class='todo-checkbox glyphicon glyphicon-unchecked'></span></div>";
	  return todo_html;
	};


	// Function for making a todo input box
	make_todoinput = function(){
	  var input_html = "<textarea rows='1' placeholder='New todo' spellcheck='false' class='todo-input'></textarea>"
	  return input_html;
	};


	// Function for getting project list from index page
	get_projects = function(){
	  $.ajax({
        url: "../index.html",
        type: 'get',
        dataType: 'html',
        async: false,
        success: function(page_contents){
			project_section = page_contents.split(/\<!\-\- PROJECTS \/\/\-\-\>/)[1];
			all_projects = project_section.match(/<h3>.*?<\/h3>/g);
			$.each(all_projects, function(i, project_name){
			  project_name = project_name.replace("<h3>","");
			  project_name = project_name.replace("</h3>","");
			  project_name = project_name.toProperCase();
			  all_projects[i] = project_name;
			});
	    }
      });
    return all_projects;
	};


	// Function for getting section todos
	get_section_todos = function(todolist, section_title){
	  var re = new RegExp(section_title+"\n(\n|.)*?(\n\n\n)","gi");
	  var section_text = todolist.match(re);
	  if(!section_text){ return [] };
	  section_text = section_text.toString();
	  section_text = section_text.replace(/\n\n\n$/,"")
	  var section_todos = section_text.split(/\n- /g);
	  section_todos.shift();
	  return section_todos;
	};


	// Function for getting important todos
	get_section_todos_important = function(todolist, section_title){
	  var section_todos = get_section_todos(todolist, section_title);

	  var important_todos = [];
	  for(i=0; i < section_todos.length; i++) {
	    if(section_todos[i].match(/^!/)) {
	      important_todos.push(section_todos[i]);
	    };
	  }

	  return(important_todos);
	};

	// Function for getting important todos
	get_section_todos_normal = function(todolist, section_title){
	  var section_todos = get_section_todos(todolist, section_title);

	  var normal_todos = [];
	  for(i=0; i < section_todos.length; i++) {
	    if(section_todos[i].match(/^(?!\!)/)) {
	      normal_todos.push(section_todos[i]);
	    };
	  }

	  return(normal_todos);
	};



	// Function for getting projects with todos
	get_todo_projects = function(todolist, projects) {
	  var todo_projects = [];
	  for(k=0; k < projects.length; k++) {
		  var re = new RegExp(projects[k]+"\n\n- ","gi");
		  if(todolist.match(re)){
		    todo_projects.push(projects[k]);
		  }
		}
		return todo_projects;
	};


	// Function for getting projects without todos
	get_notodo_projects = function(todolist, projects) {
	  var notodo_projects = [];
	  for(k=0; k < projects.length; k++) {
		  var re = new RegExp(projects[k]+"\n\n- ","gi");
		  if(!todolist.match(re)){
		    notodo_projects.push(projects[k]);
		  }
		}
		return notodo_projects;
	};
