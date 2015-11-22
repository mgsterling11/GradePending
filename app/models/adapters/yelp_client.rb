require 'yelp'


module Adapters
  class YelpClient

    def find_yelp_results(search_term)

    client = Yelp::Client.new({ consumer_key: "JisEPO_oFlz09HHq24cEyA",
                                consumer_secret: "5YkmNo1pPbCI-5P8czzJfOW_ZTA",
                                token: "zqBhyzlPIBbiHbFl8hiPpgW5QWwS4wfc",
                                token_secret: "EjPeXcCMs0cKqWXce5DN550tEJM"
                              })

    params = { term: "#{search_term}",
               category_filter: 'restaurants',
               limit: 1
             }


    client.search('New York City', params)    
    end
  end 
end