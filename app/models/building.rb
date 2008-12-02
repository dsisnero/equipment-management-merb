class Building
  include DataMapper::Resource
  include DataMapper::Timestamp
  timestamps(:at)
  
  property :id, Serial
  property :name, String
  property :description, String
    
  belongs_to :site
  has n, :rooms
  
end
