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
			message("add", "handles_notice", "Searching handle <b>" + info + "</b> on Codeforces...")
			$.ajax({
				method: "POST",
				url: "/update_handle_to_db",
				data: {name: info},
				success: function(status) {
					if (status == "false") {
						message("add", "handles_notice", "Handle " + info + " doesn't exist")
					}
					else {
						update_handle(status);
						message("add", "handles_notice", "Your Codeforces handle has been updated!")
					}
					reset_form("update_handle_form")
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
			message("add", "links_notice", "Searching problem <b>" + info + "</b> on Codeforces...")
			$.ajax({
				method: "POST",
				url: "/add_links_to_db",
				data: {name: cf_like(info)},
				success: function(status) {
					if (status == "true") {
						check_if_problem_solved(info)
					}
					else {
						message("add", "links_notice", "Problem <b>" + info + "</b> doesn't exist or has already been added")
					}
					reset_form("add_links_form")
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
				data: {name: cf_like(info)},
				success: function(status) {
					if (status == "true") {
						remove_url(info);
						message("add", "links_notice", "Problem <b>" + info + "</b> removed")
					}
					else {
						message("add", "links_notice", "Nothing to remove")
					}
					reset_form("delete_links_form")
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
			message("add", "friends_notice", "Searching handle <b>" + info + "</b> on Codeforces...")
			$.ajax({
				method: "POST",
				url: "/add_friends_to_db",
				data: {name: info},
				success: function(status) {
					if (status == "false") {
						message("add", "friends_notice", "Handle doesn't exist")
					}
					else {
						add_friend(status);
						message("add", "friends_notice", "Handle <b>" + status + "</b> added as friend")
					}
					reset_form("add_friends_form")
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
			message("add", "friends_notice", "Trying to remove <b>" + info + "</b> from your friend list...")
			$.ajax({
				method: "POST",
				url: "/remove_friends_from_db",
				data: {name: info},
				success: function(status) {
					if (status == "false") {
						message("add", "friends_notice", "Nothing to remove")
					}
					else {
						remove_friend(status);
						message("add", "friends_notice", "Removed <b>" + status + "</b> from your friend list")
					}
					reset_form("delete_friends_form")
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
			message("add", "contests_notice", "Searching contest <b>" + info + "</b> on Codeforces...")
			$.ajax({
				method: "POST",
				url: "/add_contest_to_db",
				data: {name: info},
				success: function(status) {
					if (status == "true") {
						check_if_contest_attempted(info)
					}
					else {
						message("add", "contests_notice", "Contest doesn't exist or has already been added")
					}
					reset_form("add_contests_form")
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
						message("add", "contests_notice", "Contest <b>" + info + "</b> removed")
					}
					else {
						message("add", "contests_notice", "Nothing to remove")
					}
					reset_form("delete_contests_form")
				}
			});
		};
	});
});

function check_if_problem_solved(info) {
	info = cf_like(info)
	$.ajax({
		method: "POST",
		url: "/retrieve_solved",
		data: {name: info},
		success: function(status) {
			if (String(info) in status) {
				message("add", "links_notice", "Problem <b>" + info + "</b> added, but you have already solved it")
				add_url(info, true)
			}
			else {
				message("add", "links_notice", "Problem <b>" + info + "</b> successfully added!")
				add_url(info, false)
			}
		}
	});
}

function check_if_contest_attempted(info) {
message("add", "contests_notice", "Contest <b>" + info + "</b> successfully added")
	$.ajax({
		method: "POST",
		url: "/retrieve_attempted",
		data: {name: info},
		success: function(status) {
			if (String(info) in status) {
				message("add", "links_notice", "Contest <b>" + info + "</b> added, but you have already attempted to solve problems from it...")
				add_contest(info, true)
			}
			else {
				message("add", "links_notice", "Contest <b>" + info + "</b> successfully added!")
				add_contest(info, false)
			}
		}
	});
}

function update_handle(info) {
	document.getElementById('handles').innerHTML = "<div id =" + info + ">" +
													"<a target='_blank'" +
													"href='http://codeforces.com/profile/" + 
													info + "'>" + info + "</a>" + "</div>"
}

function add_url(info, solved) {
	contest = info.substr(0, info.length-1)
	index = info[info.length-1]
	var current_html = document.getElementById('links').innerHTML
	var to_add = current_html + "<div id =" + info + ">" +
				 "<a target='_blank'" + "href='http://codeforces.com/contest/" +
				 contest + "/problem/" + index + "'>" + info + "</a>"
	if (solved) to_add = to_add + " You have already solved this problem</br>"
	to_add = to_add + "</div>"
	document.getElementById('links').innerHTML = to_add
}

function remove_url(info) {
	info = cf_like(info)
	document.getElementById(info).remove()
}

function add_friend(info) {
	var current_html = document.getElementById('friends').innerHTML
	document.getElementById('friends').innerHTML = current_html +
												   "<div id =" + info + ">" +
												   "<a target='_blank'" +
												   "href='http://codeforces.com/profile/" + 
												   info + "'>" + info + "</a>" + "</div>"
}

function remove_friend(info) {
	document.getElementById(info).remove()
}

function add_contest(info, attempted) {
	var current_html = document.getElementById('contests').innerHTML
	var to_add = current_html + "<div id =" + info + ">" + "<a target='_blank'" +
				 "href='http://codeforces.com/contest/" + info + "'>" + info + "</a>"
	if (attempted) to_add = to_add + " You have already attempted to solve problems from this contest"
	to_add = to_add + "</div>"
	document.getElementById('contests').innerHTML = to_add 
													
}

function remove_contest(info) {
	document.getElementById(info).remove()
}

function cf_like(info) {
	var problem_index = info[info.length-1];
	problem_index = problem_index.toUpperCase();
	info = info.substr(0, info.length-1) + problem_index
	return info
}

function message(action, form, notice) {
	if (action == "add") {
		document.getElementById(form).innerHTML = notice
	}
	else if (action == "remove") {
		document.getElementById(form).innerHTML = notice
	}
}

function reset_form(form) {
	document.getElementById(form).value = "";
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
	'legend': {'position': 'right', 'alignment': 'center'},
	'sliceVisibilityThreshold': .03
	};
	var chart = new google.visualization.PieChart(document.getElementById(parent_div));
	chart.draw(datatable, options);
}

function drawChart2(data, parent_div, handle1, handle2) {
	var width = document.getElementById(parent_div).clientWidth;
	var height = document.getElementById(parent_div).clientHeight;

	result = [["date", String(handle1), String(handle2)]];
	var sze = data.length;
	for (var i = 0; i < sze; i++) {
		var secs = Number(data[i][0]);
		var date = new Date(secs*1000)
		console.log(date);
		result.push([date, data[i][1], data[i][2]]);
	}
	var datatable = google.visualization.arrayToDataTable(result);
	var options = {
		'title': 'Graph Comparison',
		'backgroundColor':'transparent', 
		'width':width,
		'height':height,
		'chartArea': {'width': '100%', 'height': '70%'},
		'legend': {'position': 'bottom', 'alignment': 'center'}
	};
	var chart = new google.visualization.LineChart(document.getElementById(parent_div));
	chart.draw(datatable, options);
}

function filter(id) {
	var search_bar = 'search' + id;
	var list_id = 'list' + id;
	var input = document.getElementById(search_bar);
	var input_text = input.value.toLowerCase();
	var div_to_search = document.getElementById(list_id)
	var list = div_to_search.getElementsByTagName('div')
	var sze = list.length
	for (var i = 0; i < sze; i++) {
		let link = list[i].getElementsByTagName('a')[0].innerHTML;
		if (link.toLowerCase().indexOf(input_text) > -1) {
			list[i].style.display = "";
		}
		else {
			list[i].style.display = "none";
		}
	}
}
