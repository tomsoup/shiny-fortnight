class StocksController < ApplicationController

  def search
    if params[:stock]
      #methods def in model
      @stock = Stock.find_by_ticker(params[:stock])
      #if stock we got from params is not in database
      @stock ||= Stock.new_from_lookup(params[:stock])
    end

    if @stock

      #/search_stocks?stock=GOOG from route
      # render json: @stock
      render partial: 'lookup'
    else
      render status: :not_found, nothing: true
    end
  end
end
