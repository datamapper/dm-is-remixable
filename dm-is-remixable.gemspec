# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-remixable}
  s.version = "1.0.0.rc2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Cory O'Daniel"]
  s.date = %q{2010-05-23}
  s.description = %q{dm-is-remixable allow you to create reusable data functionality}
  s.email = %q{dm-is-remixable [a] coryodaniel [d] com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "Gemfile",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "dm-is-remixable.gemspec",
     "lib/dm-is-remixable.rb",
     "lib/dm-is-remixable/is/remixable.rb",
     "spec/data/addressable.rb",
     "spec/data/article.rb",
     "spec/data/billable.rb",
     "spec/data/bot.rb",
     "spec/data/commentable.rb",
     "spec/data/image.rb",
     "spec/data/rating.rb",
     "spec/data/tag.rb",
     "spec/data/taggable.rb",
     "spec/data/topic.rb",
     "spec/data/user.rb",
     "spec/data/viewable.rb",
     "spec/integration/remixable_spec.rb",
     "spec/rcov.opts",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "tasks/ci.rake",
     "tasks/local_gemfile.rake",
     "tasks/metrics.rake",
     "tasks/spec.rake",
     "tasks/yard.rake",
     "tasks/yardstick.rake"
  ]
  s.homepage = %q{http://github.com/datamapper/dm-is-remixable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{datamapper}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{dm-is-remixable allow you to create reusable data functionality}
  s.test_files = [
    "spec/data/addressable.rb",
     "spec/data/article.rb",
     "spec/data/billable.rb",
     "spec/data/bot.rb",
     "spec/data/commentable.rb",
     "spec/data/image.rb",
     "spec/data/rating.rb",
     "spec/data/tag.rb",
     "spec/data/taggable.rb",
     "spec/data/topic.rb",
     "spec/data/user.rb",
     "spec/data/viewable.rb",
     "spec/integration/remixable_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.0.0.rc2"])
      s.add_development_dependency(%q<dm-validations>, ["~> 1.0.0.rc2"])
      s.add_development_dependency(%q<dm-types>, ["~> 1.0.0.rc2"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
    else
      s.add_dependency(%q<dm-core>, ["~> 1.0.0.rc2"])
      s.add_dependency(%q<dm-validations>, ["~> 1.0.0.rc2"])
      s.add_dependency(%q<dm-types>, ["~> 1.0.0.rc2"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<dm-core>, ["~> 1.0.0.rc2"])
    s.add_dependency(%q<dm-validations>, ["~> 1.0.0.rc2"])
    s.add_dependency(%q<dm-types>, ["~> 1.0.0.rc2"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
  end
end

