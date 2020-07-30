$(function(){

  let toggle_btn = $("#info-toggle");
  let info_box = $("#fadein-fadeout");

  toggle_btn.on("click", function() {
    info_box.toggleClass('is-show');
  });
  info_box.on("click", function() {
    $(this).toggleClass('is-show');
  });

  function highlight_clicked_elements(this_element, id1, id2, score1, score2) {
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

    $("#game_user_id").val(id1); 
    $("#game_user2_id").val(id2);
    $("#game_user_score").val(score1); 
    $("#game_user2_score").val(score2); 
  }

  $(".league-table").on("click", ".td-scores", function() {
    const this_element = $(this);
    const user_id = $(this).data('user-id');
    const user2_id = $(this).data('user2-id');
    const score1 = $(this).text().split(" - ", 1)[0];	
    const score2 = $(this).text().split(" - ", 2)[1];	
    highlight_clicked_elements(this_element, user_id, user2_id, score1, score2);
  });
  $(".game-box").on("click", function() {
    const this_element = $(this);
    const user_id = $(this).children(".user-name.user-name__left").data("user-id");
    const user2_id = $(this).children(".user-name.user-name__right").data("user-id");
    const score1 = $(this).children(".score.score__left").text();	
    const score2 = $(this).children(".score.score__right").text();
    highlight_clicked_elements(this_element, user_id, user2_id, score1, score2);
  });

})
