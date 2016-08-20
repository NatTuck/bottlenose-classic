#!/usr/bin/env ruby

require 'lib/grading'
require 'lib/tap_parser'

bn_init

unpack_grading
unpack_submission

Dir.chdir "/home/student" do
  system("sudo -u student make")
end

unpack_grading

Dir.chdir "/home/student" do
  system("sudo -u student make test")
end
