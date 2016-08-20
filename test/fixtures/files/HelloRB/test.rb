#!/usr/bin/env ruby
require 'bn_grade.rb'

score = BnScore.new

load 'hello.rb'

hi = hello("Bob")

score.test("hello", 5) do
  (hi == "Hello, Bob") ? 5 : 0
end

score.output!
