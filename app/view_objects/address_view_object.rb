class AddressViewObject
  attr_reader :address

  def initialize(address)
    @address = address  
  end

  def display
    @address.restaurant_name + ' at ' + @address.building + ' ' + @address.street
  end
end