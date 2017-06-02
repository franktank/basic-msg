require 'socket'

class Consumer
  attr_accessor :port
  def initialize(port)
    @udp_socket = UDPSocket.new
    @udp_socket.bind("127.0.0.1", port)
    @port = port
  end

  def receive_msg
    p @udp_socket.recvfrom(1024)
  end

  def broadcast
    temp_socket = UDPSocket.new
    temp_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
    temp_socket.send "#{@port}", 0, "127.0.0.255", 3100
    p "Broadcasted.."
  end
end
