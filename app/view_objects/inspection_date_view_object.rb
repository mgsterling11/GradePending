class InspectionDateViewObject
  attr_reader :inspection_date

  def initialize(inspection_date)
    @inspection_date = inspection_date
  end

  def display
    @inspection_date.to_s[0..9]
  end
end