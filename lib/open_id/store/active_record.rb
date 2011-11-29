# This is based on the example from ruby-openid
# https://github.com/openid/ruby-openid/tree/master/examples/active_record_openid_store
require 'openid/store/interface'

module OpenID
  module Store
    class ActiveRecord < OpenID::Store::Interface
      def store_association server_url, assoc
        remove_association server_url, assoc.handle
        OpenIdAssociation.create!(
          :server_url => server_url,
          :handle => assoc.handle,
          :secret => assoc.secret,
          :issued => assoc.issued.to_i,
          :lifetime => assoc.lifetime,
          :assoc_type => assoc.assoc_type
        )
      end

      def get_association server_url, handle=nil
        scope = OpenIdAssociation.where :server_url => server_url
        scope = scope.where :handle => handle unless handle.blank?
        scope.each do |stored_assoc|
          assoc = stored_assoc.to_assoc
          if assoc.expires_in == 0
            stored_assoc.destroy
          else
            return assoc
          end
        end
        nil
      end

      def remove_association server_url, handle
        OpenIdAssociation.delete_all(:server_url => server_url, :handle => handle)
      end

      def use_nonce server_url, timestamp, salt
        scope = OpenIdNonce.where(:server_url => server_url, :timestamp => timestamp, :salt => salt)
        return false if scope.any?
        return false if (timestamp - Time.now.to_i).abs > OpenID::Nonce.skew
        scope.create!
        return true
      end

      def cleanup_nonces
        now = Time.now.to_i
        Nonce.delete_all(['timestamp > ? OR timestamp < ?', now - OpenID::Nonce.skew, now + OpenID::Nonce.skew])
      end

      def cleanup_associations
        Association.delete_all(['issues + lifetime > ?', Time.now.to_i])
      end
    end
  end
end
