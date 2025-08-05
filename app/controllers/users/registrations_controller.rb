# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  class Users::RegistrationsController < Devise::RegistrationsController
    def create
      super do |resource|
        if resource.errors.any?
          flash[:alert] = resource.errors.full_messages.join(" , ")
        end
      end
    end
  end
  

  # DELETE /resource
  def destroy
    # Store the user's email for confirmation message
    user_email = resource.email
    
    # Delete user's announcements first (if any)
    if resource.respond_to?(:announcements) && resource.announcements.any?
      resource.announcements.destroy_all
    end
    
    # Delete the user account
    if resource.destroy
      # Sign out the user
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      
      # Redirect to root with success message
      redirect_to root_path, notice: "Your account has been successfully deleted."
    else
      redirect_to edit_registration_path(resource_name), notice: "Failed to delete account. Please try again."
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after account update.
  def after_update_path_for(resource)
    root_path
  end
end
