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
//= require app_assets

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
						reset_form("update_handle_form")
					}
					else {
						update_handle(status);
						message("add", "handles_notice", "Your Codeforces handle has been updated!<br/>The page will now reload")
						reset_form("update_handle_form")
						window.location.reload();
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
			message("add", "links_notice", "Searching problem <b>" + info + "</b> on Codeforces...")
			message("add", "links_notice1", "Searching problem <b>" + info + "</b> on Codeforces...")
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
						message("add", "links_notice1", "Problem <b>" + info + "</b> doesn't exist or has already been added")
					}
					reset_form("add_links_form")
				}
			}); 
		};
	});


	$('#add_links_form1').focus();
	$('#add_links_form1').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#add_links_form1').val();
			message("add", "links_notice1", "Searching problem <b>" + info + "</b> on Codeforces...")
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
						message("add", "links_notice1", "Problem <b>" + info + "</b> doesn't exist or has already been added")
						message("add", "links_notice", "Searching problem <b>" + info + "</b> on Codeforces...")
					}
					reset_form("add_links_form1")
				}
			}); 
		};
	});
});

function try_remove_link(info) {
	var answer = confirm("Do you really want to remove problem " + info + "?");
	if (answer) {
		$.ajax({
			method: "POST",
			url: "/remove_links_from_db",
			data: {name: cf_like(info)},
			success: function(status) {
				if (status == "true") {
					remove_url(info);
					message("add", "links_notice", "Problem <b>" + info + "</b> removed")
					message("add", "links_notice1", "Problem <b>" + info + "</b> removed")
				}
				else {
					message("add", "links_notice", "Nothing to remove")

					message("add", "links_notice1", "Nothing to remove")
				}
			}
		});
	}
}


$(document).ready(function() {
	$('#add_friends_form').focus();
	$('#add_friends_form').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#add_friends_form').val();
			message("add", "friends_notice", "Searching handle <b>" + info + "</b> on Codeforces...");
			message("add", "friends_notice1", "Searching handle <b>" + info + "</b> on Codeforces...");
			$.ajax({
				method: "POST",
				url: "/add_friends_to_db",
				data: {name: info},
				success: function(status) {
					if (status == "false") {
						message("add", "friends_notice", "Handle doesn't exist or has already been added")
						message("add", "friends_notice1", "Handle doesn't exist or has already been added")
					}
					else {
						$.ajax({
							method: "POST",
							url: "/retrieve_handle",
							success: function(handle) {
								add_friend(handle, status);
								message("add", "friends_notice", "Handle <b>" + status + "</b> added as friend")
								message("add", "friends_notice1", "Handle <b>" + status + "</b> added as friend")
							}
						})
					}
					reset_form("add_friends_form")
				}
			}); 
		};
	});

	$('#add_friends_form1').focus();
	$('#add_friends_form1').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#add_friends_form1').val();
			message("add", "friends_notice1", "Searching handle <b>" + info + "</b> on Codeforces...");
			message("add", "friends_notice", "Searching handle <b>" + info + "</b> on Codeforces...");
			$.ajax({
				method: "POST",
				url: "/add_friends_to_db",
				data: {name: info},
				success: function(status) {
					if (status == "false") {
						message("add", "friends_notice1", "Handle doesn't exist or has already been added");
						message("add", "friends_notice", "Handle doesn't exist or has already been added");
					}
					else {
						$.ajax({
							method: "POST",
							url: "/retrieve_handle",
							success: function(handle) {
								add_friend(handle, status);
								message("add", "friends_notice1", "Handle <b>" + status + "</b> added as friend");
								message("add", "friends_notice", "Handle <b>" + status + "</b> added as friend");
							}
						})
					}
					reset_form("add_friends_form1")
				}
			}); 
		};
	});
});

function try_remove_friend(info) {
	var answer = confirm("Do you really want to remove friend " + info + "?");
	if (answer) {
		message("add", "friends_notice", "Removing <b>" + info + "</b> from your friend list...")
		message("add", "friends_notice1", "Removing <b>" + info + "</b> from your friend list...")

		$.ajax({
			method: "POST",
			url: "/remove_friends_from_db",
			data: {name: info},
			success: function(status) {
				if (status == "false") {
					message("add", "friends_notice", "Nothing to remove")
					message("add", "friends_notice1", "Nothing to remove")

				}
				else {
					remove_friend(status);
					message("add", "friends_notice", "Removed <b>" + status + "</b> from your friend list")
					message("add", "friends_notice1", "Removed <b>" + status + "</b> from your friend list")

				}
			}
		});
	}
}

