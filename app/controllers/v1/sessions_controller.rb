module V1
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user_from_token!

    # POST /v1/login
    def create
      @user = User.find_for_database_authentication(email: params[:username])
      return invalid_login_attempt unless @user

      if @user.valid_password?(params[:password])
        sign_in :user, @user
        render json: @user, serializer: SessionSerializer, root: nil
      else
        invalid_login_attempt
      end
    end

    def destroy
      sign_out(@user)
      render :json=> {:success=>true}
    end


    private

    def invalid_login_attempt
      warden.custom_failure!
      render json: {error: t('sessions_controller.invalid_login_attempt')}, status: :unprocessable_entity
    end

  end
end
