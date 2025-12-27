# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + "/lib/wirb/version"

Gem::Specification.new do |s|
  s.name        = "wirb"
  s.version     = Wirb::VERSION.dup
  s.authors     = ["Jan Lelis"]
  s.email       = ["hi@ruby.consulting"]
  s.homepage    = "https://github.com/janlelis/wirb"
  s.summary     = "Add syntax highlighting for inspected Ruby objects"
  s.description =  "WIRB adds syntax highlighting for inspected Ruby objects - from core and default gems"
  s.files = Dir.glob(%w[{lib,test,spec}/**/*.rb bin/* [A-Z]*.{txt,md} ext/**/*.{rb,c} data/**/*.yml]) + %w{Rakefile wirb.gemspec}
  s.extra_rdoc_files = ["README.md", "CHANGELOG.md", "COPYING.txt"]
  s.license     = 'MIT'
  s.metadata    = { "rubygems_mfa_required" => "true" }
  s.required_ruby_version = '>= 2.0', '< 5.0'
  s.add_dependency 'paint', '>= 0.9', '< 4.0'
  s.add_development_dependency 'rspec', '~> 3.13'
  s.add_development_dependency 'diff-lcs', '~> 1.6'
  s.add_development_dependency 'rake', '~> 13.2'
  s.add_development_dependency 'ruby_engine', '~> 2.0'
  s.add_development_dependency 'ostruct'
  s.add_development_dependency 'fileutils'
  s.add_development_dependency 'irb'
  s.add_development_dependency 'stringio'
  s.add_development_dependency 'date'
end
