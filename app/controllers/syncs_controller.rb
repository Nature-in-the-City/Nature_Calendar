class SyncsController < ApplicationController
  #before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :is_root
  
  
  
  def calendar_pull
    @name = @url.split("/")[-1]
    if @url =~ /meetup.com/
      begin
        @events = Meetup.new.pull_events({group_urlname: @name})
      rescue Exception => e
        @msg = " Unable to pull Meetup events: " + e.to_s
        puts @msg
      end
    elsif @url =~ /google/
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
    flash[:sync] = @msg
    handle_response
  end
    
  def perform_create_transaction
    @url = params[:sync][:url]
    if Sync.where(:url => @url).blank?
      begin
        @sync = Sync.new(sync_params)
        calendar_pull
        if @events.respond_to?(:each)
          @events.each do |event|
            @e = Event.new(event)
            @e.update_attributes(:status => 'pending', :url => @url)
            @e.save!
          end
        end
        @sync.update_attributes(:organization => @name.gsub("-", " "), :last_sync => DateTime.now())
        @sync.save!
        @msg = "Successfully synced '#{@url}'!"
      rescue Exception => e
        @msg = "Could not sync '#{@url}': " + e.to_s
      end
    else
      @msg = "Already synced '#{@url}'!"
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
  
  def is_root
    #if current_user.respond_to?('root?'); puts current_user.root?; end
    if not current_user.respond_to?('root?') or not current_user.root?
      flash[:notice] = "You must be root admin to access this action"
      redirect_to calendar_path
    end
  end
  
end