class Room
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  belongs_to :building
  
#  has n, :rows

end
