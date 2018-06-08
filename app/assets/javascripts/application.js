// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require_tree
//= require jquery

var NO_BUTTONS = 12

$(document).ready(function() {
	$('#update_handle_form').focus();
	$('#update_handle_form').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#update_handle_form').val();
			$.ajax({
				method: "POST",
				url: "/update_handle_to_db",
				data: {name: info},
				success: function(status) {
					if (status == "true") {
						update_handle(info);
					}
				}
			}); 
		};
	});
});

$(document).ready(function() {
	$('#add_links_form').focus();
	$('#add_links_form').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#add_links_form').val();
			$.ajax({
				method: "POST",
				url: "/add_links_to_db",
				data: {name: info},
				success: function(status) {
					if (status == "true") {
						add_url(info);
					}
				}
			}); 
		};
	});
});

$(document).ready(function() {
	$('#delete_links_form').focus();
	$('#delete_links_form').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#delete_links_form').val();
			$.ajax({
				method: "POST",
				url: "/remove_links_from_db",
				data: {name: info},
				success: function(status) {
					if (status == "true") {
						remove_url(info);
					}
				}
			});
		};
	});
});

$(document).ready(function() {
	$('#add_friends_form').focus();
	$('#add_friends_form').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#add_friends_form').val();
			$.ajax({
				method: "POST",
				url: "/add_friends_to_db",
				data: {name: info},
				success: function(status) {
					if (status == "true") {
						add_friend(info);
					}
				}
			}); 
		};
	});
});

$(document).ready(function() {
	$('#delete_friends_form').focus();
	$('#delete_friends_form').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#delete_friends_form').val();
			$.ajax({
				method: "POST",
				url: "/remove_friends_from_db",
				data: {name: info},
				success: function(status) {
					if (status == "true") {
						remove_friend(info);
					}
				}
			});
		};
	});
});

$(document).ready(function() {
	$('#add_contests_form').focus();
	$('#add_contests_form').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#add_contests_form').val();
			$.ajax({
				method: "POST",
				url: "/add_contest_to_db",
				data: {name: info},
				success: function(status) {
					if (status == "true") {
						add_contest(info);
					}
				}
			}); 
		};
	});
});

$(document).ready(function() {
	$('#delete_contests_form').focus();
	$('#delete_contests_form').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#delete_contests_form').val();
			$.ajax({
				method: "POST",
				url: "/remove_contest_from_db",
				data: {name: info},
				success: function(status) {
					if (status == "true") {
						remove_contest(info);
					}
				}
			});
		};
	});
});

function update_handle(info) {
	document.getElementById('update_handle_form').value = "";
	document.getElementById('handles').innerHTML = "<div id =" + info + ">" + info + "</div>"
}

function add_url(info) {
	document.getElementById('add_links_form').value = "";
	var current_html = document.getElementById('links').innerHTML
	document.getElementById('links').innerHTML = current_html + "<div id =" + info + ">"  + info + "</div>"
}

function remove_url(info) {
	document.getElementById('delete_links_form').value = "";
	document.getElementById(info).remove()
}

function add_friend(info) {
	document.getElementById('add_friends_form').value = "";
	var current_html = document.getElementById('friends').innerHTML
	document.getElementById('friends').innerHTML = current_html + "<div id =" + info + ">"  + info + "</div>"
}

function remove_friend(info) {
	document.getElementById('delete_friends_form').value = "";
	document.getElementById(info).remove()
}

function add_contest(info) {
	document.getElementById('add_contests_form').value = "";
	var current_html = document.getElementById('contests').innerHTML
	document.getElementById('contests').innerHTML = current_html + "<div id =" + info + ">"  + info + "</div>"
}

function remove_contest(info) {
	document.getElementById('delete_contests_form').value = "";
	document.getElementById(info).remove()
}

function showHide(button_id) {
	var button_to_search = "hidden" + button_id
	var button = document.getElementById(button_to_search);
	if (button.style.display === "none") {
		button.style.display = "block";
	}
	else {
		button.style.display = "none";
	}
}

function drawChart(data, parent_div) {
	var width = document.getElementById(parent_div).clientWidth;
	var height = width;
	result = [["tag","amount"]];
	Object.keys(data).forEach(function (column) {
 		result.push([column,data[column]]);
	});
	var datatable = google.visualization.arrayToDataTable(result);
  	var options = {'title':'Problems by tag', 'backgroundColor':'transparent', 
  	'width':width, 'height':height, 
  	'chartArea': {'width': '80%', 'height': '100%'},
  	'legend': {'position': 'right'}};
	var chart = new google.visualization.PieChart(document.getElementById(parent_div));
	chart.draw(datatable, options);
}
