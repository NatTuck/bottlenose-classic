#!/usr/bin/env ruby
require '/tmp/bn/lib/bn_grade'
require 'fileutils'

system("echo 127.0.0.1 `hostname` >> /etc/hosts")

sub = `ls /tmp/bn/sub/*`.chomp
gra = `ls /tmp/bn/gra/*`.chomp

ENV["BN_KEY"] = File.read("/root/bn_output_key").chomp
ENV["BN_SUB"] = sub

run(%Q{su student -c 'ruby -I /tmp/bn/lib "#{gra}"'})

