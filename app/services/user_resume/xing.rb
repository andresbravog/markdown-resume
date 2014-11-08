class UserResume::Xing < UserResume

  def perform
    get_resume_data
  end

  protected

  # Gets API resume data
  #
  # @return [Hash]
  def get_resume_data
    XingApi::User.me(client: client)
  end

  # Api client to retrieve the resume data
  #
  # @return [XingApi::Client]
  def client
    @client ||=  XingApi::Client.new consumer_key: ENV['XING_KEY'],
                                     consumer_secret: ENV['XING_SECRET'],
                                     oauth_token: user.credentials.token,
                                     oauth_token_secret: user.credentials.secret
  end
end
