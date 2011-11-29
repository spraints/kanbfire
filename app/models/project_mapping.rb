class ProjectMapping < ActiveRecord::Base
  attr_accessible :campfire_subdomain, :campfire_token, :campfire_room_name

  before_save :ensure_token

  has_many :kanbanery_updates

  def ensure_token
    while self.token.blank?
      token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
      unless self.class.where(:token => token).exists?
        self.token = token
      end
    end
  end
end
