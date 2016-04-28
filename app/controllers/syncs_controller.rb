class SyncsController < ApplicationController
  #before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :is_root

  def show
    handle_response
  end
  
  def new
    # Provides defualt path
  end
  
  def create
    Thread.new do
      flash[:sync] = Sync.sync_calendar(params[:sync][:url])
    end
    handle_response
  end
    
  def update
    Thread.new do
      Sync.synchronize_calendars
    end
    handle_response
  end
    
  def destroy
    params[:url_list].each do |url|
      Sync.find_by_url(url).destroy
    end
    flash[:sync] = "Calendars Removed!"
    handle_response
  end
    
  def handle_response
    respond_to do |format|
      format.html { redirect_to calendar_path }
      format.json { render nothing: true }
      format.js
    end
  end
    
  private

  def event_params
    params.require(:event).permit(:name, :status, :organization, :venue_name, :st_number, :st_name, :city,
                                  :state, :country, :start, :end, :description, :how_to_find_us, :image,
                                  :street_number,  :cost, :route, :locality, :family_friendly, :free,
                                  :contact_email, :contact_first, :contact_last, :contact_phone, :zip, :url,
                                  :category)
  end
  
  def is_root
    #if current_user.respond_to?('root?'); puts current_user.root?; end
    if not current_user.respond_to?('root?') or not current_user.root?
      flash[:notice] = "You must be root admin to access this action"
      redirect_to calendar_path
    end
  end
  
end