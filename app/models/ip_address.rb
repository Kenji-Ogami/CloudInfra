class IpAddress < ApplicationRecord

  def get_ip_addr?
    @ip_addresses = IpAddress.all
    found = FALSE

    addr = 1
    while found==FALSE do
      exist = FALSE
      @ip_addresses.each{|ip| 
        if ip[:ip_addr]==format("192.168.122.%<x>d",x: addr) then
          exist = TRUE
          break
        end
      }
      if exist==TRUE then
        addr += 1
      else
        found=TRUE
      end
    end
    self[:ip_addr] = format("192.168.122.%<x>d",x: addr)
    return TRUE
  end
end
