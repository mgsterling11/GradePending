class Search
  attr_accessor :keyword

  def self.for(search)
    search_type = ["dba", "cuisine_description", "boro", "grade", "street", "violation_code", "violation_description", "zipcode"]
    @result = ""

    x=0
    while x < search_type.length do 
      url_string = "https://data.cityofnewyork.us/resource/9w7m-hzhe.json?$limit=50000&#{search_type[x]}=#{search}"
      @result = self.perform_search(url_string)
      break if @result != "[]\n"
      x+=1
    end
    url_string
  end

  def self.perform_search(url_string)
    @result = RestClient::Request.execute(method: :get, url: url_string)
  end
end
