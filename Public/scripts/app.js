$(document).ready(function() {


$( "#selectByStyle" ).click(function() {
  $( "#beerStyles" ).hide().slideDown('slow');
});

$('#beerSearch input').on('change', function() {
  // alert($('input[name=styles]:checked').val());
  idval= $('input[name=styles]:checked').val();
  $("#styleId").val(idval);
});

}); //document ready function!!!!
