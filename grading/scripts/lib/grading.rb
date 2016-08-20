
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

