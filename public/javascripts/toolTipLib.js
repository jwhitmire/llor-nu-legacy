var toolTipLib = { 
	xCord : 0,
	yCord : 0,
	attachToolTipBehavior: function() {
	var links = document.getElementsByClassName('tool_tip');
	var i;
		for ( i=0;i<links.length;i++ ) {
		addEvent(links[i],'mouseover',toolTipLib.tipOver,false);
		addEvent(links[i],'mouseout',toolTipLib.tipOut,false);
		links[i].setAttribute('tip',links[i].title);
		links[i].removeAttribute('title');
		}
	},
	tipOver: function(e) {
	obj = getEventSrc(e);
	toolTipLib.xCord = findPosX(obj);
	toolTipLib.yCord = findPosY(obj);
	tID = setTimeout("toolTipLib.tipShow(obj,'"+toolTipLib.xCord+"','"+toolTipLib.yCord+"')",500)
	},
	tipOut: function(e) {
		if ( window.tID )
		clearTimeout(tID);
		if ( window.opacityID )
		clearTimeout(opacityID);
	var l = getEventSrc(e);
	var div = document.getElementById('toolTip');
		if ( div ) {
		div.parentNode.removeChild(div);
		}
	},
	checkNode : function(obj) {
	var trueLink = obj;
		if ( trueLink.nodeName.toLowerCase() == 'a' ) {
		return trueLink;
		}
		while ( trueLink.nodeName.toLowerCase() != 'a' && trueLink.nodeName.toLowerCase() != 'body' )
		trueLink = trueLink.parentNode;
	return trueLink;
	},
	tipShow: function(obj,x,y) {
	var newDiv = document.createElement('div');
	var scrX = Number(x);
	var scrY = Number(y);
	var tp = parseInt(scrY+20);
	var lt = parseInt(scrX+20);
	var anch = toolTipLib.checkNode(obj);
	var addy = (anch.href.length > 25 ? anch.href.toString().substring(0,25)+"..." : anch.href);
	newDiv.id = 'toolTip';
	newDiv.style.top = tp+'px'; newDiv.style.left = lt+'px';
	document.body.appendChild(newDiv);
	newDiv.innerHTML = "<p>"+anch.getAttribute('tip')+"</p>";
	newDiv.style.opacity = '.1';
	toolTipLib.tipFade('toolTip',10);
	},
	tipFade: function(div,opac) {
	var obj = document.getElementById(div);
	var passed = parseInt(opac);
	var newOpac = parseInt(passed+10);
		if ( newOpac < 80 ) {
		obj.style.opacity = '.'+newOpac;
		obj.style.filter = "alpha(opacity:"+newOpac+")";
		opacityID = setTimeout("toolTipLib.tipFade('toolTip','"+newOpac+"')",20);
		}
		else { 
		obj.style.opacity = '100';
		obj.style.filter = "alpha(opacity:100)";
		}
	}
};
addEvent(window,'load',toolTipLib.attachToolTipBehavior,false);