$(function(){

  let toggle_btn = $("#info-toggle");
  let info_box = $("#fadein-fadeout");

  toggle_btn.on("click", function() {
    info_box.toggleClass('is-show');
  });
  info_box.on("click", function() {
    $(this).toggleClass('is-show');
  });

  $(".td-scores").on("click", function() {

    const user_name = $(this).data('user-name');
    const user2_name = $(this).data('user2-name');

    $(this).addClass("is-colored");
    $(".form-name").addClass("is-colored");
    setTimeout(function(){
      $(".td-scores").removeClass("is-colored");
      $(".form-name").removeClass("is-colored");
    },800);

    $("#game_user_name").val(user_name); 
    $("#game_user2_name").val(user2_name);
    
  });

  $(".game-box").on("click", function() {

    const user_name = $(this).children(".user-name.user-name__left").text();
    const user2_name = $(this).children(".user-name.user-name__right").text();


    $(this).addClass("is-colored");
    $(".form-name").addClass("is-colored");
    setTimeout(function(){
      $(".game-box").removeClass("is-colored");
      $(".form-name").removeClass("is-colored");
    },800);

    $("#game_user_name").val(user_name); 
    $("#game_user2_name").val(user2_name);
    
  });

})
