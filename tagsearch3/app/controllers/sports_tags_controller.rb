class SportsTagsController < ApplicationController
  def index
    @products = SportsTag.search(params[:search])
    @hits = @products[0]
    @search_word = @products[1]
    @kinji_value = @products[2] 
  end
end
