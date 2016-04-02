class SyncsController < ApplicationController
  #before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  
  def check_calendar_type
    if params[:url].include? "calendar.google.com"
        return "google"
    elsif params[:url].include? "meetup.com"
        return "meetup"
    else
        return "NA"
    end
  end

  def show
    handle_response
  end
  
  def new
    # Provides defualt path
  end
  
  def create
    perform_create_transaction
    flash[:notice] = @msg
    handle_response
  end
    
  def perform_create_transaction
    begin
      @sync = Sync.new(sync_params)
      if is_google
      elsif is_meetup
      end
      @sync.update_attributes(organization: org)
      @sync.save!
      @success = true
      @msg = "Successfully synced '#{@sync.url}'!"
    rescue Exception => e
      @msg = "Could not sync '#{@sync.url}':" + '\n' + e.to_s
    end
  end
    
  def update
      handle_response
  end
    
  def destroy
  end
    
  def handle_response
    respond_to do |format|
      format.html { redirect_to calendar_path }
      format.json { render nothing: true }
      format.js
    end
  end
    
  private

  def sync_params
    params.require(:sync).permit(:organization, :url, :last_sync, :calendar_id)
  end
end