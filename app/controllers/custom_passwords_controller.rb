class CustomPasswordsController < ApplicationController
  def edit
    @reset_password_token = params[:id]
  end
end

