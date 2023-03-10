class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @user = current_user
    @sport_events = @user.sport_events
    @requests = @user.requests
  end

  def profile
    @user = User.find(params[:user_id])
    @sport_events = @user.sport_events

  end
end
