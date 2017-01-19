configure :development do
 set :show_exceptions, true
end

configure :production, :development do
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :username => db.user,
   :password => db.password,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end

configure :production, :development do
  HYPDF_USER=023210bd-1a5d-48b2-954a-ba7181feedda
  HYPDF_PASSWORD=njfF2ToW
end
