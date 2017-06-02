require 'socket'

class Producer
  attr_accessor :consumers
  def initialize(port, consumer_ports)
    @port = port
    @consumer_ports = consumer_ports
    @udp_socket = UDPSocket.new
    @udp_socket.bind("127.0.0.1", port)
  end

  def print_consumer_ports
    puts @consumer_ports
  end

  def add_consumer(c, p)
    @consumers << c
  end

  def contact_port(message)
    p @consumer_ports
    @consumer_ports.each do |cp|
      @udp_socket.send message, 0, "127.0.0.1", cp
    end
  end

  def receive_port_broadcast
    broadcast_socket = UDPSocket.new
    broadcast_socket.bind("127.0.0.1", 3100)
    p broadcast_socket.recvfrom_nonblock(1024)
    begin # emulate blocking recvfrom
      p broadcast_socket.recvfrom_nonblock(1024)  #=> ["aaa", ["AF_INET", 33302, "localhost.localdomain", "127.0.0.1"]]
    rescue IO::WaitReadable
      IO.select([broadcast_socket])
      retry
    end
    p "Receive broadcast"
    @consumer_ports << new_port.to_i
  end

  # how to broadcast indefinitely?
end
