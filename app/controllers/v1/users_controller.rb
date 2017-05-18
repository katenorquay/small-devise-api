module V1
  class UsersController < ApplicationController
    skip_before_action :authenticate_user_from_token!, only: [:create]

    # POST /v1/users
    # Creates an user
    def create
      @user = User.new user_params

      if @user.save
        render json: @user, serializer: V1::SessionSerializer, root: nil
      else
        render json: { error: t('user_create_error') }, status: :unprocessable_entity
      end
    end

    def update
      @user = User.find_by_email(user_params[:email])
      if @user.update_attributes(user_params)
        render :json=> @user.as_json(:email=> @user.email), :status=>201
        return
      else
        warden.custom_failure!
        render :json=> @user.errors, :status=>422
      end
    end

    def destroy
      @user = User.find_by_email(user_params[:email])
      if @user.destroy
        render :json=> {success: 'user was successfully deleted'}, :status=>201
      else
        render :json=>{error: 'user could not be deleted'}, :status=>422
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation, :current_password)
    end
  end
end
