class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

      if user.validated
        # Sign the user in and redirect to the user's show page.
        sign_in user
        redirect_back_or user
      else
        flash.now[:error] = 'Votre compte doit être validé manuellement, merci d\'écrire à g.deshors@laposte.net'
        render 'new'
      end

    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
