# encoding: utf-8
class GamesController < ApplicationController

  def show
    @game = Game.find(params[:id])
  end

  def viewlog
    @game = Game.find(params[:id])
    case params[:log]
      when 'server' ; render text: @game.log_server, content_type: "text/plain"
      when 'game' ; render text: @game.gamelog, content_type: "text/plain"
      when 'client_A' ; render text: @game.log_a, content_type: "text/plain"
      when 'client_B' ; render text: @game.log_b, content_type: "text/plain"
      when 'client_C' ; render text: @game.log_c, content_type: "text/plain"
      when 'client_D' ; render text: @game.log_d, content_type: "text/plain"
      else render status: 404
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


  private

    def game_params
      params.require(:game).permit(:gamelog)
    end


end
