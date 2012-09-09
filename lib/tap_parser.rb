
class TapParser
  def initialize(text)
    @text = text
  end

  def test_count
    @text.split("\n").each do |line|
      mm = line.match(/^1\.\.(\d+)$/)
      if mm
        return mm[1].to_i
      end
    end
  end

  def tests_ok
    tests = {}
    @text.split("\n").each do |line|
      # Passing test?
      mm = line.match(/^ok (\d+) -/)
      if mm
        nn = mm[1].to_i
        tests[nn] = true if tests[nn].nil?
      end

      # Failing test wins.
      mm = line.match(/^not ok (\d+) -/)
      if mm
        nn = mm[1].to_i
        tests[nn] = false
      end
    end    

    # Count passing tests.
    passes = 0
    1.upto(test_count) do |ii|
      passes += 1 if tests[ii]
    end

    passes
  end

  def summary
    <<-"SUMMARY"
    Test count: #{test_count}
    Tests OK:   #{tests_ok}
    SUMMARY
  end
end
