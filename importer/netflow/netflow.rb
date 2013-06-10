#require 'Vflow'
require 'socket'
require 'netflow'
#require 'netflow/collector'
require 'mongo'

# Connection code goes here
CONNECTION 	= Mongo::Connection.new("localhost")
DB		= CONNECTION.db('nibbs')
IPADRESSES	= DB['ipadress'] 

# Create Netflow Collector Object

#flow = NetflowCollector::start_collector(bind_ip = '0.0.0.0', bind_port = 2055)

#flow.parse_packet()
flow = NetflowCollector.start_collector.new(bind_ip = '0.0.0.0', bind_port = 2055)



