class ResumeExporter::Github
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  # Exports the user markdown resume to github.io pages
  # if possible
  #
  # @return [Hash]
  def perform
    # do something
  end

  protected

  # User's Github provider link
  #
  # @return [ProviderLink]
  def provider_link
    @provider_link ||= user.provider_links.where(provider: 'github').first
  end

  # Ruby github API client
  def client
    # @client ||= 
  end
end
