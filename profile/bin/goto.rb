#!/usr/bin/env ruby
# encoding: UTF-8

Dir.chdir(ENV['HOME'])

ARGV.each do |match|
  dirs = Dir['*'].select{|d| File.directory?(d) }.collect(&:downcase)
  dirs = dirs.collect{|s| s.gsub(/[-_ ]+/,'')}.sort_by{|k,v| k.length }
  dirs = dirs.select{|k| k =~ /#{match}/ } if dirs.count > 1
  
  if dirs.count > 1
    chars = dirs.select{|d| d[0] == match[0] } 
    dirs = chars unless chars.length == 0
  end
  location = dirs.first
  if location.nil?
    raise "nothing matched #{match} in #{`pwd`}"
  else
    Dir.chdir(location)
  end
end

print `pwd`