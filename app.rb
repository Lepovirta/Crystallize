require_relative "bundle/bundler/setup"
require "sinatra"
require "sinatra/config_file"
require_relative "app/lib/printer.rb"
require_relative "app/lib/validator.rb"
require_relative "app/lib/auth_helper.rb"

config_file "config.yml"
set :port, 8080
set :bind, "0.0.0.0" # required to bind to all interfaces
set :root, File.dirname(__FILE__) + "/app"

helpers AuthHelper

# Render static HTML form.
get "/" do
  erb :form
end

# Create and send PDF from form data.
post "/crystallize" do
  data = params[:crystal]
  if Validator.valid(data)
    html = erb(:pdf, locals: {crystal: data})
    file = Printer.create_pdf(html)
    send_file(file)
  else
    redirect "/"
  end
end

# Admin page for listing admin stuff.
get "/admin" do
  authenticate!
  "Admin page"
end
