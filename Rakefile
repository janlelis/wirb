require 'rake'
require 'fileutils'

task :default => :spec
task :test    => :spec

desc "Run tests"
task :spec do
  sh "rspec"
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
  sh %{gem install pkg/#{gemspec.name}-#{gemspec.version}.gem --no-doc}
end

desc "Generate the gemspec"
task :generate do
  puts gemspec.to_ruby
end

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

