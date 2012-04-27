require 'ipaddr'

require 'rubygems'
require "bundler/setup"

require 'snmp'


#class SNMP::Manager
 #attr_reader :mib
#end

#class SNMP::MIB
 #attr_reader :by_module_by_name
#end


module SNMPDevice
  class Base
    attr_reader :manager

    def self.create_device(config)
      dev = self.new(config)
      sys = dev.get_sys_descr
      case sys
      when /[Rr]uijie/
        case sys
        when /S8610/
          RuijieS8610.new(dev.manager)
        else
          Ruijie.new(dev.manager)
        end
      when /[Cc]isco/
        case sys
        when /s72033_rp-PSV-M/
          CISCO76.new(dev.manager)
        else
          CISCO.new(dev.manager)
        end
      when /[Hh]uawei/
        H3C.new(dev.manager)
      else
        dev
      end
    end

    #def get_mib
     #@mib = Hash.new
     #@manager.mib.by_module_by_name.each do |mod, name|
       #name.each do |key, value|
         #@mib["#{mod}.#{key}"] = value
       #end
     #end
     #@mib
    #end

    def get_sys_name
      snmp_get("sysName.0")
    end

    def get_sys_descr
      snmp_get("sysDescr.0")
    end

    def find_default_gateway()
      # RFC1213-MIB::ipRouteNextHop.0.0.0.0
      snmp_get("1.3.6.1.2.1.4.21.1.7.0.0.0.0")
    end

    def find_uplink_interface_name()
      # RFC1213-MIB::ipRouteIfIndex.0.0.0.0
      interface_id = snmp_get("1.3.6.1.2.1.4.21.1.2.0.0.0.0")
      snmp_get("ifName." + interface_id)
    end

    def find_uplink_interface_mac()
      # RFC1213-MIB::ipRouteIfIndex.0.0.0.0
      interface_id = snmp_get("1.3.6.1.2.1.4.21.1.2.0.0.0.0")
      snmp_get("ifPhysAddress." + interface_id).unpack("H2H2H2H2H2H2").join(":").upcase
    end

    def find_all_interface_ip()
      snmp_walk("ipAdEntAddr").delete_if { |ip| ip =~ /127\.0\.0\./ }
    end

    def find_interface_mask_by_ip(interface_ip)
      snmp_get("ipAdEntNetMask." + interface_ip)
    end

    def find_interface_name_by_ip(interface_ip)
      interface_id = snmp_get("ipAdEntIfIndex." + interface_ip)
      snmp_get("ifName." + interface_id)
    end

    def get_routing_table
      routing_table = []
      begin
        # RFC1213-MIB::ipRouteDest
        snmp_walk("1.3.6.1.2.1.4.21.1.1").each do |ip|
          row = {}
          row[:ip] = ip
          # RFC1213-MIB::ipRouteMask
          row[:mask] = snmp_get("1.3.6.1.2.1.4.21.1.11." + ip)
          # RFC1213-MIB::ipRouteNextHop
          row[:nexthop] = snmp_get("1.3.6.1.2.1.4.21.1.7." + ip)
          # RFC1213-MIB::ipRouteIfIndex
          interface_id = snmp_get("1.3.6.1.2.1.4.21.1.2." + ip)
          row[:ifname] = snmp_get("ifName." + interface_id)
          routing_table << row
        end
      rescue SNMP::RequestTimeout => detail
        $stderr.puts "SNMP::RequestTimeout: " + detail
      end
      routing_table
    end

    def get_arp_table
      arp_table = []
      begin
        @manager.walk("ipNetToMediaPhysAddress") do |vb|
          row = {}
          row[:ip] = vb.name.to_s.match(/\d*\.\d*\.\d*\.\d*$/).to_s
          row[:mac] = vb.value.to_s.unpack("H2H2H2H2H2H2").join(":").upcase
          interface_id = vb.name.to_s.match(/(\d*)\.\d*\.\d*\.\d*\.\d*$/)[1]
          row[:ifname] = snmp_get("ifName." + interface_id)
          arp_table << row
        end
      rescue SNMP::RequestTimeout => detail
        $stderr.puts "SNMP::RequestTimeout: " + detail
      end
      arp_table
    end

    def find_mac_by_ip(ip)
      get_arp_table.each do |row|
        return row[:mac] if row[:ip] == ip
      end
      return ''
    end

    def find_ip_by_mac(mac)
      get_arp_table.each do |row|
        return row[:ip] if row[:mac] == mac
      end
      return ''
    end

    def find_interface_name_by_mac(mac)
      temp = []
      mac.split(":").each { |t| temp << ("0x" + t).to_i(0).to_s }
      dec_mac = temp.join(".")

      # SNMPv2-SMI::mib-2.17.4.3.1.2.
      bridge_id = snmp_get("1.3.6.1.2.1.17.4.3.1.2." + dec_mac)
      # SNMPv2-SMI::mib-2.17.1.4.1.2.
      interface_id = snmp_get("1.3.6.1.2.1.17.1.4.1.2." + bridge_id)
      snmp_get("ifName." + interface_id)
    end

    private

    def initialize(config = {})
      config[:Host] ||= 'localhost'
      config[:Community] ||= 'public'
      @manager = SNMP::Manager.new(config)
    end

    def snmp_get(oid)
      begin
        response = @manager.get(oid)
      rescue SNMP::RequestTimeout => detail
        $stderr.puts "SNMP::RequestTimeout: " + detail
        return ''
      rescue ArgumentError => detail
        $stderr.puts "ArgumentError: " + detail
        return ''
      end
      result = response.varbind_list.first.value.to_s
      if result == "noSuchInstance"
        ''
      elsif result == "noSuchObject"
        ""
      else
        result
      end
    end

    def snmp_walk(oid)
      results = []
      begin
        @manager.walk(oid) do |vb|
          results << vb.value.to_s
        end
      rescue SNMP::RequestTimeout => detail
        $stderr.puts "SNMP::RequestTimeout: " + detail
      rescue ArgumentError => detail
        $stderr.puts "ArgumentError: " + detail
      end
      results
    end

  end

end
