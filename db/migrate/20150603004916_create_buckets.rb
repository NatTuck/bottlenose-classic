class CreateBuckets < ActiveRecord::Migration
  def change
    create_table :buckets do |t|
      t.integer :course_id
      t.string :name
      t.float :weight

      t.timestamps null: false
    end

    add_column :assignments, :bucket_id, :integer
    add_column :assignments, :course_id, :integer

    buckets = {}
    Course.all.each do |cc|
      buckets[cc.id] = Bucket.create(name: "Assignment", weight: 1.0, course_id: cc.id)
    end

    Assignment.all.each do |aa|
      query = "select * from chapters where id = #{aa.chapter_id} limit 1"
      chap = ActiveRecord::Base.connection.execute(query)[0]
      aa.course = Course.find(chap["course_id"])
      aa.bucket = buckets[aa.course.id]
      aa.save!
    end
  end
end
