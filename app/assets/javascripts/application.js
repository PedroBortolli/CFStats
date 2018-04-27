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

var NO_BUTTONS = 6

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