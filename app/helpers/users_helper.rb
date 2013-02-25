module UsersHelper

# Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: "#{user.first_name} #{user.last_name}")
  end

  def avatar_for(user, options = { size: 50, tag: 'large' })
  	if user.use_gravatar
  		gravatar_for(user, options)
  	else
  		image_tag user.avatar.url(options[:tag])
  	end
  end
end
