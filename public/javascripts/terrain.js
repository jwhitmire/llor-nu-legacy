function highlight_node(node) {
	new Effect.Appear(node);
}

function hide_node(node) {
	//setTimeout("Effect.Fade(\'" + node + "\')", 750);	
	new Effect.Fade(node,{beforeStart: function(effect) {setTimeout('do_nothing()',750)}});
}

function do_nothing() {
	return 1
}

var facet_count = 0;

function elevate(node) {
	var coords = find_xy(node);
	var adjust_x = parseInt(coords[1])-13;
	var adjust_y = parseInt(coords[2])-25;	
	$('map').innerHTML += "<div id=\"facet-"+ facet_count+1 +"\" style=\"position:absolute;display:none;top:"+ (adjust_x) +"px;left:"+ (adjust_y-1) +"px;\"><img src=\"/images/se.png\" width=\"66\" height=\"49\" /></div>";
	$('map').innerHTML += "<div id=\"facet-"+ facet_count+2 +"\" style=\"position:absolute;display:none;top:"+ (adjust_x) +"px;left:"+ (adjust_y+33) +"px;\"><img src=\"/images/ne.png\" width=\"64\" height=\"33\" /></div>";
	$('map').innerHTML += "<div id=\"facet-"+ facet_count+3 +"\" style=\"position:absolute;display:none;top:"+ (adjust_x) +"px;left:"+ (adjust_y-33) +"px;\"><img src=\"/images/sw.png\" width=\"64\" height=\"33\" /></div>";
	new Effect.Appear("facet-"+ facet_count+1,{duration:0.3});
	new Effect.Appear("facet-"+ facet_count+2,{duration:0.3});
	new Effect.Appear("facet-"+ facet_count+3,{duration:0.3});
	facet_count += 3;
}

function find_xy(node) {
	return node.split("-");
}


// image objects
function Facet(top_pos,left_pos,orientation) {
	// create some html
	this.top_pos = top_pos;
	this.left_pos = left_pos;
	this.orientation = orientation;
	alert(orientation);
}
