# encoding: utf-8
class MatchesController < ApplicationController


  def index
    @matches = Match.all.reverse_order.page(params[:page])
  end

  def show
    @match = Match.find(params[:id])
  end

  def edit
    @match = Match.find(params[:id])
  end

  def update
    @match = Match.find(params[:id])

    if @match.update_attributes(match_params)
      # Handle a successful update.
      flash[:success] = "Match mis à jour"
      redirect_to @match
    else
      render 'edit'
    end
  end


  private

    def match_params
      params.require(:match).permit(:log1, :log2)
    end


end
