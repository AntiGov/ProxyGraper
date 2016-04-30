description=[[
Checks if an SMTP port is open.
]]
author = "G66K"
license = "Same as Nmap--See http://nmap.org/book/man-legal.html"
categories = {"default", "discovery", "external", "intrusive"}
local shortport = require ('shortport')
portrule = shortport.portnumber(25, "tcp", "open")
action = function(host, port)
	file = io.open ("smtp.txt","a+")
	file:write (host.ip.."\n")
	file:flush()
	file:close()
end
