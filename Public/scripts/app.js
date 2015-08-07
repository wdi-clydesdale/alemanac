$(document).ready(function() {


$( "#selectByStyle" ).click(function() {
  $( "#beerStyles" ).hide().slideDown('slow');
});

$('#beerSearch input').on('change', function() {
  // alert($('input[name=styles]:checked').val());
  idval= $('input[name=styles]:checked').val();
  $("#styleId").val(idval);
});
console.log($('#authentication').html());

}); //document ready function!!!!
// It seems like the authentication function happens too early, so...
$(document).ready(function() {

if ($('#authentication').html()) {

 $('#myModal').modal('show')

 }

 });
