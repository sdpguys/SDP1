class UsersController < ApplicationController
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = "Registration successful!"
        redirect_to "/home/about" # Redirect to /home/about after successful registration
      else
        flash[:alert] = "Error in registration."
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
  