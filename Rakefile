require "bundler"
Bundler.setup

gemspec = eval(File.read("snmpdevice.gemspec"))

desc "Build the gem package and install it."
task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["snmpdevice.gemspec"] do
  system "gem build snmpdevice.gemspec"
  system "gem install snmpdevice-#{SNMPDevice::VERSION}.gem"
end
