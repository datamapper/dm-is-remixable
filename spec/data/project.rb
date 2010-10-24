module Portfolio
  class Project
    include DataMapper::Resource

    property :id,     Serial
    property :title,  String, :required => true,  :length=> 2..50
    property :url,    String

    remix 1, :images
    remix n, :viewables
    remix n, :commentables, :as => 'comments', :for => 'User', :via => 'commentor'
  end
end
