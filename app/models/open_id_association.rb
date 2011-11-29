require 'openid/association'

class OpenIdAssociation < ActiveRecord::Base
  def to_assoc
    OpenID::Association.new(handle, secret, Time.at(issued), lifetime, assoc_type)
  end
end
