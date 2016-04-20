class SyncsController < ApplicationController
  #before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  
  def calendar_pull(url)
    @name = url.split("/")[-1]
    if url =~ /meetup.com/
      begin
        Meetup.new.pull_events({group_urlname: @name})
      rescue Exception => e
        @msg = " Unable to pull Meetup events: " + e.to_s
        puts @msg
      end
    elsif url =~ /google/
      @name
    else
      raise Exception, 'Invalid URL', caller
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
      events = calendar_pull(params[:sync][:url])
      if events.respond_to?(:each)
        events.each do |event|
          Event.new(event)
        end
      end
      @sync.update_attributes(:organization => @name.gsub("-", " "), :last_sync => DateTime.now())
      @sync.save!
      @msg = "Successfully synced '#{@sync.url}'!"
    rescue Exception => e
      @msg = "Could not sync '#{@sync.url}': " + e.to_s
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