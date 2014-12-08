# encoding: utf-8
include AisHelper

class AisController < ApplicationController

  #before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  #before_action :admin_user,     only: [:edit, :update, :destroy]


  def new
    @ai = Ai.new
  end

  def show
    @ai = Ai.find(params[:id])
    @user = @ai.user
    @matches = Match.where("ai_1_id = ? OR ai_2_id = ?", @ai.id, @ai.id).order(:id).reverse_order.page(params[:page])
  end

  def create
    @ai = Ai.new(ai_params)
    @user = current_user
    @ai.user = @user
    @ai.elo = 1500
    if @ai.save
      flash[:success] = "IA créée"
      unless params[:ai][:data].blank?
        dir = "/home/tokserver/clients/#{@ai.id}"
        Dir.mkdir(dir) unless Dir.exists? dir
        filename = "#{dir}/#{params[:ai][:data].original_filename}"
        open(filename, "wb") do |f|
          f.write params[:ai][:data].read
        end
        @ai.update_attributes(:filename => filename)
        
        # créer un événement !
        e = Event.new
        e.ai = @ai
        e.version = @ai.version
        e.commentaire = "Création"
        e.save
      end
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    
  end

  def update
    if @ai.update_attributes(ai_params)
      unless params[:ai][:data].blank?
        dir = "/home/tokserver/clients/#{@ai.id}"
        Dir.mkdir(dir) unless Dir.exists? dir
        filename = "#{dir}/#{params[:ai][:data].original_filename}"
        open(filename, "wb") do |f|
          f.write params[:ai][:data].read
        end
        @ai.update_attributes(:filename => filename)
        
        # créer un événement !
        e = Event.new
        e.ai = @ai
        e.version = @ai.version
        e.commentaire = params[:event_comment]
        e.save
      end

      #flash[:success] = command_line_for(@ai)
      @ai.update_attributes(:command_line => command_line_for(@ai))


      # Handle a successful update.
      flash[:success] = "IA mise à jour ! Ligne de commande de l'ia : '#{@ai.command_line}'"
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

    def ai_params
      params.require(:ai).permit(:name, :active, :version,
                                   :language, :firstparam)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Merci de vous connecter." unless signed_in?
      end
    end

    def correct_user
      @ai = Ai.find(params[:id])
      @user = @ai.user
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
