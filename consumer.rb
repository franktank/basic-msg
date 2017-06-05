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
      # Pray <broadcast> works on wifi network
      temp_socket.send "#{@port},#{local_ip}", 0, l_ip, 2900
      # Broadcast local IP and port so producer can contact.
      p "Broadcasted..."
      sleep 1
    end
  end
end
