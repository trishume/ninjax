require 'socket'      # Sockets are in standard library
=begin
usage:
obj.ninjax! returns the ninaxed object
ninjax! { |indata| block}
runs the ninjax server and passes the ninjaxed object to the block and sends back the block's returned value
=end
class Object
  def ninjax!(message = false)
    if(block_given?)
      server = TCPServer.open(1337)  # Socket to listen on port 1337
      client = server.accept       # Wait for a client to connect
      dl = client.gets.to_i
      indata = Marshal.load(client.read(dl))
      out = yield(indata)
      outdata = Marshal.dump(out)
      client.write outdata
      client.close                 # Disconnect from the def client
      server.close
    else
        puts "ninjaxing!" if message
       s = TCPSocket.open('localhost', 1337)
       senddata = Marshal.dump(self)
       s.puts senddata.length
       s.write senddata
       data = Marshal.load(s.read)
       s.close               # Close the socket when done
       return data
    end
  end
  def ninjax
    return STDIN.read
  end
  alias :! :ninjax!
end
# lol
