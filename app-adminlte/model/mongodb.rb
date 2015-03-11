require 'mongo'
require './model/mongoModule'
require './model/user'

# Connection code goes here
CONNECTION 	= Mongo::Connection.new("localhost")
DB		= CONNECTION.db('nibbs')
IPADRESSES	= DB['ipadress'] 

#CONNECTION = Mongo::Connection.new("localhost")
#DB	= CONNECTION.db('nibbs')
#VENUES  = DB['ipadress']
#IPADRESS  = DB['ipadress']

# Alias to collections goes here
