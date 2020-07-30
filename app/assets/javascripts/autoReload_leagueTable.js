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

  function update_scores_in_order(data){
    let game_boxes = $(".game-box");
    let games_for_order = data.games_for_order;
    $.each(game_boxes, function(i, game_box) {
      let this_game_box = $(game_box);
      this_game_box.children(".score.score__left").text(games_for_order[i].score1);
      this_game_box.children(".score.score__right").text(games_for_order[i].score2);
    });
  }

  // main ajax
  let reloadLeagueTable = function() {
    let game_boxes = $(".game-box");
    let game_results = [];
    $.each(game_boxes, function(i, game_box) {
      let this_game_box = $(game_box);
      let user1_name = this_game_box.children(".user-name.user-name__left").text();
      let user2_name = this_game_box.children(".user-name.user-name__right").text();
      let user1_score = this_game_box.children(".score.score__left").text();
      let user2_score = this_game_box.children(".score.score__right").text();
      game_results.push({user1_name: user1_name, user2_name: user2_name, user1_score: user1_score, user2_score: user2_score});
    });

    let url_temp = $("#form-message").attr('action')  // "/groups/:group_id/messages"
    let group_id = url_temp.split("/")[2];
    let league_id = $("#message_league_id").val();

    $.ajax({
      url: `/groups/${group_id}/api/games`, // /groups/:group_id/api/leagues
      type: 'get',
      dataType: 'json',
      data: {game_results: game_results, league_id: league_id}
    })
    .done(function(data) {
      if (data.update_flag == 1){
        let html = buildHTML_for_table(data["data_for_table"]);
        $(".league-table").empty();
        $(".league-table").append(html);
        update_scores_in_order(data["data_for_order"]);
      }
    })
    .fail(function() {
      alert('error');
    });
  };

  function reloadLeagueTableDriver(){
    setTimeout(function(){
      reloadLeagueTable();
    },10000);
  }

  // relaod
  setInterval(reloadLeagueTableDriver, 20000);

  // $(".league-table").on("click", ".td-scores", function() {
  //   reloadLeagueTable();
  // });

})

