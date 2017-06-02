require 'socket'

class Producer
  attr_accessor :consumers
  def initialize(port, consumer_ports)
    @port = port
    @consumer_ports = consumer_ports
    @udp_socket = UDPSocket.new
    @consumers = Hash.new
  end

  def print_consumer_ports
    puts @consumer_ports
  end

  def contact_port(consumer, message)
    @udp_socket.send message, 0, "127.0.0.1", consumer.port
    consumer.receive_msg
  end

  # how to broadcast indefinitely?
end
