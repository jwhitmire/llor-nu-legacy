var total_dice = 0;
var dice_roll = 0;
var old_position = 0;
var new_position = 0;
var last_rendered_square = '';
//var new_buildings = '';

function roll() {
	var current_money = $('fund_text').innerHTML;
	if (current_money == 'NaN' | current_money == 'You\'re broke!') return;
	
		// switch to rolling mode
		// todo: have a timeout, so that if there's no response, it doesn't
		// just sit there rolling! the tension kills me.
//		new Effect.Fade('roll', {duration:0.125});
		new Effect.Fade('die', {duration:0.125});
//		new Effect.Appear('rolling', {duration:0.125});
		new Effect.Appear('rolling_dice', {duration:0.125});
//		new Effect.BlindUp('messages',{fps:25,duration: 0.125});
		Element.hide('roll');
		Element.show('rolling');
		Element.hide('messages'); 
		
    // Arrive at the square. This renders the balance, and
    // displays any messages that have been returned.
    
		new Ajax.Request('/js/take_turn/',{onComplete:function(t) {

				// get JS fragments				
				//var match    = new RegExp(Ajax.Updater.ScriptFragment, 'img');				
				var response = t.responseText;
				var scripts  = t.responseText.evalScripts();
				views=response.split("<!--break-->");
				
				
				// execute JS
				//match    = new RegExp(Ajax.Updater.ScriptFragment, 'im');
				//for (var i = 0; i < scripts.length; i++) {					
				//	eval(scripts[i].match(match)[1]);
				//}
				
				new Effect.Appear('die',{duration: 0.125,queue:'end'});
				new Effect.Fade('rolling_dice',{duration: 0.125,queue:'end'});
				new Effect.Fade('rolling', {duration:0.125,queue: 'end'});
				new Effect.Appear('roll',{duration: 0.25,queue:'end'});	
				
				$('messages').innerHTML = views[0];
				new Effect.BlindDown('messages',{fps:25,duration: 0.125,queue:'end'});
	
			total_dice+=dice_roll;
			if (total_dice<9)
				{
				new Effect.MoveBy("avatar", ((dice_roll) * +19), ((dice_roll) * +38), {duration:0.2*dice_roll});
				}
			else
			{
				var elements = document.getElementsByClassName("squares");	
				for(var i= 0;i< elements.length;i++)
				{
//					if (i+1==elements.length) {
//						new Effect.MoveBy(elements[i].id, ((dice_roll) * -19), ((dice_roll) * -38), {duration:1.125});
						new Effect.MoveBy(elements[i].id, ((total_dice) * -19), ((total_dice) * -38), {duration:1.125});
//					} else {
//						new Effect.MoveBy(elements[i].id, ((dice_roll) * -19), ((dice_roll) * -38), {duration:1.125});
//						new Effect.MoveBy(elements[i].id, ((dice_roll) * -19), ((dice_roll) * -38), {duration:1.125});
//					}
				}	
				new Effect.MoveBy("avatar", ((total_dice-dice_roll) * -19), ((total_dice-dice_roll) * -38), {duration:1.125});
				
//				$('buildings_pane').innerHTML = views[1];
				new_buildings = views[1];
				new Effect.Redraw('buildings_pane');
				total_dice=0;
			}			
	
				} // onComplete
    }); // Ajax

}

// muy importante - when the ajax work is done, it calls our post_roll effects
Ajax.Responders.register({ 
	onComplete: function() {if(Ajax.activeRequestCount == 0) {run_effects();}}
});

Effect.Redraw = function(element) {
  element = $(element);
  return new Effect.Parallel([],Object.extend({afterFinishInternal: function(effect) {$(element).innerHTML = new_buildings;}}, arguments[1] || {}));
}

function run_effects() {
	// PUT NO AJAX CALLS IN HERE. RESPONDER WILL GO APE BALLS
	var iso_height = 19;
	var iso_width = 38;
	var messages = "";
	var buildings = "";
	var die = "";
	var square = "";
	var roll_status = "";	
	
	// think of these in reverse order.	
//	new Effect.Appear('die',{duration: 0.125,queue:'end'});
//	new Effect.Fade('rolling_dice',{duration: 0.125,queue:'end'});
//	new Effect.Fade('rolling', {duration:0.125,queue: 'end'});
//	new Effect.Appear('roll',{duration: 0.25,queue:'end'});	
	
	
	//var elements = document.getElementsByClassName("squares");	
	//for(var i= 0;i< elements.length;i++) {
	//	if (i+1==elements.length) {
	//		new Effect.MoveBy(elements[i].id, ((dice_roll) * -19), ((dice_roll) * -38), {duration:0.125});
	//	} else {
	//		new Effect.MoveBy(elements[i].id, ((dice_roll) * -19), ((dice_roll) * -38), {duration:0.125});
	//	}
	//}	
//	new Effect.BlindDown('messages',{fps:25,duration: 0.125,queue:'end'});
//	new Effect.Redraw('buildings_pane');	
}

function balance() {
	new Ajax.Updater('fund_text', '/js/render_balance', {asynchronous:true, evalScripts:true}); return false;
}

