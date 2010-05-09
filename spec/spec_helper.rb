require 'dm-core/spec/setup'
require 'dm-core/spec/lib/adapter_helpers'

require 'dm-is-remixable'
require 'dm-migrations'
require 'dm-validations'
require 'dm-types'

require 'data/addressable'
require 'data/article'
require 'data/billable'
require 'data/bot'
require 'data/commentable'
require 'data/image'
require 'data/rating'
require 'data/tag'
require 'data/taggable'
require 'data/topic'
require 'data/user'
require 'data/viewable'

Spec::Runner.configure do |config|
  config.extend(DataMapper::Spec::Adapters::Helpers)
end
