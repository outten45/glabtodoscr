require "./glabtodoscr/*"
require "option_parser"


module Glabtodoscr
  def self.run(host : String, api_path : String, token : String, webhook)
    fetcher = Glabtodoscr::Fetch.new(host, api_path, token)
    r = fetcher.get
    todos = Array(Glabtodoscr::Todo).from_json(r)
    self.send_notifications(todos, webhook)
    r
  end

  def self.send_notifications(todos, webhook)
    todos.each do |todo|
      Glabtodoscr::Mattermost.new(todo, webhook).send
    end
  end
end

glab_host = ""
glab_apipath = ""
glab_token = ""
mattermost_webhook = ""

o = OptionParser.parse! do |parser|
  parser.banner = "Usage: pull todos from gitlab"
  parser.on("-h HOST", "--host=HOST", "Upcases the salute") { |host| glab_host = host }
  parser.on("-a PATH", "--apipath=PATH", "Specifies the name to salute") { |path| glab_apipath = path }
  parser.on("-t TOKEN", "--token=TOKEN", "Specifies the name to salute") { |token| glab_token = token }
  parser.on("-m WEBHOOK", "--mattermost=WEBHOOK", "Mattermost webhook") {|webhook| mattermost_webhook = webhook}
  parser.on("--help", "Show this help") { puts parser; exit }
end

glab_host = ENV["GLAB_HOST"] if glab_host.empty?
glab_apipath = ENV["GLAB_APIPATH"] if glab_apipath.empty?
glab_token = ENV["GLAB_TOKEN"] if glab_token.empty?
mattermost_webhook = ENV.fetch("MATTERMOST_WEBHOOK", "") if mattermost_webhook.empty?

Glabtodoscr.run(glab_host, glab_apipath, glab_token, mattermost_webhook)