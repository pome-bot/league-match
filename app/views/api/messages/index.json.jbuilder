json.array! @messages do |message|
  json.user_name    message.user.name
  json.user_id      message.user_id
  if message.user.image?
    json.user_img   message.user.image.url
  else
    json.user_img   "/assets/default_user_image-52e0572f7b3fe1473390e9939c116a21fc30a7e4071097124461969efc37bbf3.png"
  end
  json.date  message.created_at.strftime("%Y年%m月%d日 %H時%M分")
  json.text  message.text
  json.id    message.id
  json.current_user_id  current_user.id
end
