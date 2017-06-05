require 'socket'
require_relative 'producer'

# Run in own process - new terminal tab
consumers = []
consumer_ports = []
p "What is the producer port?"
p_port = gets.chomp.to_i

producer = Producer.new(p_port, consumer_ports)

Thread.new do
  # while true
    # producer.receive_port_broadcast
    producer.recv_multicast
  # end
end

while true
  p "Message: "
  msg = gets.chomp
  producer.contact_port(msg)
end
