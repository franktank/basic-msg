require 'socket'

class Consumer
  attr_accessor :port
  def initialize(port)
    @udp_socket = UDPSocket.new
    @udp_socket.bind(local_ip, port)
    @port = port
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

  def receive_msg
    p @udp_socket.recvfrom(1024)
  end

  # Send broadcast out when consumer starts
  def broadcast
    while true
      temp_socket = UDPSocket.new
      temp_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
      l_ip = (local_ip.split('.')[0..2]+['255']).join('.')
      temp_socket.send "#{@port},#{local_ip}", 0, l_ip, 2900
      p "Broadcasted..."
      sleep 1
    end
  end

  # Constantly send multicast to let producers know of existence
  def send_multicast
    multicast_addr = "225.1.2.3" # multicast address range 224.0.0.0 to 239.255.255.255
    port = 50001
    begin
      socket = UDPSocket.open
      socket.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, 1)
      socket.send("#{@port},#{local_ip}", 0, multicast_addr, port)
    ensure
      socket.close
    end
  end
end
