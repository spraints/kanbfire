class ApplicationController < ActionController::Base
  protect_from_forgery

  def sign_in_from_omniauth omniauth
    # only trust google's openid. We don't want no imposters!
    if omniauth[:provider] == :open_id && omniauth[:uid] =~ %r{^https://www.google.com/accounts/o8/id}
      session['email'] = omniauth[:info][:email]
    elsif Rails.env.development?
      raise omniauth[:provider].inspect unless omniauth[:provider] == 'open_id'
      raise omniauth[:uid].inspect unless omniauth[:uid] =~ %r{^https://www.google.com/accounts/o8/id}
      raise "huh?"
    end
  end

  def self.signed_in? request
    if email = request.session['email']
      return true if email =~ /@crankapps.com$/
    end
    return false
  end
end
