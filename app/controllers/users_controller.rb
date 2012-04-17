class UsersController < ApplicationController
  def new
    @title = "Sign up"
  end
  
  def show
    @user = User.find(params[:id]) # is refersence in the users spec created afte factory assigns(:hosts)
    @title = @user.name
  end  
end
