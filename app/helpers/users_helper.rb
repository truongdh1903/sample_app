module UsersHelper
  def gravatar_for user
    gravatar_id = Digest::MD5.hexdigest(user.email.to_s.downcase)
    gravatar_url = Settings.gravatar_url + gravatar_id
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
