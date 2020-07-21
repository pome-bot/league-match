$(function() {

  const user_search_result = $("#user-search-result");

  function append_searched_user(user) {
    const html = `<div class="group-member">
                  <p class="group-member__name">${user.name}</p>
                  <i class="fas fa-plus-square group-member__add group-member__button icon-plus" data-user-id="${user.id}" data-user-name="${user.name}"></i>
                </div>`;
    user_search_result.append(html);
  }

  function append_err_msg(msg) {
    const html = `<div class="group-member">
                  <p class="group-member__name">${msg}</p>
                </div>`;
    user_search_result.append(html);
  }

  function add_member(name, id) {
    const html = `<div class="group-member">
                  <p class="group-member__name">${name}</p>
                  <i class="fas fa-minus-square group-member__remove group-member__button icon-plus" data-user-id="${id}" data-user-name="${name}"></i>
                  <input name="group[user_ids][]" type="hidden" value="${id}">
                </div>`;
    $("#group-members").append(html);
  }

  function run_incremental_search() {
    const input = $("#user-search__field").val();

    const group_user_ids = $(".group-member__remove").map(function(){
      return $(this).data('user-id');
    }).toArray();

    $.ajax({
      type: 'GET',
      url: '/users',
      data: { keyword: input, user_ids: group_user_ids },
      dataType: 'json'
    })

    .done(function(users) {
      user_search_result.empty();
      if (users.length !== 0) {
        users.forEach(function(user){
          append_searched_user(user);
        });
      } else if (input.length == 0) {
        return false;
      } else {
        append_err_msg("no users found");
      }
    })
    .fail(function() {
      alert('error');
    });
  }

  // keyup event
  $("#user-search__field").on("keyup", function() {
    run_incremental_search();
  });

  // click event -- add
  $(user_search_result).on("click", ".group-member__add.group-member__button", function() {
    const user_name = $(this).attr("data-user-name");
    const user_id = $(this).attr("data-user-id");
    $(this).parent().remove();
    add_member(user_name, user_id);
    run_incremental_search();
  });

  // click event -- remove
  $("#group-members").on("click", ".group-member__remove.group-member__button", function() {
    $(this).parent().remove();
    run_incremental_search();
  });

});
