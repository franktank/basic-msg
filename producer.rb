require 'socket'

class Producer
  attr_accessor :consumers
  def initialize(port, consumer_ports)
    @port = port
    @consumer_ports = consumer_ports
    @udp_socket = UDPSocket.new
  end

  def print_consumer_ports
    puts @consumer_ports
  end

  def add_consumer(c, p)
    @consumers << c
  end

  def contact_port(message)
    @consumer_ports.each do |cp|
      @udp_socket.send message, 0, "127.0.0.1", cp
    end
  end

  # how to broadcast indefinitely?
end
