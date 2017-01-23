# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'hypdf'

class Contact < ActiveRecord::Base
  self.table_name = 'salesforce.contact'
end

get "/contacts" do
  @contacts = Contact.all
  erb :index
end

class Account < ActiveRecord::Base
  self.table_name = 'salesforce.account'
end

get "/acc" do
  @accounts = Account.all
  erb :acc
end

get "/" do
  erb :home
end


class Contact < ActiveRecord::Base
  self.table_name = 'salesforce.contact'
end

#get "/contacts" do
#  @contacts = Contact.all
#  erb :index
#end

get "/create" do
  dashboard_url = 'https://dashboard.heroku.com/'
  match = /(.*?)\.herokuapp\.com/.match(request.host)
  dashboard_url << "apps/#{match[1]}/resources" if match && match[1]
  redirect to(dashboard_url)
end

# get "/pdfunite" do
#   file_1 = params[:file_1]
#   file_2 = params[:file_2]
#   options = {test: true}
#   hypdf = HyPDF.pdfunite(file_1, file_2, options)
#   send_data(hypdf[:pdf], filename: 'hypdf_test.pdf', type: 'application/pdf')
# end
