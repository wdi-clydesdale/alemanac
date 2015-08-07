$(document).ready(function() {


$( "#selectByStyle" ).click(function() {
  $( "#beerStyles" ).hide().slideDown('slow');
});

$('#beerSearch input').on('change', function() {
  // alert($('input[name=styles]:checked').val());
  idval= $('input[name=styles]:checked').val();
  $("#styleId").val(idval);
});
if ( $('#authentication').length ) {

  var s = $('#authentication').html();
  console.log(s);
  if (s.indexOf('false') > -1) {

   $('#myModal').modal('show')
      
   }

}

}); //document ready function!!!!
