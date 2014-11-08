class HomeController < ApplicationController
  before_action :current_user

  def index
    # home
    render action: :index, format: 'html'
  end
end
