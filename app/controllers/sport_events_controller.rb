class SportEventsController < ApplicationController
  def index
    if params[:query].present?
      @sport_events = SportEvent.where(sport: params[:query])
      # @sport_events = SportEvent.where("location ILIKE :query AND sport ILIKE :query", query: "%#{params[:query]}%")

    else
      @sport_events = SportEvent.all
      # @sport_events = SportEvent.where.not(user: current_user)
    end
  end

  def show
    @sport_event = SportEvent.find(params[:id])
    @request = Request.new
    @user_request = Request.find_by(user: current_user, sport_event: @sport_event)
    @user_ids = @sport_event.requests.where(accepted: true).pluck(:user_id)
    @users = User.where(id: @user_ids)

    # @message = Message.new
    @review = Review.new
  end

  def new
    @sport_event = SportEvent.new
  end

  def create
    @sport_event = SportEvent.new(sport_event_params)
    @sport_event.user = current_user
    if @sport_event.save
      redirect_to sport_event_path(@sport_event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @sport_event = SportEvent.find(params[:id])
  end

  def update
    @sport_event = SportEvent.find(params[:id])
    @sport_event.update(sport_event_params)
    if @sport_event.save
      redirect_to sport_event_path(@sport_event)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sport_event = SportEvent.find(params[:id])
    @sport_event.destroy
    redirect_to sport_events_path, status: :see_other
  end

  def chat
    @sport_event = SportEvent.find(params[:id])
    @messages = @sport_event.messages
    @message = Message.new
  end

  private

  def sport_event_params
    params.require(:sport_event).permit(:address, :start_at, :sport, :description, :image)
  end
end
