require 'rubygems'
require 'rake'

begin
  gem 'jeweler', '~> 1.4'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name        = 'dm-is-remixable'
    gem.summary     = 'dm-is-remixable allow you to create reusable data functionality'
    gem.description = gem.summary
    gem.email       = 'dm-is-remixable [a] coryodaniel [d] com'
    gem.homepage    = 'http://github.com/datamapper/%s' % gem.name
    gem.authors     = [ "Cory O'Daniel" ]

    gem.rubyforge_project = 'datamapper'

    gem.add_dependency 'dm-core', '~> 1.0.1'

    gem.add_development_dependency 'dm-validations', '~> 1.0.1'
    gem.add_development_dependency 'dm-types',       '~> 1.0.1'
    gem.add_development_dependency 'rspec',          '~> 1.3'
  end

  Jeweler::GemcutterTasks.new

  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end
