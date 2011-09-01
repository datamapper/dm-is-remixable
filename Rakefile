require 'rubygems'
require 'rake'

begin
  gem 'jeweler', '~> 1.6.4'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name        = 'dm-is-remixable'
    gem.summary     = 'dm-is-remixable allow you to create reusable data functionality'
    gem.description = gem.summary
    gem.email       = 'dm-is-remixable [a] coryodaniel [d] com'
    gem.homepage    = 'http://github.com/datamapper/%s' % gem.name
    gem.authors     = [ "Cory O'Daniel" ]
    gem.has_rdoc    = 'yard'

    gem.rubyforge_project = 'datamapper'
  end

  Jeweler::GemcutterTasks.new

  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end
