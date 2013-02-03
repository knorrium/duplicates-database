require "digest"
require "find"
require "optparse"
require "data_mapper"

DataMapper.setup(:default, "sqlite3:" + File.expand_path(File.dirname(__FILE__)) + "/files.db")

module DataMapper
 module Model
   def first_or_create(conditions = {}, attributes = {})
     first(conditions) || create(conditions.merge(attributes))
   end

   alias find_or_create first_or_create
 end
end

class FileEntry
    include DataMapper::Resource

    property :id, Serial
    property :path, Text, :unique => true
    property :md5, Text
    property :size, Integer
end

DataMapper.finalize.auto_upgrade!

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

  file_entry = FileEntry.new(:path => file, :md5 => digest, :size => File.size(file))

  begin
    file_entry.save
    rescue DataObjects::IntegrityError => e
        puts "File #{file_entry.path} was already in the database"
    end
end
