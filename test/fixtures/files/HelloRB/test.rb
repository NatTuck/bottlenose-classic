#!/usr/bin/env ruby
require 'bn_grade'

score = BnScore.new

unpack_submission

load 'hello.rb'

hi = hello("Bob")

score.test("hello", 5) do
  (hi == "Hello, Bob") ? 5 : 0
end

score.output!
