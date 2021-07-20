require "sinatra"
require "sinatra/cors"
require "sinatra/json"
require "./controller.rb"

# CORS
set :allow_origin, "https://mizuoka-generator.web.app"
set :allow_methods, "GET,POST"
set :allow_headers, "content-type"
set :expose_headers, "location,link"

controller = Controller.new

post "/generate" do
  status_code, response = controller.post_generate(params)

  status status_code
  json response
end
