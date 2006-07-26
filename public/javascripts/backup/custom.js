userAgent = window.navigator.userAgent;
browserVers = parseInt(userAgent.charAt(userAgent.indexOf("/")+1),10);
function newImage(arg) {
	if (document.images) {
		rslt = new Image();
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
		die_over = newImage("/images/die-over.png");
		die_down = newImage("/images/die-down.png");
		buildings_over = newImage("/images/buildings-over.png");
		buildings_down = newImage("/images/buildings-down.png");
		scores_over = newImage("/images/scores-over.png");
		scores_down = newImage("/images/scores-down.png");
		payments_over = newImage("/images/payments-over.png");
		payments_down = newImage("/images/payments-down.png");
		bank_over = newImage("/images/bank-over.png");
		bank_down = newImage("/images/bank-down.png");
		logout_over = newImage("/images/logout-over.png");
		logout_down = newImage("/images/logout-down.png");
		settings_over = newImage("/images/settings-over.png");
		settings_down = newImage("/images/settings-down.png");
		help_over = newImage("/images/help-over.png");
		help_down = newImage("/images/help-down.png");
		forums_over = newImage("/images/forums-over.png");
		forums_down = newImage("/images/forums-down.png");
		preloadFlag = true;
	}
}

function notifier() {
	//new Effect.Appear('notifier');
	new Effect.SlideDown('notifier',
	{afterFinish: setTimeout("Effect.SlideUp('notifier')", 4000)});
}

function balance() {
	new Ajax.Updater('fund_text', '/play/notice_balance', {asynchronous:true, evalScripts:true}); return false;
}