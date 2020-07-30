$(function(){

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

  // ajax -- add message
  $('#form-message').on('submit', function(e){
    e.preventDefault();

    const form_text_val = $(".message-form-contents__text").val();

    if (form_text_val == "") {
      alert('message should not be blank');
      setTimeout(function(){
        $('#form-message')[0].reset();
        $('#form-message-submit').prop('disabled', false);
      },200);
    } else {
      const formData = new FormData(this);
      const url = $(this).attr('action')  // "/groups/:group_id/messages"
      $.ajax({
        url: url,
        type: "POST",
        data: formData,
        dataType: 'json',
        processData: false, // FormData
        contentType: false  // FormData
      })
  
      .done(function(message){
        let html = buildHTML(message);
        $('.league-messages').append(html);
        $('.league-messages').animate({ scrollTop: $('.league-messages')[0].scrollHeight});
      })
      .fail(function(){
        alert('Error');
      })
      .always(function(){
        $('#form-message')[0].reset();
        $('#form-message-submit').prop('disabled', false);
      })
    }
  })

})
