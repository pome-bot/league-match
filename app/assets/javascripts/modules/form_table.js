$(function(){

  function buildHTML(message){
    let html;
      html = `<div class="message-box message-box__current-user" data-message-id=${message.id}>
                <div class="message-box__name-icon message-box__current-user__name-icon">
                  <span class="message-user-name">${message.user_name}</span>
                  <div class="message-img">
                    <img src="${message.user_img}">
                  </div>
                </div>
                <span class="message-date">${message.date}</span>
                <p class="message-text">${message.text}</p>
              </div>`
    return html;
  }

  // ajax -- change table
  $('#form-scores').on('submit', function(e){
    e.preventDefault();

    const user1_name = $("#game_user_name").val();
    const user2_name = $("#game_user2_name").val();
    const user1_score = $("#game_user_score").val();
    const user2_score = $("#game_user2_score").val();

    if (user1_name == "" || user2_name == "" || user1_score == "" || user2_score == "") {
      alert('Error, fill all of 4 input fields.');
      setTimeout(function(){
        $('#form-scores')[0].reset();
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
        console.log("done");
        // let html = buildHTML(message);
        // $('.league-messages').append(html);
        // $('.league-messages').animate({ scrollTop: $('.league-messages')[0].scrollHeight});
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
