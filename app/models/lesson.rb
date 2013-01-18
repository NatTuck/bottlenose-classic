class Lesson < ActiveRecord::Base
  attr_accessible :chapter_id, :name, :video, :notes, :questions_due

  belongs_to :chapter
  has_many :questions, :dependent => :destroy

  validates :chapter_id, :presence => true
  validates :name,       :length => { :minimum => 2 },
                         :uniqueness => { :scope => :chapter_id }

  delegate :course, :to => :chapter

  before_validation do
    unless video.nil?
      video.sub! /width="\d+"/, 'width="1120"'
      video.sub! /height="\d+"/, 'height="630"'

      # Proposed changes to avoid related videos showing up after a video
      # has played (issue #29). Not comitted due to problems with HTML5 player.
      # 
      # yt = Regexp.new(%Q{http://www.youtube.com/embed/(\\w+)})
      # mm = yt.match(video)
      # if mm
      #   video.sub! /src="\S+"/, %Q{src="http://www.youtube.com/v/#{mm[1]}&rel=0"}
      # end

      # Another interesting idea:
      # video.sub! /www.youtube.com/, 'www.youtube-nocookie.com'
    end
  end

  def questions_score(user)
    questions.map {|qq| qq.best_score_for(user) }.inject(:&) || Score.new(0, 0)
  end

  def prev
    xs = chapter.lessons.order(:name)

    while xs.length > 1
      if xs[1] == self
        return xs[0]
      end

      xs = xs[1..-1]
    end

    return nil
  end

  def next
    xs = chapter.lessons.order(:name)

    while xs.length > 1
      if xs[-2] == self
        return xs[-1]
      end

      xs = xs[0..-2]
    end

    return nil
  end
end
