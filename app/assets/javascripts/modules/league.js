$(function(){

  let toggle_btn = $("#info-toggle");
  let info_box = $("#fadein-fadeout");

  toggle_btn.on("click", function() {
    info_box.toggleClass('is-show');
  });

  info_box.on("click", function() {
    $(this).toggleClass('is-show');
  });

})
