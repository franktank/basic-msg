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
end
