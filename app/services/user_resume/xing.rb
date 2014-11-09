class UserResume::Xing < UserResume
  attr_accessor :resume_data

  def perform
    to_markdown
  end

  protected

  # Generates the markdown resume text based on the resume data
  #
  # @return [String]
  def to_markdown
    return unless resume_data
    response = ''
    response << markdown_header
    response << markdown_contact
    response << markdown_experience
    response << markdown_education
    response << markdown_languages
    response << markdown_interests
    response << markdown_skills
    response
  end

  def markdown_header
    response =  ''
    response << "![profile-picture](#{user_data[:photo_urls][:maxi_thumb]}) \n"
    response << "# #{user_data[:display_name]} \n"
    response << markdown_current_job
  end

  def markdown_languages
    response =  "\n\n"
    response << "## Languages \n\n"
    user_data[:languages].each do |language_key, level|
      languange_name = I18n.t("languages.#{language_key }")
      response << "  * `#{languange_name}`: #{level} \n\n"
    end
    response
  end

  def markdown_interests
    response =  "\n\n"
    response << "## Interests \n\n"
    user_data[:interests].split(', ').each do |interest|
      response << "  * `#{interest}` \n\n"
    end
    response
  end

  def markdown_contact
    response =  "\n\n"
    response << "## Contact Info \n\n"
    user_data[:business_address].each do |label, value|
      next unless value.present?
      response << " `#{label.to_s.humanize}`: #{value} \n"
    end
    response
  end

  def markdown_experience
    response =  "\n\n"
    response << "## Experience \n\n"
    user_data[:professional_experience][:companies].each do |job_data|
      response << "### #{job_data[:title]} at #{job_data[:name]} `#{job_data[:begin_date]}`"
      if job_data[:end_date]
        response << ", `#{job_data[:end_date]}`"
      else
        response << ", `now`"
      end
      response << " \n"
      response << " #{job_data[:description]} \n\n"
    end
    response
  end

  def markdown_education
    response =  "\n\n"
    response << "## Education \n\n"
    user_data[:educational_background][:schools].each do |school_data|
      response << "### #{school_data[:name]} `#{school_data[:begin_date]}`, `#{school_data[:end_date]}` \n"
      response << "  #{school_data[:subject]} - #{school_data[:notes]} \n\n"
    end
    response
  end

  def markdown_skills
    response =  "\n\n"
    response << "## Skills \n\n"
    user_data[:haves].split(', ').each do |skill|
      response << "  * `#{skill}` \n\n"
    end
    response
  end

  def markdown_current_job
    return unless user_data[:professional_experience][:primary_company]
    response = ''
    job_data = user_data[:professional_experience][:primary_company]
    response << "### #{job_data[:title]} at #{job_data[:name]} \n\n"
    response
  end

  # Gets API resume data
  #
  # @return [Hash]
  def resume_data
    @resume_data ||= XingApi::User.me(client: client)
  end

  def user_data
    resume_data[:users].first
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
