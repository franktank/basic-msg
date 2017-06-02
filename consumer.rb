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

  # Send broadcast out when consumer starts
  def broadcast
    temp_socket = UDPSocket.new
    temp_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
    temp_socket.send "#{@port}", 0, "<broadcast>", 2900
    p temp_socket.send "#{@port}", 0, "<broadcast>", 2900
    p "Broadcasted..."
  end
end
