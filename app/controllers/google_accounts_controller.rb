#coding:utf-8
class GoogleAccountsController < ApplicationController

  # DELETE /google_accounts/1
  # DELETE /google_accounts/1.json
  def destroy
    settings = NoticeSetting.find_all_by_youroom_user_id_and_google_account_id(session[:youroom_user].id, params[:id])
    settings.each {|setting|
      setting.destroy
    }
    google_account = GoogleAccount.find(params[:id])
    google_account.destroy
    flash[:msg] = "Googleアカウントを削除しました。"
    respond_to do |format|
      format.html { redirect_to url_for(:controller => 'sessions', :action=> 'menu') and return }
      format.json { head :ok }
    end
  end
end
