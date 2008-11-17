class Site
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :lid, String
  property :description,Text
  property :directions, Text
  property :latitude, String
  property :longitude, String
  
  has n, :facilities

end
