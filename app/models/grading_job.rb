class GradingJob < ActiveRecord::Base
  belongs_to :submission

  @@MAX_CONC = 2

  def self.try_start_any!
    active = GradingJob.where.not(started_at: nil).count
    if active < @@MAX_CONC
      jobs = GradingJob.where(started_at: nil).limit(@@MAX_CONC - active).to_a
      jobs.each do |jj|
        jj.try_start!
      end
    end
  end

  def try_start!
    active = GradingJob.where.not(started_at: nil).count
    return if active >= @@MAX_CONC 

    root = Rails.root.to_s
    system(%Q{(cd "#{root}" && script/run-grading-job #{self.id} 2>&1) &})
  end

  def driver_script_path
    Rails.root.join("grading", "drivers", submission.assignment.grading_driver)
  end
end
