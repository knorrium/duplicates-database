require "digest"
require "find"
require "optparse"

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on("-d", "--directory DIR", "The directory to scan") do |arg|
    options[:directory] = arg
  end
end

begin
  optparse.parse!
  mandatory = [:directory]
  missing = mandatory.select{ |param| options[param].nil? }
  if not missing.empty?
    puts "Missing options: #{missing.join(', ')}"
    puts optparse
    exit
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts optparse
  exit
end

Find.find(File.expand_path(options[:directory])) do |file|
  next unless File.file?(file)
  digest = Digest::SHA256.file(file).hexdigest
  puts "#{file} - #{digest}"
end
