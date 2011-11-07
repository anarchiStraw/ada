#coding:utf-8
class NoticeSettingsController < ApplicationController

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
    refresh_external_data

    if @google_accounts.nil? || @google_accounts.size == 0
      flash[:msg] = "先にGoogleアカウントを追加してください。"
      redirect_to url_for(:controller => 'sessions', :action=> 'menu') and return
    end

    @calendars = session[:calendars]
    @rooms = session[:rooms]
    
    @notice_setting = NoticeSetting.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @notice_setting }
    end
  end
  
  def confirm
    @notice_setting = NoticeSetting.new()
    @notice_setting[:youroom_user_id] = session[:youroom_user].id
    @notice_setting[:room_number] = params[:notice_setting][:room_number]
    @notice_setting[:room_name] = session[:rooms].key @notice_setting[:room_number]
    @notice_setting[:google_account_id], @notice_setting[:google_calendar_id] = params[:google_account_and_calendar_id].split(" ")
    @notice_setting[:google_calendar_name] = session[:calendars].key @notice_setting[:google_calendar_id]
    @notice_setting[:days_before] = params[:notice_setting][:days_before]
    @notice_setting[:additional_message] = params[:notice_setting][:additional_message]
    session[:new_notice_setting] = @notice_setting
    
    if @notice_setting.valid?  
      warnings = ["明日から3日間に、以下の内容が通知される予定です。"]
      @sample_posts = Notice.test(@notice_setting)
      case @sample_posts.size
      when 0
        warnings << 'イベントが見つかりません。よろしいですか?'
      when 1..3
      else
        warnings << 'イベントが沢山あります。よろしいですか?'
      end
      @notice_setting.warnings = warnings
      @google_account_name = GoogleAccount.find(@notice_setting.google_account_id).display_name
      render :action => 'confirm'  
    else
      @calendars = session[:calendars]
      @rooms = session[:rooms]
      @google_accounts = session[:google_accounts]
      render :action => 'new'
    end
  end

  # POST /notice_settings
  # POST /notice_settings.json
  def create
    @notice_setting = session[:new_notice_setting]
    respond_to do |format|
      if @notice_setting.save
        session[:new_notice_setting] = nil
        flash[:msg] = "通知設定を追加しました。"
        redirect_to url_for(:controller => 'sessions', :action=> 'menu')
        return
#        format.json { render json: @notice_setting, status: :created, location: @notice_setting }
      else
        format.html { render action: "new" }
        format.json { render json: @notice_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notice_settings/1
  # DELETE /notice_settings/1.json
  def destroy
    @notice_setting = NoticeSetting.find(params[:id])
    @notice_setting.destroy
    flash[:msg] = "通知設定を削除しました。"
    redirect_to url_for(:controller => 'sessions', :action=> 'menu')
    return

#    respond_to do |format|
#      format.html { redirect_to "sessions/menu" } and return
#      format.json { head :ok }
#    end
  end

end
