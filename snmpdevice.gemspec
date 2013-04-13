require File.expand_path("../lib/snmpdevice/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'snmpdevice'
  s.version     = SNMPDevice::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Meng Bo"]
  s.email       = 'mengbo@lnu.edu.cn'
  s.homepage    = "https://github.com/mengbo/snmpdevice"
  s.summary     = "Ruby SNMP tool."
  s.description = "Ruby SNMP tool, for CISCO/Ruijie/H3C network deivce."

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "snmpdevice"

  # If you have other dependencies, add them here
  s.add_dependency "snmp", "~> 1.1"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "shell/*", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["snmpdevice"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end
