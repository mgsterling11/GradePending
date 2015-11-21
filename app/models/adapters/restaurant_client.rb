require 'json'
require 'time'
require 'date'
require 'pry'
require 'rest-client'




############## item || NoItem.new <-- make new empty class object 
### or do if not nil!
# next if row.empty 






module Adapters
  class RestaurantClient

    def connection
      @connection = Adapters::DataConnection.new
    end

    def build_restaurant(search)
      url = Search.for(search.upcase)
      restaurant_data = connection.query(url)
      sorted_restaurants = restaurant_sorter(restaurant_data)
      restaurant_objects = build_restaurant_object(sorted_restaurants)
      restaurant_objects
    end
  
    def restaurant_sorter(restaurant_data)
      sorted_camis = restaurant_data.map {|restaurant| restaurant['camis'] }.sort!.uniq!    

      sorted_restaurants = sorted_camis.map do |id|
        restaurant_data.select do |restaurant|
          restaurant if restaurant['camis'] == id
        end
      end
      sorted_restaurants
    end

    def build_restaurant_object(sorted_restaurants)
      restaurant_objects = sorted_restaurants.map do |restaurant|
        inspection_date = inspection_date(restaurant)
        inspection_results = inspection_results(restaurant)
        boro = boro(restaurant)
        building = building(restaurant)                                               
        cuisine_description = cuisine_description(restaurant)                                               
        restaurant_name = restaurant_name(restaurant)                                               
        phone_num = phone_num(restaurant)    
        street = street(restaurant)                                               
        violation_codes = violation_codes(restaurant) 
        zipcode = zipcode(restaurant)                                               
        grade = grade(restaurant)
        Restaurant.new(boro, building, grade, cuisine_description, restaurant_name, inspection_date, phone_num, street, violation_codes, inspection_results, zipcode)
      end
      restaurant_objects
    end


#     def after_initialize
#   if new_record?
#     max_users ||= 10
#   end
# end


##### SORTS INSPECTION HASHES BY DATE              
    def inspection_date(restaurant)
      inspection_dates = restaurant.map { |inspection| Time.parse(inspection["inspection_date"]) }
      inspection_dates.compact!
      inspection_dates.uniq!.sort! { |a,b| b <=> a }

      dates = inspection_dates.map { |result| result }
      dates
    end

## GRABS VIOLATION DESCRIPTIONS                             
    def inspection_results(restaurant)
      restaurant_violations = restaurant.map { |restaurant| restaurant['violation_description'] }
      restaurant_violations.compact!
      restaurant_violations.uniq!

      results = restaurant_violations.map { |result| result }
      results
    end

#### GRABS boro                                              
    def boro(restaurant)
      restaurant.first['boro']
    end

#### GRABS building                                          
    def building(restaurant)                                               
      restaurant.first['building'].strip
    end

#### GRABS CUISINE DESCRIPTION
    def cuisine_description(restaurant)                                               
      restaurant.first['cuisine_description'].strip
    end

##### GRABS dba                                             
    def restaurant_name(restaurant)                                               
      restaurant.first['dba'].strip
    end

#### GRABS PHONE                                            
    def phone_num(restaurant)    
      number = restaurant.first['phone'].strip
      formatted_number = "(" + number[0..2] + ") " + number[3..5] + "-" + number[6..9]
    end

#### GRABS street                                         
    def street(restaurant)                                               
      restaurant.first['street'].gsub('  ','').strip
    end

###### GRABS VIOLATION CODES
    def violation_codes(restaurant)
      violation_codes = restaurant.map { |restaurant| restaurant['violation_code'] }
      violation_codes.compact
      violation_codes.uniq!

      codes = violation_codes.map { |result| result }
      codes
    end

#### GRABS zipcode                                         
    def zipcode(restaurant)                                               
      restaurant.first['zipcode'].strip
    end

#### GRABS restaurant grade                                        
    def grade(restaurant)                                               
      grades = restaurant.map { |result| result['grade'] }
      grades.compact!
      grades.uniq!
      grades.sort!

      inspection_grades = grades.map { |grade| grade }
      inspection_grades
    end

  end
end
