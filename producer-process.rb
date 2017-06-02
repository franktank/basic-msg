require 'socket'
require_relative 'producer'

# Run in own process - new terminal tab
consumers = []
consumer_ports = []
p "What is the producer port?"
p_port = gets.chomp.to_i

p "How many consumer ports?"
num_ports = gets.chomp.to_i

while num_ports > 0
  p "Input consumer port:"
  cp = gets.chomp.to_i
  consumer_ports << cp
  num_ports -= 1
end

producer = Producer.new(p_port, consumer_ports)

while true
  p "Message: "
  msg = gets.chomp
  producer.contact_port(msg)
end