$(document).ready(function() {
	$('#add_contests_form').focus();
	$('#add_contests_form').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#add_contests_form').val();
			message("add", "contests_notice", "Searching contest <b>" + info + "</b> on Codeforces...")
			message("add", "contests_notice1", "Searching contest <b>" + info + "</b> on Codeforces...")
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
						message("add", "contests_notice1", "Contest doesn't exist or has already been added")
					}
					reset_form("add_contests_form")
				}
			}); 
		};
	});

	$('#add_contests_form1').focus();
	$('#add_contests_form1').keypress(function(event) {
		var key = (event.keyCode ? event.keyCode : event.which);
		if (key == 13) {
			var info = $('#add_contests_form1').val();
			message("add", "contests_notice1", "Searching contest <b>" + info + "</b> on Codeforces...")
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
						message("add", "contests_notice1", "Contest doesn't exist or has already been added")
						message("add", "contests_notice", "Contest doesn't exist or has already been added")
					}
					reset_form("add_contests_form1")
				}
			}); 
		};
	});
});

function try_remove_contest(info) {
	var answer = confirm("Do you really want to remove contest " + info + "?");
	if (answer) {
		$.ajax({
			method: "POST",
			url: "/remove_contest_from_db",
			data: {name: info},
			success: function(status) {
				if (status == "true") {
					remove_contest(info);
					message("add", "contests_notice", "Contest <b>" + info + "</b> removed")
					message("add", "contests_notice1", "Contest <b>" + info + "</b> removed")					
				}
				else {
					message("add", "contests_notice", "Nothing to remove")
					message("add", "contests_notice1", "Contest <b>" + info + "</b> removed")					
				}
			}
		});
	}
}

////////////////////////////////////////////////////////////////////////////////////////////

function check_if_problem_solved(info) {
	info = cf_like(info)
	$.ajax({
		method: "POST",
		url: "/retrieve_solved",
		data: {name: info},
		success: function(status) {
			if (String(info) in status) {
				message("add", "links_notice", "Problem <b>" + info + "</b> added, but you have already solved it")
				message("add", "links_notice1", "Problem <b>" + info + "</b> added, but you have already solved it")
				add_url(info, true)
			}
			else {
				message("add", "links_notice", "Problem <b>" + info + "</b> successfully added!")
				message("add", "links_notice1", "Problem <b>" + info + "</b> successfully added!")
				
				add_url(info, false)
			}
		}
	});
}

