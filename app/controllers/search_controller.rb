class SearchController < ApplicationController
  
  def show
    @result = Adapters::RestaurantClient.new.build_restaurant(params['keyword'])

      if @result.length == 1
        render "/restaurants/show"
      else 
        render "/restaurants/index"
      end
      
  end

end

