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

class Attachment < ActiveRecord::Base
  self.table_name = 'salesforce.attachment'
end

get "/att" do
  #@attachments = Attachment.all
  @attachments = Attachment.where("contenttype= 'application/pdf'")
  erb :att
end

get "/" do
  erb :home
end

get "/upload_image" do
  erb :form
end

get "/create" do
  dashboard_url = 'https://dashboard.heroku.com/'
  match = /(.*?)\.herokuapp\.com/.match(request.host)
  dashboard_url << "apps/#{match[1]}/resources" if match && match[1]
  redirect to(dashboard_url)
end

post '/save_image' do

  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end

  erb :show_image
end

post "/pdfunite" do

  file_1 = params[:file_1][:tempfile]
  file_2 = params[:file_2][:tempfile]

  options = {
    test: true,
    bucket: 'agtesthypdf',
    key: 'hypdf_test.pdf',
    public: true
  }
  hypdf = HyPDF.pdfunite(file_1, file_2, options)

  erb :pdfunite

end

post "sfpdfunite" do

  @f_1 = Attachment.where("contenttype= 'application/pdf'").limit(1)
  @f_2 = Attachment.where("contenttype= 'application/pdf'").limit(1)

  # options = {
  #   test: true,
  #   bucket: 'agtesthypdf',
  #   key: 'SFhypdf_test.pdf',
  #   public: true
  # }
  # hypdf = HyPDF.pdfunite(file_1, file_2, options)

  erb :pdfunite

end
