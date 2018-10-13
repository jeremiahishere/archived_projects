$(document).ready(function()  {
  $('#menu ul li').mouseover(function()  {
    $(this).children('ul').show();
  });

  $('#menu ul li').mouseout(function()  {
    $(this).children('ul').hide();
  });
});

