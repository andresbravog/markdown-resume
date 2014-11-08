class UserResume
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  # Returns the resume data retrieved from the API
  #
  # @return [Hash]
  def perform
    case user.provider
    when 'xing'
      UserResume::Xing.new(user).perform
    when 'linkedin'
      UserResume::Linkedin.new(user).perform
    end
  end
end
