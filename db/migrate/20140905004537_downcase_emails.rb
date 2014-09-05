class DowncaseEmails < ActiveRecord::Migration
  def up
    User.all.each do |uu|
      uu.email = uu.email.downcase
      uu.save!
    end

    RegRequest.all.each do |rr|
      rr.email = rr.email.downcase
      rr.save!
    end
  end

  def down
  end
end
