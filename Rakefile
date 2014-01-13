require 'rake'
require 'fileutils'
require "rspec/core/rake_task"
task :default => :spec
task :test    => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = [
     '--color',
    '-r ' + File.expand_path( File.join( 'spec', 'spec_helper') ),
  ]
end

def gemspec
  @gemspec ||= eval(File.read('wirb.gemspec'), binding, 'wirb.gemspec')
end

desc "Build the gem"
task :gem => :gemspec do
  sh "gem build wirb.gemspec"
  FileUtils.mkdir_p 'pkg'
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", 'pkg'
end

desc "Install the gem locally"
task :install => :gem do
  sh %{gem install pkg/#{gemspec.name}-#{gemspec.version}.gem --no-rdoc --no-ri}
end

desc "Generate the gemspec"
task :generate do
  puts gemspec.to_ruby
end

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

