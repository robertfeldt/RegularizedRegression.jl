Lib = "RegularizedRegression"
TestDir = "test"

# General parameters that the user can set from the command line.
Julia = "julia"
Julia04 = "julia04"
Julia03 = "julia03"
MinReps = (ENV["minreps"] || 30).to_i
MaxReps = (ENV["maxreps"] || 1000).to_i
MaxRepTime = (ENV["maxreptime"] || 1.0).to_f
Verbosity = ENV["verbosity"] || 2
MoreFactor = (ENV["morefactor"] || 10).to_i
MostFactor = (ENV["mostfactor"] || 1000).to_i
TimedTestMinFactor = (ENV["timedminfactor"] || 10).to_i
TimedTestMaxFactor = (ENV["timedmaxfactor"] || 1000).to_i

MainFile = "src/#{Lib}.jl"
BaseCommand = "--color=yes -L #{MainFile}"

Command = Command05 = "#{Julia} #{BaseCommand}"
Command04 = "#{Julia04} #{BaseCommand}"
Command03 = "#{Julia03} #{BaseCommand}"

desc "Run normal (fast) tests"
task :runtest do
  sh "#{Command} test/runtests.jl"
end

desc "Run normal (fast) tests, while timing test execution"
task :timedruntest do
  sh "#{Command} test/timedruntests.jl"
end

desc "Run normal (fast) tests on Julia 0.4"
task :runtest4 do
  sh "#{Command04} test/runtests.jl"
end

desc "Run normal (fast) tests on Julia 0.4, while timing test execution"
task :timedruntest4 do
  sh "#{Command04} test/timedruntests.jl"
end

desc "Run normal (fast) tests on julia 0.3"
task :runtest03 do
  sh "#{Command03} test/runtests.jl"
end

def filter_latest_changed_files(filenames, numLatestChangedToInclude = 1)
  filenames.sort_by{ |f| File.mtime(f) }[-numLatestChangedToInclude, numLatestChangedToInclude]
end

desc "Run only the latest changed test file"
task :t do
  latest_changed_test_file = filter_latest_changed_files Dir["test/**/test*.jl"]
  sh "#{Command} -e 'include(\"test/helper.jl\"); include(\"#{latest_changed_test_file.first}\")'"
end

desc "Run and create code coverage information"
task :coverage do
  sh "#{Command} --code-coverage test/runtests.jl"
end

def deleting_file(f)
    puts "Deleting #{f}"
    File.delete(f)
end

desc "Clear build files etc"
task :clobber do
  Dir['**/*.jl.cov'].each {|f| deleting_file(f)}
  Dir['examples/benchmarking/*.log'].each {|f| deleting_file(f)}
  Dir['examples/benchmarking/comparison_2*.csv'].each {|f| deleting_file(f)}
end

task :default => :runtest

def loc_of_files(files)
  lines = files.map {|fn| File.readlines(fn)}
  nonblanklines = lines.map {|ls| ls.select {|line| line.strip.length > 0}}
  loc = lines.map {|ls| ls.length}.inject(0) {|s,e| s+e}
  nbloc = nonblanklines.map {|ls| ls.length}.inject(0) {|s,e| s+e}
  return loc, nbloc, files.length
end

desc "Count LOC"
task :loc do
  srcloc, srcnbloc, numsrcfiles = loc_of_files(Dir["src/**/*.jl"])
  testloc, testnbloc, numtestfiles = loc_of_files(Dir["test/**/*.jl"])
  puts "Source files: #{numsrcfiles} files\t\t#{srcloc} LOC\t\t(#{srcnbloc} non-blank LOC)"
  puts "Test   files: #{numtestfiles} files\t\t#{testloc} LOC\t\t(#{testnbloc} non-blank LOC)"
  if testloc > 0 && srcloc > 0
    puts("Test to code ratio:\t\t%.3f   \t\t(%.3f)" % [(testloc.to_f/srcloc), (testnbloc.to_f/srcnbloc)])
  end
end
