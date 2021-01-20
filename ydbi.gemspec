# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dbi/version'
Gem::Specification.new do |gem|
  gem.name          = 'ydbi'
  gem.version       = DBI::VERSION
  gem.authors       = ['Erik Hollensbe', 'Christopher Maujean', 'Niklaus Giger', 'Zeno Davatz']
  gem.email         = 'zdavatz@ywesee.com'
  gem.homepage      = 'https://github.com/zdavatz/ydbi'
  gem.summary       = 'A vendor independent interface for accessing databases, similar to Perl\'s DBI'
  gem.description   = 'Branch by ywesee com, as our patches were never accepted by upstream'
  gem.licenses      = ['MIT']
  gem.files         = `git ls-files`.split($/)
  gem.test_file     = 'test/ts_dbi.rb'
  gem.executables   = ['dbi', 'test_broken_dbi']
  gem.require_paths = ['lib']

  gem.add_dependency "pg", '>= 1.0.0'
  gem.add_development_dependency "rake"
  gem.add_development_dependency "test-unit"
  gem.add_runtime_dependency 'deprecated', '= 2.0.1'
end
