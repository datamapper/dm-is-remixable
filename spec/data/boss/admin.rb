require 'data/boss/commandable'
module Boss
  class Admin

    include DataMapper::Resource

    property :id, Serial
    property :first_name, String, :required => true,  :length=> 2..50
    property :last_name, String, :required => true, :length => 2..50

    remix n, :commandables, :as => :commands
    remix n, :commentables, :as => :comments

  end
end
