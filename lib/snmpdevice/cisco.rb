require 'snmpdevice/base'

module SNMPDevice
  class CISCO < Base
    def initialize(manager)
      @manager = manager
    end

  end

  class CISCO76 < CISCO
    def find_interface_name_by_mac(mac)
      get_arp_table.each do |row|
        return row[:ifname] if row[:mac] == mac
      end
      return ''
    end

    def get_temp()
      temp_table = []
      @manager.walk("1.3.6.1.4.1.9.9.13.1.3.1.2") do |vb|
        dot_id = vb.name.to_s.match(/.\d*$/).to_s
        device = vb.value.to_s
        temp = snmp_get("1.3.6.1.4.1.9.9.13.1.3.1.3#{dot_id}")
        temp_table << [device, temp]
      end
      temp_table
    end

  end

end
