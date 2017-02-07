# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'hypdf'
require 'base64'

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

  erb :form

end

get "/sfpdfunite" do

  encoded_file_1_hex = Attachment.where("name= 'test pdf 1.pdf'").limit(1).pluck(:Body)[0]
  encoded_file_2_hex = Attachment.where("name= 'test pdf 2.pdf'").limit(1).pluck(:Body)[0]
  
  # print encoded_file_1
  # print encoded_file_2
  
  # print encoded_file_1.inspect
  # print encoded_file_2.inspect
  
  file1 = encoded_file_1_hex.hex_data.scan(/../).map { |x| x.hex }.pack('c*')
  # file2 = encoded_file_2_hex.scan(/../).map { |x| x.hex.chr }.join
  
  # file1 = encoded_file_1_hex.unpack('A')
  
  #file1 = Base64.decode64(encoded_file_1)
  #file2 = Base64.decode64(encoded_file_2)
  
  print 'printing two file contents'
  
  print file1.inspect
  
  puts file1
  
  #print file2
  
   options = {
     test: true,
     bucket: 'agtesthypdf',
     key: 'SFhypdf_test.pdf',
     public: true
   }
   
   # hypdf = HyPDF.pdfunite(file1, file2)
   
   # print hypdf
   
   # print hypdf.inspect
   
   # merged_adn_encoded_file = Base64.encode64(hypdf[:pdf])
   
   # print merged_adn_encoded_file.inspect
   
   # Attachment.create(name: 'SFhypdf_test1.pdf', contenttype: 'application/pdf', parentid: '00628000008AaUnAAK', body: hypdf[:pdf])
   
  erb :form

end
