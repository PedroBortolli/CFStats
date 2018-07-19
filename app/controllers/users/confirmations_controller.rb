# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create

    if params[:user][:email] == ""
      flash[:notice] = "Email cant be blank."
      flash[:success] = ""
      redirect_to request.referrer
    else
      @user = User.where(:email => params[:user][:email]).first
      if @user
        if @user.confirmed_at.nil?
          @user.send_confirmation_instructions.deliver
          flash[:success] = "You will soon receive an email with instructions on how to confirm your email address. Check your spam if you can't find it."
          flash[:notice] = ""
          redirect_to "/users/sign_in"
        else
          flash[:notice] = "This email has already been confirmed. Try logging in."
          flash[:success] = ""
          redirect_to request.referrer
        end
      else
        flash[:notice] = "This email isn't registered."
        flash[:success] = ""
        redirect_to request.referrer
      end
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        set_flash_message(:success, :confirmed) if is_flashing_format?
        respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
      else
        respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
      end
    end


  protected

  # The path used after resending confirmation instructions.
    def after_resending_confirmation_instructions_path_for(resource_name)
      set_flash_message(:success, :send_instructions) if is_flashing_format?
      flash[:notice] = ""
      super(resource_name)
    end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
