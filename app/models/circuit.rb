require 'fti_circuit_search/client'
class Circuit
  include DataMapper::Resource
  
  property :id, Serial
  property :usi, String
  property :from_lid_fac, String
  property :to_lid_fac, String
  property :csa, String
  property :from_interface_type, String
  property :nas,String
  property :svc,String
  property :cutover_status,String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :service_area, String
  property :region, String
  property :actual_sa, DateTime
  property :actual_cutover, DateTime
  property :gnas, String
  
  before :create, :create_associated
  
  belongs_to :from_facility, :class_name => 'Facility', :child_key => [:from_lid,:from_fac]
  belongs_to :to_facility, :class_name => 'Facility', :child_key => [:to_lid,:to_fac]

  def self.find_all_remote(lid,fac)
    agent.get_circuits(lid,fac)
  end
  
  def self.remote_keys
    keys = %w(usi csa from_interface_type nas svc cutover_status service_area region)
    keys += %w(actual_sa actual_cutover gnas)
  end
  
  def self.find_or_create_from_remote(lid,fac)
    remote_circuits = self.find_all_remote(lid,fac)
    return [] if remote_circuits.empty? || nil
    unique_facilities = self.find_unique_facilities(remote_circuits)
    unique_sites = unique_facilities.map{ |fac| fac[0]}.uniq
    unique_facilities.each do |fac|
      ::Facility.first_or_create(:lid => fac[0], :factype => fac[1])
    end
    unique_sites.each do |site|
      ::Site.first_or_create(:lid => site)
    end
    remote_circuits.each do |remote|
      _find_or_create_from_remote(remote)
      #circuit.update_from_remote(remote)
    end
    
  end
  
  def self.find_unique_facilities(circuits)
    fac = Set.new
    circuits.each{ |h| fac << h['from_lid_fac']; fac << h['to_lid_fac']}
    facarrays = fac.map{ |lid_fac| split_lid_fac(lid_fac)}    
    facarrays
  end


  def self._find_or_create_from_remote(remote)
    update_atts = update_remote_hash(remote)
    circuit = self.first_or_create({:usi => remote["usi"]},update_atts)    
  end

  def self.find_and_update_from_remote(remote)
    update_atts
    if circuit= self.first({ :usi => remote})
    end
    update_atts = update_remote_hash(remote)
    circuit = self.first_or_create({:usi => remote["usi"]},update_atts)    
    circuit.update_attributes update_atts    
  end
  
  def self.update_remote_hash(remote)
    to_lid,to_fac = lid_fac_from_remote(remote,'to_lid_fac')
    #Facility.first_or_create({ :lid => to_lid,:factype => to_fac})
    from_lid,from_fac = lid_fac_from_remote(remote,'from_lid_fac')
    #Facility.first_or_create( { :lid => from_lid, :factype => from_fac})
    update_atts =  remote.only( *self.remote_keys)
    update_atts.merge('to_lid'=> to_lid, 'to_fac' => to_fac,
                      'from_lid'=> from_lid, 'from_fac'=> from_fac)   
  end
  
  def self.split_lid_fac(lid_fac)
    lid_fac.gsub(' ','_').split('_')
  end
  
  def self.lid_fac_from_remote(remote,key)
    hash = remote.dup
    lid_fac = hash.delete(key)
    lid,fac = lid_fac.gsub(' ','_').split('_')
    [lid,fac]
  end
  
  def self.find_remote(uid)
    agent.get_circuit(uid)
  end  
  
  def update_from_remote(remote)
    update_attributes(remote,*self.class.remote_keys)
    from_fac = Facility.find_or_create_from_lid_fac(remote['from_lid_fac'])
    self.from_facility = from_fac
    # from_fac.from_circuits << self
    to_fac = Facility.find_or_create_from_lid_fac(remote['to_lid_fac'])
    self.to_facility = to_fac
    #to_fac.to_circuits << self    
    self.save
  end
  
  private
  
  def create_associated
    Facility.first_or_create(:lid => from_lid,:factype => from_fac)
    Site.first_or_create(:lid => :from_lid)
    Facility.first_or_create(:lid => to_lid, :factype => to_fac)
    Site.first_or_create(:lid => to_lid)
  end


  def self.agent
    @agent ||= FtiCircuitSearch::Client.new
  end
end
