class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end
  def create
    @title = "Sign in"
    render 'new'
  end
  def destroy
    
    
  end
end
