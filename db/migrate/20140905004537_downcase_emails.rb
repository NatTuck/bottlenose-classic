class DowncaseEmails < ActiveRecord::Migration
  def up
    User.all.each do |uu|
      unless uu.email.nil?
        uu.email = uu.email.downcase
        uu.save!
      end
    end

    RegRequest.all.each do |rr|
      unless rr.email.nil?
        rr.email = rr.email.downcase
        rr.save!
      end
    end
  end

  def down
  end
end
