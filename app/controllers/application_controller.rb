class ApplicationController < ActionController::API
  private

  def current_user
    User.find_by(id: params[:current_user_id])
  end
end
