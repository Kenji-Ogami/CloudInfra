class IpAddress < ApplicationRecord

  def get_ip_addr?
    @ip_addresses = IpAddress.all
    i=1
    @ip_addresses.each{|ip| 
      if ip[:ip_addr]!=format("192.168.122.%<x>d",x: i) then
        break
      else
	if i < 256 then
	  i+=1
	else
	  return FALSE
	end
      end
    }
    self[:ip_addr] = format("192.168.122.%<x>d",x: i)
    return TRUE
  end
end
