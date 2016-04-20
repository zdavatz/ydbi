# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name          = 'dbi'
  gem.version       = '0.4.6'
  gem.authors       = ['Erik Hollensbe', 'Christopher Maujean']
  gem.email         = 'ruby-dbi-users@rubyforge.org'
  gem.homepage      = 'http://www.rubyforge.org/projects/ruby-dbi'
  gem.summary       = 'A vendor independent interface for accessing databases, similar to Perl\'s DBI'
  gem.description   = 'A vendor independent interface for accessing databases, similar to Perl\'s DBI'
  gem.has_rdoc      = true

  gem.files         = `git ls-files`.split($/)
  gem.test_file     = 'test/ts_dbi.rb'
  gem.executables   = ['dbi', 'test_broken_dbi']
  gem.require_paths = ['lib']
 
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "test-unit"
  gem.add_runtime_dependency 'deprecated', '= 2.0.1'
end
