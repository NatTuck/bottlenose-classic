class LessonView < ActiveRecord::Base
  attr_accessible :lesson_id, :registration_id, :viewed_page, 
                  :viewed_video, :viewed_video2
end
