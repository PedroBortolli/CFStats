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

var NO_BUTTONS = 5

window.onload=function(){
	for (var i = 1; i <= NO_BUTTONS; i++) {
		var button_to_hide = "hidden" + i
		document.getElementById(button_to_hide).style.display='none';
	}
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