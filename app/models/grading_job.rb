class GradingJob < ActiveRecord::Base
  belongs_to :submission

  @@MAX_CONC = 2

  def self.kill_container!(job_id)
    system("lxc stop bn-#{Rails.env}-#{job_id} --force")
  end

  def self.cleanup_stale!
    conts = JSON.parse(`lxc list --format json`)
    conts.each do |cont|
      name = cont["name"]
      mm = /^bn-#{Rails.env}-(\d+)$/.match(name)
      next if mm.nil?

      job_id = mm[1].to_i
      job = GradingJob.find_by_id(job_id)
      if job.nil?
         kill_container!(job_id)
         next
      end

      unless job.started_at.nil?
        if job.started_at < (Time.now - 10.minutes)
          kill_container!(job_id)
          job.destroy
        end

        next 
      end
    end

    stale = GradingJob.where("started_at is not null").where("started_at < ?", [Time.now - 15.minutes])
    stale.destroy_all
  end

  def self.try_start_next!
    cleanup_stale!

    GradingJob.transaction do
      active = GradingJob.where.not(started_at: nil).count
      return if active >= @@MAX_CONC
    
      jobs = GradingJob.where(started_at: nil).limit(@@MAX_CONC - active).to_a
      jobs.each do |jj|
        jj.started_at = Time.now
        jj.save!

        root = Rails.root.to_s
        system(%Q{(cd "#{root}" && script/run-grading-job #{jj.id} 2>&1) &})
      end
    end
  end

  def try_start!
    root = Rails.root.to_s
    system(%Q{(cd "#{root}" && script/run-next-grading-job 2>&1) &})
  end

  def driver_script_path
    Rails.root.join("grading", "drivers", submission.assignment.grading_driver)
  end
end
