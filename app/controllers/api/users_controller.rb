class Api::UsersController < ApplicationController
    def create
        user = User.new(user_params)
        user.currency_package_ids = [*1..12]
        if user.save
          render json: user
        else
          render json: user.errors, status: :bad_request
        end
    end
    
    def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: user
        else
          render json: user.erorrs, status: :bad_request
        end
    end
    
    def me
        render json: current_user
    end
    
    private
    
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
