class Search
  attr_accessor :keyword

  def self.for(search)
    search_type = ["dba", "cuisine_description", "boro", "grade", "street", "violation_code", "violation_description", "zipcode"]
    @result = ""
    
    search_type.each do |param|
      url_string = "https://data.cityofnewyork.us/resource/9w7m-hzhe.json?$limit=50000&#{param}=#{search}"
      @result = self.perform_search(url_string)
      return @result if @result != "[]\n"
    end
  end

  def self.perform_search(url_string)
    RestClient::Request.execute(method: :get, url: url_string)
  end
end
