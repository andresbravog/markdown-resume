class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  devise :omniauthable, omniauth_providers: [:linkedin, :xing, :github]

  serialize :credentials, Hash

  has_many :provider_links

  # Finds or creates user from omniauth info
  #
  # @param [type] ominiauth auth info object containing the user info
  # @return [User]
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.credentials = auth.credentials || auth.extra.access_token.params
    end
  end
end
