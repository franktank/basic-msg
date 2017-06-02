require 'socket'

require_relative 'consumer'
require_relative 'producer'

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
  c = Consumer.new(cp)
  consumers << c
  num_ports -= 1
end

producer = Producer.new(p_port, consumer_ports)

consumers.each do |consumer|
  Thread.new do
    while true
      consumer.receive_msg
    end
  end
end

while true
  p "Message: "
  msg = gets.chomp
  producer.contact_port(msg)
end

consumers.each do |consumer|
  consumer.receive_msg
end

# how to have appear and reappear consumers
