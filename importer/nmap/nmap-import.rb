require 'nmap/parser'
require 'mongo'

# Connection code goes here
CONNECTION 	= Mongo::Connection.new("localhost")
DB		= CONNECTION.db('nibbs')
IPADRESSES	= DB['ipadress'] 

#parse nmap xml scan
parser = Nmap::Parser.parsefile("nmap.xml")

parser.hosts("up") do |host|
	puts "#{host.addr} is up:"
	newip = { :description => host.hostname, :adress => host.addr, :type => "ipv4" ,:tag => "nmap-parser",:time => Time.now }
	ip_id = IPADRESSES.insert(newip)
  
end
