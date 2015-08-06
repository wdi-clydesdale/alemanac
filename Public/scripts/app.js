$(document).ready(function() {
  $(".dropdown-menu li").click(function() {
    idval = $(this).data("id");
    $("#styleId").val(idval);
    $("#dropdownMenu1").html($(this).text());
  });

$('.beerpopoverData').popover();

});
