class HomeController < ApplicationController
  before_action :current_user

  def index
    # home
    render action: :index
  end

  def markdown_preview
    # markdown preview
    content = UserResume.new(@current_user).perform
    @markdown_content = GitHub::Markdown.render_gfm(content).html_safe
    render action: :markdown_preview, format: 'html', layout: 'github_markdown'
  end
end
