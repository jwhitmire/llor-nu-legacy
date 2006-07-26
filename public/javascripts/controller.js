// NO LONGER USED AS FAR AS I CAN TELL //

var dice_roll = 0;
var reset_toggle = 0;
var iso_height = 19;
var iso_width = 38;
var position = 3;
var redraw_count = 0;

function render_scene() {
	new Ajax.Updater('buildings_pane','/js/render_scene/');
}

function roll() {
	//new Effect.Appear('rolling');
	new Ajax.Request('/js/roll_dice/',{beforeStart:new Effect.Fade('die',{beforeStart:Element.hide('messages')},new Effect.Appear('rolling_dice',{afterFinish:prep_die})),onComplete:function(t) {
		dice_roll = parseInt(t.responseText);
		if (reset_toggle == 0) {
			document.getElementById('avatar').style.top = '203px';
			document.getElementById('avatar').style.left = '25px';
			reset_toggle = 1;
			$('roll').innerHTML = 'Rolling...';
		}		
		new Effect.MoveBy('avatar', dice_roll*iso_height, dice_roll*iso_width, {beforeStart:arrived_at_square});		
	}});
}

function arrived_at_square() {
	position = position + dice_roll;			
	new Ajax.Updater('messages','/js/arrived_at_square/'+ position, {onComplete:function(t) {
		if (t.responseText) {
			
			new Ajax.Request('/js/get_square/' + position,{onComplete:function(t) {
					$('square_'+position).innerHTML = t.responseText;
						new Ajax.Updater('active_item','/js/render_active_item/');
					}});
					//{
						//client_type_string = $('square_'+position).innerHTML.match(/type\=\"(1|2|3|5)( )?([1-9])?([0-9])?\"/);
						//server_type_string = t.responseText.match(/type\=\"(1|2|3|5)( )?([1-9])?([0-9])?\"/);
						//if (toString(client_type_string) == toString(server_type_string)) {
							// leave the div alone
						//	$('js_debug').innerHTML = "no update";
						//} else {
							// write the div
														
						//}
						
						//}
					//}
			//);
			new Effect.Appear('die', {beforeStart:Element.show('messages'), afterFinish:update_balance});
			new Element.hide('rolling_dice');
			$('roll').innerHTML = 'You rolled a ' + dice_roll;
			//new Element.hide('rolling');
			//${'square_' + position}.innerHTML = t.responseText;
		}
	}});
	if (position >= 9) {
		new Effect.MoveBy('avatar', dice_roll*iso_height, dice_roll*iso_width, {afterFinish:scroll_map});		
	}			
}

function scroll_map() {
	var x_total = (position-3) * iso_height;
	var y_total = (position-3) * iso_width;	
	position = 3;
	
	var elements = document.getElementsByClassName('others');
	for (var j = 0; j < elements.length; j ++) {
		elements[j].style.display = 'none';
	}

	new Effect.MoveBy('avatar', -x_total, -y_total);		
	for(var i=1;i<=14;i++) {			
		if (i==14) {
			new Effect.MoveBy('square_' + i, -x_total, -y_total, {afterFinish:new Ajax.Updater('buildings_pane','/js/render_scene/')});			
		} else {
			new Effect.MoveBy('square_' + i, -x_total, -y_total);
		}		
	}
	
}

function redraw_scene() {	
	new Ajax.Updater('buildings_pane','/js/render_scene/');	
}

function prep_die() {
	new Ajax.Updater('die','/js/render_die/');		
}

function update_balance() {
	new Ajax.Updater('fund_text','/js/render_balance/');
	new Element.hide('rolling_dice');
}


/*
var start_balance = 0;
var end_balance = 0;
function fancy_balance() {
	//start_balance = $('balance').innerHTML;
	new Ajax.Request('/js/render_balance/',{beforeStart:start_balance = parseInt($('balance').innerHTML),onComplete:function(t) {
		end_balance = parseInt(t.responseText);
		if (start_balance < end_balance) {
			countup();
		} else if (start_balance > end_balance) {
			countdown();
		}
	}});	
}

function countup(){
	start_balance+=10; 
	render_increment(start_balance);
	if (start_balance<end_balance){
		setTimeout("countdown()",10); 
	}
}

function countdown(){
	start_balance-=10; 
	render_increment(start_balance);
	if (start_balance>end_balance){
		setTimeout("countdown()",10); 
	}
}

function render_increment(counter){
	$("balance").innerHTML=counter;
}
*/