$(document).ready(function() {
  $(".dropdown-menu li").click(function() {
    idval = $(this).data("id");
    $("#styleId").val(idval);
    $("#style_display").html($(this).text());
  });


});