function check_if_contest_attempted(info) {
	$.ajax({
		method: "POST",
		url: "/retrieve_attempted",
		data: {name: info},
		success: function(status) {
			if (String(info) in status) {
				message("add", "contests_notice", "Contest <b>" + info + "</b> added, but you have already attempted to solve problems from it...")
				add_contest(info, true)
			}
			else {
				message("add", "contests_notice", "Contest <b>" + info + "</b> successfully added!")
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
	$.ajax({
		method: "POST",
		url: "/retrieve_cancel_icon_path",
		success: function(cancel_path) {
			contest = info.substr(0, info.length-1)
			index = info[info.length-1]
			var current_html = document.getElementById('links').innerHTML
			var seen = ""
			if (solved) seen = "<i>(solved)</i> "
				var to_add = current_html + "<div id =" + info + ">" + seen +
			"<a target='_blank'" + "href='http://codeforces.com/contest/" +
			contest + "/problem/" + index + "'>" + info + "</a>"
			to_add = to_add + " <img onclick=\"try_remove_link('" + String(info) + "')\" src='" + cancel_path + "' alt='Cancel' width='16' height='16'>";			 
			to_add = to_add + "</div>"
			document.getElementById('links').innerHTML = to_add
			document.getElementById('links1').innerHTML = to_add
		}
	});
}

function remove_url(info) {
	$('.' + cf_like(info)).remove()
}

function add_friend(handle, info) {
	$.ajax({
		method: "POST",
		url: "/retrieve_compare_icon_path",
		success: function(compare_path) {
			$.ajax({
				method: "POST",
				url: "/retrieve_cancel_icon_path",
				success: function(cancel_path) {
					var current_html = document.getElementById('friends').innerHTML
					var to_add = current_html +  "<div id =" + info + ">" + "<a target='_blank'" +
					"href='http://codeforces.com/profile/" + info + "'>" + info + "</a>" + "&nbsp;"
					to_add = to_add + " <img onclick=\"compare('" + String(handle) + "', '" + String(info) + "')\" src='" + compare_path + "' alt='Compare' width='16' height='16'>";
					to_add = to_add + " <img onclick=\"try_remove_friend('" + String(info) + "')\" src='" + cancel_path + "' alt='Cancel' width='16' height='16'>";
					to_add = to_add + "</div>"
					document.getElementById('friends').innerHTML = to_add
					document.getElementById('friends1').innerHTML = to_add
				}
			});
		}
	});
}

function remove_friend(info) {
	$('.' + info).remove()
}

function add_contest(info, attempted) {
	$.ajax({
		method: "POST",
		url: "/retrieve_cancel_icon_path",
		success: function(cancel_path) {
			var current_html = document.getElementById('contests').innerHTML
			var seen = ""
			var to_add = ""
			if (attempted) seen = "<i>(attempted)</i> "
				if (Number(info) > 99999) {
					to_add = current_html + "<div id =" + info + ">" + seen + "<a target='_blank'" +
					"href='https://codeforces.com/gym/" + info + "'>" + info + "</a>"
				}
				else {
					var to_add = current_html + "<div id =" + info + ">" + seen + "<a target='_blank'" +
					"href='http://codeforces.com/contest/" + info + "'>" + info + "</a>"
				}
				to_add = to_add + " <img onclick=\"try_remove_contest('" + String(info) + "')\" src='" + cancel_path + "' alt='Cancel' width='16' height='16'>";
				to_add = to_add + "</div>"
				document.getElementById('contests').innerHTML = to_add
				document.getElementById('contests1').innerHTML = to_add
			}
		});
}

function remove_contest(info) {
	$('.' + info).remove()
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
	var datatable = new google.visualization.DataTable();
	datatable.addColumn('date', 'date');
	datatable.addColumn('number', String(handle1));
	datatable.addColumn('number', String(handle2));
	datatable.addColumn('number', 'Newbie');
	datatable.addColumn('number', 'Pupil');
	datatable.addColumn('number', 'Specialist');
	datatable.addColumn('number', 'Expert');
	datatable.addColumn('number', 'Candidate Master');
	datatable.addColumn('number', 'Master');
	datatable.addColumn('number', 'International Master');
	datatable.addColumn('number', 'Grandmaster');
	datatable.addColumn('number', 'International Grandmaster');
	datatable.addColumn('number', 'Legendary Grandmaster');
	
	var big = 0;
	var small = 10000;

	for (var i = 0; i < data.length; i++) {
		var secs = Number(data[i][0]);
		var date = new Date(secs*1000);

		if (data[i][1] == null) {
			if (data[i][2] != null) {
				small = Math.min(small, data[i][2]);
				big = Math.max(big, data[i][2]);
			}
		} else {
			if (data[i][2] == null) {
				small = Math.min(small, data[i][1]);
				big = Math.max(big, data[i][1]);
			} else {
				small = Math.min(small, data[i][1]);
				small = Math.min(small, data[i][2]);

				big = Math.max(big, data[i][1]);
				big = Math.max(big, data[i][2]);
			}
		}

		datatable.addRow([date, data[i][1], data[i][2], 1200, 200, 200, 300, 200, 200, 100, 200, 400, 2000]);
	}

	var chart = new google.visualization.ComboChart(document.getElementById(parent_div));

	chart.draw(datatable, {
		backgroundColor: 'transparent',
		width: document.getElementById(parent_div).clientWidth,
		height: document.getElementById(parent_div).clientHeight,
		isStacked: true,
		vAxis: {
			viewWindow: {
				min: Math.min(1000, small - 0.1 * Math.abs(small)),
				max: Math.max(2000, 1.1 * big)
			},
			ticks: [1200,1400,1600,1900,2100,
			2300,2400,2600,3000],
			textStyle: {
				fontSize: 10
			},
			format: ''
		},
		series: {
			0: {
				type: 'line'
			},
			1: {
				type: 'line'
			},
			2: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#bfbfbf'
			},
			3: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#00ff55'
			},
			4: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#66d9ff'
			},
			5: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#3722f6'
			},
			6: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#cc33ff'
			},
			7: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#ffff66'
			},
			8: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#ff6600'
			},
			9: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#ff6666'
			},
			10: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#e60000'
			},
			11: {
				lineWidth: 0,
				type: 'area',
				visibleInLegend: false,
				enableInteractivity: false,
				color: '#AC0000'
			}
		},
		chartArea: {'width': '80%', 'height': '70%', 'top': '1%'},
		legend: {'position': 'bottom', 'alignment': 'center'}
	});
}

function filter(id, name) {
	var search_bar = 'search' + id;
	var list_id = name;
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

function compare(handle1, handle2) {
	var url = "/result?&param1=" + handle1 + "&param2=" + handle2 + "&commit=Compare%21"
	window.open(url);
}

//update two first handles, two last ones are the handles being compared
function update_info(handle_to_update_1, handle_to_update_2, handle1, handle2) {
	document.getElementById('loadingDiv').style = 'display: unset'
	$.ajax({
		method: "POST",
		url: "/update_handle_info",
		data: {handle1: handle_to_update_1, handle2: handle_to_update_2},
		success: function(status) {
			var url = "/result?&param1=" + handle1 + "&param2=" + handle2 + "&commit=Compare%21"
			window.location.replace(url);
		}
	});
}

function update_single_handle(handle) {
	document.getElementById('loadingDiv').style = 'display: unset'
	$.ajax({
		method: "POST",
		url: "/update_handle_info",
		data: {handle1: handle, handle2: ""},
		success: function(status) {
			var url = "/profile"
			window.location.replace(url);
		}
	});
}