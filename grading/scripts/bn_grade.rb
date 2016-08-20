require 'json'

def unpack_to_home(file)
  Dir.chdir "/home/student" do
    if (file =~ /\.tar\.gz$/i) || file =~ (/\.tgz$/i)
      system(%Q{tar xzf "#{file}"})
    elsif (file =~ /\.zip/i)
      system(%Q{unzip "#{file}"})
    else
      system(%Q{cp "#{file}" .})
    end

    system("chown -R student:student ~student") 
  end
end

def unpack_submission
  unpack_to_home(ENV["BN_SUB"])
end

def unpack_grading
  unpack_to_home(ENV["BN_GRADE"])
end

class BnScore
  def initialize
    @tst_no = 1
    @bn_key = ENV["BN_KEY"] || "-- bn security key --"
    ENV["BN_KEY"] = ""

    @scores = []
  end

  def add(txt, pts, max)
    @scores << [txt, pts, max]
  end

  def test(txt, max)
    pts = yield
    add(txt, max, pts)

    puts "Test\t##{@tst_no}:\t#{pts} / #{max}\t#{txt}"
  end
  
  def output!
    pts = 0
    max = 0

    @scores.each do |_, pp, mm|
      pts += pp
      max += mm
    end

    puts
    puts @bn_key
    puts({
      scores: @scores,
      pts: pts,
      max: max,
    }.to_json)
  end
end

