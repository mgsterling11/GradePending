class Restaurant < ActiveRecord::Base

  attr_accessor :boro, :building, :grade, :cuisine_description, :restaurant_name, :inspection_date, :phone_num, :street, :violation_codes, :inspection_results, :zipcode

  def initialize(boro, building, grade, cuisine_description, restaurant_name, inspection_date, phone_num, street, violation_codes, inspection_results, zipcode)
    @boro = boro
    @building = building
    @grade = grade
    @cuisine_description = cuisine_description
    @restaurant_name = restaurant_name
    @inspection_date = inspection_date
    @phone_num = phone_num
    @street = street
    @violation_codes = violation_codes
    @inspection_results = inspection_results
    @zipcode = zipcode
  end

end
