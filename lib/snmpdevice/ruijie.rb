require 'snmpdevice/base'

module SNMPDevice
  class Ruijie < Base
    def initialize(manager)
      @manager = manager
    end
  
  end

  class RuijieS8610 < Ruijie
    def find_interface_name_by_mac(mac)
      get_arp_table.each do |row|
        return row[:ifname] if row[:mac] == mac
      end
      return ''
    end

  end
  
end
