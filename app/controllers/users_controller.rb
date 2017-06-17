class UsersController < ApplicationController
  before_action :require_user_logged_in, only:[:index,:show]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザを登録しました。"
      redirect_to @user
    else
      flash[:danger] = "ユーザの登録に失敗しました。"
      render :new
    end
  end
  
  def edit
    @user = User.find(session[:user_id])
  end
  
  def update
    @user = User.find(session[:user_id])
    
    if @user.update(user_update_params)
      flash[:success] = "プロフィールを更新しました。"
      redirect_to @user
    else 
      flash[:danger] = "プロフィールの更新に失敗しました。"
      render :edit
    end
  end
  
  def destroy
    @user = User.find(session[:user_id])
    @user.destroy
    flash[:success] = "アカウント削除しました"
    redirect_to "/"
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :nickname)
  end
  
  def user_update_params
    params.require(:user).permit(:name, :email, :nickname)
  end
  
end
