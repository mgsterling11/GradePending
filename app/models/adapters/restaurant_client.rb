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
    RESTAURANT_ID = 'camis'
    INSPECTION_RESULTS = 'violation_description'
    INSPECTION_DATE = 'inspection_date'
    BORO = 'boro'
    RESTAURANT_NAME = 'dba'
    CUISINE_DESCRIPTION = 'cuisine_description'
    BUILDING_NUMBER = 'building' 
    PHONE_NUM = 'phone'
    STREET_NAME = 'street'
    VIOLATION_CODE = 'violation_code'
    ZIPCODE = 'zipcode'
    GRADE = 'grade' 


    def connection
      @connection = Adapters::DataConnection.new
    end

    def build_restaurant(search)
      url = Search.for(search.upcase)
      restaurant_data = connection.query(url)
      sorted_restaurants = restaurant_sorter(restaurant_data)
      restaurant_objects = build_restaurant_object(sorted_restaurants)
    end
  
    def restaurant_sorter(restaurant_data)
      sorted_camis = restaurant_data.map {|restaurant| restaurant[RESTAURANT_ID] }.sort.uniq    

      sorted_restaurants = sorted_camis.map do |id|
        restaurant_data.select do |restaurant|
          restaurant if restaurant[RESTAURANT_ID] == id
        end
      end
      sorted_restaurants
    end

    def build_restaurant_object(sorted_restaurants)
      restaurant_objects = sorted_restaurants.map do |restaurant|
        inspection_date = inspection_date(restaurant)
        inspection_results = inspection_results(restaurant, INSPECTION_RESULTS)
        boro = get_single_value(restaurant, BORO)
        building = get_single_value(restaurant, BUILDING)                                         
        cuisine_description = get_values(restaurant, CUISINE_DESCRIPTION)                                               
        restaurant_name = get_single_value(restaurant, RESTAURANT_NAME)                                               
        phone_num = get_single_value(restaurant, PHONE_NUM)
        formatted_phone_number = format_phone_number(phone_num)
        street = get_street(restaurant)                                               
        violation_codes = violation_codes(restaurant, VIOLATION_CODE)        
        zipcode = get_single_value(restaurant, ZIPCODE)                                               
        grade = get_values(restaurant, GRADE)
        Restaurant.new(boro, building, grade, cuisine_description, restaurant_name, inspection_date, formatted_phone_number, street, violation_codes, inspection_results, zipcode)
      end
      restaurant_objects
    end


    def get_values(restaurant, key)
      restaurant.map {|r| r[key] }.compact.uniq
    end

    def get_single_value(restaurant, key)
      restaurant.first[key].strip
    end


##### SORTS INSPECTION HASHES BY DATE              
    def inspection_date(restaurant)
      inspection_dates = restaurant.map { |inspection| Time.parse(inspection["inspection_date"]) }
      inspection_dates.compact.uniq.sort { |a,b| b <=> a }    
    end

## GRABS VIOLATION DESCRIPTIONS                             
    # def inspection_results(restaurant)
    #   restaurant.map { |r| r['violation_description'] }.compact.uniq
    # end

#### GRABS boro                                              
    # def boro(restaurant)
    #   restaurant.first['boro']
    # end

#### GRABS building                                          
    # def building(restaurant)                                               
    #   restaurant.first['building'].strip
    # end

#### GRABS CUISINE DESCRIPTION
    # def cuisine_description(restaurant)                                               
    #   restaurant.first['cuisine_description'].strip
    # end

##### GRABS dba                                             
    # def restaurant_name(restaurant)                                               
    #   restaurant.first['dba'].strip
    # end

#### GRABS PHONE                                            
    def phone_num(restaurant)    
      restaurant.first['phone'].strip
    end
      
    def format_phone_number(phone_num)
      "(" + phone_number[0..2] + ") " + phone_number[3..5] + "-" + phone_number[6..9]
    end

#### GRABS street                                         
    def get_street(restaurant)                                               
      restaurant.first['street'].split.compact.join(' ')
    end

###### GRABS VIOLATION CODES
    # def violation_codes(restaurant)
    #   restaurant.map { |restaurant| restaurant['violation_code'] }.compact.uniq
    # end

#### GRABS zipcode                                         
    # def zipcode(restaurant)                                               
    #   restaurant.first['zipcode'].strip
    # end

#### GRABS restaurant grade                                        
    # def grade(restaurant)                                               
    #   grades = restaurant.map { |result| result['grade'] }.compact.uniq.sort
    # end



  end
end
