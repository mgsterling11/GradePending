class SearchController < ApplicationController
  
  def show
    @result = Adapters::RestaurantClient.new.build_restaurant(params['keyword'])
    @yelp = Adapters::YelpClient.new.find_yelp_results(params['keyword'])
    binding.pry

      if @result.length == 1
        render "/restaurants/show"
      else 
        render "/restaurants/index"
      end
      
  end

end

