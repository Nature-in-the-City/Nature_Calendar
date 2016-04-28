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
    thread = Thread.new { Thread.current[:output] = Sync.sync_calendar(params[:sync][:url]) }
    thread.join
    flash[:sync] = thread[:output]
    handle_response
  end
    
  def update
    Thread.new do
      Sync.synchronize_calendars
    end
    flash[:sync] = "Calendars Synced!"
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
  
  def is_root
    #if current_user.respond_to?('root?'); puts current_user.root?; end
    if not current_user.respond_to?('root?') or not current_user.root?
      flash[:notice] = "You must be root admin to access this action"
      redirect_to calendar_path
    end
  end
  
end