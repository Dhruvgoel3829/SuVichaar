=begin

class AnnouncementsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_announcement, only: %i[ show edit update destroy ]

  # GET /announcements or /announcements.json
  def index
    @announcements = Announcement.all

    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @announcements = @announcements.joins(:user)
                                   .where("LOWER(announcements.title) LIKE ? OR LOWER(users.username) LIKE ?", search_term, search_term)
                                   .distinct
    end
  end

  # GET /announcements/1 or /announcements/1.json
  def show
  end

  # GET /announcements/new
  def new
    @announcement = Announcement.new
  end

  # GET /announcements/1/edit
  def edit
  end

  # POST /announcements or /announcements.json
  def create
    user_tz = params[:announcement][:timezone].presence || "UTC"
    Rails.logger.info "User timezone param: #{user_tz}"

    # Map problematic timezones to valid IANA names
    case user_tz
    when "Japan" then user_tz = "Asia/Tokyo"
    when "US" then user_tz = "America/New_York"
    when "UK" then user_tz = "Europe/London"
    when "France" then user_tz = "Europe/Paris"
    when "Germany" then user_tz = "Europe/Berlin"
    when "Russia" then user_tz = "Europe/Moscow"
    when "China" then user_tz = "Asia/Shanghai"
    when "Singapore" then user_tz = "Asia/Singapore"
    when "Hong Kong" then user_tz = "Asia/Hong_Kong"
    when "Thailand" then user_tz = "Asia/Bangkok"
    when "South Korea" then user_tz = "Asia/Seoul"
    when "Asia/Calcutta" then user_tz = "Asia/Kolkata"
    when "Australia" then user_tz = "Australia/Sydney"
    end

    @announcement = Announcement.new(announcement_params)
    @announcement.posted_on = Time.current.in_time_zone(user_tz)
    @announcement.user_id = current_user.id if @announcement.user_id.blank?

    if @announcement.save
      redirect_to @announcement, notice: "Announcement was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /announcements/1 or /announcements/1.json
  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to @announcement, notice: "Announcement was successfully updated." }
        format.json { render :show, status: :ok, location: @announcement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /announcements/1 or /announcements/1.json
  def destroy
    @announcement.destroy!

    respond_to do |format|
      format.html { redirect_to announcements_path, status: :see_other, notice: "Announcement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement = Announcement.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def announcement_params
      params.require(:announcement).permit(:title, :content, :created_by, :timezone, :user_id)
    end
end
=end

class AnnouncementsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_announcement, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  # GET /announcements or /announcements.json
  def index
    @announcements = Announcement.all

    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @announcements = @announcements.joins(:user)
                                     .where("LOWER(announcements.title) LIKE ? OR LOWER(users.username) LIKE ?", search_term, search_term)
                                     .distinct
    end
  end

  # GET /announcements/1
  def show
  end

  # GET /announcements/new
  def new
    @announcement = Announcement.new
  end

  # GET /announcements/1/edit
  def edit
  end

  # POST /announcements
  def create
    user_tz = map_timezone(params[:announcement][:timezone])
    Rails.logger.info "User timezone param: #{user_tz}"

    @announcement = current_user.announcements.build(announcement_params)
    @announcement.posted_on = Time.current.in_time_zone(user_tz)

    if @announcement.save
      redirect_to @announcement, notice: "Announcement was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /announcements/1
  def update
    if @announcement.update(announcement_params)
      redirect_to @announcement, notice: "Announcement was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /announcements/1
  def destroy
    @announcement.destroy!
    redirect_to announcements_path, notice: "Announcement was successfully destroyed.", status: :see_other
  end

  private

  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  def authorize_user!
    # unless @announcement.user == current_user
    #  redirect_to announcements_path, alert: "You are not authorized to do that."
    # end

    return if current_user.admin? || @announcement.user == current_user

    redirect_to announcements_path, alert: "You are not authorized to perform this action."
  end

  def announcement_params
    params.require(:announcement).permit(:title, :content, :created_by, :timezone)
  end

  def map_timezone(tz)
    return "UTC" if tz.blank?

    {
      "Japan"         => "Asia/Tokyo",
      "US"            => "America/New_York",
      "UK"            => "Europe/London",
      "France"        => "Europe/Paris",
      "Germany"       => "Europe/Berlin",
      "Russia"        => "Europe/Moscow",
      "China"         => "Asia/Shanghai",
      "Singapore"     => "Asia/Singapore",
      "Hong Kong"     => "Asia/Hong_Kong",
      "Thailand"      => "Asia/Bangkok",
      "South Korea"   => "Asia/Seoul",
      "Asia/Calcutta" => "Asia/Kolkata",
      "Australia"     => "Australia/Sydney"
    }[tz] || tz # fallback: assume it's already a valid IANA timezone
  end
end
