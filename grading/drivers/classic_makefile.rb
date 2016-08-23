#!/usr/bin/env ruby

require 'bn_grade'
require 'tap_parser'

ENV["BN_SUB"]   = `ls /tmp/bn/sub/*`.chomp
ENV["BN_GRADE"] = `ls /tmp/bn/gra/*`.chomp
ENV["BN_KEY"]   = `cat /root/bn_output_key`.chomp

score = BnScore.new

unpack_grading
unpack_submission

def run_in_sub(cmd)
  count = `find . -name "Makefile" | wc -l`.chomp.to_i
  if count != 1
    raise Exception.new("Too many Makefiles: #{count}")
  end

  Dir.chdir "/home/student"
  dir = `dirname $(find . -name "Makefile" | head -1)`.chomp
  run(%Q{chown -R student:student "#{dir}"})
  Dir.chdir dir
  run(cmd)
end

run_in_sub("sudo -u student make")

unpack_grading

run_in_sub("sudo -u student make test | tee /root/test.out")

tap = TapParser.new(File.read("/root/test.out"))
score.add("make test", tap.points_earned, tap.points_available)
score.output!
