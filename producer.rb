require 'socket'
require 'ipaddr'

class Producer
  attr_accessor :consumers
  def initialize(port)
    @port = port
    @consumer_ports = Hash.new
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

  def contact_port(message)
    p @consumer_ports
    @consumer_ports.each do |key, value|
      pa = key.split(",")
      @udp_socket.send message, 0, pa[1], pa[0]
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

  def recv_multicast
    multicast_addr= "225.1.2.3"
    port = 50001
    ip =  IPAddr.new(multicast_addr).hton + IPAddr.new("0.0.0.0").hton
    sock = UDPSocket.new
    sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, ip)
    sock.bind(Socket::INADDR_ANY, port)
    # sock.bind("0.0.0.0", port)
    loop do
      # need exceptions for background threads
      begin
        msg, info = sock.recvfrom(1024)
        pa = msg.split(",")
        @consumer_ports[msg] = pa[0]
        # p pa
      rescue =>e
        p e
        raise
      end
    end
  end
end
