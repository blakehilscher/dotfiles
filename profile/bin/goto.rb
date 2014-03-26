#!/usr/bin/env ruby
# encoding: UTF-8

def goto(*args)
  args.each_with_index do |match, index|
    if match[0] == '-'
      goto_expression(match)
    else
      goto_dir(match)
    end
  end
  print `pwd`
end

def goto_expression(exp)
  require 'yaml'
  dir = expressions[exp[1..-1]]
  unless dir.nil?
    dir.gsub!(/^\~/, ENV['HOME'])
    Dir.chdir( dir )
  else
    raise "no expression #{exp} in (#{expressions.keys.join(', ')})"
  end
end

def goto_dir(match)
  
  dirs = Dir['*'].select{|d| File.directory?(d) }.sort_by{|k,v| k.length }
  dirs_hash = dirs.inject({}){|m,d| m[d] = d.downcase.gsub(/[-_ ]+/,''); m }
  dirs_hash = dirs_hash.select{|k,v| v =~ /#{match}/ }
  
  if dirs_hash.count > 1
    chars = dirs_hash.select{|k,v| v[0] == match[0] } 
    dirs_hash = chars unless chars.length == 0
  end
  location = dirs_hash.keys.first
  if location.nil?
    raise "nothing matched #{match} in #{`pwd`}"
  else
    Dir.chdir(location)
  end
  
end

def expressions
  @expressions ||= YAML.load(File.read(File.join(ENV['HOME'], '.goto') ))
end

goto(*ARGV)