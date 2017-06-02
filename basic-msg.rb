require 'socket'

require_relative 'consumer'
require_relative 'producer'

consumer_ports = []

p "What is the producer port?"
p_port = gets.chomp.to_i

p "How many consumer ports?"
num_ports = gets.chomp.to_i

while num_ports > 0
  p "Input consumer port:"
  consumer_ports << gets.chomp.to_i
  num_ports -= 1
end

producer = Producer.new(p_port, consumer_ports)

consumers_hash = Hash.new
consumer_ports.each do |cp|
  consumers_hash[cp] = Consumer.new(cp)
end

producer.consumers = consumers_hash

while true
  p "Message: "
  m = gets.chomp

  p "Which port from #{consumer_ports}?"
  recipient_port = gets.chomp.to_i

  producer.contact_port(consumers_hash[recipient_port], m)
end
