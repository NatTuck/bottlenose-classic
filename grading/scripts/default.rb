#!/usr/bin/env ruby
require 'fileutils'

def run(cmd)
  system(cmd) or do
    puts "Error running cmd: #{cmd}"
    exit(1)
  end
end

sub = `ls /tmp/bn/sub/*`.chomp
gra = `ls /tmp/bn/gra/*`.chomp

ENV["BN_KEY"] = File.read("/root/bn_output_key").chomp
ENV["BN_SUB"] = sub

run(%Q{su student -c 'ruby -I /tmp/bn/lib "#{gra}"'})

