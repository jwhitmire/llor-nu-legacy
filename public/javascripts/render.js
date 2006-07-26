var new_buildings;
var cursor_x=0;
var cursor_y=0;

function move_car(x)
{
new Effect.MoveBy("avatar", ((x) * +19), ((x) * +38), {duration:0.2*x});
}

function move_board(total_dice)
{
				var elements = document.getElementsByClassName("halo");
				for(var i=0; i<elements.length; i++)
				{
				elements[i].style.left=parseInt(elements[i].style.left)-(total_dice*38);
				elements[i].style.top=parseInt(elements[i].style.top)-(total_dice*19);
				}
				var elements = document.getElementsByClassName("squares");	
				for(var i= 0;i< elements.length;i++)
				{
						new Effect.MoveBy(elements[i].id, ((total_dice) * -19), ((total_dice) * -38), {duration:1.125});
				}	
				new Effect.MoveBy("avatar", ((total_dice-dice_roll) * -19), ((total_dice-dice_roll) * -38), {duration:1.125});

}

function render_changes()
{
var squares=new_squares.squares;

squares.each ( function (square) 
{
if ($('square_' + square.position))
{
  // update_old square
}
else 
{
out=render_square_at_cursor(square);
new Insertion.After('square_' + previous_square.position, out);
}
previous_square=square;

});

}

function delete_offscreen_squares()
{
  var squares = document.getElementsByClassName("squares");
  squares.each ( function(square) {
    top=parseInt(square.style.top);
    left=parseInt(square.style.left);
    if ((top+left) < -108)
      {
      id=square.id.replace("square_","");
      square.parentNode.removeChild(square);
      
      halo=$('halo' + id);
      if (halo)
        halo.parentNode.removeChild(halo);
      bubble=$('bubble' + id);
      if (bubble)
        bubble.parentNode.removeChild(bubble);
      }
});

}

function render_square_at_cursor(square)
{
out=render_square_at(square, cursor_x, cursor_y)
cursor_down(1);
return out;
}

/* renders a square at a given position on the board */
function render_square_at(square, x, y)
{
  left=x;
  top=y;
  out="";

  if (square.deeded)
	{
    out+='<div class="halo" id="halo' + square.position + '" style="display:none; top:' + top + 'px;left:' + left + 'px;"><img src="/images/sprites/halo.png" width="65" height="255" /></div>';
		out+='<div class="squares" id="square_' + square.position + '" style="top:' + top + 'px;left:' + left + 'px;" onmouseover="bubbleShow(\'' + square.position+ '\');" onmouseout="bubbleHide(\'' + square.position + '\')" >';
	}
	else
	{
		if (square.square_type_id==1 || square.square_type_id==3)
			out+='<div class="squares" id="square_' + square.position + '" style="top:' + (top+221) + 'px;left:' + left + 'px;">';
		else if (square.square_type_id==5)
			out+='<div class="squares" id="square_' + square.position + '" style="top:' + (top+202) + 'px;left:' + left + 'px;">';
		else
			out+='<div class="squares" id="square_' + square.position + '" style="top:' + top + 'px;left:' + left + 'px;">';
	}

switch(square.square_type_id)
{
  case 2:
    out+='<a type="2 ' + square.deed.levels + '" href="#">';
    out+='<img src="/images/sprites/';
    out+=square.deed.property_type_id + "/" + square.deed.levels;
		out+='.png" width="65" height="255" /></a></div> ';
    break;
  case 3:
    out+='<a type="' + square.square_type_id + '" href="#">';
    out+='<img src="/images/sprites/';
    out+="sale_short";
		out+='.png" width="65" height="34" /></a></div> ';
    break;
  case 5:
    out+='<a type="' + square.square_type_id + '" href="#">';
    out+='<img src="/images/sprites/';
    out+="quicky_short";
		out+='.png" width="65" height="53" /></a></div> ';
    break;
  default:
    out+='<a type="' + square.square_type_id + '" href="#">';
    out+='<img src="/images/sprites/';
    out+="square_short";
		out+='.png" width="65" height="34" /></a></div> ';
}

if (square.deeded)
{
  out+='<div class="bubbles" id="bubble' + square.position + '" style="display:none;">';
  out+='<div id="content">';
  out+='<table style="width:280px;">';
  out+='<tr>';
  out+='<td><img src="/images/dot.gif" style="height:68px;width:1px;"></td>';
  out+='<td style="text-align:center;">';
  out+='<b>' + square.deed.name + '</b>';
  out+='<br />Owned by: ' + square.deed.owner + '<br />';
  out+='Rent: ' + square.deed.rent + '<br />';
  out+='Position: ' + square.position;
  out+='</td></tr></table>';
  out+='</div>';
  out+='<div><img src="/images/notifier_cap.png" height="8" width="329" ></div>     </div>';
}
if (square.other_players)
{
//out+='<div class="others" style="position:absolute;top:' + (top+280) + 'px;left:' + (left-4) +'"><a class="tool_tip" href="#"><img src="/images/vehicles/odyssey_purple.png" width="52" height="35" /></a></div>';
}

  return out;
}

function crappy_render_full_map()
{
out="";
cursor_reset();

var squares=new_squares.squares;

squares.each ( function (square) 
{
out+=render_square_at(square, cursor_x, cursor_y);

cursor_down(1);
});



out+='<div id="avatar" style="position:absolute;top:200px;left:21px;"><img  src="/images/vehicles/odyssey.png" width="52" height="35" title="Honda Odyssey" /></div>';

/*
x=12;
y=201;
map='<img style="position:absolute;" src="/images/map.png" usemap="#halo_map">';
map+='<map name="halo_map">';
squares.shift();
squares.each ( function (square)
{
  if (square.deeded)
  {
    map+='<area shape="rect" onmouseover="bubbleShow(\'' + square.position+ '\');" onmouseout="bubbleHide(\'' + square.position + '\')" coords="' + x + ',0,' + (x + 33) +',' + y + '" href="#">'
  }
x+=38;
y+=19;
});
//out+=map;
out+="</map>";
*/

//alert(out);
//$('buildings_pane').innerHTML = out;

return out;

}

function cursor_reset()
{
cursor_x=-33;
cursor_y=-75;
}

function cursor_up(count)
{
cursor_down(-1*count);
}

function cursor_down(count)
{
cursor_x+=38*count;
cursor_y+=19*count
}
