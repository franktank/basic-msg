require 'socket'

class Producer
  # @TODO Make address input or based on network IP
  # @TODO Find network IP
  # @TODO 255 for broadcast address
  # @TODO Need local IP and port from consumer to producer for communication
  attr_accessor :consumers
  def initialize(port, consumer_ports)
    @port = port
    @consumer_ports = consumer_ports
    @udp_socket = UDPSocket.new
    @udp_socket.bind(local_ip, port)
  end

  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
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
      @udp_socket.send message, 0, local_ip, cp
    end
  end

  def receive_port_broadcast
    broadcast_socket = UDPSocket.new
    # l_ip = (local_ip.split('.')[0..2]+['255']).join('.')
    # p l_ip
    broadcast_socket.bind('0.0.0.0', 2900) # 0.0.0.0 is the address to receive broadcasts
    begin # emulate blocking recvfrom, handle exception if no message, retry until receives one
      p port_num = broadcast_socket.recvfrom_nonblock(1024)[0]  #=> ["aaa", ["AF_INET", 33302, "localhost.localdomain", "127.0.0.1"]]
    rescue IO::WaitReadable
      IO.select([broadcast_socket])
      retry
    end
    p "New consumer online: #{port_num}"
    @consumer_ports << port_num.to_i
    @consumer_ports.uniq!
  end
end
