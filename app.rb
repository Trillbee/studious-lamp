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
  @attachments = Attachment.all
  erb :att
end

get "/" do
  erb :home
end

get "/upload_image" do
  erb :form
end


# class Contact < ActiveRecord::Base
#   self.table_name = 'salesforce.contact'
# end

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

post '/save_image' do

  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end

  erb :show_image
end

# get "/pdfunite" do
#   erb :pdfunite
# end
#
# get "/unite" do
#   file_1 = params[:file_1]
#   file_2 = params[:file_2]
#   options = {test: true}
#
#   if params[:commit] == 'Download PDF'
#     hypdf = HyPDF.pdfunite(file_1.path, file_2.path, options)
#     send_data(hypdf[:pdf], filename: 'hypdf_test.pdf', type: 'application/pdf')
#   else
#     options.merge!(
#       bucket: 'agtesthypdf', #'hypdf_test', # NOTE: replace 'hypdf_test' with your backet name
#       key: 'hypdf_test.pdf',
#       public: true
#     )
#     hypdf = HyPDF.pdfunite(file_1.path, file_2.path, options)
#     redirect_to '/pdfunite', notice: "PDF url: #{hypdf[:url]}"
#   end
# end

post "/pdfunite" do

  # file_1 = JSON.parse(params[:file_1].to_json)
  # file_2 = JSON.parse(params[:file_2].to_json)
  file_1 = params[:file_1][:tempfile]
  file_2 = params[:file_2][:tempfile]

  options = {test: true}

  hypdf = HyPDF.pdfunite(file_1, file_2, options)
  send_data(hypdf[:pdf], filename: 'hypdf_test.pdf', type: 'application/pdf')
end
