require 'fti_circuit_search/client'
class Facility
  include DataMapper::Resource
  include DataMapper::Timestamp  
  timestamps(:at)
  is_paginated  
    
  property :lid, String, :key => true
  property :factype, String, :key => true
  property :circuits_updated_at, DateTime
  property :processing, Boolean
  
  belongs_to :site, :child_key => [:lid],:parent_key => [:lid]
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
  
  def update_circuits
    if needs_updated_circuits?
      update_attributes(:processing => true)      
      Merb.run_later{ self._update_circuits}
    end
  end
  
  def needs_updated_circuits?
    (circuits_updated_at.nil? || circuits_updated_at < 15.minutes.ago.to_datetime) && !processing
  end
  
  def _update_circuits
    #not_updatable = []
    remote_hash = agent.get_circuits(lid,factype)
    remote_hash.each do |circ|
      atts = Circuit.update_remote_hash(circ)
      circuit = Circuit.first(:usi => atts['usi'])
      if circuit
        circuit.update_attributes atts
      else
        circuit = Circuit.new atts
      end      
      unless circuit.save
        #not_updatable << update_atts
      end
    end
    update_attributes(:circuits_updated_at => DateTime.now, :processing => false )    
  end
  
  def self.agent
    @agent ||= FtiCircuitSearch::Client.new
  end
  
  def agent
    self.class.agent
  end


  
end
