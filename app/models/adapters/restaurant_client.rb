require 'json'
require 'time'
require 'date'
require 'pry'
require 'rest-client'

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


    def build_restaurant(search)
      restaurant_data = JSON.load(Search.for(search.upcase))
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
        inspection_dates = inspection_date(restaurant)
        inspection_results = sort_inspections_by_date(restaurant, inspection_dates)
        grade = sort_restaurant_grades(restaurant, inspection_dates)
        boro = get_single_value(restaurant, BORO)
        building = get_single_value(restaurant, BUILDING_NUMBER)                                         
        cuisine_description = get_values(restaurant, CUISINE_DESCRIPTION)                                               
        restaurant_name = get_single_value(restaurant, RESTAURANT_NAME)                                               
        phone_num = format_phone_number(get_single_value(restaurant, PHONE_NUM))
        street = get_street(restaurant)                                               
        violation_codes = get_values(restaurant, VIOLATION_CODE)        
        zipcode = get_single_value(restaurant, ZIPCODE)                                               
        Restaurant.new(boro, building, grade, cuisine_description, restaurant_name, inspection_dates, phone_num, street, violation_codes, inspection_results, zipcode)
      end
      restaurant_objects
    end

    def get_values(restaurant, key)
      restaurant.map {|r| r[key] }.compact.uniq
    end

    def get_single_value(restaurant, key)
      restaurant.first[key].strip
    end

    def sort_inspections_by_date(restaurant, inspection_dates)
      inspection_dates.each_with_object({}) do |date, hash| 
        hash[date] = restaurant.map do |r|
          r[INSPECTION_RESULTS] if Time.parse(r[INSPECTION_DATE]) == date
        end.compact
      end
    end

    def sort_restaurant_grades(restaurant, inspection_dates)
      inspection_dates.each_with_object({}) do |date, hash| 
        hash[date] = restaurant.map do |r|
          r[GRADE] if Time.parse(r[INSPECTION_DATE]) == date
        end.compact.uniq
      end
    end

    def inspection_date(restaurant)
      inspection_dates = restaurant.map { |inspection| Time.parse(inspection["inspection_date"]) }
      inspection_dates.compact.uniq.sort { |a,b| b <=> a }    
    end

    def format_phone_number(phone_number)
      "(" + phone_number[0..2] + ") " + phone_number[3..5] + "-" + phone_number[6..9]
    end

    def get_street(restaurant)                                               
      restaurant.first['street'].split.compact.join(' ')
    end

  end
end
