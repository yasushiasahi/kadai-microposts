module SessionsHelper
    
  def current_user
    @current_user ||=User.find_by(id: session[:user_id])
# =>  上記は以下の式を短く書いたもの
#     if @current_user
#       return @current_user
#     else
#       @current_user = User.find_by(id: session[:user_id])
#       return @current_user
  end
      
  def logged_in?
    !!current_user
# =>  上記は以下の式を短く書いたもの
#   if current_user
#     return true
#   else
#     return false
#   end
    
  end
end
