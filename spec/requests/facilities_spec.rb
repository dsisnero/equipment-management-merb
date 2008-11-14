require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a facility exists" do
  Facility.all.destroy!
  request(resource(:facilities), :method => "POST", 
    :params => { :facility => { :id => nil }})
end

describe "resource(:facilities)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:facilities))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of facilities" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a facility exists" do
    before(:each) do
      @response = request(resource(:facilities))
    end
    
    it "has a list of facilities" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Facility.all.destroy!
      @response = request(resource(:facilities), :method => "POST", 
        :params => { :facility => { :id => nil }})
    end
    
    it "redirects to resource(:facilities)" do
      @response.should redirect_to(resource(Facility.first), :message => {:notice => "facility was successfully created"})
    end
    
  end
end

describe "resource(@facility)" do 
  describe "a successful DELETE", :given => "a facility exists" do
     before(:each) do
       @response = request(resource(Facility.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:facilities))
     end

   end
end

describe "resource(:facilities, :new)" do
  before(:each) do
    @response = request(resource(:facilities, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@facility, :edit)", :given => "a facility exists" do
  before(:each) do
    @response = request(resource(Facility.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@facility)", :given => "a facility exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Facility.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @facility = Facility.first
      @response = request(resource(@facility), :method => "PUT", 
        :params => { :article => {:id => @facility.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@facility))
    end
  end
  
end

