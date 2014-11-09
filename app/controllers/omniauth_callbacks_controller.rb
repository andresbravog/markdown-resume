class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authenticate_user!, only: [:github]

  # GET /users/auth/linkedin/callback
  def linkedin
    sing_up_or_login('linkedin')
  end

  # GET /users/auth/xing/callback
  def xing
    sing_up_or_login('xing')
  end

  # GET /users/auth/github/callback
  def github
    find_or_create_provider_link('github')
    ResumeExporter::Github.new(current_user).perform
  end

  protected

  # Finds or creates user in the system based on the omniauth provider info
  # and creates also the session for that user
  #
  # @param provider [String] provider name to store the session data
  def sing_up_or_login(provider='omniauth')
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end

  # Finds existing provider link to this user or creates a new link
  #
  # @param provider [String] provider name to store the session data
  def find_or_create_provider_link(provider='omniauth')
    @provider_link = ProviderLink.from_omniauth(request.env["omniauth.auth"], current_user)

    if @provider_link.persisted?
      redirect_to root_path
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end
end
