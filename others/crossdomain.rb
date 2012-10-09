#!/usr/bin/env ruby
require 'socket'
xml='<cross-domain-policy><allow-access-from domain="*" to-ports="*" /></cross-domain-policy>'

while true do
TCPServer.open("0.0.0.0", 843) {|serv|
    s = serv.accept
        s.puts xml
        s.close
}
end
