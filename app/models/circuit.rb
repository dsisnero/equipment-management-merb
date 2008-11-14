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
  
  belongs_to :from_facility, :class_name => 'Facility', :child_key => [:from_lid,:from_fac]
  belongs_to :to_facility, :class_name => 'Facility', :child_key => [:to_lid,:to_fac]

  def self.find_all_remote(facility)
    lid,fac = facility.gsub(" ",'_').split("_")
    #debugger
    agent.get_circuits(lid,fac)
  end
  
  def self.remote_keys
    %w(usi csa from_interface_type nas svc cutover_status)
  end
  
  def self.find_and_create_from_remote(facility)
    remote_circuits = self.find_all_remote(facility)
    return [] if remote_circuits.empty? || nil
    unique_facilities = self.find_unique_facilities(remote_circuits)
    unique_facilities.each do |fac|
      Facility.first_or_create(:lid => fac[0], :factype => fac[1])
    end      
    remote_circuits.each do |remote|
      find_or_update_from_remote(remote)
      #circuit.update_from_remote(remote)
    end
    
  end
  
  def self.find_unique_facilities(circuits)
    fac = Set.new
    circuits.each{ |h| fac << h['from_lid_fac']; fac << h['to_lid_fac']}
    facarrays = fac.map{ |lid_fac| split_lid_fac(lid_fac)}    
    facarrays
  end
  
  
  def self.find_or_update_from_remote(remote)
    update_atts = update_remote_hash(remote)
    circuit = self.first_or_create({:usi => remote["usi"]},update_atts)
    
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
  
  #  def self.agent
  #     @agent ||= initialize_agent
  #   end
  
  def fetch(id)
    
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
  
  
  def self.agent
    @agent ||= FtiCircuitSearch::Client.new
  end
end
