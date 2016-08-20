
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

    0
  end

  def tests_ok
    tests = {}
    @text.split("\n").each do |line|
      # Passing test?
      mm = line.match(/^ok (\d+) -/)
      if mm
        nn = mm[1].to_i
        tests[nn] = 1 if tests[nn].nil?
      end

      # Failing test wins.
      mm = line.match(/^not ok (\d+) -/)
      if mm
        nn = mm[1].to_i
        tests[nn] = false
      end
    end

    # Count passing tests.
    points = 0
    1.upto(test_count) do |ii|
      points += 1 if tests[ii]
    end

    points
  end

  def points_available
    total_points = test_count

    @text.split("\n").each do |line|
      mm = line.match(/# TOTAL POINTS: (\d+)/)
      if mm
        total_points = mm[1].to_i
      end
    end

    total_points
  end

  def points_earned
    points = tests_ok

    @text.split("\n").each do |line|
      mm = line.match(/# POINTS: (\d+)/)
      if mm
        points = points + mm[1].to_i - 1
      end
    end

    points
  end

  def summary
    <<-"SUMMARY"
    Test count:        #{test_count}
    Tests OK:          #{tests_ok}
    Points available:  #{points_available}
    Points earned:     #{points_earned}
    SUMMARY
  end
end
