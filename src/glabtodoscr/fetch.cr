require "http/client"

class Glabtodoscr::Fetch
  property url : String
  property path : String
  property token : String
  def initialize(url : String, path : String, token : String)
    @url = url
    @path = path
    @token = token
  end

  def full_url
    "#{url}#{path}todos"
  end

  def get
    headers = HTTP::Headers{"PRIVATE-TOKEN" => token}
    response = HTTP::Client.get(full_url, headers: headers)
    response.body
  end
end
