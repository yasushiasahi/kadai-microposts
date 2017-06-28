class UsersController < ApplicationController
  before_action :require_user_logged_in, only:[:index,:show, :followings, :followers]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order("created_at DESC").page(params[:page])
    counts(@user)
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
    destroy_all_linked_things
    @user.destroy
    flash[:success] = "アカウント削除しました"
    redirect_to "/"
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  def favorites
    @user = User.find(params[:id])
    @adding_to_favorites = @user.adding_to_favorites.page(params[:page])
    counts(@user)
  end
  
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :nickname)
  end
  
  def user_update_params
    params.require(:user).permit(:name, :email, :nickname)
  end
  
  def destroy_linked_microopsts
    if Micropost.find_by(user_id: @user.id)
      microposts = @user.microposts
      microposts.each do |micropost|
        if Favorite.find_by(micropost_id: micropost.id)
          micropost.favorites.destroy_all
        end
        if Comment.find_by(micropost_id: micropost.id)
          micropost.comments.destroy_all
        end
      end
      @user.microposts.destroy_all
    end
  end
  
  def destroy_linked_relationships
    if Relationship.find_by(user_id: @user.id)
      @user.relationships.destroy_all
    end
  end
  
  def destroy_linked_reverses_of_relationships
    if Relationship.find_by(follow_id: @user.id)
      @user.reverses_of_relationship.destroy_all
    end
  end
  
  def destroy_linked_favorites
    if Favorite.find_by(user_id: @user.id)
      @user.favorites.destroy_all
    end
  end
  
  def destroy_linked_comments
    if Comment.find_by(user_id: @user.id)
      @user.comments.destroy_all
    end
  end
  
  def destroy_all_linked_things
    destroy_linked_microopsts
    destroy_linked_relationships
    destroy_linked_reverses_of_relationships
    destroy_linked_favorites
    destroy_linked_comments
  end
  
end
