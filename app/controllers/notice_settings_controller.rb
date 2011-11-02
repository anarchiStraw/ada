class NoticeSettingsController < ApplicationController
  # GET /notice_settings
  # GET /notice_settings.json
  def index
    @notice_settings = NoticeSetting.all
    @calendars = session[:calendars]
    @rooms = session[:rooms]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notice_settings }
    end
  end

  # GET /notice_settings/1
  # GET /notice_settings/1.json
  def show
    @notice_setting = NoticeSetting.find(params[:id])
    @calendars = session[:calendars]
    @rooms = session[:rooms]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notice_setting }
    end
  end

  # GET /notice_settings/new
  # GET /notice_settings/new.json
  def new
    prepare_external_data
    @calendars = session[:calendars]
    @rooms = session[:rooms]
    
    @notice_setting = NoticeSetting.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @notice_setting }
    end
  end

  # GET /notice_settings/1/edit
  def edit
    prepare_external_data
    @calendars = session[:calendars]
    @rooms = session[:rooms]
    @notice_setting = NoticeSetting.find(params[:id])
  end

  # POST /notice_settings
  # POST /notice_settings.json
  def create
    @notice_setting = NoticeSetting.new()
    @notice_setting[:youroom_user_id] = session[:youroom_user].id
    @notice_setting[:room_number] = params[:room_number]
    @notice_setting[:room_name] = session[:rooms].key params[:room_number]
    @notice_setting[:google_account_id], @notice_setting[:google_calendar_id] = params[:google_account_and_calendar_id].split(" ")
    @notice_setting[:google_calendar_name] = session[:calendars].key params[:google_calendar_id]
    @notice_setting[:days_before] = params[:notice_setting][:days_before]
    @notice_setting[:additional_message] = params[:notice_setting][:additional_message]
    debugger
    respond_to do |format|
      if @notice_setting.save
        format.html { redirect_to @notice_setting, notice: 'Notice setting was successfully created.' }
        format.json { render json: @notice_setting, status: :created, location: @notice_setting }
      else
        format.html { render action: "new" }
        format.json { render json: @notice_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notice_settings/1
  # PUT /notice_settings/1.json
  def update
    @notice_setting = NoticeSetting.find(params[:id])

    respond_to do |format|
      if @notice_setting.update_attributes(params[:notice_setting])
        format.html { redirect_to @notice_setting, notice: 'Notice setting was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @notice_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notice_settings/1
  # DELETE /notice_settings/1.json
  def destroy
    @notice_setting = NoticeSetting.find(params[:id])
    @notice_setting.destroy

    respond_to do |format|
      format.html { redirect_to notice_settings_url }
      format.json { head :ok }
    end
  end
  
  private
  def prepare_external_data
    calendars = []
    @google_accounts = GoogleAccount.find_all_by_youroom_user_id(session[:youroom_user].id)
    @google_accounts.each{|account|
      account.load_google_data
      account.calendars.each {|calendar|
        calendars.concat [[calendar.title, calendar.event_feed_link]]
      }
    }
    debugger
    
    res = access_token_as_youroom_user.get("#{Youroom.my_groups_url}.json")
    rooms = JSON.parse(res.body).map {|item|
      [item["group"]["name"], item["group"]["id"]]
    }
    
    session[:calendars] = Hash[*calendars.flatten]
    session[:rooms] = Hash[*rooms.flatten]
  end

end
