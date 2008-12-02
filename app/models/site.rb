class Site
  include DataMapper::Resource
  include DataMapper::Timestamp
  timestamps(:at)
  
  is_paginated
  
  property :id, Serial
  property :name, String
  property :lid, String
  property :gsa_address, String
  property :description,Text
  property :directions, Text
  property :latitude, String
  property :longitude, String
  
  has n, :facilities, :child_key => [:lid]
  has n, :buildings

end
