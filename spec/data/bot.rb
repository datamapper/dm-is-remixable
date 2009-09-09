require 'data/viewable'
require 'data/billable'
require 'data/addressable'
require 'data/rating'

class Bot
  include DataMapper::Resource

  property :id, Serial

  property :bot_name,     String,
    :nullable     => false,
    :length       => 2..50

  property :bot_version,      String,
    :nullable     => false,
    :length       => 2..50

end
