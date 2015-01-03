# encoding: utf-8
class GamesController < ApplicationController

  def show
    @game = Game.find(params[:id])
  end

  def viewlog
    @game = Game.find(params[:id])
    @userAC = @game.ai_1.user
    @userBD = @game.ai_2.user
    case params[:log]
      when 'server' ; render text: @game.log_server, content_type: "text/plain"
      when 'game' ; render text: @game.gamelog, content_type: "text/plain"
      when 'client_A' ; 
        if current_user?(@userAC) or current_user.admin? 
          render text: @game.log_a, content_type: "text/plain"
        else
          redirect_to @game
        end
      when 'client_B' ; 
        if current_user?(@userBD) or current_user.admin? 
          render text: @game.log_b, content_type: "text/plain"
        else
          redirect_to @game
        end
      when 'client_C' ; 
        if current_user?(@userAC) or current_user.admin? 
          render text: @game.log_c, content_type: "text/plain"
        else
          redirect_to @game
        end
      when 'client_D' ; 
        if current_user?(@userBD) or current_user.admin? 
          render text: @game.log_d, content_type: "text/plain"
        else
          redirect_to @game
        end
      else redirect_to @game
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])

    if @game.update_attributes(game_params)
      # Handle a successful update.
      flash[:success] = "Partie mise à jour"
      redirect_to @game
    else
      render 'edit'
    end
  end

  def live
    @game = Game.find(params[:id])
    render 'live'
  end

  private

    def game_params
      params.require(:game).permit(:gamelog)
    end


end
