class ToppagesController < ApplicationController
  def index
    if logged_in?
      @user = current_user
      @micropost = current_user.microposts.build
      @microposts = current_user.feed_microposts.order("created_at DESC")
      counts(@user)
      @ranking = Micropost.find(Favorite.group(:micropost_id).order('count(micropost_id) desc').limit(3).pluck(:micropost_id))
    end
  end
end