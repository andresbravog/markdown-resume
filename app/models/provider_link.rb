class ProviderLink < ActiveRecord::Base
  belongs_to :user

  serialize :credentials, Hash

  # Finds or creates user from omniauth info
  #
  # @param [type] ominiauth auth info object containing the user info
  # @return [User]
  def self.from_omniauth(auth, owner)
    where(provider: auth.provider, uid: auth.uid, user_id: owner.id).first_or_create do |provider_link|
      provider_link.credentials = auth.credentials || auth.extra.access_token.params
    end
  end
end
