module UsersHelper
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end

  def smile_for(user)
    smile = 'smile.png'
    image_tag(smile, alt: user.name, class: 'gravatar')
  end

  def icon_for(user, options = { size: 1 })
    size = options[:size]
    if size == 3
      icon = 'user-icon-large.png' # 300px x 300px
    elsif size == 2
      icon = 'user-icon-medium.png' # 174px x 174px
    elsif size == 1
      icon = 'user-icon-small-blue.png' # 64px x 64px
    else
      raise 'StandardError'
    end
    image_tag(icon, alt: user.name, class: 'album')
  end
end
