$(function(){

  function buildHTML_for_table(data){
    let users = data["users_for_table"];
    let table_rows = data["table_rows"];
    let user_num = users.length;

    let html;
    html = `<table><tbody><tr>`;
    $.each(table_rows[0], function(i, th) {
      if (i == 0){
        html += `<th></th>`;
      } else {
        html += `<th class="thtd-user-name">${th}</th>`;
      }
      if (i >= user_num){ return false; }
    });
    html += `<th class="thtd-border-double">won</th><th>lost</th><th>draw</th><th class="thtd-border-double">point</th><th>dif</th><th class="thtd-border-double">rank</th></tr>`

    $.each(table_rows, function(i, table_row) {
      if (i !== 0){
        html += `<tr>`;
        $.each(table_row, function(j, td) {
          if (j==0){
            html += `<td class="thtd-user-name">${td}</td>`;
          } else if (i==j){
            html += `<td class="td-gray"></td>`;
          } else if (j <= user_num){
            html += `<td class="td-scores" data-user-name="${users[i-1].name}" data-user2-name="${users[j-1].name}">${td}</td>`;
          } else if (j == user_num+1 || j == user_num+4 || j == user_num+6){
            html += `<td class="thtd-border-double">${td}</td>`;
          } else {
            html += `<td>${td}</td>`;
          }
        });
        html += `</tr>`;
      }
    });
    html += `</tbody></table>`;
    return html;
  }

  function update_score_in_order(data){
    let game_boxes = $(".game-box");
    $.each(game_boxes, function(i, game_box) {
      let this_game_box = $(game_box);
      let user_name_left = this_game_box.children(".user-name.user-name__left").text();
      let user_name_right = this_game_box.children(".user-name.user-name__right").text();

      if (user_name_left == data.user1_name && user_name_right == data.user2_name) {
        this_game_box.children(".score.score__left").text(data.user1_score);
        this_game_box.children(".score.score__right").text(data.user2_score);
      } else if (user_name_left == data.user2_name && user_name_right == data.user1_name) {
        this_game_box.children(".score.score__left").text(data.user2_score);
        this_game_box.children(".score.score__right").text(data.user1_score);
      }
    });
  }

  // ajax -- change table
  $('#form-scores').on('submit', function(e){
    e.preventDefault();

    const user1_name = $("#game_user_name").val();
    const user2_name = $("#game_user2_name").val();
    const user1_score = $("#game_user_score").val();
    const user2_score = $("#game_user2_score").val();

    // if (user1_name == "" || user2_name == "" || user1_score == "" || user2_score == "") {
    if (user1_name == "" || user2_name == "" || user1_name === user2_name) {
      alert('Error, select both of 2 user fields.');
      setTimeout(function(){
        // $('#form-scores')[0].reset();
        $('#form-scores-submit').prop("disabled", false);
      },200);
    } else if ( (user1_score == "" && user2_score.length !== 0) || (user2_score == "" && user1_score.length !== 0) ) {
      alert('Error, 2 score fields should be both filled or both empty.');
      setTimeout(function(){
        // $('#form-scores')[0].reset();
        $('#form-scores-submit').prop("disabled", false);
      },200);
    } else {
      const formData = new FormData(this);
      const url = $(this).attr('action')  // "/groups/:group_id/games"
      $.ajax({
        url: url,
        type: "POST",
        data: formData,
        dataType: 'json',
        processData: false, // FormData
        contentType: false  // FormData
      })
  
      .done(function(data){
        if (data.update_flag == 1){
          update_score_in_order(data["data_for_order"]);
          let html = buildHTML_for_table(data["data_for_table"]);
          $(".league-table").empty();
          $(".league-table").append(html);
        }
      })
      .fail(function(){
        alert('Error');
      })
      .always(function(){
        $('#form-scores')[0].reset();
        $('#form-scores-submit').prop("disabled", false);
      })
    }
  })

})
