# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'

class Contact < ActiveRecord::Base
  self.table_name = 'salesforce.contact'
end

get "/contacts" do
  @contacts = Contact.all
  erb :index
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

get "/pdfunite" do

  file_1 = params[:file_1]
  file_2 = params[:file_2]
  options = {test: true}

  #if params[:commit] == 'Download PDF'
    hypdf = HyPDF.pdfunite(file_1.path, file_2.path, options)
    send_data(hypdf[:pdf], filename: 'hypdf_test.pdf', type: 'application/pdf')
  #else
  #  options.merge!(
  #    bucket: 'agtesthypdf', #'hypdf_test', # NOTE: replace 'hypdf_test' with your backet name
  #    key: 'hypdf_test.pdf',
  #    public: true
  #  )
  #  hypdf = HyPDF.pdfunite(file_1.path, file_2.path, options)
  #  redirect_to '/pdfunite', notice: "PDF url: #{hypdf[:url]}"
  end

end
