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

$('#prev').click(function() {
  var new_page = Math.max(parseInt($('#pg_num').val())-1,1);
  $('#pg_num').val(new_page);
});

$('#next').click(function() {
  var top = $('#numberOfPages').val();
  var new_page = Math.min(parseInt($('#pg_num').val())+1,top);
  $('#pg_num').val(new_page);
});

$("#first-choice").on('click', 'li a', function() {
  var str =   $(this).html();
  $("#dropdownMenu1").html(str);
  str = str.replace(/ /g,'_');
   $("#second-choice").load("Menu/" + str + ".txt");
});

$("#second-choice").on('click', 'li a', function() {
    var str = $(this).html();
  $("#dropdownMenu2").html(str);
    console.log(str);

    var idval = $(this).parent().data('styleid');
    console.log(idval);
  $("#styleId").val(idval);
})

}); //document ready function!!!!
