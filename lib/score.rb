Score = Struct.new(:points, :total)

class Score
  def to_s
    "#{points.to_i} / #{total}"
  end

  def &(bb)
    Score.new(points + bb.points, total + bb.total)
  end

  def percent
    (100.0 * points / total).round(1)
  end
end
