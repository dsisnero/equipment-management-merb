class Facility
  include DataMapper::Resource
  
  property :lid, String, :key => true
  property :factype, String, :key => true
  
  belongs_to :site
  has n, :from_circuits, :class_name => "Circuit", :child_key => [:from_lid,:from_fac]
  has n, :to_circuits, :class_name => "Circuit", :child_key => [:to_lid,:to_fac]  
  
  def to_s
    "#{lid} #{factype}"
  end
  
  def lid_fac
     "#{attribute_get(:lid)}_#{attribute_get(:factype)}"
  end
  
  def to_param
    lid_fac
  end
  
  def self.find_or_create_from_lid_fac(lid_fac,create_attrs= { })
    lid,fac = lid_fac.gsub(' ', '_').split('_')
    self.first_or_create({ :lid => lid,:factype => fac}, create_attrs)    
  end


  
end
