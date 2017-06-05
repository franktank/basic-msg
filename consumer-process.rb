require 'socket'
require_relative 'consumer'

# Run in separate process by new terminal tab
p "Consumer port?"
c_port = gets.chomp.to_i
c = Consumer.new(c_port)
Thread.new do
  while true
    # producer.receive_port_broadcast
    c.send_multicast
  end
end
while true
  c.receive_msg
end
