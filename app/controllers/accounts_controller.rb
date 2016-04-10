class AccountsController < ApplicationController
  #before_action :authenticate_user!
  before_action :is_root

  def create
    @user = User.new email: params[:user][:email], password: params[:user][:password], reset_password_token: params[:user][:reset_password_token]
    if @user.save
      flash[:notice] = "Account successfully created"
      redirect_to calendar_path
    else
      flash[:notice] = @user.errors.full_messages.join(", ").html_safe
      redirect_to new_account_path
    end
  end

  def edit
    @users = User.where(level: 1)
    if @users.length == 0
      flash.now[:notice] = "No existing accounts to destroy"
    end
  end

  def destroy
    user = User.find_by_id(params[:id])
    if user
      email = user.email
      user.destroy!
      flash[:notice] = "#{email} deleted"
    else
      flash[:notice] = "Account does not exist"
    end
    redirect_to calendar_path
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
