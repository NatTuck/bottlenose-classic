module LessonsHelper
  def prev_and_next_lesson_links
    links = ""

    if @lesson.prev
      links << link_to(raw("&#x2190; Prev Lesson"), @lesson.prev)
    else
      if @chapter.prev
        links << link_to(raw("&#x2190; Prev Chapter"), @chapter.prev)
      else
        links << link_to(raw("&#x2191; This Chapter"), @chapter)
      end
    end

    links << " | "

    if @lesson.next
      links << link_to(raw("Next Lesson &#x2192;"), @lesson.next)
    else
      if @chapter.next
        links << link_to(raw("Next Chapter &#x2192;"), @chapter.next)
      else
        links << link_to(raw("This Chapter &#x2191;"), @chapter)
      end
    end

    raw links
  end
end
