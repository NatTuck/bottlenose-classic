require 'securerandom'
require 'audit'
require 'score'

class Assignment < ActiveRecord::Base
  belongs_to :blame, :class_name => "User", :foreign_key => "blame_id"

  belongs_to :chapter
  has_many :submissions, :dependent => :restrict_with_error

  validates :name, :uniqueness => { :scope => :chapter_id }
  validates :name, :presence => true
  validates :chapter_id, :presence => true
  validates :due_date,   :presence => true
  validates :points_available, :numericality => true
  validates :blame_id,   :presence => true

  delegate :course, :to => :chapter

  def assignment_upload
    Upload.find_by_id(assignment_upload_id)
  end
  
  def grading_upload
    Upload.find_by_id(grading_upload_id)
  end

  def solution_upload
    Upload.find_by_id(solution_upload_id)
  end

  def assignment_file
    if assignment_upload_id.nil?
      ""
    else
      assignment_upload.file_name
    end
  end

  def assignment_file_name
    assignment_file
  end

  def grading_file
    if grading_upload_id.nil?
      ""
    else
      grading_upload.file_name
    end
  end

  def grading_file_name
    grading_file
  end

  def solution_file
    if solution_upload_id.nil?
      ""
    else
      solution_upload.file_name
    end
  end

  def solution_file_name
    solution_file
  end

  def assignment_full_path
    assignment_upload.full_path
  end

  def grading_full_path
    grading_upload.full_path
  end

  def assignment_file_path
    if assignment_upload_id.nil?
      ""
    else
      assignment_upload.path
    end
  end

  def grading_file_path
    if grading_upload_id.nil?
      ""
    else
      grading_upload.path
    end
  end

  def solution_file_path
    if solution_upload_id.nil?
      ""
    else
      solution_upload.path
    end
  end

  def assignment_file=(data)
    @assignment_file_data = data
  end

  def grading_file=(data)
    @grading_file_data = data
  end

  def solution_file=(data)
    @solution_file_data = data
  end

  def has_grading?
    !grading_upload_id.nil?
  end

  def save_uploads!
    user = User.find(blame_id)

    unless @assignment_file_data.nil?
      unless assignment_upload_id.nil?
        Audit.log("Assn #{id}: Orphaning assignment upload " +
                  "#{assignment_upload_id} (#{assignment_upload.secret_key})")
      end

      up = Upload.new
      up.user_id = user.id
      up.store_meta!({
        type:       "Assignment File",
        user:       "#{user.name} (#{user.id})",
        course:     "#{course.name} (#{course.id})",
        date:       Time.now.strftime("%Y/%b/%d %H:%M:%S %Z")
      })
      up.store_upload!(@assignment_file_data)
      up.save!
      
      self.assignment_upload_id = up.id
      self.save!

      Audit.log("Assn #{id}: New assignment file upload by #{user.name} " +
                "(#{user.id}) with key #{up.secret_key}")
    end

    unless @grading_file_data.nil?
      unless assignment_upload_id.nil?
        Audit.log("Assn #{id}: Orphaning grading upload " +
                  "#{assignment_upload_id} (#{assignment_upload.secret_key})")
      end

      up = Upload.new
      up.user_id = user.id
      up.store_meta!({
        type:       "Assignment Grading File",
        user:       "#{user.name} (#{user.id})",
        course:     "#{course.name} (#{course.id})",
        date:       Time.now.strftime("%Y/%b/%d %H:%M:%S %Z")
      })
      up.store_upload!(@grading_file_data)
      up.save!

      self.grading_upload_id = up.id
      self.save!
      
      Audit.log("Assn #{id}: New grading file upload by #{user.name} " +
                "(#{user.id}) with key #{up.secret_key}")
    end

    unless @solution_file_data.nil?
      unless solution_upload_id.nil?
        Audit.log("Assn #{id}: Orphaning solution upload " +
                  "#{solution_upload_id} (#{solution_upload.secret_key})")
      end

      up = Upload.new
      up.user_id = user.id
      up.store_meta!({
        type:       "Assignment Solution File",
        user:       "#{user.name} (#{user.id})",
        course:     "#{course.name} (#{course.id})",
        date:       Time.now.strftime("%Y/%b/%d %H:%M:%S %Z")
      })
      up.store_upload!(@solution_file_data)
      up.save!

      self.solution_upload_id = up.id
      self.save!
      
      Audit.log("Assn #{id}: New solution file upload by #{user.name} " +
                "(#{user.id}) with key #{up.secret_key}")
    end
  end

  def tarball_path
    if tar_key.blank?
      self.tar_key = SecureRandom.hex(16)
      save!
    end

    dir = "downloads/#{tar_key}/"
    FileUtils.mkdir_p(Rails.root.join('public', dir))
    
    return '/' + dir + "assignment_#{id}.tar.gz"
  end

  def tarball_full_path
    Rails.root.join('public', tarball_path.sub(/^\//, ''))
  end

  def submissions_for(user)
    submissions.where(user_id: user.id).order(:created_at).reverse
  end

  def main_submission_for(user)
 end

  def main_submissions
    regs = course.active_registrations.sort_by {|sr| sr.user.invert_name.downcase  }
    regs.map do |sreg|
      main_submission_for(sreg.user)
    end
  end

  def main_score_for(user)
    sub = main_submission_for(user)
    points = sub.nil? ? 0 : sub.score

    Score.new(points, points_available)
  end

  def update_best_subs!
    course.registrations.each do |reg|
      update_best_sub_for!(reg.user)
    end
  end

  def update_best_sub_for!(user)
    sub = calc_best_sub_for(user)
    best = BestSub.find_or_create_by(user_id: user_id, assignment_id: self.id)
    best.submission_id = sub.id
    best.score = sub.score
    best.save!
  end

  private

  def calc_best_sub_for(user)
    subs = submissions_for(user)
    if subs.empty?
      Submission.new(user_id: user.id, assignment_id: self.id, file_name: "none")
    else
      teacher_scores = subs.find_all {|ss| not ss.teacher_score.nil? }
      
      if teacher_scores.empty?
        subs.sort_by {|ss| sprintf("%06d%014d", ss.score, ss.created_at.to_i) }.last
      else
        teacher_scores.sort_by {|ss| ss.score }.last
      end
    end
  end
end

