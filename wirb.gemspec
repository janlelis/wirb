# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem
require File.dirname(__FILE__) + "/lib/wirb/version"
 
Gem::Specification.new do |s|
  s.name        = "wirb"
  s.version     = Wirb::VERSION.dup
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "https://github.com/janlelis/wirb"
  s.summary     = "Wavy IRB: Colorizes irb results."
  s.description =  "Wavy IRB: Colorizes irb results. It originated from Wirble, but only provides result highlighting. Just call Wirb.start and enjoy the colors in your IRB ;). You can use it with your favorite colorizer engine. See README.rdoc for more details."
  s.required_rubygems_version = '>= 1.3.6'
  s.required_ruby_version     = '>= 1.8.7'
  s.files = Dir.glob(%w[{lib,test,spec}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} data/**/*.yml]) + %w{Rakefile wirb.gemspec .gemtest}
  s.extra_rdoc_files = ["README.rdoc", "COPYING.txt"]
  s.license = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'zucker', '>= 11'
  #s.add_development_dependency 'highline'
  s.add_development_dependency 'paint'
 
  len = s.homepage.size
  s.post_install_message = \
   ("       ┌── " + "info ".ljust(len-2,'%')            + "─┐\n" +
    " J-_-L │ "   + s.homepage                          + " │\n" +
    "       ├── " + "usage ".ljust(len-2,'%')           + "─┤\n" +
    "       │ "   + "require 'wirb'".ljust(len,' ')     + " │\n" +
    "       │ "   + "Wirb.start".ljust(len,' ')         + " │\n" +
    "       └─"   + '─'*len                             + "─┘").gsub('%', '─') # 1.8 workaround
end
