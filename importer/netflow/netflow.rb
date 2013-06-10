require 'netflow'
require 'netflow/collector'
require 'mongo'

# Connection code goes here
CONNECTION 	= Mongo::Connection.new("localhost")
DB		= CONNECTION.db('nibbs')
IPADRESSES	= DB['ipadress'] 

flow = NetflowCollector::start_collector(bind_ip = '0.0.0.0', bind_port = 2055)

flow.parse_packet()



