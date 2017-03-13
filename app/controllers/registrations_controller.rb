# class RegistrationsController <  DeviseController
#
#   prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]
#   prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy]
#   prepend_before_action :set_minimum_password_length, only: [:new, :edit]
#
#   # GET /resource/sign_up
#   def new
#     build_resource({})
#     yield resource if block_given?
#     respond_with resource
#   end
#
# end