# encoding: utf-8
class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page])
    @ykeys = []
    @labels = []
    Ai.all.each do |ai|
     @ykeys.push(ai.id.to_s) 
     @labels.push(ai.name)
    end

  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @ais = @user.ais
    #@ai = @user.ais.first
    #@matches = Match.where("ai_1_id = ? OR ai_2_id = ?", @ai.id, @ai.id).order(:id).reverse_order.page(params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Bienvenue dans Tok IA !"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profil mis à jour"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Merci de vous connecter." unless signed_in?
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
