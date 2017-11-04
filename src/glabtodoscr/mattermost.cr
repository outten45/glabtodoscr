require "json"

class Glabtodoscr::Mattermost
  property todo, webhook
  def initialize(todo : Glabtodoscr::Todo, webhook : String)
    @webhook = webhook
    @todo = todo
  end

  def send
    headers = HTTP::Headers{"Context-Type" => "application/json", "User-Agent" => "crystal"}
    body = JSON.build do |json|
      json.object do
        json.field "text", msg_text
        json.field "username", "Glabtodoscr"
      end
    end
    # response = HTTP::Client.post(webhook, headers: headers, body: "payload=#{body}")
    # response.body

    # response = HTTP::Client.post(webhook, headers: headers, body: "payload=#{body}") do |r|
    #   puts r.body
    # end

    # for some reason, the native http client didn't work (above). call out to curl.
    cmd = "curl -s -X POST -d 'payload=#{body}' #{webhook}"
    puts %x{#{cmd}}
  end

  def msg_text
    "gitlab: [#{todo.target_type}](#{todo.target_url}) \n_#{todo.body}_"
  end
end