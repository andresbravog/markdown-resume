class ResumeExporter::Github
  attr_accessor :user, :repo

  def initialize(user)
    @user = user
  end

  # Validates whenever is possible to export the user resume to given github account
  #
  # @return [Boolean]
  def valid?
    return false unless user.present?
    return false unless provider_link.present?
    return false unless client.present?
    return false if repo_name_list.include?(repo_name)
    true
  end

  # Exports the user markdown resume to github.io pages
  # if possible
  #
  # @return [Hash]
  def perform
    return unless valid?
    create_repo!
  end

  protected

  # User's Github provider link
  #
  # @return [ProviderLink]
  def provider_link
    @provider_link ||= user.provider_links.where(provider: 'github').first
  end

  # User's account login
  #
  # @return [String]
  def repo_name
    "#{client.user[:login]}.github.io"
  end

  # List of the user repo names
  #
  # @return [Array(String)]
  def repo_name_list
    client.repos.map { |r| r[:name]}
  end

  # Creates the repo used by github.io
  #
  # @return [Hash]
  def create_repo!
    @repo = client.fork('markdown-resume/example.github.io')
    @repo = client.update_repository("#{client.user[:login]}/example.github.io", name: repo_name)
  end

  # Ruby github API client
  #
  # @return [Octokit::Client]
  def client
    @client ||= Octokit::Client.new(access_token: provider_link.credentials.token)
  end
end
