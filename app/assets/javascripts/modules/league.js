$(function(){

  let toggle_btn = $("#info-toggle");
  let info_box = $("#fadein-fadeout");

  toggle_btn.on("click", function() {
    info_box.toggleClass('is-show');
  });
  info_box.on("click", function() {
    $(this).toggleClass('is-show');
  });

  function highlight_clicked_elements(this_element, name1, name2, score1, score2) {
    this_element.addClass("is-colored");
    $(".form-name").addClass("is-colored");
    if (score1 !== ""){
      $(".form-score").addClass("is-colored");
    }
    setTimeout(function(){
      this_element.removeClass("is-colored");
      $(".form-name").removeClass("is-colored");
      $(".form-score").removeClass("is-colored");
    },1000);

    $("#game_user_name").val(name1); 
    $("#game_user2_name").val(name2);
    $("#game_user_score").val(score1); 
    $("#game_user2_score").val(score2); 
  }

  $(".league-table").on("click", ".td-scores", function() {
    const this_element = $(this);
    const user_name = $(this).data('user-name');
    const user2_name = $(this).data('user2-name');
    const score1 = $(this).text().split(" - ", 1)[0];	
    const score2 = $(this).text().split(" - ", 2)[1];	
    highlight_clicked_elements(this_element, user_name, user2_name, score1, score2);
  });
  $(".game-box").on("click", function() {
    const this_element = $(this);
    const user_name = $(this).children(".user-name.user-name__left").text();
    const user2_name = $(this).children(".user-name.user-name__right").text();
    const score1 = $(this).children(".score.score__left").text();	
    const score2 = $(this).children(".score.score__right").text();
    highlight_clicked_elements(this_element, user_name, user2_name, score1, score2);
  });

})
