# encoding: utf-8
class GamesController < ApplicationController

  def show
    @game = Game.find(params[:id])
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
