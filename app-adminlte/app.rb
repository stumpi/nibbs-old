require 'sinatra'
require './helpers/sinatra'
#require './helpers/milieu'
require './model/mongodb'
require './model/elasticsearchdb'
require 'haml'
require 'digest/md5'
require 'googlestaticmap'
require 'nmap/parser'
require 'elasticsearch'
#require 'stretcher'
require 'tire'
#require 'yajl/json_gem'
require 'multi_json'

configure do
  enable :sessions
end

# This runs prior to all requests.
# It passes along the logged in user's object (from the session)
before do
  unless session[:user] == nil
    @suser = session[:user]
  end
end

#Database Connections
#es = Elasticsearch::Client.new log: true
#es.ping
#Tire::Configuration.url ENV['http://localhost:9200']
#Tire.configure do
#  url environment['elasticsearch_host']
#end


get '/' do
  haml :index
#	redirect '/ipadress'

end

get '/login' do
  haml :login
end

# The login post routine will take the provided params and run the auth routine.
# If the auth routine is successful it will return the user object, else nil
post '/login' do
  if session[:user] = User.auth(params["email"], params["password"])
    flash("Login successful")
    redirect "/user/" << session[:user].email << "/dashboard"
  else
    flash("Login failed - Try again")
    redirect '/login'
  end
end

get '/logout' do
  session[:user] = nil
  flash("Logout successful")
  redirect '/'
end

get '/register' do
  haml :register
end

get '/dashboard' do
  haml :dashboard
end

get '/events' do
	#Show all Events
	#@events = es.get index: 'nibbs', type: 'task', id: 1
  	haml :events
end

get '/eventsshowall' do
  #Show all Events
  #@events = es.search index: 'nibbs', type: 'task', id: 1 
  #@events = es.all
  #esearch = Elasticsearch::Client.new log: true
  #@events = es.search index: 'nibbs'
  search_es = Tire.search('nibbs') do
  	query do
      	  string 'title:*'
  	end
  end
  @events = search_es.results
  
 search_es.results.each do |event|
   puts event.to_yaml 

  end
#puts "Title" 

  haml :eventsshowall
end

get '/addevent' do
  # Create a Blogpost
        es.index index: 'nibbs',
         type:  'task',
         id: '3',
         body: {
         title:   "Installation VLAN",
         content: "VLAN 811",
         date:    "2015-02-17"
         }
  #haml :addevent
end


get '/addip' do
  haml :addip
end

post '/addip' do
  # Creating and populating a new user object from the DB
  newip = { :description => params[:name], :adress => params[:adress], :type => "ipv4" ,:tag => params[:tag],:time => Time.now }
  
  #ip = db.collection('ipadress')
  
  ip_id = IPADRESSES.insert(newip) 
  #ip.description      = params[:name]
  #ip.adress   = params[:adress]
  #ip.type       = params[:type]

  redirect '/ipadress'
end

get '/netscan' do
	haml :netscan
end

post '/netscan' do
parser = Nmap::Parser.parsescan("sudo nmap", "-sVC " + params[:network] )

parser.hosts("up") do |host|
	newip = { :description => host.hostname, :adress => host.addr, :type => "ipv4" ,:tag => "nmap-parser",:time => Time.now }
	ip_id = IPADRESSES.insert(newip)
end
redirect '/ipadress'
end


post '/register' do
  # Creating and populating a new user object from the DB
  u            = User.new
  u.email      = params[:email]
  u.password   = params[:password]
  u.name       = params[:name]

  # Attempt to save the user to the DB
  if u.save()
    flash("User created")

    # If user saved, authenticate from the database
    session[:user] = User.auth( params["email"], params["password"])
    redirect '/user/' << session[:user].email.to_s << "/dashboard"
  else
    # Else, display errors
    tmp = []
    u.errors.each do |e|
      tmp << (e.join("<br/>"))
    end
    flash(tmp)
    redirect '/create'
  end
end

get '/user/:email/dashboard' do
  haml :user_dashboard
end

get '/user' do
  if logged_in?
      redirect '/user/' + session[:user].email + '/profile'
  else
      redirect '/'
  end
end

get '/user/:email/profile' do
  @user = User.new_from_email(params[:email])
  haml :user_profile
end

get '/ipadress' do
	#Show all IP Adresses
	@ipadresses = IPADRESSES.find
	haml :ipadresses
	
end

get '/ipadress/:_id' do
    #Show a single IP Adress
    object_id = BSON::ObjectId.from_string(params[:_id])
    @ipadress = IPADRESSES.find_one({:_id => object_id })
    haml :ipadress
    
end


get '/ipadress/:_id/pluseins' do
	#Add Repuation to IP Adress
	object_id = BSON::ObjectId.from_string(params[:_id])
    @ipadress = IPADRESSES.find_one({:_id => object_id })
    #IPADRESSES.update({:_id => @ipadress['_id']},{:counter => @ipadress['counter'].to_i + 1 } ) 
    IPADRESSES.update({:_id => @ipadress['_id']},{:$inc => {:'counter' =>1}})
end



