class AccountsController < ApplicationController
  #before_action :authenticate_user!
  before_action :is_root
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "#{@user[:email]} successfully created!"
      redirect_to calendar_path
    else
      flash[:notice] = @user.errors.full_messages.join(", ").html_safe
      redirect_to new_account_path
    end
  end

  def edit
    @users = User.all
    if @users.length == 0
      flash.now[:notice] = "No existing accounts to destroy"
    end
  end
  
  def update
    @user = User.find_by_id(params[:id])
    @user.level ? @user.update_attribute(:level, false) : @user.update_attribute(:level, true)
    @user.save!
    flash[:notice] = "#{@user.email} updated"
    redirect_to edit_account_path
  end

  def destroy
    @user = User.find_by_id(params[:id])
    if @user
      @email = @user.email
      @user.destroy!
      flash[:notice] = "#{@email} deleted"
    else
      flash[:notice] = "Account does not exist"
    end
    redirect_to calendar_path
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :level, :reset_password_token)
  end
  
  def is_root
    #if current_user.respond_to?('root?'); puts current_user.root?; end
    if not current_user.respond_to?('root?') or not current_user.root?
      flash[:notice] = "You must be root admin to access this action"
      redirect_to calendar_path
    end
  end
end
