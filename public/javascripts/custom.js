var userAgent = window.navigator.userAgent;
var browserVers = parseInt(userAgent.charAt(userAgent.indexOf("/")+1),10);

function newImage(arg) {
	if (document.images) {
		var rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}

function findElement(n,ly) {
	if (browserVers < 4)		return document[n];
	var curDoc = ly ? ly.document : document;
	var elem = curDoc[n];
	if (!elem) {
		for (var i=0;i<curDoc.layers.length;i++) {
			elem = findElement(n,curDoc.layers[i]);
			if (elem) return elem;
		}
	}
	return elem;
}

function changeImages() {
	if (document.images && (preloadFlag == true)) {
		var img;
		for (var i=0; i<changeImages.arguments.length; i+=2) {
			img = null;
			if (document.layers) {
				img = findElement(changeImages.arguments[i],0);
			}
			else {
				img = document.images[changeImages.arguments[i]];
			}
			if (img) {
				img.src = changeImages.arguments[i+1];
			}
		}
	}
}

var preloadFlag = false;
function preloadImages() {
	if (document.images) {
		var die_over = newImage("/images/die-over.png");
		var die_down = newImage("/images/die-down.png");
		var buildings_over = newImage("/images/buildings-over.png");
		var buildings_down = newImage("/images/buildings-down.png");
		var scores_over = newImage("/images/scores-over.png");
		var scores_down = newImage("/images/scores-down.png");
		var payments_over = newImage("/images/payments-over.png");
		var payments_down = newImage("/images/payments-down.png");
		var bank_over = newImage("/images/bank-over.png");
		var bank_down = newImage("/images/bank-down.png");
		var logout_over = newImage("/images/logout-over.png");
		var logout_down = newImage("/images/logout-down.png");
		var settings_over = newImage("/images/settings-over.png");
		var settings_down = newImage("/images/settings-down.png");
		var help_over = newImage("/images/help-over.png");
		var help_down = newImage("/images/help-down.png");
		var forums_over = newImage("/images/forums-over.png");
		var forums_down = newImage("/images/forums-down.png");
		preloadFlag = true;
	}
}

Effect.DownThenUp = function(element) {
  	new Effect.SlideDown(element,{afterFinish: function(effect) {setTimeout('Effect.SlideUp(effect.element)',4000)}});
	}

function notifier() {
	//new Effect.Appear('notifier');
	new Effect.Appear('notifier',
	{afterFinish: setTimeout("Effect.Fade('notifier')", 8000)});
}



function loading() {
		new Element.Appear('loading');
	}
		
	function toggle_die(toggle) {
		if (toggle == 1) {
			new Effect.Fade('rolling_dice');
			new Effect.Appear('die');
		}
	}
	
	function load_die() {
		new Ajax.Updater('die', '/play/die', {onComplete:toggle_die(1), asynchronous:true, evalScripts:true}); return false;		
	}
	
	function load_blank() {
		new Ajax.Updater('roll', '/play/blank', {asynchronous:true, evalScripts:true}); return false;
	}
	
	function load_roll_status() {
		new Effect.Fade('rolling');
		new Ajax.Updater('roll', '/play/roll', {onLoaded:Effect.Appear('roll'),asynchronous:true, evalScripts:true}); return false;
	}
	function load_messages() {
		new Ajax.Updater('messages', '/play/messages', {asynchronous:true, evalScripts:true}); return false;
	}
	function load_roll_nav() {
		new Ajax.Updater('roll_nav', '/play/roll_nav', {asynchronous:true, evalScripts:true}); return false;
	}
	
	function load_status_area(roll) {
		new Ajax.Updater('status_area', '/play/status_area', {asynchronous:true, evalScripts:true}); return false;		
	}
		
	function scroll(roll) {
		move_vehicle();
			
		var x_total = roll * -19;
		var y_total = roll * -38;
						
		new Effect.Fade('die');
		new Effect.Fade('roll');
		new Effect.Appear('rolling');
		new Effect.Appear('rolling_dice');
		
				
		for(var i=0;i<=17;i++) {
			new Effect.MoveBy('sq' + i, x_total, y_total);
		}		
	}
	
	function scroll_pane(roll) {
		move_vehicle();
			
		var x_total = roll * -19;
		var y_total = roll * -38;
						
		new Effect.Fade('die');
		new Effect.Fade('roll');
		new Effect.Appear('rolling');
		new Effect.Appear('rolling_dice');
		
				
		for(var i=0;i<=17;i++) {
			new Effect.MoveBy('sq' + i, x_total, y_total);
		}		
	}
		
	function end_scroll() {
		load_status_area();
		new Effect.Appear('place_marker');
	}
	
	function reset_pos(x,y) {
		document.getElementById('vehicle').style.top = x;
		document.getElementById('vehicle').style.left = y;
	}	
	
	Effect.SpeedUpDown = function(element) {
  	new Effect.MoveBy(element, -5, -10, 
	    { beforeStart: reset_pos('299px','44px'),
			duration: 0.5, afterFinish: function(effect) {
	  new Effect.MoveBy(effect.element, 5, 10, 
	    { duration: 0.5, afterFinish: function(effect) { 
	  }}) }});
	}
	
	function move_back() {
		new Effect.MoveBy('vehicle', 10,20, {beforeStart: reset_pos('190px','12px')});		
	}
	function move_vehicle() {
		new Effect.SpeedUpDown('vehicle');
		new Effect.Fade('place_marker');
	}
	

	
	function action_window_up() {
		new Effect.Fade('building_details');
	}
	
	function action_window_down() {
		new Effect.Appear('building_details');
	}
	
	Effect.Switcher = function(id) {
  		new Effect.Fade('building_details', 
			{afterFinish: function(effect) 
				{new Ajax.Updater('building_details', '/play/building_details/' + id,
					{asynchronous:true, evalScripts:true,onComplete: function(effect) 
						{new Effect.Appear('building_details')}
					}
				)
			}}		
		);
	}
	
	function hotel_switch(element) {
		new Effect.Switcher(element.options[element.selectedIndex].value); return false;		
	}
	
	function loading_builder() {
		new Effect.Appear('build_window');
	}
	function build_window_loading() {
		new Effect.Appear('loading');
	}
	function build_window_loaded() {
		new Effect.Fade('loading');
	}
	function hide_notice() {
		new Effect.Fade('account_status');
	}
	function show_notice() {
		new Effect.Appear('account_status');
	}
	
	function bubbleShow(id) {
		new Effect.Appear('halo' + id, {duration: 0.125});
		new Effect.Appear('bubble' + id, {duration: 0.125});
//		Element.show('halo' + id);
//		Element.show('bubble' + id);
	}
	
	function bubbleHide(id) {		
		new Effect.Fade('bubble' + id, {duration: 0.125});		
		new Effect.Fade('halo' + id, {duration: 0.125});
//		Element.hide('bubble' +id);
//		Element.hide('halo' + id);
	}
	
	function playerShow(id) {
		new Effect.Appear('other_' + id, {beforeStart:hide_others, duration: 0.3});
	}
	
	function playerHide(id) {
		new Effect.Fade('other_' + id, {afterFinish:hide_others, duration: 0.3});		
	}
	
	function hide_others() {
		//hideClass('bubbles');
	}
	
	function hideClass() {
	    for (var i = 0; i < arguments.length; i++) {
	      var elements = document.getElementsByClassName(arguments[i]);
	      for (var j = 0; j < elements.length; j ++)
	        elements[j].style.display = 'none'
	    }
	}
	
function building_title () {
	new Effect.Fade('fade_me');	
}
