require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = FileList['spec/**/*_spec.rb']
end

task default: [:spec]

desc 'Load gem inside irb console'
task :console do
  require 'irb'
  require 'irb/completion'
  require File.join(__FILE__, '../lib/github_api')
  ARGV.clear
  IRB.start
end

