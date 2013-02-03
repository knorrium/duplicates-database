require "digest"
require 'find'

path = File.dirname(__FILE__)
Find.find(path) do |file|
	next unless File.file?(file)
	digest = Digest::SHA256.file(file).hexdigest
	puts "#{file} - #{digest}"
end