class SessionsController < ApplicationController
  
  def menu
p('SessionsController.menu called -------------------')
    @msg = flash[:msg]
    @youroom_user ||= session[:youroom_user]
    if (@youroom_user)
      @notice_settings = NoticeSetting.find_all_by_youroom_user_id(@youroom_user.id)
      @google_accounts = GoogleAccount.find_all_by_youroom_user_id(@youroom_user.id)
    end
    
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
