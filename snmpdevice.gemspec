# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snmpdevice/version'

Gem::Specification.new do |spec|
  spec.name          = "snmpdevice"
  spec.version       = SNMPDevice::VERSION
  spec.authors       = ["Meng Bo"]
  spec.email         = ["mengbo@lnu.edu.cn"]

  spec.summary       = %q{Ruby SNMP tool.}
  spec.description   = %q{Ruby SNMP tool, for CISCO/Ruijie/H3C network deivce.}
  spec.homepage      = "https://github.com/mengbo/snmpdevice"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "snmp", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
