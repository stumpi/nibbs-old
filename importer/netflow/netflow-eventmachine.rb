require 'netflowfu'
require 'eventmachine'

class NetflowCallbacks

  def netflow5_callback(packet)
    # Put code to handle netflow 5 flows here
    puts "netflow5 flows received"
    packet.flows.each { |x| puts x.humanize + "\n" }
  end

  def netflow9_callback(packet)
    # Put code to handle netflow 9 flows here
    puts "netflow9 decoded_flowset received"
    packet.data_flowsets.each { |x| puts x.humanize }
  end

end

module Collector

  def post_init
    @collector = NetflowCollector.new(:netflow_callbacks => NetflowCallbacks.new)
  end

  def receive_data(data)
    puts "Data received"
    @collector.receive(data)
  end
end

EventMachine::run { EventMachine::open_datagram_socket("0.0.0.0", 2055, Collector) }
