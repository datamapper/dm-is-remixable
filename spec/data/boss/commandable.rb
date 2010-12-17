module Boss
  module Commandable
    include DataMapper::Resource

    is :remixable,
      :suffix => "command"

    property :id,         Serial
    property :comment,    String
    property :created_at, DateTime

    validates_presence_of :comment, :context => [ :publish ]
  end
end
