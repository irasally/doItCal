# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hokkaido_it_calendar/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["niku"]
  gem.email         = ["niku@niku.name"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hokkaido_it_calendar"
  gem.require_paths = ["lib"]
  gem.version       = HokkaidoItCalendar::VERSION
end
