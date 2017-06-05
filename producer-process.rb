require 'socket'
require_relative 'producer'

# Run in own process - new terminal tab
p "What is the producer port?"
p_port = gets.chomp.to_i

producer = Producer.new(p_port)

Thread.new do
  producer.recv_multicast
end

while true
  p "Message: "
  msg = gets.chomp
  producer.contact_port(msg)
end
