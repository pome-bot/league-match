$(function(){

  $('.league-messages').animate({ scrollTop: $('.league-messages')[0].scrollHeight});

  function buildHTML(message){
    let html;
    if (message.current_user_id == message.user_id){
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
    } else {
      html = `<div class="message-box message-box__other-user data-message-id=${message.id}">
                <div class="message-box__name-icon message-box__other-user__name-icon">
                  <div class="message-img">
                    <img src="${message.user_img}">
                  </div>
                  <span class="message-user-name">${message.user_name}</span>
                </div>
                <span class="message-date">${message.date}</span>
                <p class="message-text">${message.text}</p>
              </div>`
    }
    return html;
  }

  let reloadMessages = function() {
    let last_message_id = $('.message-box:last').data("message-id");
    if ( !(last_message_id) ) { last_message_id = 0 }
    let url_temp = $("#form-message").attr('action')  // "/groups/:group_id/messages"
    let group_id = url_temp.split("/")[2];
    let league_id = $("#message_league_id").val();

    $.ajax({
      url: `/groups/${group_id}/api/messages`, // /groups/:group_id/api/messages
      type: 'get',
      dataType: 'json',
      data: {id: last_message_id, league_id: league_id}
    })
    .done(function(messages) {
      if (messages.length !== 0) {
        let insertHTML = '';
        $.each(messages, function(i, message) {
          insertHTML += buildHTML(message)
        });
        $('.league-messages').append(insertHTML);
        $('.league-messages').animate({ scrollTop: $('.league-messages')[0].scrollHeight});
      }
    })
    .fail(function() {
      alert('error');
    });
  };

  // relaod
  setInterval(reloadMessages, 100000);

  // $(".td-scores").on("click", function() {
    // reloadMessages();
  // });




})

