
class SubTarball
  def initialize(as_id)
    @as = Assignment.find(as_id)
  end

  def update!
    temp = Rails.root.join('tmp', 'tars', 'assign', @as.id.to_s)
    if temp.to_s =~ /tars\/assign/
      FileUtils.rm_rf(temp)
    end

    FileUtils.mkdir_p(temp)

    afname = "assignment_#{@as.id}"

    dirs = temp.join(afname)
    FileUtils.mkdir_p(dirs)

    @as.main_submissions.each do |sub|
      next if sub.file_full_path.blank?

      uu = sub.user
      dd = dirs.join(uu.dir_name)
      FileUtils.mkdir_p(dd)

      FileUtils.mkdir_p(dd)

      FileUtils.cp(sub.file_full_path, dd)
    end

    FileUtils.cd(temp)
    system(%Q{tar czf "#{afname}.tar.gz" "#{afname}"})

    src = temp.join("#{afname}.tar.gz")

    FileUtils.cp(src, @as.tarball_full_path)
  end

  def path
    @as.tarball_path
  end
end
